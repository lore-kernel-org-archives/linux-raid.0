From: "Mikael Chambon" <raid-ml@cronos.org>
Subject: RAID design
Date: Fri, 11 Jul 2003 12:10:14 -1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000201c3480a$9c7ebbd0$27e703ca@magnus>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,
First I wish to thanks you guys for your answers, I really apreciate.
Now I have a question about RAID design.

I am trying to implement the best soft RAID system for a samba fileserver
as safer as possible.

Here is my first idea:

 1) Using a small hard drive for the OS (2gigs)
plugged as IDE 1 master (won't take part of the raid array).

2) Using two 120 gig for the fileserver in a raid1 array
The first one will be as IDE1 slave and the second one as
IDE2 master (the cdrom drive will be IDE2 slave).

The weakness here will be if the first hard drive with the OS
failed.


My second idea is:

Use only 2 120 gig hard drives and implement a root raid array including
the OS. The first one as IDE1 master and the second one as IDE2 master.
(The cdrom drive as IDE1 slave).

I am not RAID expert but I really don't see the benefits of including
the OS in the RAID array as if the primary HD failed, the system won't be
able to boot anyway. Am I right ?

I mean if the primary disk failed, even if I ask the BIOS to boot the second
hard drive, the system won't boot as everything is linked to hda in the
system.

As you can see I am a little confused about root-raid and the benefits, if
someone
could give me some advices and tell me which solution is the best I would
really appreciate.

Thanks a lot and have a nice day.
--
Mikael Chambon


