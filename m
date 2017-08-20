From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Filesystem corruption on RAID1
Date: Sun, 20 Aug 2017 17:22:58 -0600
Message-ID: <CAJCQCtQNx=8-16Xu1ffxqYh04W3mDy_qiPSysBw-g=fwWOtDMA@mail.gmail.com>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
 <20170713214856.4a5c8778@natsu> <592f19bf608e9a959f9445f7f25c5dad@assyoma.it>
 <d1255092-73f5-1ca4-0e68-69ff37631a26@thelounge.net> <cd37f90b86eb67be4c893b7fdf112692@assyoma.it>
 <770b09d3-cff6-b6b2-0a51-5d11e8bac7e9@thelounge.net> <9eea45ddc0f80f4f4e238b5c2527a1fa@assyoma.it>
 <f01b4649-df39-9835-728d-545cbd45976d@assyoma.it> <CAAMCDefXYdDKrFjEgeS8JAYt1GNP0-fL1chEXrGqxY8=xEf4Cw@mail.gmail.com>
 <7ca98351facca6e3668d3271422e1376@assyoma.it> <5995D377.9080100@youngman.org.uk>
 <83f4572f09e7fbab9d4e6de4a5257232@assyoma.it> <59961DD7.3060208@youngman.org.uk>
 <784bec391a00b9e074744f31901df636@assyoma.it> <CAAMCDefNRMuTwyXn_=3v_EWHwkjy3mhod1dLw3RQpjU=9VHNJQ@mail.gmail.com>
 <a93cf0cc1d39c30f585eb53ed36aa4c0@assyoma.it> <alpine.DEB.2.20.1708200907440.3655@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1708200907440.3655@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Gionatan Danti <g.danti@assyoma.it>, Roger Heflin <rogerheflin@gmail.com>, Wols Lists <antlists@youngman.org.uk>, Reindl Harald <h.reindl@thelounge.net>, Roman Mamedov <rm@romanrm.net>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Aug 20, 2017 at 1:14 AM, Mikael Abrahamsson <swmike@swm.pp.se> wrote:

> After a non-clean poweroff and possible mismatch now between the RAID1
> drives, and now fsck runs. It reads from the drives and fixes problem.
> However because the RAID1 drives contain different information, some of the
> errors are not fixed. Next time anything comes along, it might read from a
> different drive than what fsck read from, and now we have corruption.

The fsck has no idea this is two drives, it things it's one and does
an overwrite of whatever (virtual) blocks contain file system metadata
needing repair. Then md should take each fsck write, and duplicate it
(for 2 way mirror) and push those writes to each real physical device.

Since md doesn't read from both mirrors, it's possible there's a read
from a non-corrupt drive, which presents good information to fsck,
which then sees no reason to fix anything in that block; but the other
mirror does have corruption which thus goes undetected.

One way of dealing with it is to scrub (repair) so they both have the
same information to hand over to fsck. Fixups then get replicated to
disks by md.

Another way is to split the mirror (make one device faulty), and then
fix the remaining drive (now degraded). If that goes well, the 2nd
device can be re-added. Here's a caveat thought: how it resync's will
depend on the write-intent bitmap being present. I have no idea if
write-intent bitmaps on two drives can get out of sync and what the
ensuing behavior is, but I'd like to think md will discover the fixed
drive event count is higher than the re-added one, and if necessary
does a full resync, rather than possibly re-introducing any
corruption.



-- 
Chris Murphy
