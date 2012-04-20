From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Is this enough for us to have triple-parity RAID?
Date: Fri, 20 Apr 2012 12:39:17 -0700
Message-ID: <4F91BB65.8040304@zytor.com>
References: <CAMqP1GVnOErhxj8RV=KFtzHHEJqtguEd1L_vmsS=AAi_rAPoVg@mail.gmail.com> <4F8D228D.8060005@westcontrol.com> <20120417171609.GA2859@lazy.lzy> <4F8DD02F.1060504@westcontrol.com> <4F905690.3060301@zytor.com> <CAMqP1GVjqBMTiM9Yb+PxQLULWDnG8x3uvzuLFKya3NXsTPt_hg@mail.gmail.com> <067e21e2-6f21-48a7-93a8-bb2249534155@email.android.com> <CAMqP1GXaqtxrSviV1ZhBXopt82ZprjzPFppXvLK36yLkptmXQw@mail.gmail.com> <4F91B1C4.5080205@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F91B1C4.5080205@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Alex <creamyfish@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/20/2012 11:58 AM, David Brown wrote:
> Hi,
>=20
> Yes, being a generator for GF(2^8) is a requirement for a parity
> generator (sorry for the confusing terminology here - if anyone has a
> better suggestion, please say) to be part of a 255 data disk system.
> However, being a GF generator is necessary but not sufficient - using
> parity generators (1, 2, 4, 16) will /not/ give quad parity for 255 d=
ata
> disks, even though individually each of 1, 2, 4 and 16 are generators
> for GF.
>=20
> 255 data disks is the theoretical limit for GF(2=E2=81=B8).  But it i=
s a
> theoretical limit of the algorithms - I don't know whether Linux md r=
aid
> actually supports that many disks.  I certainly doubt if it is useful=
=2E
>=20
> It might well be that a 21 data disk limit quad parity is useful - or=
 at
> least, as useful as quad parity ever would be.  It would fit well wit=
hin
> a typical large chassis with 24 disk slots.  And then it doesn't matt=
er
> that 8 is not a generator for GF(2=E2=81=B8) - it becomes the best ch=
oice
> because of the easiest implementation.
>=20

It is also worth noting that there is nothing magical about GF(2^8).  I=
t
is just a reasonable tradeoff when tables are needed.

There are hardware tricks one can play to do efficient operation of
wider fields, too.

But It sounds like {04} or {8e} are particular interesting generators o=
f
the existing GF(2^8) field for an efficient second field, giving
triple-parity RAID again at a reasonable cost.

	-hpa

--=20
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
