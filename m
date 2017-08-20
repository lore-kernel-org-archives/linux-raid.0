From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Filesystem corruption on RAID1
Date: Sun, 20 Aug 2017 17:48:50 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1708201742080.3655@uplift.swm.pp.se>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it> <d1255092-73f5-1ca4-0e68-69ff37631a26@thelounge.net> <cd37f90b86eb67be4c893b7fdf112692@assyoma.it> <770b09d3-cff6-b6b2-0a51-5d11e8bac7e9@thelounge.net> <9eea45ddc0f80f4f4e238b5c2527a1fa@assyoma.it>
 <f01b4649-df39-9835-728d-545cbd45976d@assyoma.it> <CAAMCDefXYdDKrFjEgeS8JAYt1GNP0-fL1chEXrGqxY8=xEf4Cw@mail.gmail.com> <7ca98351facca6e3668d3271422e1376@assyoma.it> <5995D377.9080100@youngman.org.uk> <83f4572f09e7fbab9d4e6de4a5257232@assyoma.it>
 <59961DD7.3060208@youngman.org.uk> <784bec391a00b9e074744f31901df636@assyoma.it> <CAAMCDefNRMuTwyXn_=3v_EWHwkjy3mhod1dLw3RQpjU=9VHNJQ@mail.gmail.com> <a93cf0cc1d39c30f585eb53ed36aa4c0@assyoma.it> <alpine.DEB.2.20.1708200907440.3655@uplift.swm.pp.se>
 <7d0af770699948fb0ecb66185145be05@assyoma.it> <alpine.DEB.2.20.1708201241400.3655@uplift.swm.pp.se> <59998974.60103@youngman.org.uk> <5df0037e-fc76-1127-e2e8-c4992b6d216e@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5df0037e-fc76-1127-e2e8-c4992b6d216e@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 21 Aug 2017, Adam Goryachev wrote:

> data (even where it is wrong). So just do a check/repair which will 
> ensure both drives are consistent, then you can safely do the fsck. 
> (Assuming you fixed the problem causing random write errors first).

This involves manual intervention.

While I don't know how to implement this, let's at least see if we can 
architect something for throwing ideas around.

What about having an option for any raid level that would do "repair on 
read". So you can do "0" or "1" on this. RAID1 would mean it reads all 
stripes and if there is inconsistency, pick one and write it to all of 
them. It could also be some kind of IOCTL option I guess. For RAID5/6, 
read all data drives, and check parity. If parity is wrong, write parity.

This could mean that if filesystem developers wanted to do repair (and 
this could be a userspace option or mount option), it would use the 
beforementioned option for all fsck-like operation to make sure that 
metadata was consistent while doing fsck (this would be different for 
different tools, if it's an "fs needs to be mounted"-type of fs, or if 
it's an "offline fsck" type filesystem. Then it could go back to normal 
operation for everything else that would hopefully not cause 
catastrophical failures to the filesystem, but instead just individual 
file corruption in case of mismatches.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
