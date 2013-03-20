From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Western Digital Green 3TB SATA3 experiences
Date: Wed, 20 Mar 2013 12:50:56 -0600
Message-ID: <C15F1FA6-440F-44AA-84DD-44DE9D3E46C6@colorremedies.com>
References: <1363766982.51496ec6ea41f@mail.inbox.lv>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1363766982.51496ec6ea41f@mail.inbox.lv>
Sender: linux-raid-owner@vger.kernel.org
To: Andris Berzins <pkix@inbox.lv>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Mar 20, 2013, at 2:09 AM, Andris Berzins <pkix@inbox.lv> wrote:

> Hello,
> 
> I am running RAID5 array on 6x 3TB WD SATA disks.
> I have problems with all of these disks (including replaced one).
> Disks are being randomly kicked out from array and SMART shows
> pending sectors which usually can be fixed by read-write or write to that sector.

Have you changed the /sys/block/sdX/device/timeout value? Cat it, report the value. For the greens I think the value needs to be at least 125 seconds. Depend on your SATA controller, it may have a separate timeout value that also needs to be changed.

If a potential "hang" delay of 125 seconds isn't workable for your application, you'll need different drives.


> Has anyone experienced something similar with WD green series?
> Is this because of WD "green" series?

Yes, the mail list achive is full of such posts.


> Anyone running raid on 3TB SATA drives can suggest model disk that
> runs without problems?

Hitachi Deskstar reportedly still support configurable SCT ERC, so you get set the drive to fail much less than 30 seconds, e.g. 7 seconds. Then md will fix the problems, if they're encountered. These drives are offered in 4TB size also.


Chris Murphy