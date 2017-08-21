From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: Filesystem corruption on RAID1
Date: Mon, 21 Aug 2017 14:28:30 +0200
Message-ID: <1b95e2f43f237b4da2aed74b0b60e617@assyoma.it>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
 <20170713214856.4a5c8778@natsu>
 <592f19bf608e9a959f9445f7f25c5dad@assyoma.it>
 <d1255092-73f5-1ca4-0e68-69ff37631a26@thelounge.net>
 <cd37f90b86eb67be4c893b7fdf112692@assyoma.it>
 <770b09d3-cff6-b6b2-0a51-5d11e8bac7e9@thelounge.net>
 <9eea45ddc0f80f4f4e238b5c2527a1fa@assyoma.it>
 <f01b4649-df39-9835-728d-545cbd45976d@assyoma.it>
 <CAAMCDefXYdDKrFjEgeS8JAYt1GNP0-fL1chEXrGqxY8=xEf4Cw@mail.gmail.com>
 <7ca98351facca6e3668d3271422e1376@assyoma.it>
 <5995D377.9080100@youngman.org.uk>
 <83f4572f09e7fbab9d4e6de4a5257232@assyoma.it>
 <59961DD7.3060208@youngman.org.uk>
 <784bec391a00b9e074744f31901df636@assyoma.it>
 <CAAMCDefNRMuTwyXn_=3v_EWHwkjy3mhod1dLw3RQpjU=9VHNJQ@mail.gmail.com>
 <a93cf0cc1d39c30f585eb53ed36aa4c0@assyoma.it>
 <alpine.DEB.2.20.1708200907440.3655@uplift.swm.pp.se>
 <CAJCQCtQNx=8-16Xu1ffxqYh04W3mDy_qiPSysBw-g=fwWOtDMA@mail.gmail.com>
 <alpine.DEB.2.20.1708211027370.3655@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1708211027370.3655@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Chris Murphy <lists@colorremedies.com>, Linux RAID <linux-raid@vger.kernel.org>, linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

Il 21-08-2017 10:37 Mikael Abrahamsson ha scritto:
> This doesn't solve the problem because it doesn't check if the second
> mirror is out of sync with the first one, because it'll only detect
> writes to the degraded array and sync those. It doesn't fix the "fsck
> read the block and it was fine, but on the second drive it's not
> fine".

As stated elsewhere, you can re-attach a detached device with 
"--add-spare": this will copy *all* data from the other mirror leg. 
However, it is vastly better to simple issue a "repair" action. Anyway, 
the basic problem remains: with larger drives, this will take many hours 
or even days.

> However, this again causes the problem that if there is an URE on the
> degraded array remaining drive, things will fail.

On relatively recent MDRAID code (kernel > 3.5.x), a degraded array with 
a URE in another disk will *not* totally fail the array. Rather, a 
badblock is logged into MDRAID superblock and a read error is returned 
to upper layers.

Anyway, this has little to do with the main problem: micro power losses 
can cause undetected, silent data corruption, even with synced writes.

> The only way to solve this is to add more code to implement a new mode
> which would be "repair-on-read".
> 
> I understand that we can't necessarily detect which drive has the
> right or wrong information, but at least we can this way make sure
> that when fsck is done, all the inodes and other metadata is now
> consistent. Everything that fsck touched during the fsck will be
> consistent across all drives, with correct parity. It might not
> contain the "best" information that could have been presented by a
> more intelligent algorithm/metadata, but at least it's better than
> today when after a fsck run you don't know if parity is correct or
> not.
> 
> It would also be a good diagnostic tool for admins. If you suspect
> that you're getting inconsistencies but you're fine with the
> performance degradation then md could log inconsistencies somewhere so
> you know about them.

I second that.
Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
