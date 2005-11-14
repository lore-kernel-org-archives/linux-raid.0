From: Shane Bishop <sbishop@trinitybiblecollege.edu>
Subject: Re: help!
Date: Mon, 14 Nov 2005 13:24:55 -0600
Message-ID: <4378E487.6050402@trinitybiblecollege.edu>
References: <4378C76A.9070906@trinitybiblecollege.edu> <17272.56732.538446.471537@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17272.56732.538446.471537@fisica.ufpr.br>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Carlos Carvalho wrote:

>Shane Bishop (sbishop@trinitybiblecollege.edu) wrote on 14 November 2005 11:20:
> >I had an mdadm device running fine, and had created my own scripts for 
> >shutting it down and such. I upgraded my distro, and all of a sudden it 
> >decided to start initializing md devices on it's own, which include one 
> >that I want removed.
>
>Probably the filesystem type in the partition table is set to raid
>autodetect (fd). Try changing it to something else, for example 83.
>Note that these are hexadecimal numbers.
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  
>
They were indeed set to raid autodetect. I was unaware of what that 
actually did, I think I must have followed that step in a how-to when I 
originally set it up. The odd thing is that these are the partition 
pairs that were being mounted:
sda sdb
sda1 sdb1
sdc1 sdd1
The last 2 are the ones I actually wanted, but the first one was 
something I had done when I was first playing around with it, if memory 
serves me correct. Is that possible, or does it point to some other issue?

Shane
