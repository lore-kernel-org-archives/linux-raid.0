From: Gordon Henderson <gordon@drogon.net>
Subject: Quick Question ..
Date: Tue, 6 Jun 2006 10:36:42 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0606060931200.17732@lion.drogon.net>
References: <200605221746.38122.Dexter.Filmore@gmx.de>
 <17522.17186.715844.748238@cse.unsw.edu.au> <Pine.LNX.4.56.0605240913410.16780@lion.drogon.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0605240913410.16780@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


I'm just after conformation (or not!) of something I've done for a long
time which I think is right - it certainly seem right, but one of those
things I've always wondered about ...

When creating an array I allocate drives from alternative controllers with
the thought that the OS/system/hardware might be able to better overlap
accesses to the devices - but it sort of assumes that the kernel drivers
(and/or mdadm) don't re-order accesses to the devices internally (I'm not
counting SCSI logical re-ordering here)

So. eg. an example I'm working on now - I have a server with 2 external
facing SCSI interfaces, and a box with 14 drives on 2 chains - so 7 drives
on each interface (I'd prefer less, but it's what I've got - it's a Dell
external box)  sd{a-g} are on scsi0, and sd{h-n} are on scsi1, so I issue
the create command with:

  mdadm --create /dev/md1 -n14 -l6	\
	 /dev/sda /dev/sdh		\
	 /dev/sdb /dev/sdi		\
	etc.

I guess benchmarking it would be the way to really test it, but I'm not
after performance for this particular box - just after some thoughts as to
whether this is the "best" (or not!) way to do things, or if I'm wasting
my time doing it this way!

Thanks,

Gordon
