From: Bernd Schubert <bs@q-leap.de>
Subject: Re: RAID 6 recovery (it's not looking good)
Date: Fri, 19 Dec 2008 13:36:33 +0100
Message-ID: <20081219123633.GA19688@lanczos.q-leap.de>
References: <20081216235957.GA458@lanczos.q-leap.de> <C571442A.BA18%groups@email.iain.rauch.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <C571442A.BA18%groups@email.iain.rauch.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Iain Rauch <groups@email.iain.rauch.co.uk>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Dec 19, 2008 at 12:29:30PM +0000, Iain Rauch wrote:
> > I'm still tired (now even more ;-) ). Just check again if /dev/sdu really
> > was the latest to fail and if so, clone this one.
> > I also suggest to reassemble it without an immediate raid-rebuild.
> > First check your data and only then add a new drives to the raid.
> > Once you start a raid-rebuild.
> > there is no way to go back. We recently also had the problem of three
> > failed disks  but we only could get back the data by not assembling the
> > array with the latest failed disk, but with the 2nd latest (don't ask why).
> > 
> > So in short
> > 
> > 1) clone disk
> > 
> > 2) mdadm --assemble --force /dev/mdX /dev/sda1 /dev/sdb1 ... /dev/sdx1
> > 
> > ===> Use only **22** devices here.
> > 
> > 3) Mount and check data, maybe even a read-only fsck
> > 
> > 4) Add two new disks.
> > 
> > 
> > Hope it helps,
> > Bernd
> 
> Well I cloned the disk and force started the array with 22 drives. I mounted
> the file system read-only and it did appear to be intact :)

I'm glad to hear that.

> 
> The problem is I cloned the failed drive to a 1.5TB Seagate, and it has the
> freezing issue. After 12h of rebuilding (out of 50) that drive got kicked.
> I'm gonna see if updating the FW on the drive helps, but otherwise I'll just
> have to get another decent drive.
> 
> Is there any way to have mdadm be more patient and not kick the drive, or
> let me put it back in and continue the rebuild of another drive? I don't
> believe the drive will operate for 50h straight.

I think this would continue the rebuild if you would use bitmaps. You may
add bitmaps by using "mdadm --grow --bitmap=internal /dev/mdX", but I'm not 
sure if it will work on a degrade md device. At least it won't work during
rebuild phase.

Cheers,
Bernd
