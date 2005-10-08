From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Anybody know about nforce4 SATA II hot swapping + linux raid?
Date: Sat, 8 Oct 2005 16:23:25 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0510081600080.7326@lion.drogon.net>
References: <200510071111.46788.andrew@walrond.org> <43477836.6020107@gmail.com>
 <62b0912f0510080726ge2436e9ra6d7e8d17d1001ee@mail.gmail.com>
 <200510081555.41159.andrew@walrond.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932158AbVJHPXd@vger.kernel.org>
In-Reply-To: <200510081555.41159.andrew@walrond.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Walrond <andrew@walrond.org>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 8 Oct 2005, Andrew Walrond wrote:

> On Saturday 08 October 2005 15:26, Molle Bestefich wrote:
> >
> > IDE hotswap has never worked (OOTB at least) in Linux, and based on my
> > experience it never will.  Seems the IDE folks doesn't care a bit
> > about it.  (No offence meant.  Just keeping it real.)
>
> Fair enough. What about SCSI? Do any of the in-kernel scsi drivers support
> hotswap? And if so, how well does it cooperate with linux raid?

I've successfully hot-swapped SCSI drives in a live server, so yes, I
guess it does!

You have to fail the drive (if it's not failed already!) then remove it,

(mdadm --fail /dev/mdX /dev/sdxy, then mdadm --remove /dev/mdX /dev/sdyz)

then use the runes:

  echo "scsi remove-single-device 0 1 2 3" > /proc/scsi

where 0 1 2 3 represent the scsi host, channel, device id and lun, (get
this out of /proc/scsi/scsi if unsure)

then (assuming your hardware supports it), you can power down that drive
and unplug it, put a new one it, then do the opposite rune:

  echo "scsi add-single-device 0 1 2 3" > /proc/scsi

make sure the kernel sees it (look in /var/log/kern.log, or wherever your
distribution puts this stuff), then mdadm --add ...

Then you can partition (if required) and add it back into the array with
the usual mdadm --add /dev/mdX /dev/sdyz

If your drive is partitioned and each partition is part of a separate RAID
set then you will have to FAIL each partition and remove it in-turn. The
scsi remove-single-device command will only be successfull of all
partitions are not in-use. (similarly you'll have to partition and mdadm
--add each partition with the new drive)

Ideally you want hardware that will power the drive down nicely before you
take it out (and power it up nicely after you plug it back in again) to
avoid any glitches on the SCSI bus, etc...

I've had to do this in a Dell and a home-made box, neither of which had
any facilities for soft powering the drives down or up - I got away with
it, so maybe I was lucky, but I'd do it again if I had to.

One thing to watch out for - if you reboot after taking the drive out the
scsi drive letters will be logically renumbered, so if you take out sda,
then reboot, what was sdb will now become sda, and so on, so if you then
subsequently hot plug a drive in, it will still have the same scsi host,
channel, id, lun numbers, but it'll be the last device in the array (eg.
it will be sdf if it was a 6-disk array) Reboot again and the original
numbering/lettering would be restored.

Good job the RAID code doesn't really care about this...

Good luck!

Gordon
