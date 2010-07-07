From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: mapping ataXX.YY to a /dev/sdX
Date: Wed, 07 Jul 2010 22:02:16 +1000
Message-ID: <87wrt7ijp3.fsf@rimspace.net>
References: <alpine.DEB.1.10.1007070810540.23489@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael Abrahamsson <swmike@swm.pp.se> writes:

> I have some spurious timeouts (but without md kicking the drive) on a=
n
> WD20EADS. I believe this drive is actually defective and would like t=
o swap
> it.
>
> Looking at dmesg etc, I don't see an exact mapping between /dev/sdX a=
nd the
> ataXX.YY semantics. I can guess with high probability which drive thi=
s is, but
> I don't know for sure and I don't want to fail the wrong drive.
>
> Anybody know a sure way to find this mapping out? Been looking in /sy=
s etc,
> but no go so far...

No.  OTOH, the poor sysadmins version of the "disk identification light=
" is:

    sudo dd if=3D/dev/sdFAIL of=3D/dev/null

=2E..plus a pair of eyes.  FWIW.

        Daniel

--=20
=E2=9C=A3 Daniel Pittman            =E2=9C=89 daniel@rimspace.net      =
      =E2=98=8E +61 401 155 707
               =E2=99=BD made with 100 percent post-consumer electrons

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
