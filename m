From: Gordon Henderson <gordon@drogon.net>
Subject: Re: RAID 5 on four IDE channels doesn't work
Date: Sun, 10 Oct 2004 19:56:10 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0410101951040.9395@lion.drogon.net>
References: <1097432092.1294.8.camel@qabal.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1097432092.1294.8.camel@qabal.org>
To: "Nathanial A. Byrnes" <nate@qabal.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 10 Oct 2004, Nathanial A. Byrnes wrote:

> 	Where hde-hdh are on my PCI promise controller, and hdi-hdl are on my
> onboard HighPoint 366 controller. (The same array worked on just the
> Highpoint 366 controller as well)

Assuming you have the right driver compiled into the kernel, /dev doesn't
list hdi-l by default (at least not on my Debian systems) Check the dmesg
output to make sure the driver is compiled in and it's recognising the
drives.

You might need to run MAKEDEV with the right runes - but worse, I've had
to hand-edit this file to insert the right major/minor device numbers for
some really high alphabetical letters.

I have this:

brw-rw----    1 root     disk       3,   0 Mar 14  2002 hda
brw-rw----    1 root     disk       3,  64 Mar 14  2002 hdb
brw-rw----    1 root     disk      22,   0 Mar 14  2002 hdc
brw-rw----    1 root     disk      22,  64 Mar 14  2002 hdd
brw-rw----    1 root     disk      33,   0 Mar 14  2002 hde
brw-rw----    1 root     disk      33,  64 Mar 14  2002 hdf
brw-rw----    1 root     disk      34,   0 Mar 14  2002 hdg
brw-rw----    1 root     disk      34,  64 Mar 14  2002 hdh
brw-rw----    1 root     disk      56,   0 May 24 15:31 hdi
brw-rw----    1 root     disk      56,  64 May 24 15:31 hdj
brw-rw----    1 root     disk      57,   0 May 24 15:31 hdk
brw-rw----    1 root     disk      57,  64 May 24 15:31 hdl
brw-rw----    1 root     disk      88,   0 May 24 16:00 hdm
brw-rw----    1 root     disk      88,  64 May 24 16:00 hdn
brw-rw----    1 root     disk      89,   0 May 24 16:00 hdo
brw-rw----    1 root     disk      89,  64 May 24 16:00 hdp
brw-rw----    1 root     disk      90,   0 May 24 16:00 hdq
brw-rw----    1 root     disk      90,  64 May 24 16:00 hdr

I think I had to dig in the kernel originally to get the major/minor
devices. Hope this is of use.

You can get the MAKEDEV I used to create these from
  http://www.drogon.net/MAKEDEV

Gordon
