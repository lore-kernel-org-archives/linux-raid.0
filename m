From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: 3ware glitches cause softraid rebuilds
Date: Mon, 04 Sep 2006 12:59:20 -0400
Message-ID: <44FC5B68.7080500@tmr.com>
References: <1926236045.20060829034652@2ka.mipt.ru> <b1bc6a000608281756s1e76a80eq5f70e654e2e7e3e3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b1bc6a000608281756s1e76a80eq5f70e654e2e7e3e3@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: Jim Klimov <klimov@2ka.mipt.ru>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

adam radford wrote:

> Jim,
>
> Can you try the attached (and below) patch for 2.6.17.11?


Don't you want the sleep BEFORE setting the new value? ie. giving a wait 
for status to change before checking it again?

>
> Also, please make sure you are running the latest firmware.
>
> Thanks,
>
> -Adam
>
> diff -Naur linux-2.6.17.11/drivers/scsi/3w-9xxx.c
> linux-2.6.17.12/drivers/scsi/3w-9xxx.c
> --- linux-2.6.17.11/drivers/scsi/3w-9xxx.c    2006-08-23 
> 14:16:33.000000000 -0700
> +++ linux-2.6.17.12/drivers/scsi/3w-9xxx.c    2006-08-28 
> 17:48:29.000000000 -0700
> @@ -943,6 +943,7 @@
>         before = jiffies;
>         while ((response_que_value & TW_9550SX_DRAIN_COMPLETED) !=
> TW_9550SX_DRAIN_COMPLETED) {
>             response_que_value = 
> readl(TW_RESPONSE_QUEUE_REG_ADDR_LARGE(tw_dev));
> +            msleep(1);
>             if (time_after(jiffies, before + HZ * 30))
>                 goto out;
>         }
>
>------------------------------------------------------------------------
>
>diff -Naur linux-2.6.17.11/drivers/scsi/3w-9xxx.c linux-2.6.17.12/drivers/scsi/3w-9xxx.c
>--- linux-2.6.17.11/drivers/scsi/3w-9xxx.c	2006-08-23 14:16:33.000000000 -0700
>+++ linux-2.6.17.12/drivers/scsi/3w-9xxx.c	2006-08-28 17:48:29.000000000 -0700
>@@ -943,6 +943,7 @@
> 		before = jiffies;
> 		while ((response_que_value & TW_9550SX_DRAIN_COMPLETED) != TW_9550SX_DRAIN_COMPLETED) {
> 			response_que_value = readl(TW_RESPONSE_QUEUE_REG_ADDR_LARGE(tw_dev));
>+			msleep(1);
> 			if (time_after(jiffies, before + HZ * 30))
> 				goto out;
> 		}
>  
>


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

