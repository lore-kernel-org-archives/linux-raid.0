From: Robert L Mathews <lists@tigertech.com>
Subject: Re: Filesystem corruption on RAID1
Date: Fri, 1 Sep 2017 16:14:37 -0700
Message-ID: <c2063aa8-85c6-4d64-3a41-b13cef523030@tigertech.com>
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
 <dbc04880-65f9-edd8-fbd4-f70d9549e06e@tigertech.com>
 <8fa7e6e8-0924-6db7-2e7d-9d5316cb3b8e@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8fa7e6e8-0924-6db7-2e7d-9d5316cb3b8e@thelounge.net>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 8/31/17 10:39 PM, Reindl Harald wrote:
> you gain nothing when you completly lie to fsck and after that switch
> back to normal operations with the other disks part of the game

Sorry, I didn't make myself clear. I meant that you could leave the
array like that (all disks except one write-mostly) permanently, in
normal use (and while fscking too). That way you always have a
consistent view of the array.

With an array composed of modern SSDs, such a setup still performs well
for many loads.

-- 
Robert L Mathews, Tiger Technologies, http://www.tigertech.net/
