From: Aaron Botsis <aaron@blight.com>
Subject: Re: raid5 endian question....
Date: Sun, 19 Jun 2005 21:54:38 -0500
Message-ID: <B2243AB6-F57E-46ED-8726-1B8C7F4B120C@blight.com>
References: <61C14314-53E9-4140-A4DB-3929A683FE67@blight.com> <42B5EC22.4030906@steeleye.com>
Mime-Version: 1.0 (Apple Message framework v730)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42B5EC22.4030906@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


On Jun 19, 2005, at 5:05 PM, Paul Clements wrote:

> Aaron Botsis wrote:
>
>> Is this a bug? Is just the magic number whacked? or are the   
>> superblock data structures too?
>>
>
> The version 0.90 superblock is not "endian agnostic". It records  
> data in whatever endian order the host machine is (Version 1  
> superblocks, by the way, fix this, but are not available unless you  
> have the latest 2.6 kernel and mdadm).
>

So it's really only the superblock, then? Does that mean the parity  
stripes don't suffer from endian problems as well?


>
>> what's the best way to fix this?
>>
>
> Unfortunately, I don't think there's an easy way. But, if you can  
> get the array back up on the original machine and copy down all the  
> information (or if you already have it) then you can re-create the  
> array on the x86 machine using "mdadm -C", but be careful... :)

By information, I'm assuming you mean chunk size, parity algo, etc?   
So I can just whack a new superblock on top and all will be well  
because the parity stripes will be cool?

what's what look like:
mdadm -C -c bleh -level=5 --parity=left --raid-devices=3 /dev/md0 / 
dev/hda1 /dev/hdb1 /dev/hdc1

??
Also, I thought I noticed the array in degraded mode (probably a  
failed read or something) before the machine it was in crashed...  
(bad root disk) if I do this, will BadThings(tm) occur??

If so, can I just hack mdadm to fixup the order while reading the  
superblock, and recreate in degraded based on that?

Thanks again for the help.

- -Aaron
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (Darwin)

iD8DBQFCti/xN/nDplnlBBgRAuKIAKCNqiuC6+0NBUCQMFDxW7gMTnk8/ACfdHQ2
hSmINmk+Hq0v1QdZ+4teLRc=
=eBtc
-----END PGP SIGNATURE-----
