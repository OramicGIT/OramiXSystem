import tkinter as tk
from tkinter import ttk, Menu, Text, filedialog
import datetime
import getpass
import os

class Windows11Desktop(tk.Tk):
    def __init__(self):
        super().__init__()

        self.title("Windows 11 Desktop")
        self.geometry("800x600")
        self.configure(bg='#ADD8E6')  # Light Blue Background

        self.is_fullscreen = False
        self.bind("<F11>", self.toggle_fullscreen)

        # Style
        style = ttk.Style(self)
        style.theme_use('clam')
        style.configure('TButton', font=('Segoe UI', 10, 'bold'), padding=10, relief='flat', background='#2D2D30', foreground='white')
        style.configure('TLabel', font=('Segoe UI', 10), background='#ADD8E6', foreground='black')
        style.configure('TFrame', background='#ADD8E6')

        # Taskbar
        self.create_taskbar()

        # Start Menu
        self.create_start_menu()

        # Widgets Panel
        self.create_widgets_panel()

        # Clock
        self.clock_label = ttk.Label(self, text="", font=('Segoe UI', 12), background='#ADD8E6', foreground='black')
        self.clock_label.place(relx=1.0, rely=0.0, anchor='ne', x=-10, y=10)
        self.update_clock()

        # User Info
        self.user_label = ttk.Label(self, text="", font=('Segoe UI', 12), background='#ADD8E6', foreground='black')
        self.user_label.place(relx=0.0, rely=0.0, anchor='nw', x=10, y=10)
        self.update_user_info()

        # Settings
        self.create_settings()

    def create_taskbar(self):
        taskbar = ttk.Frame(self, height=40, relief='raised')
        taskbar.pack(side='bottom', fill='x')

        start_button = ttk.Button(taskbar, text="Start", command=self.toggle_start_menu)
        start_button.pack(side='left', padx=10)

    def create_start_menu(self):
        self.start_menu = tk.Toplevel(self)
        self.start_menu.geometry("300x400")
        self.start_menu.configure(bg='#2D2D30')
        self.start_menu.withdraw()

        start_label = ttk.Label(self.start_menu, text="Start Menu", background='#2D2D30', foreground='white', font=('Segoe UI', 12, 'bold'))
        start_label.pack(pady=10)

        start_menu_frame = ttk.Frame(self.start_menu)
        start_menu_frame.pack(fill='both', expand=True)

        self.create_start_menu_item(start_menu_frame, "Text Editor", self.open_text_editor)
        self.create_start_menu_item(start_menu_frame, "File Explorer", self.open_file_explorer)
        self.create_start_menu_item(start_menu_frame, "Settings", self.open_settings)
        # Add more applications here

    def create_start_menu_item(self, parent, name, command):
        item_frame = ttk.Frame(parent)
        item_frame.pack(fill='x', pady=2, padx=5)

        item_button = ttk.Button(item_frame, text=name, command=command)
        item_button.pack(fill='x')

    def create_widgets_panel(self):
        self.widgets_panel = tk.Toplevel(self)
        self.widgets_panel.geometry("200x400")
        self.widgets_panel.configure(bg='#ADD8E6')
        self.widgets_panel.title("Widgets")
        self.widgets_panel.withdraw()

        widgets_label = ttk.Label(self.widgets_panel, text="Widgets", font=('Segoe UI', 12, 'bold'))
        widgets_label.pack(pady=10)

        # Add widgets here (e.g., weather, news, etc.)
        weather_label = ttk.Label(self.widgets_panel, text="Weather: Sunny")
        weather_label.pack()
        news_label = ttk.Label(self.widgets_panel, text="News: No news today")
        news_label.pack()

    def create_settings(self):
        self.settings_window = tk.Toplevel(self)
        self.settings_window.geometry("400x300")
        self.settings_window.configure(bg='#ADD8E6')
        self.settings_window.title("Settings")
        self.settings_window.withdraw()

        settings_label = ttk.Label(self.settings_window, text="Settings", font=('Segoe UI', 12, 'bold'))
        settings_label.pack(pady=10)

        # Add settings options here (e.g., change background color)
        bg_color_label = ttk.Label(self.settings_window, text="Background Color:")
        bg_color_label.pack()
        bg_color_entry = ttk.Entry(self.settings_window)
        bg_color_entry.insert(0, "#ADD8E6")  # Default light blue
        bg_color_entry.pack()

        apply_button = ttk.Button(self.settings_window, text="Apply", command=lambda: self.change_background(bg_color_entry.get()))
        apply_button.pack(pady=10)

    def change_background(self, color):
        try:
            self.configure(bg=color)
            style = ttk.Style(self)
            style.configure('TLabel', background=color)
            style.configure('TFrame', background=color)
            self.settings_window.configure(bg=color)
            for widget in self.widgets_panel.winfo_children():
                widget.configure(background=color)
            self.widgets_panel.configure(background=color)
        except tk.TclError:
            print("Invalid color format!")

    def toggle_fullscreen(self, event=None):
        self.is_fullscreen = not self.is_fullscreen
        self.attributes("-fullscreen", self.is_fullscreen)
        return "break"

    def toggle_start_menu(self):
        if self.start_menu.winfo_viewable():
            self.start_menu.withdraw()
        else:
            self.start_menu.deiconify()

    def open_text_editor(self):
        text_editor = tk.Toplevel(self)
        text_editor.title("Text Editor")
        text_editor.geometry("600x400")

        text_area = Text(text_editor, wrap='word')
        text_area.pack(expand=True, fill='both')

    def open_file_explorer(self):
        file_explorer = tk.Toplevel(self)
        file_explorer.title("File Explorer")
        file_explorer.geometry("800x600")

        # Directory listing
        def populate_files(directory):
            for item in os.listdir(directory):
                item_path = os.path.join(directory, item)
                if os.path.isfile(item_path):
                    files_list.insert(tk.END, f"File: {item}")
                elif os.path.isdir(item_path):
                    files_list.insert(tk.END, f"Dir: {item}")

        # Navigation
        def browse_directory():
            initial_dir = os.path.expanduser("~")
            directory = filedialog.askdirectory(initialdir=initial_dir)
            if directory:
                files_list.delete(0, tk.END)
                populate_files(directory)

        # UI
        browse_button = ttk.Button(file_explorer, text="Browse", command=browse_directory)
        browse_button.pack(pady=10)

        files_list = tk.Listbox(file_explorer, width=100, height=30)
        files_list.pack(expand=True, fill='both', padx=10, pady=10)

    def open_settings(self):
        self.settings_window.deiconify()

    def update_clock(self):
        now = datetime.datetime.utcnow()
        formatted_time = now.strftime("%Y-%m-%d %H:%M:%S UTC")
        self.clock_label.config(text=formatted_time)
        self.after(1000, self.update_clock)

    def update_user_info(self):
        user_login = getpass.getuser()
        self.user_label.config(text=user_login)

if __name__ == "__main__":
    app = Windows11Desktop()
    app.mainloop()