From: Mark Knecht <markknecht@gmail.com>
Subject: Re: What RAID type and why?
Date: Sat, 6 Mar 2010 15:51:27 -0800
Message-ID: <5bdc1c8b1003061551n7413d4f1ibbadb77779e1d551@mail.gmail.com>
References: <5bdc1c8b1003061402n1281b64es9fa597b8bc714bd5@mail.gmail.com>
	 <87f94c371003061433x404a8c2fgcb61f817af6ecb1@mail.gmail.com>
	 <9089562724D84B3C858E337F202FF550@m5>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9089562724D84B3C858E337F202FF550@m5>
Sender: linux-raid-owner@vger.kernel.org
To: Guy Watkins <linux-raid@watkins-home.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Mar 6, 2010 at 3:17 PM, Guy Watkins <linux-raid@watkins-home.co=
m> wrote:
<SNIP>
> }
> } At a minimum I would build a 3-disk raid 6. =C2=A0raid 6 does a lot=
 of i/o
> } which may be a problem.
>
> If he only needs 3 drives I would recommend RAID1. =C2=A0Can still lo=
ose 2 drives
> and you don't have the RAID6 I/O overhead.
>
> Also, you said your data is important. =C2=A0If so, you need a backup=
 solution!
> 2 copies with 1 off-site. =C2=A0Maybe alternate between the 2 each da=
y or week.
>
> How much data per day? =C2=A0How much data during the next 3 years?
>
> Guy

OK - good points.

The 'data' is very important to me. Full disclosure (and it well could
make a difference I suppose) but the stock data is really just part of
a medium sized VMWare image on the order of 10GB. VMWare is running on
Gentoo and hosting Windows XP currently, Windows 7 later possibly.
Windows is the only platform that has programs that currently do what
I need. (And my trading partner is completely Windows based so until I
convert him to Linux Windows must be part of the recipe.)

Anyway, I try to keep my VMWare images below 10GB so that I can tar
them up once a week and write them to a dual-layer DVD for backup.
Once a month I move one to the safe deposit box at the bank. Otherwise
I keep three in the house at the far end in a fireproof box. (Although
high temp might damage them if the whole house goes up. Who knows...)

So, Gentoo hosts VMWare. VMWare maps a logical 10GB Windows C: drive
into a bunch of 2GB files and the stock data it typically a single
file for each stock where the file size approaches 100MB. I have
little or no control in terms of how that 100MB file is placed on the
drive.

I haven't a clue what that really means in terms of disk access from a
Linux point of view.

Daily backups are just my programming. They are incremental and just
sent to another computer on the network, and then also covered in the
VMWare backup at the end of the week.


Replying to Asdo - I'm hoping to use a more or less standard desktop
or server motherboard with 6-8 SATA ports dedicating 3-6 ports to this
RAID interface and then using Linux software RAID and no hardware RAID
controllers. Is this unreasonable in your opinion for the work flow
I'm describing using VMWare?

I'm concerned about any RAID hardware that leaves me stranded if the
controller dies.

Thanks all!

- Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
