From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: How To Remove Rogue RAID
Date: Sun, 02 Jan 2011 20:38:59 +0000
Message-ID: <4D20E263.5060202@anonymous.org.uk>
References: <AANLkTi=95GkF4QqW7s1tOsYT0oZ0WrruD_Ggrx+q6FLp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=95GkF4QqW7s1tOsYT0oZ0WrruD_Ggrx+q6FLp@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Mennens <carloswill@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/01/2011 19:42, Carlos Mennens wrote:
> I added two new physical drives to my Linux server and for some reason
> I now see '/dev/md127' when I run 'cat /proc/mdstat':
>
> root ~ # cat /proc/mdstat
> Personalities : [raid1]
> md127 : active (auto-read-only) raid1 sdc2[1] sdd2[0]
>        243199936 blocks [2/2] [UU]
>        	resync=PENDING
>
> I never create /dev/md127 what so ever and I'm fairly sure it just
> popped up. I can tell you the two new disks I added above (/dev/sdc&
> /dev/sdd) did have 'fd' RAID partition tables on the disk so I don't
> know if that is why it (/dev/md127) shows up when I run 'cat
> /proc/mdstat'.
>
> I tried to remove the drives too but they failed:
>
> root ~ # mdadm --manage /dev/md127 --remove /dev/sdc2
> mdadm: hot remove failed for /dev/sdc2: Device or resource busy
> root ~ # mdadm --manage /dev/md127 --remove /dev/sdd2
> mdadm: hot remove failed for /dev/sdd2: Device or resource busy

You'd need to --fail the devices before you can --remove them. But in 
this case, you don't need to do either...

> Can someone please tell me how I can stop the RAID, remove /dev/md127
> so that I can create a separate mirror with /dev/sdc&  /dev/sdd.

mdadm --stop /dev/md127
mdadm --zero-superblock /dev/sdc2
mdadm --zero-superblock /dev/sdd2
(To be sure I'd do the above repeatedly until it complains there's no 
superblock, because different superblocks live in different places and 
--zero-superblock only scrubs one at a time, and if you want to get 
these discs back to properly blank, --zero-superblock again repeatedly 
on /dev/sd[cd]1 and /dev/sd[cd])
fdisk /dev/sdc and delete/adjust/create whatever partition(s) you want
ditto /dev/sdd
mdadm --create whatever

I've never used whole discs as md components, always partitions, so I'm 
not sure whether there might be the possibility of the whole discs being 
auto-detected as blank if there's no partition table or an empty one, 
for which I can imagine a workaround of using 1.2 metadata and some kind 
of dummy partition table, but somebody who's done it can advise.

Cheers,

John.

