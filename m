From: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Subject: RE: Questions about VERY large software raid config
Date: Fri, 21 Feb 2003 11:03:27 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <8075D5C3061B9441944E137377645118012E66@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Mike Dresser <mdresser_l@windsormachine.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Isn't it 2TB per RAID device (i.e. Linux block device) or 2TB in total?


I have 28 36GB 15K drives and 28 18GB 15K drives.

36GB * 28 = 1008GB
18GB * 28 = 504GB

Either way, that's below the 2TB limit.  However, since I'm mirroring,
it will effectively be ~750GB.  

But I would like to know if there is a 2TB *total* limit for ALL RAID
devices (good information to know in advance :) ).

I'm going to be running LVM on top of the resulting md device for
snapshots as well.  I have a Red Hat kernel (2.4.18-24) so I assume that
the vfs-lock patch is already integrated since Red Hat offers LVM as an
option in 7.3.  I've tested snapshots on my small setup and it appears
to work just fine with ext3 on LVM on software RAID.

Thanks for the help,
Andy.  

-----Original Message-----
From: Mike Dresser [mailto:mdresser_l@windsormachine.com] 
Sent: Friday, February 21, 2003 10:50 AM
To: Rechenberg, Andrew
Cc: linux-raid@vger.kernel.org
Subject: Re: Questions about VERY large software raid config


On Fri, 21 Feb 2003, Rechenberg, Andrew wrote:

> Basically I'm going to do a bunch of RAID1 mirrors (56 drives), RAID)
> those in sets of 14 and then stripe those 4 into one big array.  We
want
> to get the most spindles possible servicing disk requests and I wanted
> to know if anyone has tried such a setup.

How big are your drives?  There's apparently a 2 TiB limit on raid
sizes,
there's even someone who has been asking if 12 x 160 or 13 x 160 is
ok(sorry, I don't have an answer for said person)

Mike

