From: Matt Darcy <kernel-lists@projecthugo.co.uk>
Subject: Re: 2.6.15-rc5-mm3 sata_mv raid5 array failure to start
Date: Wed, 11 Jan 2006 10:11:38 +0000
Message-ID: <43C4D9DA.4030008@projecthugo.co.uk>
References: <43B82D22.7080705@projecthugo.co.uk> <17347.3596.845986.167120@cse.unsw.edu.au>
Reply-To: kernel-lists@projecthugo.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17347.3596.845986.167120@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

>On Sunday January 1, kernel-lists@projecthugo.co.uk wrote:
>  
>
>>Hello all,
>>
>>I am still persisting with my quest for a usable sata_mv driver.
>>
>>The 2.5.15-rc5-m3 kernel appear to have been good to me.
>>
>>Before I attempt moving to later releases of the 2.6.15 tree I thought 
>>I'd get feedback from the people in the know
>>
>>This is an intentional cross-post as I'm not %100 sure if the problems 
>>sits in the raid error or the actual libata/driver area (more probable)
>>
>>I have 7 SATA disks hanging of an 8 port controller which uses the 
>>sata_mv driver.
>>
>>I create a raid 5 array consisting of 6 disks (using 1 full disk 
>>partition) and 1 spare
>>    
>>
>
>"1 full disk partition"... So I would expect the array consist of
>   sdc1 sdd1 sde1 ...
>
>but..
>  
>
>>The array builds fine - although it takes 300 minutes so its not a quick 
>>process to run through tests.
>>
>>
>>md6 : active raid5 sdh[5] sdi[6](S) sdg[4] sdf[3] sde[2] sdd[1] sdc[0]
>>      1225586560 blocks level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]
>>
>>    
>>
>
>It doesn't.  It is created using the full disks (sdc, sdd, ... No partitioning).
>  
>

My mistake in this example (I've built this array <15 times - this 
occasion was a typo - %100 my mistake)

however.......

>and them on reboot, md tried to assemble an array from the partitions,
>presumably because you set the partition type to raid-auto-detect.
>This doesn't work because the array wasn't made from partitions.
>
>I suggest you recreate the array using partitions and see how that
>goes:
>
>  mdadm -C /dev/md6 -l5 -n6 -x1 /dev/sd[cdefghi]1
>
>NeilBrown
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  
>

using the partitions for the array (which I had done in previous tests 
despite my typo mentioned above on this case) I get the same problem,

the array starts to build, gets around %35-ish through and then the 
system hangs.

I don't believe this is a raid issue, more a case of the sata_mv driver.

Thanks for the input.

Matt


