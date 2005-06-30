From: Laurent CARON <lcaron@gw.unix-scripts.info>
Subject: Re: RAID1: What happens when one half of a mirror fails?
Date: Thu, 30 Jun 2005 21:03:44 +0200
Message-ID: <42C44210.7010204@gw.unix-scripts.info>
References: <200506301024.13126.eric@pretorious.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200506301024.13126.eric@pretorious.net>
Sender: linux-raid-owner@vger.kernel.org
To: eric@pretorious.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Eric Pretorious a =E9crit :

>Hello, All:
>
>I've been a bit surprised by the complete failure of our system when o=
ne half=20
>of a mirror failed so I suppose that I should verify that I understand=
=20
>RAID1's failover methodology: Is the purpose of the mirror only to pre=
serve=20
>the data or is it to allow the system to continue operating until a=20
>replacement can be installed? (i.e., If one half of a mirror fails, sh=
ouldn't=20
>the system continue operating normally?)
>
> =20
>
is the swap partition on raid?

--=20
Mauvaise garde permet au loup de se repa=EEtre.
	-+- Le Roman de Renart -+-

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
