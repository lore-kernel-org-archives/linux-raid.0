From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Is it possible to create a raid from/over other raids?
Date: Thu, 19 Dec 2013 09:37:00 +1100
Message-ID: <52B2238C.4000605@websitemanagers.com.au>
References: <BLU0-SMTP2702D8075688EF7D229D66498DA0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP2702D8075688EF7D229D66498DA0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19/12/13 08:12, Wilson Jonathan wrote:
> I realise if it is possible its not going to be the best solution, but a
> temp stop gap...
>
> What I am thinking of doing is while I save up to by my 4'th new disk
> for a new raid 6 setup (4 drive raid 6, currently has 3 disks 1 missing)
> is it possible to use 3 existing smaller disks, create a raid0 across
> them and then add the resulting /dev/dmX as "a disk" where the currently
> missing disk is marked as missing.
>
> EG. /dev/md7  ... /dev/sdb1 /dev/sdc1 /dev/sdd1 missing
>
> mdadm create /dev/md8 raid0 /dev/sde1 /dev/sdf1 /dev/sdg1
>
> mdadm --add /dev/md7 /dev/md8
Yes, this is possible, MD doesn't care what the block device is.... MD 
uses block devices, and produces block devices...
> If it is possible do I need to make sure the order in the conf file
> first lists the /md8 then the /md7 or will mdadm see that a raid
> contains a raid as a disk and then waits for it before assembling.
This might depend on what distribution you use /etc... IMHO, it should 
work without a problem, but you should try it to confirm that.

IMHO, this isn't such a terrible idea, it adds at least some level of 
protection, although if you can using a 4th smaller disk with RAID5 
would be better still. I'm also assuming performance is not a critical 
factor in all this...

BTW, can anyone comment whether this would work:
Using linear, then only the portion of the RAID0 with the failed disk 
will be failed in the RAID6, so 2/3rds will still be 4 disk RAID6 and 
1/3rd will be 3 disk RAID6?

Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
