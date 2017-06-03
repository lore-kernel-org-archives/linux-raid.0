From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Recovery after accidental raid5 superblock rewrite
Date: Sat, 3 Jun 2017 23:20:11 +0200
Message-ID: <20170603212011.GA13271@metamorpher.de>
References: <2009e689-39b7-14fa-44bd-3288f96b9c91@tonel.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2009e689-39b7-14fa-44bd-3288f96b9c91@tonel.li>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Tonelli <paul@tonel.li>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jun 03, 2017 at 09:46:44PM +0200, Paul Tonelli wrote:
> I am trying to recover an ext4 partition on lvm2 on raid5.

Okay, your mail is very long, still unclear in places.

This was all done recently? So we do not have to consider that mdadm 
changed its defaults in regards to metadata versions, offsets, ...?

In that case I might have good news for you. 
Provided you didn't screw anything else up.

> ```
> mdadm --create --verbose --force --assume-clean /dev/md0 --level=5 
> --raid-devices=2  /dev/sdb /dev/sdc
> ```

You're not really supposed to do that.
( https://unix.stackexchange.com/a/131927/30851 )

> I immediately made backups of the three disks to spares using dd

This is a key point. If those backups are not good, you have lost.

> I made another mistake during the 3 days I spent trying to recover the 
> data, I switched two disks ids in a dd command and overwrite the first 
> 800Mb or so of disk c:

Just to confirm, this is somehow not covered by your backups?

> Part 2: What I tried
> ====================

In a data recovery situation there is one thing you should absolutely not do.
That is writing to your disks. Please use overlays in the future...
( https://raid.wiki.kernel.org/index.php/Recovering_a_damaged_RAID#Making_the_harddisks_read-only_using_an_overlay_file )

Your experiments wrote all sorts of nonsense to your disks.
As stated above, now it all depends on the backups you made...

>    - one is missing ~120 GB at the start of the array, I have marked 
> this disk as missing for all my tests

Maybe good news for you. Provided those backups are still there.

If I understood your story correctly, then this disk has good data.

RAID5 parity is a simple XOR. a XOR b = c

You had a RAID 5 that was fully grown, fully synced. 
You re-created it with the correct drives but wrong disk order. 
This started a sync.

The sync should have done a XOR b = c (only c is written to disk c)
Wrong order you did c XOR b = a (only a is written to disk a)

It makes no difference. Either way it wrote the data that was already there. 
Merely the data representation (what you got from /dev/md0) was garbage.

As long as you did not write anything to /dev/md0 when you couldn't mount, 
you're good right here. You just have to put the disks in correct order.

Proof:

--- Step 1: RAID Creation ---

# truncate -s 100M a b c
# losetup --find --show a
/dev/loop0
# losetup --find --show b
/dev/loop1
# losetup --find --show c
/dev/loop2
# mdadm --create /dev/md42 --level=5 --raid-devices=3 /dev/loop0 /dev/loop1 /dev/loop2
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md42 started.
# mdadm --wait /dev/md42
# mkfs.ext4 /dev/md42
# mount /dev/md42 loop/
# echo I am selling these fine leather jackets... > loop/somefile.txt
# umount loop/
# mdadm --stop /dev/md42

--- Step 2: Foobaring it up (wrong disk order) ---

# mdadm --create /dev/md42 --level=5 --raid-devices=3 /dev/loop2 /dev/loop1 /dev/loop0
mdadm: /dev/loop2 appears to be part of a raid array:
       level=raid5 devices=3 ctime=Sat Jun  3 23:01:31 2017
mdadm: /dev/loop1 appears to be part of a raid array:
       level=raid5 devices=3 ctime=Sat Jun  3 23:01:31 2017
mdadm: /dev/loop0 appears to be part of a raid array:
       level=raid5 devices=3 ctime=Sat Jun  3 23:01:31 2017
Continue creating array? yes
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md42 started.
# mdadm --wait /dev/md42
# mount /dev/md42 loop/
mount: wrong fs type, bad option, bad superblock on /dev/md42,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.
# mdadm --stop /dev/md42

--- Step 3: Pulling the rabbit out of the hat (correct order, even one missing) ---

# mdadm --create /dev/md42 --level=5 --raid-devices=3 /dev/loop0 missing /dev/loop2
mdadm: /dev/loop0 appears to be part of a raid array:
       level=raid5 devices=3 ctime=Sat Jun  3 23:04:35 2017
mdadm: /dev/loop2 appears to be part of a raid array:
       level=raid5 devices=3 ctime=Sat Jun  3 23:04:35 2017
Continue creating array? yes
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md42 started.
# mount /dev/md42 loop/
# cat loop/somefile.txt 
I am selling these fine leather jackets...

> - I am a the point where hiring somebody / a company with better 
> experience than mine to solve this issue is necessary. If yes who would 
> you advise, if this is an allowed question on the mailing list ?

Oh. I guess should have asked for money first? Damn.

Seriously though. I don't know if the above will solve your issue. 
It is certainly worth a try. And if it doesn't work it probably means 
something else happened... in that case chances of survival are low.

Pictures (if they are small / unfragmented, with identifiable headers, 
i.e. JPEGs not RAWs) can be recovered but not their filenames / order. 

Filesystem with first roughly 2GiB missing... filesystems _HATE_ that.

Regards
Andreas Klauer
