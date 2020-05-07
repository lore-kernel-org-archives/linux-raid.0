From: "David F" <raid@meta-dynamic.com>
Subject: "mdadm -n": component device selection when delta_disks<0
Date: Thu, 07 May 2020 15:36:36 -0400
Message-ID: <20200507193636.5B4FE53E95@mail.meta-dynamic.com>
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi list,

I've got a RAID-5 array that I'm looking to reshape from 3-on-4
3TB-device [9TB-array] to 2-on-3 6TB-device [12TB-array], after
having replaced all 3TB drives with larger 6TB ones.  I'll omit
the details and simplify a little, since my question is more
general in nature, but here is a crude ascii diagram ('#' is used
disk sectors, either data or parity, and ' ' is unused).

Currently running
RAID-5 3-on-4 3TB md-dev-size, 9TB array-size:
+-------+-------+-------+-------+
| dev 1 | dev 2 | dev 3 | dev 4 |
+-------+-------+-------+-------+
|#######|#######|#######|#######|  :
|#######|#######|#######|#######|  :
|#######|#######|#######|#######| 3TB
|       |       |       |       |  :
|       |       |       |       |  :
|       |       |       |       | 6TB
+-------+-------+-------+-------+

Want to reshape to
RAID-5 2-on-3 6TB md-dev-size, 12TB array-size:
+-------+-------+-------+-------+
| dev 1 | dev 2 | dev 3 | dev 4 |
+-------+-------+-------+-------+
|#######|#######|#######|       |  :
|#######|#######|#######|       |  :
|#######|#######|#######|       | 3TB
|#######|#######|#######|       |  :
|#######|#######|#######|       |  :
|#######|#######|#######|       | 6TB
+-------+-------+-------+-------+

... and remove dev 4 from the array.


I'm planning to use use three mdadm commands to accomplish the
reshape, as follows:

mdadm --grow --size=6000G --assume-clean /dev/md0
mdadm --grow --array-size=12000G /dev/md0
mdadm --grow --raid-devices=3 --backup-file=/root/md-backup /dev/md0


Ideally, I'd prefer a single command,
mdadm --grow --size=6000G --raid-devices=3 /dev/md0
... but that seems not possible [1].


In either case, my question still applies: when reshaping to
reduce the number of devices in the array (--raid-devices), is
there any way to specify exactly which device(s) are to be
removed from active sync (I suppose they become spares) and which
ones kept?  It seems odd that this would not be possible to
control, but I've perused the mdadm manual-page, the wiki, the
mailing-list archives, the web-search-engine, etc. and I can't
seem to find any direct answer.  Also scanned the source code of
both mdadm and the kernel driver, and didn't see a way to select
beyond just listing component drives on the command-line,
although with so many different kinds of functionality mixed in
one (two) dense codebase, I didn't yet definitively determine
where the drive(s) to eliminate are selected... hence asking here
before spending more time with the code or setting up a test
array to trial-and-error.

It seems like a selection option akin to --replace and --with
would be appropriate here, but perhaps I'm missing something.

Any info or advice appreciated, thanks in advance.
-- David


[1]: A blog post by Neil Brown in 2009 [2] seemed to indicate
     that it would be implemented, but while I haven't tried it,
     my reading of the source code (current HEAD) of mdadm leads
     me to believe that this is as yet unimplemented, please
     correct me if I'm wrong.  In fact, there seem to me to be
     specific validation checks that prevent any of the three
     commands (-z, -Z, -n) from being combined with any other.
     But I didn't go through it with a fine-toothed comb.

[2]: From http://neil.brown.name/blog/20090817000931:
     If you have replaced all the devices with larger devices,
     you can avoid the need to reduce the size of the array by
     increasing the component size at the same time as reducing
     the number of devices. e.g. on a 4-disk RAID5,
	`mdadm --grow --size max --raid-disk 3`
     ... or at least you should be able to. The current mdadm
     pre-release don't get that right but hopefully it will
     before mdadm-3.1 is really released.
