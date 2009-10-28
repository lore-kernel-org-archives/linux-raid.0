From: "Majed B." <majedb@gmail.com>
Subject: Re: md software raid
Date: Wed, 28 Oct 2009 03:47:35 +0300
Message-ID: <70ed7c3e0910271747o29e53a69l2b88de8d538284aa@mail.gmail.com>
References: <4AE75D87.60708@tmr.com> <20091028004524773.SGCK5890@cdptpa-omta01.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091028004524773.SGCK5890@cdptpa-omta01.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Leslie,

How do you check xfs? xfs_check? Why not use xfs_repair -n?

On Wed, Oct 28, 2009 at 3:45 AM, Leslie Rhorer <lrhorer@satx.rr.com> wr=
ote:
>> That's certainly a valid point, if you are stuck using xfs by prefer=
ence
>> or requirement. I have seen claims that 2.6.32 will be better, but I
>> have no intention of testing it, having parted company with xfs a wh=
ile
>> ago.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0May I ask, "Why?" =C2=A0I am running XFS o=
n both my video server and its
> backup. =C2=A0Generally I have been very pleased. =C2=A0The only issu=
e I have had was
> trying to fsck the arrays. =C2=A0I only have 10G of swap space, and X=
=46S requires
> much more than that to successfully check file systems in excess of 6=
T. =C2=A0It
> wasn't a really big deal, however. =C2=A0I just plugged in a 750G dri=
ve, shut
> down the default swap, and turned it up on the large drive. =C2=A0Onc=
e done, I
> switched the swap back to the boot drive.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
