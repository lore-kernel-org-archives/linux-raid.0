From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: http://raid.wiki.kernel.org/ unreachable - need to "lend" clone
 of RAID1 HD to another machine
Date: Sun, 24 Apr 2011 03:33:44 +0100
Message-ID: <4DB38C08.8020406@anonymous.org.uk>
References: <4DB38214.4080003@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DB38214.4080003@earthlink.net>
Sender: linux-raid-owner@vger.kernel.org
To: Vernon Tonnesen <jdcpa@earthlink.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24/04/2011 02:51, Vernon Tonnesen wrote:
> I've been trying to get through without success for over an hour. Is the
> content there mirrored somewhere?

Google has it cached.

> Is there an alternate, preferably in
> FAQ format?

There are dozens but I couldn't make any particular recommendation.

> I have a pair of HDs partitioned with 14 identical partitions each, 7 of
> which on each make up 1 of 2 partitions making up 7 md devices. The
> seven md devices were originally configured through openSUSE
> installation's YaST2. I made a clone of the whole of one HD. This clone
> I want to attach to another machine simply to copy the files from one
> partition's EXT3 filesystem that is a component of md7 on the original
> machine.
>
> Can I just mount that partition on the other machine RO as an ordinary
> EXT3 partition to make the copies, or does that machine need to have a
> RAID "built" or "rebuilt" with mdadm in order to mount that disks
> partition as a degraded array? Nothing shows up in /dev/mdstat booting
> with it plugged in, even after copying /etc/mdadm.conf from the original
> machine. I tried modprobe raid1, but that didn't seem to affect anything
> I can tell. Fdisk -l /dev/sdb shows me only what I expect, a bunch of
> 0x83 and 0xfd partitions, while fdisk -l produces none of the extra
> output I'm used to seeing on the system with the full RAID1 running.
>
> Problem 2: Looking at the mdadm man page, I really don't understand the
> distinction between build and create, or what a persistent superblock is
> good for.

A persistent superblock stores important information about the array 
like its level, chunk size, bitmap, etc, and you use create to do this. 
Build sets up md devices one time only.

Use `mdadm -Evvs` to find your array members. If that finds nothing, the 
arrays were built and not created, but I think that's unlikely with your 
type FD partitions. If that finds metadata version 0.90 or 1.0 RAID1 
partitions, yes you can mount them read-only directly from the 
partitions without doing anything else - `file -s /dev/sdXp` should tell 
you what the filesystem type is. If it's metadata 1.1 or 1.2, you can 
start them in degraded mode with `mdadm -Avs --run` and then you should 
find your filesystems on /dev/mdX (again, you can check). Again, mount 
them read-only if you might want to put the disc back in the original 
machine.

As I said in another post, I'm off to bed now, but good luck!

Cheers,

John.

