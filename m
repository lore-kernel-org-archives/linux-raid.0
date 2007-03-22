From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Another report of a raid6 array being maintaind by _raid5 in
 ps .
Date: Thu, 22 Mar 2007 09:45:46 -0400
Message-ID: <4602888A.1090704@tmr.com>
References: <Pine.LNX.4.64.0703212139010.2224@filesrv1.baby-dragons.com> <17922.5241.61746.282156@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17922.5241.61746.282156@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Mr. James W. Laferriere" <babydr@baby-dragons.com>, linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Wednesday March 21, babydr@baby-dragons.com wrote:
>   
>>  	Hello Neil ,  Someone else reported this before .  But I'd thought it 
>> was under a older kernel than 2.6.21-rc4 .  Hth ,  JimL
>>
>> root      2936  0.0  0.0   2948  1760 tts/0    Ss   04:30   0:00 -bash
>> root      2965  0.3  0.0      0     0 ?        S<   04:34   0:00 [md3_raid5]
>> root      2977  0.0  0.0   2380   912 tts/0    R+   04:38   0:00 ps -auxww
>>
>> root@(none):~# uname -a
>> Linux (none) 2.6.21-rc4 #2 SMP Thu Mar 22 04:19:35 UTC 2007 i686 pentium4 i386 GNU/Linux
>>
>> root@(none):~# cat /proc/mdstat
>> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] [multipath]
>> md3 : active raid6 sdc1[0] sdh1[5] sdg1[4] sdf1[3] sde1[2] sdd1[1]
>>        573905664 blocks super 1.2 level 6, 64k chunk, algorithm 2 [6/6] [UUUUUU]
>>        bitmap: 0/137 pages [0KB], 512KB chunk
>>     
>
> It's just a name....
> Given that the module is raid456.ko, how about this?
>
> There are lots of error message that say 'raid5' too....
>   
Yes, and lots of log watching programs which know about them. I bet they 
don't know raid456, though, and will either miss them or report them as 
"unknown error" on the scan. Do we really need a cosmetic change which 
will require a functional change with no gain in function?
> NeilBrown
>
> Signed-off-by: Neil Brown <neilb@suse.de>
>
> ### Diffstat output
>  ./drivers/md/raid5.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
> --- .prev/drivers/md/raid5.c	2007-03-13 10:38:33.000000000 +1100
> +++ ./drivers/md/raid5.c	2007-03-22 16:28:37.000000000 +1100
> @@ -4209,7 +4209,7 @@ static int run(mddev_t *mddev)
>  	}
>  
>  	{
> -		mddev->thread = md_register_thread(raid5d, mddev, "%s_raid5");
> +		mddev->thread = md_register_thread(raid5d, mddev, "%s_raid456");
>  		if (!mddev->thread) {
>  			printk(KERN_ERR 
>  				"raid5: couldn't allocate thread for %s\n",
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

