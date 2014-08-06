#!/usr/bin/ruby

=begin

* Specify the location of the popup. -- maybe use wmctrl?
** See Libwm
* Specify the location of the command which is executed.
* Control-a to highlight the text
* If destroying itself, switch to the previous window -- maybe use wmctrl?

=end

require 'tk'

# ARGV[0] = "xterm"

class Launcher

  def initialize
# common options
ph = { 'padx' => 10, 'pady' => 10 }
    command = TkVariable.new
    root = TkRoot.new { title "Launcher 3" }
    top = TkFrame.new(root)
    text_area = TkEntry.new(top, 'textvariable' => command)
    # Be able to call it with a pre-typed, but not yet executed, command
    text_area.insert(0,ARGV[0])
    text_area.pack(ph)
    # TODO:
    text_area.bind("Control-a") {p "highlight all"}
    text_area.bind("Control-A") {p "highlight all"}
    text_area.bind("Any-Key-Return") {launch(command)}
#     text_area.bind("Any-Key-Enter") {launch(command)}
    text_area.focus()

    button = TkButton.new(root) {text "Go"; proc{launch(command)}; pack ph}
    button.configure('underline'=>0)
    # FIXME: Hitting spacebar makes the 'go' button explode.  But I see no sensible key to bind!
    # button.bind("Space") {launch(command)}
    button.pack("side"=>"right")

    root.bind("Escape") {proc exit}
    root.bind("Alt-g") {launch(command)}
    root.bind("Alt-G") {launch(command)}

    # Perform actions when pressing 'x'
    TkRoot.new.protocol('WM_DELETE_WINDOW', proc{window_close})

    top.pack('fill'=>'both', 'side' =>'top')
  end # def initialize

  def launch(command)
#     p                 @text.value
#     p      'nohup ' + @text.value + '>/dev/null&'
    system('nohup ' + command.value + '>/dev/null&')
    # I don't believe the delay is necessary.
    # sleep 0.01
    exit
  end # def launch(command)

  def window_close
    p "close button pressed"
    proc exit
  end # def window_close

end # class Launcher

Launcher.new
Tk.mainloop


__END__

* Allow tab-completion
* Be able to display the output of the program which ran.
* use ~/.bash_history for past programs
* make a featureful control panel which stores the last run programs and their results.
* The location of the launcher window can be done via Devil's Pie.
* The location of the window which is created could be done via Devil's Pie. But how would Devil's Pie be informed of the things to match? It would have to be prepared, and then act on any window, and then run, and then the command would be launched, and then Devil's Pie would be killed.
** But what if Devil's Pie is already being run on the system? Is there a smarter way to do a "one shot" use of Devil's Pie? 
