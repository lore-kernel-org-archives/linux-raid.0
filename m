From: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Subject: Questions about VERY large software raid config
Date: Fri, 21 Feb 2003 10:42:35 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <8075D5C3061B9441944E137377645118012E65@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I am currently testing switching from Dell PERC hardware RAID cards to
Linux software RAID and I wanted to see if anyone out there has anything
this large or larger and can give me some tips.

Basically I'm going to do a bunch of RAID1 mirrors (56 drives), RAID)
those in sets of 14 and then stripe those 4 into one big array.  We want
to get the most spindles possible servicing disk requests and I wanted
to know if anyone has tried such a setup.

I have test hardware with 20 drives and it appears to behave nicely and
I'm getting much better throughput from software RAID than the Dell PERC
hardware RAID cards, but I wanted to make sure that this solution would
scale up to 56.  Looking at dmesg (MAX_MD_DEVS=256, MD_SB_DISKS=27) and
looking at the /dev directory (up to 128 SCSI disks) it looks like it
should, but I wanted to get some first hand experience, if there is any
:)

Thanks in advance.

Regards,
Andy.

Andrew Rechenberg
Infrastructure Team, Sherman Financial Group

