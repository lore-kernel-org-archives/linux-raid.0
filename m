From: "B. J. Zolp" <bjzolp@wisc.edu>
Subject: Re: RAID5 Not coming back up after crash
Date: Mon, 29 Nov 2004 23:48:39 -0600
Message-ID: <41AC09B7.5080603@wisc.edu>
References: <200411292229.iATMTpN06996@www.watkins-home.com>
 <41AC0740.9060508@wisc.edu> <16812.2292.774718.891472@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <16812.2292.774718.891472@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Its 1.8.1.

bjz

Neil Brown wrote:

>On Monday November 29, bjzolp@wisc.edu wrote:
>  
>
>>I found a spare new drive that I copied hdj1 onto and put the new drive 
>>on the proper IDE cable for hdj.  Then tried running the mdadm -A 
>>/dev/md0 --force /dev/hda1 /dev/hdc1 /dev/hdd1 /dev/hdi1 /dev/hdj1
>>But it seg faults.  Should I try the  mkraid --force 
>>--dangerous-no-resync /dev/md0   ???
>>
>>    
>>
>
>which version of mdadm segfaults? 
>If you aren't using 1.8.0, use that.
>
>NeilBrown
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  
>

