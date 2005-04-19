From: David Greaves <david@dgreaves.com>
Subject: Re: optimum blockdev --setra settings
Date: Tue, 19 Apr 2005 09:17:35 +0100
Message-ID: <4264BE9F.1030509@dgreaves.com>
References: <426464F9.5040301@advocap.org>
Reply-To: LVM general discussion and development <linux-lvm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-lvm-bounces@redhat.com>
In-Reply-To: <426464F9.5040301@advocap.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-lvm>
List-Post: <mailto:linux-lvm@redhat.com>
List-Help: <mailto:linux-lvm-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=subscribe>
Sender: linux-lvm-bounces@redhat.com
Errors-To: linux-lvm-bounces@redhat.com
To: John McMonagle <johnm@advocap.org>
Cc: linux-raid@vger.kernel.org, linux-lvm@redhat.com
List-Id: linux-raid.ids

John McMonagle wrote:

> Anyone establish optimum blockdev --setra settings for raid on a 2.6 
> kernel?

yep.
I found 0 at all levels except the topmost.
ie
/dev/hdx -> ra=0
/dev/mdx -> ra=0
/dev/lvm/ -> ra=xxxx

>
> There has been some discussions on the lvm mailing list.

must have missed it...
Here's the message I cc'ed the lvm group *last* time this came up (12 
Dec '04) ;)

I hacked up a quick script to test permutations of readahead - it's not 
exactly bonnie+++ but it may be useful.
I wish I'd bothered with mdadm stripe sizes too - but the array is 
pretty full now and I'll live with what it delivers.

Essentially I found the best performance on *my* system with all low 
level devices and the md device set to a 0 readahead and the lvm device 
set to 4096.
I'm only interested in video streaming big (1+Gb) files. Your needs (and 
hence test) may differ.

my system is 2.6.10-rc2, xfs, lvm2, raid5, sata disks.

cc'ed the lvm group since this often seems to come up in conjunction 
with you guys :)

For your entertainment...

#!/bin/bash
RAW_DEVS="/dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/hdb"
MD_DEVS=/dev/md0
LV_DEVS=/dev/huge_vg/huge_lv

LV_RAS="0 128 256 1024 4096 8192"
MD_RAS="0 128 256 1024 4096 8192"
RAW_RAS="0 128 256 1024 4096 8192"

function show_ra()
{
for i in $RAW_DEVS $MD_DEVS $LV_DEVS
do echo -n "$i `blockdev --getra $i`  ::  "
done
echo
}

function set_ra()
{
 RA=$1
 shift
 for dev in $@
 do
   blockdev --setra $RA $dev
 done
}

function show_performance()
{
 COUNT=4000000
 dd if=/dev/huge_vg/huge_lv of=/dev/null count=$COUNT 2>&1 | grep seconds
}

for RAW_RA in $RAW_RAS
 do
 set_ra $RAW_RA $RAW_DEVS
 for MD_RA in $MD_RAS
   do
   set_ra $MD_RA $MD_DEVS
   for LV_RA in $LV_RAS
     do
     set_ra $LV_RA $LV_DEVS
     show_ra
     show_performance
     done
   done
 done




_______________________________________________
linux-lvm mailing list
linux-lvm@redhat.com
https://www.redhat.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
