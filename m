From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Cannot remove failed drive
Date: Fri, 25 Jun 2004 07:51:58 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16603.19710.728034.669031@cse.unsw.edu.au>
References: <40DADBF2.3030105@corp.texas.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Philip Molter on Thursday June 24
To: Philip Molter <philip@corp.texas.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday June 24, philip@corp.texas.net wrote:
> I have a drive that failed out:
> 
> scsi1: ERROR on channel 0, id 1, lun 0, CDB:
>    Read (10) 00 00 c2 a0 3f 00 00 28 00
> Info fld=0xc2a03f, Current sdf: sense key Medium Error
> Additional sense: Read retries exhausted
> end_request: I/O error, dev sdf, sector 12755007
> raid1: Disk failure on sdf1, disabling device.
> ^IOperation continuing on 1 devices
> raid1: sdf1: rescheduling sector 12754944
> raid1: sdb1: redirecting sector 12754944 to another mirror
> 
> /proc/mdstat shows the drive failed:
> 
> md4 : active raid1 sdf1[2](F) sdb1[0]
>        35905152 blocks [2/1] [U_]
> 
> When I try to remove the drive:
> 
> # mdadm /dev/md4 -r /dev/sdf1
> mdadm: hot remove failed for /dev/sdf1: Device or resource busy


This fix for this went into Linus' BK tree 20 days ago, and so is in
2.6.7-rc3 and later.

NeilBrown

http://linux.bkbits.com:8080/linux-2.5/cset@40c2091dDFmX9NP0UWlmCGCZNPsEoA
