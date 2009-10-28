From: "Majed B." <majedb@gmail.com>
Subject: Re: md software raid
Date: Wed, 28 Oct 2009 03:58:38 +0300
Message-ID: <70ed7c3e0910271758r3f10b79fw99375299ed721f1e@mail.gmail.com>
References: <70ed7c3e0910271747o29e53a69l2b88de8d538284aa@mail.gmail.com>
	<20091028005303577.NTSS9287@cdptpa-omta02.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091028005303577.NTSS9287@cdptpa-omta02.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Indeed xfs_repair doesn't require the abusive amount of memory
xfs_check requires.

I've been a happy XFS user for a few years now, but the fact the
xfsprogs aren't being maintained properly and xfs_check is still a
failure, I'm considering other alternatives.

A filesystem that provides speed and a small footprint on the array
for its master file table is great, but a filesystem that has
maintained tools and tools that work well in case of data corruption
is a preferred one, at least to me.

I almost lost 5.5TB worth of data recently and the tools available
made it really hard to fix problems.

On Wed, Oct 28, 2009 at 3:52 AM, Leslie Rhorer <lrhorer@satx.rr.com> wr=
ote:
>
>> Leslie,
>>
>> How do you check xfs? xfs_check?
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Yes.
>
>> Why not use xfs_repair -n?
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0I guess the short answer is, "I didn't kno=
w it would make a
> difference". =C2=A0I take it, then, xfs_repair uses a completely diff=
erent method
> of scanning for errors than xfs_check, one whihcdoes not require so m=
uch
> memory? =C2=A0I find that a bit surprising.
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
