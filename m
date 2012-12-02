From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Raid 0+1
Date: Sat, 01 Dec 2012 20:10:17 -0600
Message-ID: <50BAB889.2090308@hardwarefreak.com>
References: <CAAo+KF=-XStwczZvxPh7jgLZzwEAD71XWWg0h5HBXekBO8-5vQ@mail.gmail.com> <50B8C26C.7000807@profitbricks.com> <50B8C55E.1050902@profitbricks.com> <CAAo+KFn82hYUak4mvqMfix8UEPC7uwdvmbmRFLikQFqYDjNrHg@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAo+KFn82hYUak4mvqMfix8UEPC7uwdvmbmRFLikQFqYDjNrHg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Oguz Yilmaz <oguzyilmazlist@gmail.com>
Cc: Sebastian Riemer <sebastian.riemer@profitbricks.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/1/2012 7:11 AM, Oguz Yilmaz wrote:

> Why do we need another storage server.

You don't.

> IF I create
> md0 Raid0 (sda1 + sda2)
> md1 Raid0 (sdc1 + sdc2)
> 
> then is it possible to create
> md2 Raid1 (md0 + md1)
> 
> like md?

Sure, you can do this.  One downside is you can never expand it WRT
capacity or effective spindles.  The only way to get there is to put the
RAID1 device in a linear device and grow more of these 4 device RAID 0+1
devices into the linear device.  This setup requires an allocation group
based filesystem, XFS, to get anything near linear scaling across the
drives.  But for that your application must exhibit file level
parallelism, i.e. reading/writing many dozens of files in parallel, and
with inode64 mount, they must be in different directories.  Otherwise
you IO won't scale across your disks.

-- 
Stan


