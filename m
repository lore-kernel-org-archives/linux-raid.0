From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: Filesystem corruption on RAID1
Date: Sun, 20 Aug 2017 21:11:45 +0200
Message-ID: <1a76f763001db612c4b369348688c2c3@assyoma.it>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
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
 <7d0af770699948fb0ecb66185145be05@assyoma.it>
 <alpine.DEB.2.20.1708201241400.3655@uplift.swm.pp.se>
 <59998974.60103@youngman.org.uk>
 <5df0037e-fc76-1127-e2e8-c4992b6d216e@websitemanagers.com.au>
 <alpine.DEB.2.20.1708201742080.3655@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1708201742080.3655@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, Linux RAID <linux-raid@vger.kernel.org>, linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

Il 20-08-2017 17:48 Mikael Abrahamsson ha scritto:
> 
> This involves manual intervention.
> 
> While I don't know how to implement this, let's at least see if we can
> architect something for throwing ideas around.
> 
> What about having an option for any raid level that would do "repair
> on read". So you can do "0" or "1" on this. RAID1 would mean it reads
> all stripes and if there is inconsistency, pick one and write it to
> all of them. It could also be some kind of IOCTL option I guess. For
> RAID5/6, read all data drives, and check parity. If parity is wrong,
> write parity.

Wait, is isn't that what MDRAID already do by issuing "echo 1 > 
sync_action"?

The big plus would be to not blindly copy the first mirror/stripe, 
rather to identify the correct one and use it to correct any corrupted 
data.

Obviously you need sufficient data to do that, by the mean of 3-way 
RAID1, double parity (RAID6) or checksummed data blocks (ZFS, BTRFS and 
dm-integrity).

Please note that these methods alone do not provide complete protection 
over other failures mode as phantom writes; however, any of them would 
significantly increase the current data protection level.

Regards.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
