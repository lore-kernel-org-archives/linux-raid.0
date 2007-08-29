From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Raid5 Reshape gone wrong, please help
Date: Wed, 29 Aug 2007 09:32:24 -0400
Message-ID: <46D57568.3010202@tmr.com>
References: <c92bcddf0708171826n5991b3ffw1094e0e8c44c97e8@mail.gmail.com>	 <18118.46141.966406.577626@notabene.brown>	 <c92bcddf0708180837y4d92d2b4x3a4308e77b515ab3@mail.gmail.com>	 <18120.9950.578786.624453@notabene.brown>	 <c92bcddf0708190845k485a8460q609b16a8795bc288@mail.gmail.com>	 <c92bcddf0708191944x4aab7770ga6815210109dca6f@mail.gmail.com>	 <c92bcddf0708201909w2534c25du6282fd661ed838f5@mail.gmail.com> <c92bcddf0708230804g2e3fb7ev4e5d1a13814d4d0f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c92bcddf0708230804g2e3fb7ev4e5d1a13814d4d0f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Nicholson <d0gz.net@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greg Nicholson wrote:
> <Trimming tons of detail, but keeping the thread>
>
> OK.... I've reproduced the original issue on a seperate box.
> 2.6.23-rc3 does not like to grow Raid 5 arrays.  MDadm 2.6.3
>   

I have to say that trying something as critical as a reshape of live 
data on an -rc kernel is a great way to have a learning experience. Good 
that you found the problem, but also good that *you* found the problem, 
not me.

Thanks for testing. ;-)
> mdadm --add /dev/md0 /dev/sda1
> mdadm -G --backup-file=/root/backup.raid.file /dev/md0
>
> (Yes, I added the backup-file this time... just to be sure.)
>
> Mdadm began the grow, and stopped in the critical section, or right
> after creating the backup... Not sure which.  Reboot.
>
> Refused to start the array.  So...
>
>  mdadm -A /dev/md0 /dev/sd[abdefg]1
>
> and we have in /proc/mdstat:
>
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdg1[0] sda1[5] sdf1[4] sdd1[3] sdb1[2] sde1[1]
>       1953535488 blocks super 0.91 level 5, 128k chunk, algorithm 2
> [6/6] [UUUUUU]
>       [>....................]  reshape =  0.0% (512/488383872)
> finish=378469.4min speed=0K/sec
>
> unused devices: <none>
>
> And it's sat there without change for the past 2 hours.  Now, I have a
> backup, so frankly, I'm about to blow away the array and just recreate
> it, but I thought you should know.
>
> I've got the stripe_cache_size at 8192... 256 and 1024 don't change anything.
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

