From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Speaking of network disks (was: Re: syncing remote homes.)
Date: Mon, 24 Sep 2007 14:12:45 -0400
Message-ID: <46F7FE1D.6040705@tmr.com>
References: <Pine.LNX.4.64.0709221022440.7723@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0709221022440.7723@filesrv1.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mr. James W. Laferriere wrote:
>     Hello Bill & all ,
>
> Bill Davidsen <davidsen@tmr.com> Sat, 22 Sep 2007 09:41:40 -0400 ,  
> wrote:
>> My only "advice" is to try and quantify the data volume and look at 
>> nbd vs. iSCSI to provide the mirror if you go that way.
>
>     You mentioned nbd as a transport for disk to remote disk .
>
>     My Question is have you OR anyone else tried using drbd(*) as a
>     method to replicate disk data across networks ?

Have not. And looking at the homepage, I think it's aimed at anothjer 
problem. If the local drive fails, I really don't want anything starting 
applications on another machine, running fsck, etc, etc. I just want my 
disk reads to go to a working device or pseudo-device.

HA and mirroring are related, but HA is more aimed at whole machine 
failures.
>
>     I've looked at the projects documents & software .  They're
>     mentioned at linux-ha .  But I personally have not heard of anyone
>     using it in production .  So I asked my question here .
>         Tia ,  JimL
>
> (*) http://www.drbd.org/


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

