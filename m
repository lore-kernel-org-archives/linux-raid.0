From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: linux/raid problem, linux not recognizing bios raid
Date: Sun, 17 Oct 2004 00:29:11 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410170429.i9H4THN05204@www.watkins-home.com>
References: <000401c4b3f4$47bc9570$6101a8c0@renoir>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000401c4b3f4$47bc9570$6101a8c0@renoir>
To: "'Robert E. Singer'" <Robert.E.Singer@cox.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is just a guess....

Since the MB has RAID drivers that are required to install XP (if using
RAID).  I think the RAID would also require drivers for Linux.  And since
you see both disks, I bet the RAID system is really a software RAID.  But
just a guess.  The downloads section from ABIT don't list Linux at all.

Some RAID cards are really software RAID and require drivers that contain
the RAID software.  This is not the same as using the software RAID built-in
to Linux.

I have never had a fake hardware RAID system before, but I have read about
them on this list.

I hope I am wrong, else you got F'd.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Robert E. Singer
Sent: Saturday, October 16, 2004 10:52 PM
To: linux-raid@vger.kernel.org
Subject: linux/raid problem, linux not recognizing bios raid

hi -

i dont have tons of linux experience.  my in-depth unix experience was many
years ago.

im building a system containing:
- abit ic7g motherboard
- 2 wd 160gb sata hard drives
- red hat linux workstation version 3

the drives have been physically installed and the bios configured to run the
disks as a raid (either raid0 or raid1). this is verified during the post.

when i try to install linux, the disk partitioning program reports two disks
/dev/sda & /dev/sdb individually with 160gb capacities available for
partitioning, not one.  whether using bios raid0 or raid1, only 1 disk
should be available (with 160 or 320 gb available, depending on the raid
flavor).

whats wrong?

bob singer 

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

