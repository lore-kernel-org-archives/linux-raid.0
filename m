From: Jim Paris <jim@jtan.com>
Subject: Re: Call for RAID-6 users
Date: Mon, 26 Jul 2004 17:38:11 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040726213811.GA17363@jim.sh>
References: <cds76e$ee7$1@terminus.zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cds76e$ee7$1@terminus.zytor.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Thus, if you have used RAID-6 and have good or bad experiences, I'd
> like to know them as soon as possible.

Just tried setting up a RAID-6 on a new server, and I'm seeing
complete filesystem corruption.

I have 6 250GB disks, and want them all in the array.  I've created it
degraded, with the first disk missing, since that disk temporarily
holds the system.

Using kernel 2.6.7, mdadm 1.6.0, I did something like this:

# mdadm --create /dev/md1 --level=6 --chunk=128 --raid-devices=6 missing /dev/hd{g,i,k,m,o}2

which gives me:

md1 : active raid6 hdo2[5] hdm2[4] hdk2[3] hdi2[2] hdg2[1]
      976269312 blocks level 6, 128k chunk, algorithm 2 [6/5] [_UUUUU]

Then created the filesystem:
# mkreiserfs /dev/md1
# reiserfsck /dev/md1  # <-- no errors
# df -H                # <-- shows proper size (1 TB)

Then copied the system do it:
# mount /dev/md1 /mnt/root
# cd /mnt/root ; tar --one-file-system -cf - / | tar --preserve -xvf - ; cd /
# umount /mnt/root
# reiserfsck /dev/md1  # <-- many, many errors

There were no errors in dmesg while copying the data to the
filesystem, or while running reiserfsck.  The filesystem gives tons of
errors if I try to use it as root.  Not sure what else to try.  It's
easy to reproduce, and seems to fail the exact same way every time.

I need this server up soon, so I may just settle for RAID5, but I can
keep it around for testing for a few days.  Let me know if you'd like
access to the machine.

-jim
