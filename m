From: klink@clouddancer.com (Colonel)
Subject: (unknown)
Date: Tue,  4 Jun 2002 08:47:12 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020604154712.AD48D8347@phoenix.clouddancer.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org, roy@karlsbakk.net
List-Id: linux-raid.ids

From: Colonel <klink@clouddancer.com>
To: roy@karlsbakk.net
CC: linux-raid@vger.kernel.org
In-reply-to: <200206041259.g54CxuP07700@mail.pronto.tv> (message from Roy
	Sigurd Karlsbakk on Tue, 4 Jun 2002 14:59:55 +0200)
Subject: Re: SV: RAID-6 support in kernel?
Reply-to: klink@clouddancer.com
References: <2D0AFEFEE711D611923E009027D39F2B02F17E@nasexs1.meridian-data.com> <200206041259.g54CxuP07700@mail.pronto.tv>

   From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
   Organization: Pronto TV AS
   Date:	Tue, 4 Jun 2002 14:59:55 +0200
   Cc: Christian Vik <cvik@vanadis.no>, linux-kernel@vger.kernel.org,
	   linux-raid@vger.kernel.org
   Sender: linux-raid-owner@vger.kernel.org
   X-Mailing-List:	linux-raid@vger.kernel.org
   News-Group: list.kernel

   > Of course, for a 4 drive setup there's no reason to use RAID 6 at all (RAID
   > 10 will withstand any two drive failure if you only use 4 drives), but
   > that's the reasoning.  I think the best way to deal with the read-modify
   > write problem for RAID 6 is to use a small chunk size and deal with NxN
   > chunks as a unit.  But YMMV.

   RAID10 will _not_ withstand any two-drive fail in a 4-drive scenario. If D1 
   and D3 fail, you're fscked

   D1 D2
   D3 D4


True, I think that the point is that of the 5 possible 2 disk
failures, 2 of them (in striped mirrors, not mirrored stripes) kill
the array.  For RAID5, all of them kill the array.  But the fancy RAID
setups are for _large_ arrays, not 4 disks, unless you are after the
small write speed improvement (as I am).

Plus any raid metadevice made of metadevices cannot autostart, which
means tinkering during startup, which is only worth it for those large
drive arrays.


r

---
Personalities : [raid0] [raid1] 
read_ahead 1024 sectors
md0 : active raid0 md4[3] md3[2] md2[1] md1[0]
      34517312 blocks 64k chunks
