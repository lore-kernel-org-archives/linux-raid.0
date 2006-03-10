From: Mike Tran <mhtran@us.ibm.com>
Subject: Re: Did --zero-superblock by mistake ... How can I get back data
 ?
Date: Fri, 10 Mar 2006 13:38:19 -0600
Message-ID: <4411D5AB.2030609@us.ibm.com>
References: <4411BF56.7010801@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4411BF56.7010801@free.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Raphael Delaporte <jordanrudess@free.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Raphael Delaporte wrote:

> Hi,
>
> On a RAID 5 array which is composed by 5 hdd, I did mdadm 
> --zero-superblocks on each hdd because I thought it was required to 
> use the array on a new system....
>
> But now, I cannot mdadm --assemble the array. It says :
>
> mdadm: no RAID superblock on /dev/sda
> mdadm: /dev/sda has no superblock - assembly aborted
>
> Is it possible to assemble this array because I don't want to lose my 
> data... Someone told me that I can do a :
>
> mdadm -Cv /dev/md0 -l5 -n5 /dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/hdc
>
> But if do that, all the data on the raid will be lost or not ?
>
> Is there an other way to get back these data ?
>
> Thank you very much for your help.
>
I would try to recreate the raid5 array with *1 missing disk,* then try 
to mount the array (read only) and verify the data.

For example,
mdadm -C /dev/md0 -l 5 -c 32 -p ls -n 5 /dev/sda /dev/sdb /dev/sdc 
/dev/sdd missing

Notes:
If you used /etc/mdadm.conf, specify the disk order on the ARRAY line 
with 1 missing disk to be safe.
I specified the mdadm default chunk size (32K) and default parity 
algorithm (left-symmetric). You may have to use other values.
You should change the order of the disks if your data is invalid.

--
Regards,
Mike T.

