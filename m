From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: single cpu thread performance limit?
Date: Thu, 11 Aug 2011 17:01:32 +0100
Message-ID: <CADNH=7ESorghKRedp8U3Ef9Ak45KFaDPqbmvLqwyTD_9gdpUCA@mail.gmail.com>
References: <CAACGR8sSieD1MLCEnY0Wv24pHd9xpcJ=mhduwGMCqo5A5ttZpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAACGR8sSieD1MLCEnY0Wv24pHd9xpcJ=mhduwGMCqo5A5ttZpw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

 11 August 2011 16:58, mark delfman <markdelfman@googlemail.com> wrote:
> I seem to have hit a significant hard stop in MD RAID1/10 performance
> which seems to be linked to a single CPU thread.
>
> I am using extremely high speed (IOPS) internal block devices =E2=80=93=
 8 in
> total. =C2=A0They are capable of achieving > 1million iops.
>
> However if I use RAID1 / 10 then MD seems to use a single thread whic=
h
> will reach 100% CPU utilisation (single core) at around 200K IOPS.
> Limiting the entire performance to around 200K.
>
> If I use say 4 x RAID1 / 10=E2=80=99s and a RAID0 on top =E2=80=93 I =
see not much
> greater results. (although the theory seems to say I should and there
> are now 4 CPU threads running, it still seems to hit 4 x 100% at mayb=
e
> 350K).
>
> Is there any way to increase the number of threads per RAID set? Or
> any other suggestions on configurations? =C2=A0(I have tried every
> permutation of R0+R1/10=E2=80=99s)
>
> Thank you for any advice.
>
>
> Mark
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Maybe create separate MD RAID1 devices, then a new MD device with
RAID0? (instead of using mdadm RAID"10")

/M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
