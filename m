From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: How do I get rid of old device?
Date: Wed, 16 Jan 2008 19:35:41 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0801161935020.9869@p34.internal.lan>
References: <alpine.DEB.0.999999.0801161808010.4374@p34.internal.lan>
 <18318.36828.106749.497307@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18318.36828.106749.497307@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 17 Jan 2008, Neil Brown wrote:

> On Wednesday January 16, jpiszcz@lucidpixels.com wrote:
>> p34:~# mdadm /dev/md3 --zero-superblock
>> p34:~# mdadm --examine --scan
>> ARRAY /dev/md0 level=raid1 num-devices=2
>> UUID=f463057c:9a696419:3bcb794a:7aaa12b2
>> ARRAY /dev/md1 level=raid1 num-devices=2
>> UUID=98e4948c:c6685f82:e082fd95:e7f45529
>> ARRAY /dev/md2 level=raid1 num-devices=2
>> UUID=330c9879:73af7d3e:57f4c139:f9191788
>> ARRAY /dev/md3 level=raid0 num-devices=10
>> UUID=6dc12c36:b3517ff9:083fb634:68e9eb49
>> p34:~#
>>
>> I cannot seem to get rid of /dev/md3, its almost as if there is a piece of
>> it on the root (2) disks or reference to it?
>>
>> I also dd'd the other 10 disks (non-root) and /dev/md3 persists.
>
> You don't zero the superblock on the array device, because the array
> device does not have a superblock.  The component devices have the
> superblock.
>
> So
>  mdadm --zero-superblock /dev/sd*
> or whatever.
> Maybe
>  mdadm --examine --scan -v
>
> then get the list of devices it found for the array you want to kill,
> and  --zero-superblock that list.
>
> NeilBrown
>

Thanks, will keep this in mind for the future-- I just checked and the 
dd's have finished and there is no longer a /dev/md3, but mdadm 
--zero-superblock /dev/sd[c-l] would have been much easier.

Justin.
