From: "Henry, Andrew" <andrew.henry@logica.com>
Subject: RE: (no subject): should have read--"Regarding thread '"Deleting
 mdadm RAID arrays'".
Date: Thu, 15 May 2008 17:33:40 +0200
Message-ID: <3ECBDC05781B3D48ABD520A01ABF2F9B12C546FB2B@SE-EX008.groupinfra.com>
References: <3ECBDC05781B3D48ABD520A01ABF2F9B12C53D0880@SE-EX008.groupinfra.com>
 <482B5600.6040204@dgreaves.com>
 <3ECBDC05781B3D48ABD520A01ABF2F9B12C5435703@SE-EX008.groupinfra.com>
 <482C4240.7020202@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <482C4240.7020202@dgreaves.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> > At least I can still see the discs now.  So now it's been syncing all
> night and it's 50% complete.
> That's slow - my RAID5 takes 3hrs to do 320Gb - mirrors should be a *lot*
> faster.

Hmmm.  It's syncing at 6056k/s.  dd ran at 320MB/s.  worrying.  Wonder if the controller is not that good. Sorry for line breaks, Outlook.

> You *do not* need (and should not use) kernel autodetect. You should
> assemble
> the array in the init scripts.

How can I stop the kernel from autodetecting?  You just made me realize that this would solve my other problem: I cannot reboot my server remotely because it asks for the dmcrypt password on boot when I put a line in crypttab.  Mounting everything with scripts *after* boot would let me reboot remotely. :)

Thanks a lot for the help.  I'll try mdadm --stop as soon as syncing has finished (95% complete now!!!)
>
> David

