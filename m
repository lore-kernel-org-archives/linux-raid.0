From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Setup Recommendation on UEFI/GRUB/RAID1/LVM
Date: Thu, 16 Apr 2020 12:16:03 +0100
Message-ID: <5E983E73.8010309@youngman.org.uk>
References: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
 <5E95C698.1030307@youngman.org.uk>
 <461be4bb-a86b-dca0-605f-cda13bc1602d@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <461be4bb-a86b-dca0-605f-cda13bc1602d@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 16/04/20 02:50, David C. Rankin wrote:
> On 04/14/2020 09:20 AM, Wols Lists wrote:
>> That's true, but is it worth it? RAM is cheap, max out your motherboard,
>> and try and avoid falling into swap at all. I have one swap partition
>> per disk, but simply set them up as equal priority so the kernel does
>> its own raid-0 stripe across them. Yes a disk failure would kill any
>> apps swapped on to that disk, but my system rarely swaps...
> 
> That's a neat approach, I do it just the opposite and care RAID1 partitions
> for swap (though I rarely swap as well). I've never had an issue restarting
> after a failure (or me doing something dumb like hitting the wrong button on
> the UPS)
> 
> So that I'm understanding, you simply create a swap partition on each disk not
> part of an array, swapon both and let the kernel decide?
> 
Don't forget the mount option "pri=1" ... the following is the relevant
lines from my fstab ...

# /dev/sda2             none            swap            sw,pri=1        0 0
UUID=184b6322-eb42-405e-b958-e55014ce3691       none    swap    sw,pri=1
       0 0
# /dev/sdb2             none            swap            sw,pri=1        0 0
UUID=48913c8d-e4c4-482d-9733-e44be3889f07       none    swap    sw,pri=1
       0 0
# /dev/sdc2             none            swap            sw,pri=1        0 0

If you don't use the priority option, each partition is allocated a
different priority and it fills them up one after the other (raid
linear). Make them all equal priority, and it'll stripe them.

Cheers,
Wol
