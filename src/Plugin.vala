/*
 * Copyright (c) 2011-2015 Marcus Wichelmann (marcus.wichelmann@hotmail.de)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

public class Drop.Plugin : Marlin.Plugins.Base {
    private Drop.Session session;

    public Plugin () {
        session = new Drop.Session ();
    }

    public override void context_menu (Gtk.Widget? widget, List<GOF.File> gof_files) {
        Gtk.Menu? menu = widget as Gtk.Menu;

        if (context_menu != null && gof_files != null) {
            enhance_menu (menu, gof_files);
        }
    }

    private void enhance_menu (Gtk.Menu menu, List<GOF.File> files) {
        Gtk.MenuItem drop_menu_item = new Gtk.MenuItem.with_label (_("Send to…"));
        try {
            Drop.TransmissionPartner[] transmission_partners = session.get_transmission_partners (false);

            if (transmission_partners.length > 0) {
                Gtk.Menu drop_submenu = new Gtk.Menu ();

                for (int i = 0; i < transmission_partners.length; i++) {
                    if (i >= 5) {
                        break;
                    }

                    Drop.TransmissionPartner transmission_partner = transmission_partners[i];

                    Gtk.MenuItem partner_menu_item = new Gtk.MenuItem.with_label (transmission_partner.display_name);
                    partner_menu_item.activate.connect (() => {
                        start_transmission (transmission_partner, files);
                    });

                    add_menu_item (drop_submenu, partner_menu_item);
                }

                Gtk.MenuItem others_menu_item = new Gtk.MenuItem.with_label (_("Others…"));
                others_menu_item.activate.connect (() => {
                    show_drop_dialog (files);
                });

                add_menu_item (drop_submenu, new Gtk.SeparatorMenuItem ());
                add_menu_item (drop_submenu, others_menu_item);

                drop_menu_item.set_submenu (drop_submenu);
            } else {
                drop_menu_item.activate.connect (() => {
                    show_drop_dialog (files);
                });
            }

            add_menu_item (menu, new Gtk.SeparatorMenuItem ());
            add_menu_item (menu, drop_menu_item);
        } catch (Error e) {
            warning ("Loading drop menu failed: %s", e.message);
        }
    }

    private void start_transmission (Drop.TransmissionPartner transmission_partner, List<GOF.File> files) {
        string[] filenames = {};

        foreach (GOF.File file in files) {
            if (file.file_type == FileType.REGULAR) {
                filenames += file.location.get_path ();
            }
        }

        try {
            session.start_transmission (transmission_partner.hostname, transmission_partner.port, filenames, true);
        } catch (Error e) {
            warning ("Starting transmission failed: %s", e.message);
        }
    }

    private void show_drop_dialog (List<GOF.File> files) {
        string command = "drop-dialog";

        foreach (GOF.File file in files) {
            if (file.file_type == FileType.REGULAR) {
                command += " %s".printf (file.location.get_path ().replace (" ", "\\ "));
            }
        }

        Granite.Services.System.execute_command (command);
    }

    private void add_menu_item (Gtk.Menu menu, Gtk.MenuItem menu_item) {
        menu.append (menu_item);
        menu_item.show ();

        plugins.menuitem_references.add (menu_item);
    }
}

public Marlin.Plugins.Base module_init () {
    return new Drop.Plugin ();
}