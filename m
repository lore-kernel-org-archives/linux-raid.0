From: Roe Peterson <roe@liveglobalbid.com>
Subject: Raid1 bug in 2.5.26?
Date: Fri, 19 Jul 2002 10:12:46 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D383A7E.A092D212@liveglobalbid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I'm a total newbie here, but...

I've just installed 2.5.26 on a redhat 7.3 distribution, and I've got a
problem with raid1.

The raid1 array is the root file system, on /dev/hda1 and /dev/hdb1.

It boots, runs the raid1 resync correctly, and bombs at the very end of
the resync at
line 655 in drivers/md/raid1.c:
     if (waitqueue_active(&conf->wait_resume)) BUG();

The BUG happens...

I hesitate to simply comment this code out.  Anyone out there run into
this yet?

Thanks.




