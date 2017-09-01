From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Filesystem corruption on RAID1
Date: Fri, 1 Sep 2017 07:39:38 +0200
Message-ID: <8fa7e6e8-0924-6db7-2e7d-9d5316cb3b8e@thelounge.net>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
 <20170713214856.4a5c8778@natsu> <592f19bf608e9a959f9445f7f25c5dad@assyoma.it>
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
 <dbc04880-65f9-edd8-fbd4-f70d9549e06e@tigertech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dbc04880-65f9-edd8-fbd4-f70d9549e06e@tigertech.com>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Am 01.09.2017 um 00:55 schrieb Robert L Mathews:
> On 8/20/17 3:43 AM, Mikael Abrahamsson wrote:
> 
>> Indeed, but as far as I know there is nothing md can do about this. What
>> md could do about it is at least present a consistent view of data to
>> fsck (which for raid1 would be read all stripes and issue "repair" if
>> they don't match). Yes, this might indeed cause corruption but at least
>> it would be consistent and visible.
> 
> If you set all disks except one as "write-mostly", won't mdadm give you
> a consistent view of it because it only reads from a single disk?

you gain nothing when you completly lie to fsck and after that switch 
back to normal operations with the other disks part of the game

and it works only on RAID1 and *really* RAID1, otherwise my current 
RAID10 would be as fast as hell instead the terrible random lags which 
are worser sometimes as before replace two out of 4 disks with a SSD
