From: "Kyle" <kyle@southa.com>
Subject: Something md raid-5 questions
Date: Sat, 21 Feb 2004 15:47:03 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <006e01c3f84e$e5a46680$353ffea9@kyle>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I'm planning to built a md raid-5 with 6 IDE-disks, and I have somethings
questions, wish that someone here can give me some advance.

If I built a raid-5 like this:
/dev/md0 (raid1 mirroring for /boot) :
/dev/hda1, /dev/hdb1, /dev/hdc1, /dev/hdd1, /dev/hde1, /dev/hdf1

/dev/md1 (/dev/hdf2 being hot-spare disk):
/dev/hda2 + /dev/hdb2 + /dev/hdc2 + /dev/hdd2 + /dev/hde2 + /dev/hdf2

1. If, one of the disk from hd(a-e) failed, will /dev/hdf auto re-built with
contents of the failed disk?
2. If, one of the disk from hd(a-e) failed AND /dev/hdf is rebuilded with
contents of failed disk, can I shut down the machine, unplug /dev/hdf, plug
it back as /dev/hd(a-e), and assume I can boot the machine and mount
/dev/md0 and /dev/md1 w/o problems?
3, If, /dev/hda dead, will there be any difficulty or is there any special
things for me to recover the raid?
4. Any special advance for builting such a raid5 ?
5. I know SCSI is good and fast, but I can't really afford it (I need 6 x
250GB, or 12 x 146GB for SCSI!), any recommended IDE controller / chipset
known to be happy with kernel 2.6.x? I don't need/want any hardware RAID
solutions, since I always think that, if the card itself got some problems
..... I'll have a hard-time to get my data back.

6. Is there any up-to-date documentations for md raid5 for me to read from
web?

Thanks in advance, I read the maillist from the web so please CC my email if
possible.

Kyle




