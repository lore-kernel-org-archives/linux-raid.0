From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Expanding array with multiple devices
Date: Fri, 1 Mar 2013 07:52:21 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1303010746120.14991@uplift.swm.pp.se>
References: <512FBDA3.7080501@schinagl.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <512FBDA3.7080501@schinagl.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 28 Feb 2013, Oliver Schinagl wrote:

> A little bit of background. I have 8 2TB disks, 4 in a current raid5 array, 
> which will be the donor disks en 4 'new' disk going to form the basis of a 
> new array. I want to change chunk size and re-format to ext4 to a) optimize 
> the new array according to the new parameters (stride,stripe-width) and 
> (possibly) a new ondisk ext4 disk format (new features added since last 
> time). The old array was 4 disk raid5, the new array will be 8 disk raid6.
>
> Any idea's how best to expand all this?

You didn't mention what kernel and mdadm version you're running.

Anyhow, what I would do is the following:

Create RAID6 with 3 data drives, 1 parity and 1 missing. Do whatever you 
need to create the fs etc, and copy the files. When you're satisfied with 
the result (checksumming the files etc), destroy the old raid5, add all 
the drives to the new raid6, and tell it to --grow to a total of 8 drives. 
What will probably happen is that as soon as you add the 4 drives it'll 
start to resync onto one of them to restore state to a non-degraded raid6.

I would personally let this complete so you actually have a fully 
functional non-degraded raid6 with 5 drives and 3 spares that you then 
grow in one go to 8 drives and 0 spares. After this is done you can grow 
the fs and hopefully everything should be well.

Personally, I use LVM on top of md, but in your case this wouldn't help 
because you want to mkfs the filesystem.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
