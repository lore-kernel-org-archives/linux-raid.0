From: Iain Rauch <groups@email.iain.rauch.co.uk>
Subject: Re: RAID 6 recovery (it's not looking good)
Date: Fri, 19 Dec 2008 12:29:30 +0000
Message-ID: <C571442A.BA18%groups@email.iain.rauch.co.uk>
References: <20081216235957.GA458@lanczos.q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081216235957.GA458@lanczos.q-leap.de>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> I'm still tired (now even more ;-) ). Just check again if /dev/sdu really
> was the latest to fail and if so, clone this one.
> I also suggest to reassemble it without an immediate raid-rebuild.
> First check your data and only then add a new drives to the raid.
> Once you start a raid-rebuild.
> there is no way to go back. We recently also had the problem of three
> failed disks  but we only could get back the data by not assembling the
> array with the latest failed disk, but with the 2nd latest (don't ask why).
> 
> So in short
> 
> 1) clone disk
> 
> 2) mdadm --assemble --force /dev/mdX /dev/sda1 /dev/sdb1 ... /dev/sdx1
> 
> ===> Use only **22** devices here.
> 
> 3) Mount and check data, maybe even a read-only fsck
> 
> 4) Add two new disks.
> 
> 
> Hope it helps,
> Bernd

Well I cloned the disk and force started the array with 22 drives. I mounted
the file system read-only and it did appear to be intact :)

The problem is I cloned the failed drive to a 1.5TB Seagate, and it has the
freezing issue. After 12h of rebuilding (out of 50) that drive got kicked.
I'm gonna see if updating the FW on the drive helps, but otherwise I'll just
have to get another decent drive.

Is there any way to have mdadm be more patient and not kick the drive, or
let me put it back in and continue the rebuild of another drive? I don't
believe the drive will operate for 50h straight.


Regards,

Iain


