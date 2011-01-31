From: NeilBrown <neilb@suse.de>
Subject: Re: What's the typical RAID10 setup?
Date: Tue, 1 Feb 2011 10:10:10 +1100
Message-ID: <20110201101010.522361e4@notabene.brown>
References: <AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com>
	<AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com>
	<AANLkTi=mLFwdLzcjcpzC0JJ=v8Aa817g+CzrR88pmy9y@mail.gmail.com>
	<AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com>
	<AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com>
	<AANLkTim_uQ7AQs_ZSyeYPJPYSLCJd6ChzzTBwBNk2qA9@mail.gmail.com>
	<20110131192858.GD27952@www2.open-std.org>
	<4D4718E1.9040607@hardwarefreak.com>
	<20110131203725.GB2283@www2.open-std.org>
	<AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com>
	<AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com>
	<AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com>
	<AANLkTi=kUGc8bjisn69BEEkZr6kcHUyfKnVZzNtgaJf3@mail.gmail.com>
	<AANLkTikYGquOk9wwMuLxaDRvOe3-iJOMMW7JQKpdZBpk@mail.gmail.com>
	<20110201095030.65e2349b@notabene.brown>
	<AANLkTik-XjBpViq5ibeQMcBH7z6BpFXhyzHk1QcPxHTq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTik-XjBpViq5ibeQMcBH7z6BpFXhyzHk1QcPxHTq@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, Mathias =?ISO-8859-1?B?QnVy6W4=?= <mathias.buren@gmail.com>, Keld =?ISO-8859-1?B?Svhybg==?= Simonsen <keld@keldix.com>, Stan Hoeppner <stan@hardwarefreak.com>, Denis <denismpa@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 31 Jan 2011 20:53:07 -0200 Roberto Spadim <roberto@spadim.com.b=
r>
wrote:

> uhmmmmm write-behind is nice,
> raid0 have chunk size, don=B4t?

Yes, but we weren't discussing RAID0 (???)

NeilBrown

>=20
> 2011/1/31 NeilBrown <neilb@suse.de>:
> > On Mon, 31 Jan 2011 19:51:32 -0200 Roberto Spadim <roberto@spadim.c=
om.br>
> > wrote:
> >
> >> now, a question....
> >>
> >> if raid1 is like raid10 (one disk =3D raid0)
> >> why not only one raid1 (raid10) software implementation?
> >> for example, if i have 4 disks and i want 4 mirrors.
> >> why not work with only raid10? why the option since we have all
> >> features of raid1 inside raid10?
> >> is it to allow small source code (a small ARM rom)? memory usage? =
cpu
> >> usage? easy to implement?
> >
> > It is mostly "historical reasons".
> > RAID1 already existed. =A0When I wrote RAID10 I wanted to keep it s=
eparate so
> > as not to break RAID1. =A0I have never had a good reason to merge t=
he two
> > implementations.
> >
> > And RAID1 does have some functionality that RAID10 doesn't, like wr=
ite-behind.
> > Also RAID1 doesn't have a chunk size. =A0RAID10 does.
> >
> > NeilBrown
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
>=20
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
