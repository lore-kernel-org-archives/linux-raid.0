From: "BO MOON" <bmoon@anthologysolutions.com>
Subject: RE: Raid0 or Raid1 READ performance
Date: Thu, 16 Dec 2004 20:24:27 -0800
Message-ID: <000c01c4e3f0$4ecb77b0$040a10ac@asitest>
References: <Pine.LNX.4.44.0412161741200.19312-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0412161741200.19312-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mark Hahn' <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Mark,

Thanks for your opinion and suggestion.
You are right to get the real and meaningful performance, I should
Follow your suggestion.

My real attention is to find the difference in READ operation between
Single(one HDD) and RAID0 or RAID1 by the parallelism( 
access or read data block from more than 2 HDDs at the same time).

I tried with "time dd if=dev of=/dev/zero bs=64K". There is no
Difference.

Any more comments?

Thanks,

Bo  
-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Mark Hahn
Sent: Thursday, December 16, 2004 2:48 PM
To: BO MOON
Cc: linux-raid@vger.kernel.org
Subject: Re: Raid0 or Raid1 READ performance

> I am expecting the faster performance on READ than WRITE because of
> parallel read from disks more than 2(2 for RAID1, 3 for RAID0) at the
> same time.

if I understand your description, each of your tests involves either
reading or writing from a single disk (and also writing/reading a raid.)
such tests will always run at the speed of the slowest disk,
presumably the single one.  for instance,

    cp /some-2-disk-raid0/file /other-single-disk/

will be limited by the write speed of other-single-disk, 
and not the raid.

    cp /other-single-disk/file /some-2-disk-raid0/

is similar, though now it's the reading from a single disk which 
is the bottleneck.

> Any suggestion or opinion?

test bandwidth with something more reasonable than time cp.
even "time dd if=/disk-to-read-from of=/dev/zero bs=64k"
is more sensible.

regards, mark hahn.

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



