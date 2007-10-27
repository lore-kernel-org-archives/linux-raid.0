From: Raz <raziebe@gmail.com>
Subject: Re: Superblocks
Date: Sat, 27 Oct 2007 16:08:53 +0200
Message-ID: <5d96567b0710270708s3c6c75e0ga1d5e86881c72fb4@mail.gmail.com>
References: <29a863790710260943o7623212esce30325be4610dea@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <29a863790710260943o7623212esce30325be4610dea@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Greg Cormier <gcormier@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

why you zeroing hdd ?  should you clear sdd?

On 10/26/07, Greg Cormier <gcormier@gmail.com> wrote:
> Can someone help me understand superblocks and MD a little bit?
>
> I've got a raid5 array with 3 disks - sdb1, sdc1, sdd1.
>
> --examine on these 3 drives shows correct information.
>
>
> However, if I also examine the raw disk devices, sdb and sdd, they
> also appear to have superblocks with some semi valid looking
> information. sdc has no superblock.
>
> How can I clear these? If I unmount my raid, stop md0, it won't clear it.
>
> [root@zeus ~]# mdadm --zero-superblock /dev/hdd
> mdadm: Couldn't open /dev/hdd for write - not zeroing
>
> I'd like to rule out these oddities before I start on my next
> troubleshooting of why my array rebuilds every time I reboot :)
>
> Thanks,
> Greg
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Raz
