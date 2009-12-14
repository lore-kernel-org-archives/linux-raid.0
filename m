From: Neil Brown <neilb@suse.de>
Subject: Re: [GIT PATCH 0/2] external-metadata recovery checkpointing for
 2.6.33
Date: Mon, 14 Dec 2009 16:35:02 +1100
Message-ID: <20091214163502.5336f303@notabene.brown>
References: <20091213041123.12532.15225.stgit@dwillia2-linux.ch.intel.com>
	<20091214150725.49de72f1@notabene.brown>
	<e9c3a7c20912132049g6034fbc6vf86a7bcbc323746a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20912132049g6034fbc6vf86a7bcbc323746a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: ed.ciechanowski@intel.com, marcin.labun@intel.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 13 Dec 2009 21:49:07 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> > +static ssize_t recovery_start_store(mdk_rdev_t *rdev, const char *=
buf, size_t len)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 unsigned long long recovery_start;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 if (cmd_match(buf, "none"))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 recovery_start =3D=
 MaxSector; =20
>=20
> Should probably do the same for resync_start to be consistent?

Good idea, thanks.

I've resubmitted the pull request for all the 2.6.33 patches.

Thanks,
NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
