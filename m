From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: mdadm break / restore soft mirror
Date: Thu, 13 Dec 2007 11:27:06 +1300
Message-ID: <4760603A.7030902@sauce.co.nz>
References: <05ED21952E28E94E8352836547A6BA37042318B3@achmsx001.hsa.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <05ED21952E28E94E8352836547A6BA37042318B3@achmsx001.hsa.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brett Maton wrote:
> Hi, 
> 
>   Question for you guys. 
> 
>   A brief history: 
>   RHEL 4 AS 
>   I have a partition with way to many small files on (Usually around a couple of million) that needs to be backed up, standard
> 
>   methods mean that a restore is impossibly slow due to the sheer volume of files. 
>   Solution, raw backup /restore of the device.  However the partition is permanently being accessed. 
> 
>   Proposed solution is to use software raid mirror.  Before backup starts, break the soft mirror unmount and backup partition
> 
>   restore soft mirror and let it resync / rebuild itself. 
> 
>   Would the above intentional break/fix of the mirror cause any problems? 
> 

Is there a reason you can't use rsync to just update changes from the 
previous backup, once you have your initial one?

Regards,

Richard
