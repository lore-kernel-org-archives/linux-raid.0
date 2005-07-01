From: Tyler <pml@dtbb.net>
Subject: Re: raid0 low performance
Date: Thu, 30 Jun 2005 19:28:01 -0700
Message-ID: <42C4AA31.8040307@dtbb.net>
References: <1120184148.5521.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1120184148.5521.21.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: mingz@ele.uri.edu
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

My guess at a glance would be either the Marvel driver is at fault, or 
the simple fact of software raid performance... did you monitor the cpu 
useage during the tests?  even PCI 32bit, 33mhz should be able to hit 
133 Mbytes per second I believe.  What are you writing *from* ? dev/zero 
or another drive that may not have a read speed high enough to keep up 
with what is available?

Tyler.

Ming Zhang wrote:

>I meet some strange low performance when run RAID0 with vanilla kernel
>2.4.27/2.6.11.12.
>
>My box is a 2.8G P4 and 1G RAM. 8 400GB SATA disk and A marvel 8port
>controller. I run marvel 3.4.1 driver. I wrote a small program to write
>device sequentially and SYNCHRONOUSLY.
>
>This is performance of 1 disk. looks fine.
>
> 1048576Bytes *     1024 :    55.466MB/s
>  524288Bytes *     2048 :    55.830MB/s
>  262144Bytes *     4096 :    55.782MB/s
>  131072Bytes *     8192 :    55.567MB/s
>   65536Bytes *    16384 :    55.926MB/s
>   32768Bytes *    32768 :    54.344MB/s
>   16384Bytes *    65536 :    41.415MB/s
>    8192Bytes *    65536 :    26.499MB/s
>    4096Bytes *    65536 :    15.110MB/s
>    2048Bytes *    65536 :     8.422MB/s
>    1024Bytes *    65536 :     4.318MB/s
>
>But when run 2 disk raid0, there is only 10% improvement.
>
>md3 : active raid0 sdb[1] sda[0]
>      781422592 blocks 64k chunks
> 1048576Bytes *     1024 :    67.300MB/s
>  524288Bytes *     2048 :    66.796MB/s
>  262144Bytes *     4096 :    65.728MB/s
>  131072Bytes *     8192 :    65.017MB/s
>   65536Bytes *    16384 :    59.223MB/s
>   32768Bytes *    32768 :    49.766MB/s
>   16384Bytes *    65536 :    39.162MB/s
>    8192Bytes *    65536 :    26.386MB/s
>    4096Bytes *    65536 :    15.084MB/s
>    2048Bytes *    65536 :     8.383MB/s
>    1024Bytes *    65536 :     4.303MB/s
>
>And when use 4 disks, the speed is slower!
>md0 : active raid0 sdh[3] sdg[2] sdf[1] sde[0]
>      1562845184 blocks 64k chunks
> 1048576Bytes *     1024 :    58.032MB/s
>  524288Bytes *     2048 :    56.994MB/s
>  262144Bytes *     4096 :    58.289MB/s
>  131072Bytes *     8192 :    65.999MB/s
>   65536Bytes *    16384 :    59.723MB/s
>   32768Bytes *    32768 :    50.061MB/s
>   16384Bytes *    65536 :    38.689MB/s
>    8192Bytes *    65536 :    26.169MB/s
>    4096Bytes *    65536 :    15.169MB/s
>    2048Bytes *    65536 :     8.378MB/s
>    1024Bytes *    65536 :     4.287MB/s
>
>
>Any hint on this?
>
>* I do not know how to check current PCI bus speed and I am not sure
>whether is limited by that. It is a 64bit card but I am not sure if it
>is run at 66MHZ. Should be, but want to check to make sure.
>* I tested each disk and all disk performs OK.
>
>
>Thanks
>
>
>Ming
>
>  
>

