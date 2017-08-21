From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Filesystem corruption on RAID1
Date: Mon, 21 Aug 2017 10:37:16 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1708211027370.3655@uplift.swm.pp.se>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it> <20170713214856.4a5c8778@natsu> <592f19bf608e9a959f9445f7f25c5dad@assyoma.it> <d1255092-73f5-1ca4-0e68-69ff37631a26@thelounge.net> <cd37f90b86eb67be4c893b7fdf112692@assyoma.it>
 <770b09d3-cff6-b6b2-0a51-5d11e8bac7e9@thelounge.net> <9eea45ddc0f80f4f4e238b5c2527a1fa@assyoma.it> <f01b4649-df39-9835-728d-545cbd45976d@assyoma.it> <CAAMCDefXYdDKrFjEgeS8JAYt1GNP0-fL1chEXrGqxY8=xEf4Cw@mail.gmail.com> <7ca98351facca6e3668d3271422e1376@assyoma.it>
 <5995D377.9080100@youngman.org.uk> <83f4572f09e7fbab9d4e6de4a5257232@assyoma.it> <59961DD7.3060208@youngman.org.uk> <784bec391a00b9e074744f31901df636@assyoma.it> <CAAMCDefNRMuTwyXn_=3v_EWHwkjy3mhod1dLw3RQpjU=9VHNJQ@mail.gmail.com> <a93cf0cc1d39c30f585eb53ed36aa4c0@assyoma.it>
 <alpine.DEB.2.20.1708200907440.3655@uplift.swm.pp.se> <CAJCQCtQNx=8-16Xu1ffxqYh04W3mDy_qiPSysBw-g=fwWOtDMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtQNx=8-16Xu1ffxqYh04W3mDy_qiPSysBw-g=fwWOtDMA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 20 Aug 2017, Chris Murphy wrote:

> Since md doesn't read from both mirrors, it's possible there's a read 
> from a non-corrupt drive, which presents good information to fsck, which 
> then sees no reason to fix anything in that block; but the other mirror 
> does have corruption which thus goes undetected.

That was exactly what I wrote.

> One way of dealing with it is to scrub (repair) so they both have the 
> same information to hand over to fsck. Fixups then get replicated to 
> disks by md.

Yes, it is, but that would require a full repair before doing fsck. That 
seems excessive because that will take hours on larger drives.

> Another way is to split the mirror (make one device faulty), and then
> fix the remaining drive (now degraded). If that goes well, the 2nd
> device can be re-added. Here's a caveat thought: how it resync's will
> depend on the write-intent bitmap being present. I have no idea if
> write-intent bitmaps on two drives can get out of sync and what the
> ensuing behavior is, but I'd like to think md will discover the fixed
> drive event count is higher than the re-added one, and if necessary
> does a full resync, rather than possibly re-introducing any
> corruption.

This doesn't solve the problem because it doesn't check if the second 
mirror is out of sync with the first one, because it'll only detect writes 
to the degraded array and sync those. It doesn't fix the "fsck read the 
block and it was fine, but on the second drive it's not fine".

In that case fsck would have to be modified to write all blocks it read to 
make them dirty, so they're sync:ed.

However, this again causes the problem that if there is an URE on the 
degraded array remaining drive, things will fail.

The only way to solve this is to add more code to implement a new mode 
which would be "repair-on-read".

I understand that we can't necessarily detect which drive has the right or 
wrong information, but at least we can this way make sure that when fsck 
is done, all the inodes and other metadata is now consistent. Everything 
that fsck touched during the fsck will be consistent across all drives, 
with correct parity. It might not contain the "best" information that 
could have been presented by a more intelligent algorithm/metadata, but at 
least it's better than today when after a fsck run you don't know if 
parity is correct or not.

It would also be a good diagnostic tool for admins. If you suspect that 
you're getting inconsistencies but you're fine with the performance 
degradation then md could log inconsistencies somewhere so you know about 
them.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
