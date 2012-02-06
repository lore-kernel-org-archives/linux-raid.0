From: Doug Dumitru <doug@easyco.com>
Subject: Re: Would different hd speeds affect md raid?
Date: Mon, 6 Feb 2012 12:15:14 -0800
Message-ID: <CAFx4rwRYbPMDRPtwU2kkozyefgG8Tj-64jXHz2YpCEk8abvSAA@mail.gmail.com>
References: <BLU0-SMTP42258229182D2BB3BC44EB798740@phx.gbl>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP42258229182D2BB3BC44EB798740@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: wilsonjonathan <piercing_male@hotmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

In general, the speed of a raid array is limited by the speed of the
slowest drive.  This is why if one drives gets "wonky", the array degra=
des
down to the speed of the slowest drive.

If you look at statistically evenly distributed IO, this make sense.  A=
fter
all, each drive will get even numbers of reads, so the read rate of the
slowest drive will predominate read overhead.  With writes, each drive =
gets
the same number of writes, so the same rules apply.

This logic falls apart with mirrors where the raid control layer can ch=
oose
to aim IO at the least busy drives, but you said you were running raid-=
5.

So in your case, replacing a drive with a faster drive is just fine.

Doug Dumitru

On Mon, Feb 6, 2012 at 11:54 AM, wilsonjonathan
<piercing_male@hotmail.com> wrote:
>
> I was just wondering a quick question... If a system had a failed
> 1.5Gbps speed sata (out of 3 in a raid 5) and it was replaced with a
> 3Gbps speed drive would the difference affect the speed of the raid, =
or
> would it be no different to its original 3 * 1.5Gbps speed.
>
> I'm curious as to if the speed difference would affect overall speeds=
 as
> obviously 2 drives would be running at half the speed of the other
> drives.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html




--
Doug Dumitru
EasyCo LLC
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
