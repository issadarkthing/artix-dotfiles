# This is a sample commands.py.  You can add your own commands here.
#
# Please refer to commands_full.py for all the default commands and a complete
# documentation.  Do NOT add them all here, or you may end up with defunct
# commands when upgrading ranger.

# You always need to import ranger.api.commands here to get the Command class:
from ranger.api.commands import Command
import ranger.api
import ranger.core.linemode

# A simple command for demonstration purposes follows.
# -----------------------------------------------------------------------------

# You can import any python module as needed.
import os

# Any class that is a subclass of "Command" will be integrated into ranger as a
# command.  Try typing ":my_edit<ENTER>" in ranger!


class my_edit(Command):
    # The so-called doc-string of the class will be visible in the built-in
    # help that is accessible by typing "?c" inside ranger.
    """:my_edit <filename>

    A sample command for demonstration purposes that opens a file in an editor.
    """

    # The execute method is called when you run this command in ranger.
    def execute(self):
        # self.arg(1) is the first (space-separated) argument to the function.
        # This way you can write ":my_edit somefilename<ENTER>".
        if self.arg(1):
            # self.rest(1) contains self.arg(1) and everything that follows
            target_filename = self.rest(1)
        else:
            # self.fm is a ranger.core.filemanager.FileManager object and gives
            # you access to internals of ranger.
            # self.fm.thisfile is a ranger.container.file.File object and is a
            # reference to the currently selected file.
            target_filename = self.fm.thisfile.path

        # This is a generic function to print text in ranger.
        self.fm.notify("Let's edit the file " + target_filename + "!")

        # Using bad=True in fm.notify allows you to print error messages:
        if not os.path.exists(target_filename):
            self.fm.notify("The given file does not exist!", bad=True)
            return

        # This executes a function from ranger.core.acitons, a module with a
        # variety of subroutines that can help you construct commands.
        # Check out the source, or run "pydoc ranger.core.actions" for a list.
        self.fm.edit_file(target_filename)

    # The tab method is called when you press tab, and should return a list of
    # suggestions that the user will tab through.
    # tabnum is 1 for <TAB> and -1 for <S-TAB> by default
    def tab(self, tabnum):
        # This is a generic tab-completion function that iterates through the
        # content of the current directory.
        return self._tab_directory_content()


class fzf_select(Command):
    """
    :fzf_select

    Find a file using fzf.

    With a prefix argument select only directories.

    See: https://github.com/junegunn/fzf
    """
    def execute(self):
        import subprocess
        import os.path
        if self.quantifier:
            # match only directories
            command="find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
            -o -type d -print 2> /dev/null | sed 1d | cut -b3- | fzf +m"
        else:
            # match files and directories
            command="find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
            -o -print 2> /dev/null | sed 1d | cut -b3- | fzf +m"
        fzf = self.fm.execute_command(command, universal_newlines=True, stdout=subprocess.PIPE)
        stdout, _ = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)



class fzf_z(Command):
    """
    :fzf_z

    jump around using z history and fzf

    """
    def execute(self):
        import subprocess
        import os.path

        command = "awk -F'|' '{print $1}' ~/.z | fzf +m --preview='ls {}'"


        fzf = self.fm.execute_command(command, universal_newlines=True,stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)
        else:
            print(stderr)


class copy_to_clipboard(Command):
    """
    copy image to clipboard
    """


    def execute(self):
        import subprocess
        file = self.fm.thisfile.path

        filetype = self.get_filetype()

        command = f"xclip -selection clipboard -t image/{filetype} -i {file}"

        xclip = self.fm.execute_command(command, universal_newlines=True)

        _, stderr = xclip.run()

        if xclip.returncode == 0:
            self.fm.notify("Copied to clipboard")
        else:
            self.fm.notify(stderr, bad=True)


    def get_filetype(self):
        import subprocess
        file = self.fm.thisfile.path

        command = f"file --mime-type {file} | awk '{{split($2, a, \"/\"); print a[2]}}'"

        cmd = self.fm.execute_command(command, universal_newlines=True)

        stdout, stderr = cmd.run()

        if cmd.returncode == 0:
            return str(stdout)
        else:
            self.fm.notify(stderr, bad=True)


class cd(Command):
    """:cd [-r] <dirname>

    The cd command changes the directory.
    The command 'cd -' is equivalent to typing ``.
    Using the option "-r" will get you to the real path.
    """

    def execute(self):
        import os.path
        if self.arg(1) == '-r':
            self.shift()
            destination = os.path.realpath(self.rest(1))
            if os.path.isfile(destination):
                self.fm.select_file(destination)
                return
        else:
            destination = self.rest(1)

        if not destination:
            destination = '~'

        if destination == '-':
            self.fm.enter_bookmark('`')
        else:
            self.fm.cd(destination)

    def tab(self, tabnum):
        import os
        from os.path import dirname, basename, expanduser, join

        cwd = self.fm.thisdir.path
        rel_dest = self.rest(1)

        bookmarks = [v.path for v in self.fm.bookmarks.dct.values()
                if rel_dest in v.path]

        # expand the tilde into the user directory
        if rel_dest.startswith('~'):
            rel_dest = expanduser(rel_dest)

        # define some shortcuts
        abs_dest = join(cwd, rel_dest)
        abs_dirname = dirname(abs_dest)
        rel_basename = basename(rel_dest)
        rel_dirname = dirname(rel_dest)

        try:
            # are we at the end of a directory?
            if rel_dest.endswith('/') or rel_dest == '':
                _, dirnames, _ = next(os.walk(abs_dest))

            # are we in the middle of the filename?
            else:
                _, dirnames, _ = next(os.walk(abs_dirname))
                dirnames = [dn for dn in dirnames
                        if dn.startswith(rel_basename)]
        except (OSError, StopIteration):
            # os.walk found nothing
            pass
        else:
            dirnames.sort()
            if self.fm.settings.cd_bookmarks:
                dirnames = bookmarks + dirnames

            # no results, return None
            if len(dirnames) == 0:
                return

            # one result. since it must be a directory, append a slash.
            if len(dirnames) == 1:
                return self.start(1) + join(rel_dirname, dirnames[0]) + '/'

            # more than one result. append no slash, so the user can
            # manually type in the slash to advance into that directory
            return (self.start(1) + join(rel_dirname, dirname) for dirname in dirnames)


class Dragon(Command):
    """
    Drag on drop functionality
    """

    def execute(self):
        import subprocess
        file = self.fm.thisfile.path

        command = f"dragon -x {file}"

        dragon = self.fm.execute_command(command, universal_newlines=True)

        _, stderr = dragon.run()

        if dragon.returncode == 0:
            self.fm.notify("File transfered")
        else:
            self.fm.notify(stderr, bad=True)

