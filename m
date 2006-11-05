From: dean gaudet <dean@arctic.org>
Subject: mdadm 2.5.5 external bitmap assemble problem
Date: Sat, 4 Nov 2006 18:51:13 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0611041838080.13706@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i think i've got my mdadm.conf set properly for an external bitmap -- but 
it doesn't seem to work.  i can assemble from the command-line fine 
though:

# grep md4 /etc/mdadm/mdadm.conf
ARRAY /dev/md4 bitmap=/bitmap.md4 UUID=dbc3be0b:b5853930:a02e038c:13ba8cdc

# mdadm -A /dev/md4
mdadm: Could not open bitmap file

# mdadm -A --uuid=dbc3be0b:b5853930:a02e038c:13ba8cdc --bitmap=/bitmap.md4 /dev/md4
mdadm: /dev/md4 has been started with 5 drives and 1 spare.

# mdadm --version
mdadm - v2.5.5 - 23 October 2006

(this is on debian unstale)

btw -- mdadm seems to create the bitmap file with world readable perms.
i doubt it matters, but 600 would seem like a better mode.

hey i have another related question... external bitmaps seem to pose a bit 
of a chicken-and-egg problem.  all of my filesystems are md devices. with 
an external bitmap i need at least one of the arrays to start, then have 
filesystems mounted, then have more arrays start... it just happens to 
work OK if i let debian unstale initramfs try to start all my arrays, 
it'll fail for the ones needing bitmap.  then later /etc/init.d/mdadm-raid 
should start the array.  (well it would if the bitmap= in mdadm.conf 
worked :)

is it possible to put bitmaps on devices instead of files?  mdadm seems to 
want a --force for that (because the device node exists already) and i 
haven't tried forcing it.  although i suppose a 200KB partition would be 
kind of tiny.... but i could place the bitmap right beside the external 
transaction log for the filesystem on the raid5.

-dean
