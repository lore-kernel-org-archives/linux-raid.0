From: "Enrique Garcia Briones" <egarcia@mail.uadec.mx>
Subject: Fw: Re: Configuring combination of RAID-1 RAID-5
Date: Tue, 31 Jan 2006 11:03:31 -0600
Message-ID: <20060131165932.M47478@mail.uadec.mx>
References: <20060131163248.M20133@mail.uadec.mx> <Pine.LNX.4.56.0601311658220.17400@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0601311658220.17400@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Gordon,

I will then read and re-read the RAID-6 configuration, and something I miss 
to explain, may be is not to be discussed here, is that when I installed the 
Linux with the A1000 pulled out everything went out well but, when I 
reconnect the A1000 the system didn't start up correctly... so my unique way 
was to install the Linux in the first hard drive of the A1000 and it seems 
to be working fine, Is that alternative functional?

thanks

---------- Forwarded Message -----------
From: Gordon Henderson <gordon@drogon.net>
To: Enrique Garcia Briones <egarcia@mail.uadec.mx>
Cc: linux-raid@vger.kernel.org
Sent: Tue, 31 Jan 2006 17:05:12 +0000 (GMT)
Subject: Re: Configuring combination of RAID-1 RAID-5

On Tue, 31 Jan 2006, Enrique Garcia Briones wrote:

> Hi,
>
> Let me introduce myself.
>
> I'm newbie in linux and in RAID over linux, I have configured a RAID-0 in a
> NetBSD 2.0 BOX. so, now let me explain what I'm trying to do,
>
> Antecedents/Equipment:
>
> I have a Sparc 420 with 4 processors and 4 Gb in RAM, two SCSI SEAGATE
> internal hard disk with an array of 12 hard disks (Storedge 1000).
>
> What we want to have:
>
> We installed Debian Linux (I think it is 3.1 with kernel 2.4), and we want
> to have the following configuration:
>
> 1 System Harddisk
> 1 RAID-1 Mirror Hard Drive
> 12 Hard drives in RAID-5, 10 working and 2 as spare disks.
>
> I have read the setting-up for the raid-5 and 1, but I would like to ask 
you
> if I can set-up a combined RAID configuration as mentioned above, since all
> the examples I found upto now just talk of one RAD configuration, besides
> this, I would like to ask you that if the configuration I want to have is
> STRONG enough for the quantity of disk in the box, or if there must be any
> other considerations to have.

Wow. an A1000. Ancient, but probably still OK. I'm not sure if there are
any management utilities for them that'll run under Linux - I've only ever
seen 2 of these and they seem to be able to run RAID themselves - might be
faster, but the ones I had were slow anyway - maybe you can re-configure
them to just look like 12 disks and let Linux do the RAID on them...

Heres my suggestion:

Install a 2.6 kernel.

Partition both internal disks identically, then then combine all the
partitions with RAID-1. Boot off RAID-1, if you can - I'm not up on the
SLILO/whatever boot loaders for Sparc though.

Configure the 12 external disks using RAID-6. You'll get one disk more
worth of storage that way and still be able to sustain a 2 disk failure.

Gordon

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
------- End of Forwarded Message -------


--
UAdeC
En el Bien fincamos el Saber
Open WebMail Project (http://openwebmail.org)

