From: c.baegert-listes@lixium.fr
Subject: Re: RAID 0, disks swapped ?
Date: Fri, 17 Oct 2008 15:48:59 +0200
Message-ID: <200810171548.59686.c.baegert-listes@lixium.fr>
References: <200810171318.12654.c.baegert-listes@lixium.fr> <48F89094.2080504@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48F89094.2080504@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Le vendredi 17 octobre 2008, Bill Davidsen a =E9crit :
> Just for educational purposes (won't help fix your problem), you had
> RAID 1+0 rather than RAID-10. See the mdadm docs for the difference. =
And
> reading old discussions here on the performance of RAID-10 with two f=
ar
> copies would be useful as well.

Yeah, I saw them, I use directly raid10 for a few months, but this arra=
y was=20
older. The good point of the RAID 1+0 solution is that I just have to r=
epair=20
a raid0 array now. But how ?

Regards,
--=20
=20
Christophe
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
