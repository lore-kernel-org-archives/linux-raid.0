From: Dylan Distasio <interzone@gmail.com>
Subject: Re: RAID5 -> RAID6 conversion, please help
Date: Tue, 10 May 2011 21:04:29 -0400
Message-ID: <BANLkTimYWfT_Vr7ZUnNUhOqW2JOyLHHNQQ@mail.gmail.com>
References: <002a01cc0f68$1c851180$558f3480$@priv.hu> <20110511093155.5b1a203e@notabene.brown>
 <4DC9CCAF.9010709@crc.id.au> <20110511102116.494bf0fd@notabene.brown>
 <BANLkTimwg94Bz22q5J7FJTcuFvX4BpRECg@mail.gmail.com> <20110511104730.175372fe@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110511104730.175372fe@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It's possible I did use different versions but I thought I had
upgraded both of them right before the reshapes.  Sorry if this is an
elementary question, but does writing the 2nd parity block always to
the last drive instead of rotating it increase the odds of a total
loss of the array since the one specific drive always has the 2nd
parity block?

If so, do you think normalizing would be worth the risk of something
going wrong with that operation?  I'm just trying to get a feel for
how much of a difference this makes.


> mdadm first converts the RAID5 to RAID6 in an instant atomic operatio=
n which
> results in the "-6" layout. =A0It then starts a restriping process wh=
ich
> converts the layout.
>
> If you end up with a -6 layout then something when wrong starting the
> restriping process.
>
> Maybe you used different version of mdadm? =A0There have probably bee=
n bugs in
> some versions..
>
> NeilBrown
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
