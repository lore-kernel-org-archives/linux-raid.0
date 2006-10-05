From: Eli Stair <estair@ilm.com>
Subject: Re: RAID10: near, far, offset -- which one?
Date: Thu, 05 Oct 2006 10:57:13 -0700
Message-ID: <45254779.70506@ilm.com>
References: <20061005152321.GA32017@piper.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061005152321.GA32017@piper.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Taken for what it is, here's some recent experience I'm seeing (not a 
precise explanation as you're asking for, which I'd like to know also).

Layout : near=2, far=1
Chunk Size : 512K
gtmp01,16G,,,125798,22,86157,17,,,337603,34,765.3,2,16,240,1,+++++,+++,237,1,241,1,+++++,+++,239,1
gtmp01,16G,,,129137,21,87074,17,,,336256,34,751.7,1,16,239,1,+++++,+++,238,1,240,1,+++++,+++,238,1
gtmp01,16G,,,125458,22,86293,17,,,338146,34,755.8,1,16,240,1,+++++,+++,237,1,240,1,+++++,+++,237,1

Layout : near=1, offset=2
Chunk Size : 512K
gtmp02,16G,,,141278,25,98789,20,,,297263,29,767.5,2,16,240,1,+++++,+++,238,1,240,1,+++++,+++,238,1
gtmp02,16G,,,143068,25,98469,20,,,316138,31,793.6,1,16,239,1,+++++,+++,237,1,239,1,+++++,+++,238,0
gtmp02,16G,,,143236,24,99234,20,,,313824,32,782.1,1,16,240,1,+++++,+++,237,1,240,1,+++++,+++,238,1


Here, testing with bonnie++, 14-drive RAID10 dual-multipath FC, 10K 146G 
drives.  RAID5 nets the same approximate read performance (sometimes 
higher), with single-thread writes limited to 100MB/sec, and 
concurrent-thread R/W access in the pits (obvious for RAID5).

mdadm 2.5.3
linux 2.6.18
xfs (mkfs.xfs -d su=512k,sw=3 -l logdev=/dev/sda1 -f /dev/md0)


Cheers,

/eli




martin f krafft wrote:
> I am trying to compare the three RADI10 layouts with each other.
> Assuming a simple 4 drive setup with 2 copies of each block,
> I understand that a "near" layout makes RAID10 resemble RAID1+0
> (although it's not 1+0).
> 
> I also understand that the "far" layout trades some read performance
> for some write performance, so it's best for read-intensive
> operations, like read-only file servers.
> 
> I don't really understand the "offset" layout. Am I right in
> asserting that like "near" it keeps stripes together and thus
> requires less seeking, but stores the blocks at different offsets
> wrt the disks?
> 
> If A,B,C are data blocks, a,b their parts, and 1,2 denote their
> copies, the following would be a classic RAID1+0 where 1,2 and 3,4
> are RAID0 pairs combined into a RAID1:
> 
>   hdd1  Aa1 Ba1 Ca1
>   hdd2  Ab1 Bb1 Cb1
>   hdd3  Aa2 Ba2 Ca2
>   hdd4  Ab2 Bb2 Cb2
> 
> How would this look with the three different layouts? I think "near"
> is pretty much the same as above, but I can't figure out "far" and
> "offset" from the md(4) manpage.
> 
> Also, what are their respective advantages and disadvantages?
> 
> Thanks,
> 

