From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Verifying spare drive, best practices
Date: Sat, 22 Mar 2008 13:25:53 -0400
Message-ID: <47E54121.80806@tmr.com>
References: <47E33AF8.6020106@harddata.com> <18403.53429.355889.906445@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18403.53429.355889.906445@fisica.ufpr.br>
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Carlos Carvalho wrote:
> Maurice Hilarius (maurice@harddata.com) wrote on 20 March 2008 22:35:
>  >Given this situation:
>  >7 disks in total
>  >RAID5 of 6 disks, and a hot spare.
>  >
>  >mdadm show the 6 disks, but not the spare.
>  >
>  >As a maintenance question, where one wants to periodically ensure that 
>  >the hot spare is both available and good.
>  >How should one best :
>  >1) Verify the hot spare is still available.
>  >2) Verify that the hot spare is healthy?
>
> I usually do a dd if=/dev/zero of=/dev/spare to write to all sectors
> and give the drive a chance to remap bad blocks. Then run smartctl
> with a long test, and smartctl -a to see the results.
>
>   
I hope you disable use as a spare before doing this... If you were so 
"lucky" as to have a failure in the array and start using the drive as a 
spare while writing zeros to it, you might have an unexpected learning 
experience.

> If there are partitions I use sfdisk -d /dev/disk-in-array |sfdisk -f
> /dev/spare to copy the partition table from one of the other disks to
> the spare, or any other (non-manual...) method to restore the partitioning.
>
> This can be easily included in the routine array checks.
-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


