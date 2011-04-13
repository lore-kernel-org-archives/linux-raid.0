From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: expand raid10
Date: Wed, 13 Apr 2011 13:10:16 +0200
Message-ID: <20110413111015.GA10195@www2.open-std.org>
References: <BANLkTimFwM0m3jT4mg8ZL4VvSXkbi4pU6g@mail.gmail.com> <BANLkTimqdD39TgbghGi3hK4b1gh1FmcmdQ@mail.gmail.com> <BANLkTi=udXzNJwK9CKtK1QEqK1PznSp_2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BANLkTi=udXzNJwK9CKtK1QEqK1PznSp_2g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Mathias =?iso-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Apr 13, 2011 at 07:47:26AM -0300, Roberto Spadim wrote:
> raid10 with other layout i could expand?

My understanding is that you currently cannot expand raid10.
but there are things in the works. Expansion of raid10,far
was not on the list from neil, raid10,near was. But it should be fairly
easy to expand raid10,far. You can just treat one of the copies as your
refence data, and copy that data to the other raid0-like parts of the
array.  I wonder if Neil thinks he could leave that as an exersize for
me to implement... I would like  to be able to combine it with a
reformat to a more robust layout of raid10,far that in some cases can s=
urvive more
than one disk failure.

best regards
keld


> 2011/4/13 Mathias Bur=E9n <mathias.buren@gmail.com>:
> > On 13 April 2011 05:28, Roberto Spadim <roberto@spadim.com.br> wrot=
e:
> >> hi guys, today i have 2 disks raid10 far, with 2tb each disk/array
> >> i want to expand it to 4 disks raid10 far, with 2tb each disk and =
4tb array
> >> in other words, i will put more 2 disks of 2tb and i want more 2tb=
 of space
> >>
> >> could i do this with raid10 far layout? i?m using ext4 at filesyst=
em
> >> how could i expand ext4 filesystem?
> >>
> >> --
> >> Roberto Spadim
> >> Spadim Technology / SPAEmpresarial
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
> >>
> >
> > No, you cannot expand RAID0.
> >
> > // M
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
> --=20
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
