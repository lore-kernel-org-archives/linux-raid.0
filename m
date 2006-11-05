From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm 2.5.5 external bitmap assemble problem
Date: Mon, 6 Nov 2006 09:48:36 +1100
Message-ID: <17742.27204.963051.400395@cse.unsw.edu.au>
References: <Pine.LNX.4.64.0611041838080.13706@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from dean gaudet on Saturday November 4
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday November 4, dean@arctic.org wrote:
> i think i've got my mdadm.conf set properly for an external bitmap -- but 
> it doesn't seem to work.  i can assemble from the command-line fine 
> though:
> 
> # grep md4 /etc/mdadm/mdadm.conf
> ARRAY /dev/md4 bitmap=/bitmap.md4 UUID=dbc3be0b:b5853930:a02e038c:13ba8cdc
> 
> # mdadm -A /dev/md4
> mdadm: Could not open bitmap file

Arg!!

--- .prev/config.c	2006-10-13 08:16:19.000000000 +1000
+++ ./config.c	2006-11-06 09:42:14.000000000 +1100
@@ -464,7 +464,7 @@ void arrayline(char *line)
 				fprintf(stderr, Name ": only specify bitmap file once. %s ignored\n",
 					w);
 			else
-				mis.bitmap_file = w+7;
+				mis.bitmap_file = strdup(w+7);
 
 		} else if (strncasecmp(w, "devices=", 8 ) == 0 ) {
 			if (mis.devices)


Thanks!

> 
> btw -- mdadm seems to create the bitmap file with world readable perms.
> i doubt it matters, but 600 would seem like a better mode.

Set you umask to 077?  Maybe we could have a bitmap_perms= option
to the 'CREATE' line in mdadm.conf....


> 
> hey i have another related question... external bitmaps seem to pose a bit 
> of a chicken-and-egg problem.  all of my filesystems are md devices. with 
> an external bitmap i need at least one of the arrays to start, then have 
> filesystems mounted, then have more arrays start... it just happens to 
> work OK if i let debian unstale initramfs try to start all my arrays, 
> it'll fail for the ones needing bitmap.  then later /etc/init.d/mdadm-raid 
> should start the array.  (well it would if the bitmap= in mdadm.conf 
> worked :)
> 
> is it possible to put bitmaps on devices instead of files?  mdadm seems to 
> want a --force for that (because the device node exists already) and i 
> haven't tried forcing it.  although i suppose a 200KB partition would be 
> kind of tiny.... but i could place the bitmap right beside the external 
> transaction log for the filesystem on the raid5.

Create the root filesystem with --bitmap=internal, and store all the
other bitmaps on that filesystem maybe?

I don't know if it would work to have a bitmap on a device, but you
can always mkfs the device, mount it, and put a bitmap on a file
there??

NeilBrown
