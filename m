From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Raid0 or Raid1 READ performance
Date: Thu, 16 Dec 2004 17:48:15 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0412161741200.19312-100000@coffee.psychology.mcmaster.ca>
References: <000401c4e3b9$2cef1f20$040a10ac@asitest>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000401c4e3b9$2cef1f20$040a10ac@asitest>
Sender: linux-raid-owner@vger.kernel.org
To: BO MOON <bmoon@anthologysolutions.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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

