From: Frank van Maarseveen <frankvm@xs4all.nl>
Subject: Re: RAID 5 questions
Date: Tue, 3 Aug 2004 22:23:34 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040803202334.GB5148@janus>
References: <1091325475.2374.11.camel@localhost> <20040801033109.GA23032@jim.sh> <410DD8AA.6060609@softers.net> <20040802060939.GA12472@jim.sh> <410DECC6.6040403@softers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <410DECC6.6040403@softers.net>
To: Jarmo =?iso-8859-15?B?SuRydmVucOTk?= <Jarmo.Jarvenpaa@softers.net>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Aug 02, 2004 at 10:27:02AM +0300, Jarmo J=E4rvenp=E4=E4 wrote:
> Jim Paris wrote:
>=20
> >README.raid from lilo-22.5.9 (the latest version) states:
> >
> >"Only RAID1 is supported.  LILO may be used to boot a system

yep. and even that may go wrong.

> Hmm, I'm not sure how to convince you :-)

try running lilo with -v -v -v

Then you might see the BIOS drive number, geometry it assumes etc. You
will probably see only _one_ disk and in that case your system boots
by sheer luck.

With -v -v -v I discovered why my system refused to boot from raid 1.
It appears to actually boot from the first disk in the raid set, e.g:

	md1 : active raid1 hdg1[1] hda1[0]
				   ^^^^^^^

This is mounted on /boot and lilo will boot from hda1 (bios disk 0x80).
I had to reassemble the raid set in opposite order to get this because
hdg is unbootable (lilo assumed bios drive 0x81). But maybe my lilo is
old (21.4-4).

--=20
=46rank
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
