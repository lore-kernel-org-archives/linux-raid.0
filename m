From: Mike Hartman <mike@hartmanipulation.com>
Subject: New RAID causing system lockups
Date: Sat, 11 Sep 2010 14:12:21 -0400
Message-ID: <AANLkTimbYOYj7_f+FKjemsjmjpV0FsdG_wyQZrvu4Vnx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've tried sending this twice now (it was my first post to the list)
but it never seems to make it through. Resending in multiple parts to
see if it's just too long.

PART 1:

First let me outline where I am and how I got to this point.

About a week ago I created a RAID array on my Gentoo server. I already
had a handful of full, independent drives on that server, and 3 new
empty ones. The three new 1.5TB SATA drives are in an external e-SATA
enclosure, along with 2 of the existing drives (750GB each). The
e-SATA enclosure is connected to the server with a Syba SD-SA2PEX-2E
card (SIL3132 chipset) since it supports port multiplying. The other 4
drives (2 1.5TB, 2 750GB) are still mounted in the server itself.

My goal was to end up with all the drives (9) in a single RAID 6 array
to use as a storage partition (not for any system files). I only had 3
clean ones, so I wanted to start with RAID 5, use that new space to
clear off some of the other drives, and bootstrap up to a RAID 6.

My first step was to update to the newest stable gentoo kernel
(2.6.35-gentoo-r4) to be sure I had reasonably current mdadm support.
No problems during that upgrade.

Then I created 1.5 TB partitions (type 0xDA) on each of the 3 new
(empty) drives and assembled them into a RAID 5 array (md0). Once that
was finished resyncing I created an ext4 filesystem and started
copying over everything that was on the 2 750GB drives in the same
enclosure.

Once that was done (no problems) and the 750s were empty I created a
RAID 0 (md1) from them. I created a 1.5TB partition on md1 just like I
had on a bare drives, and then added that partition to md0 as a hot
spare. I've seen that approach in several RAID tutorials - it seems
like the only way to get these undersized drives into the same RAID 6.

Then I switched md0 over to a RAID 6, using that hot spare. The
reshaping was SLOW (4MB/s) but that seems to be par for the course in
a RAID5->RAID6 transition.

It was during this reshaping that I saw my first lockup. I was
monitoring things via SSH, and the reshaping was about 13% complete.
The filesystem was mounted but wasn't being written to (or even read
much). I noticed my SSH session had stopped responding, so I tried
creating a new one in a fresh terminal. I was able to enter my
password, see the MOTD, and get a prompt, but couldn't type anything
into it. Tried this several times with no luck. Physically sat down at
the computer (no X running) and couldn't even get the screen to wake
up. The monitor's LED made it seem awake, but I only got a black
screen and couldn't even Ctrl-Alt-F2 to get a fresh terminal.

CONTINUED IN PART 2
