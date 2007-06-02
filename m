From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: RAID 6 grow problem
Date: Sat, 2 Jun 2007 12:19:50 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0706021219380.13025@p34.internal.lan>
References: <C2874B9F.7EBD%groups@email.iain.rauch.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C2874B9F.7EBD%groups@email.iain.rauch.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Iain Rauch <groups@email.iain.rauch.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 2 Jun 2007, Iain Rauch wrote:

> Hello, when I run:
>
> mdadm /dev/md1 --grow --raid-devices 16 --backup-file=/md1backup
>
> I get:
>
> mdadm: Need to backup 1792K of critical section..
> mdadm: Cannot set device size/shape for /dev/md1: Invalid argument
>
> Any help?
>
>
> Iain
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Yup, I got the same thing, first, what is your chunk size?

mdadm -D /dev/md1

Justin.
