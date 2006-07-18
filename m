From: Sevrin Robstad <quack@online.no>
Subject: Re: trying to "brute-force" my RAID 5...
Date: Tue, 18 Jul 2006 23:14:23 +0200
Message-ID: <44BD4F2F.2050502@online.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
 >
 >>I have written some posts about this before... My 6 disk RAID 5 broke
 >>down because of hardware failure. When I tried to get it up'n'running 
again
 >>I did a --create without any missing disk, which made it rebuild. I have
 >>also lost all information about how the old RAID was set up..
 >>
 >>I got a friend of mine to make a list of all the 6^6 combinations of dev
 >>1 2 3 4 5 missing, and set it up this way :
 >>
 >>"mdadm --create -n 6 -l 5  dev1 2 3 4 5 missing ; fdisk -l /dev/md0 ;
 >>mdadm --stop /dev/md0" .
 >>But a "cat logfile | grep Linux" of the output of this script tells me
 >>that on no of these combination does it find a valid "type 83" partition.
 >>
 >>shouldn't this work ???
 >
 > No.
 >
 > What are you expecting fdisk to tell you?  fdisk lists partitions and
 > I suspect you didn't have any partitions on /dev/md0
 > More likely you want something like
 >    fsck -n -f /dev/md0
 >
 > and see which one produces the least noise.

They all produce

"Bad magic number in super-block while trying to open /dev/md0" .

I tried file -s /dev/md0 also, and with one of the disk as first disk I 
got "ext 3 filedata (needs journal recovery) (errors)" .

but as fsck -n -f can't do anything with it, there might not be any hope ?


Or can it still be that I have some wrong setting?

Chunk size is (and was) default 64k, yes?

Sevrin
