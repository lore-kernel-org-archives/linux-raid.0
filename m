From: Jules Bean <jules@jellybean.co.uk>
Subject: Re: After partition resize, RAID5 array does not assemble on boot
Date: Wed, 04 Jun 2008 07:31:21 +0100
Message-ID: <484636B9.20700@jellybean.co.uk>
References: <4844E994.8020808@jellybean.co.uk>    <4845B573.7090801@jellybean.co.uk> <48675.192.168.1.70.1212528422.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48675.192.168.1.70.1212528422.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown wrote:
>> Does the mdadm --detail output I pasted in my last message hold any clues?
>>
> 
> Yes.  Based on the "used device size", the smallest device was between
> 242244096K and 242244160K
> 
> Hopefully both of the smaller devices were the same size.

They were (the same size) but I couldn't find the superblock. I tried 
several possible partition sizes around 242244032K (plus or minus a 
cylinder or two) and no luck.

In the end I gritted my teeth and, following the advice in

http://joshuahayes.blogspot.com/2006/11/expand-existing-raid-5-array.html

I forced mdadm --create to recreate the array using correct parameters.

  mdadm --create /dev/md0 --chunk=64 --level=5 --layout=left-symmetric 
--raid-devices=4 --size=242244032 /dev/sda2 /dev/sdb2 /dev/sdd2 /dev/sdc2

and after a reboot, everything came all the way up to multiuser (which 
is significant, because /usr was on an LVM on this RAID partition) and 
as far as I can see, everything is fine.

Phew!

As to where my superblock has gone, the only theory I have is that the 
MD layer knew that my partitions were 400G large while the kernel was 
convinced they were 250G large, so the md layer tried to write the 
superblock at (approx) +400G, and the kernel refused to do that.

However, since the used dev size was only 242244032, all my actual data 
was safe and just using mdadm to recreate the superblocks was all that 
was needed.

The lesson here is always reboot after changing partition sizes, unless 
you have a tool which reliably flushes the kernel partition table cache 
(partprobe?)

Thanks for the help,

Jules
