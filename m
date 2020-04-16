From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: Setup Recommendation on UEFI/GRUB/RAID1/LVM
Date: Wed, 15 Apr 2020 20:50:33 -0500
Message-ID: <461be4bb-a86b-dca0-605f-cda13bc1602d@suddenlinkmail.com>
References: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
 <5E95C698.1030307@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5E95C698.1030307@youngman.org.uk>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/14/2020 09:20 AM, Wols Lists wrote:
> That's true, but is it worth it? RAM is cheap, max out your motherboard,
> and try and avoid falling into swap at all. I have one swap partition
> per disk, but simply set them up as equal priority so the kernel does
> its own raid-0 stripe across them. Yes a disk failure would kill any
> apps swapped on to that disk, but my system rarely swaps...

That's a neat approach, I do it just the opposite and care RAID1 partitions
for swap (though I rarely swap as well). I've never had an issue restarting
after a failure (or me doing something dumb like hitting the wrong button on
the UPS)

So that I'm understanding, you simply create a swap partition on each disk not
part of an array, swapon both and let the kernel decide?


-- 
David C. Rankin, J.D.,P.E.
