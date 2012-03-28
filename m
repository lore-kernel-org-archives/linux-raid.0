From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: RAID6 grow failed
Date: Wed, 28 Mar 2012 04:22:24 +0100
Message-ID: <CADNH=7EjUDuMARO23cLPa2AMKhD11df3KcL8r-BN1WkmQb53MQ@mail.gmail.com>
References: <CAJ72viP2MLb2tL84P-aK6Rs9eAH4x9Wwd=kVNbmPA=2LAfNLjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ72viP2MLb2tL84P-aK6Rs9eAH4x9Wwd=kVNbmPA=2LAfNLjg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Bush <bbushvt@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 28 March 2012 03:44, Bryan Bush <bbushvt@gmail.com> wrote:
> I hope this is the right place to ask this question. =C2=A0I have at =
8
> drive RAID 6 array that I wanted to grow to 13 drives (adding 5 more)=
=2E
> =C2=A0I issued the mdadm command and checked /proc/mdstat and all loo=
ked
> well. =C2=A0However at some point in time a disk failed and that hung=
 my
> system. =C2=A0Upon reboot the array is inactive and I can't get it to
> reassemble.

<snip>
>
> Is there anything I can do to get the array back up?
> Thanks
> -Bryan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml

Sorry I can't help you, but that many large HDDs in one array? Can't
help but think that's a bit over-the-top risky! Good luck with the
recovery.

Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
