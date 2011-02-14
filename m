From: Andras Korn <korn@raidlist.elan.rulez.org>
Subject: Re: write-behind has no measurable effect?
Date: Tue, 15 Feb 2011 00:03:22 +0100
Message-ID: <20110214230321.GH836@hellgate.intra.guy>
References: <20110214213817.GG836@hellgate.intra.guy>
 <AANLkTi=fte1B=D_8=KrEf9_dVT5gAEPTy-uw1Duz_ECB@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTi=fte1B=D_8=KrEf9_dVT5gAEPTy-uw1Duz_ECB@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 14, 2011 at 02:56:37PM -0800, Doug Dumitru wrote:

> Not to be too cute, but the man page for mdadm says that
> --write-behind is only attempted on drives marked --write-mostly.=A0 =
I
> did not see a --write-mostly in your array create statement.

Yeah, I abbreviated it as -W:

> > mdadm --create /dev/md/ssdraid --force --assume-clean --level=3D1 \
> > --raid-devices=3D3 --bitmap=3Dinternal --bitmap-chunk=3D262144 \
> > /dev/sdo2 --write-behind=3D16383 -W /dev/sd[nm]2

> Also, are you trying to create a three-way-mirror or mirror the one

A three-way mirror.

--=20
                     Andras Korn <korn at elan.rulez.org>
                     Caesar si viveret, ad remum dareris.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
