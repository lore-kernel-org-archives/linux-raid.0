From: Luzipher McLeod <luziphermcleod@yahoo.ie>
Subject: Re: [dm-crypt] Kernel BUG (fs/bio.c:1499) when copying more files to an encrypted device
Date: Tue, 31 Jan 2012 23:26:05 +0000 (GMT)
Message-ID: <1328052365.7861.YahooMailClassic@web24101.mail.ird.yahoo.com>
References: <1327884369.77187.YahooMailClassic@web24106.mail.ird.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1327884369.77187.YahooMailClassic@web24106.mail.ird.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: dm-crypt@saout.de, Mandeep Singh Baines <msb@chromium.org>
List-Id: linux-raid.ids

Hi list,

I just wanted to know if there is interest in solving this bug (see bel=
ow). I'd need some help with creating a working patch for bio_multi_spl=
it, so I could test if it solves my problem.
If nobody has any further suggestions, I'll just use lvm instead of lin=
ear, as it's a temporary backup anyway.

Thanks and regards,
Luzipher



--- On Mon, 30/1/12, Luzipher McLeod <luziphermcleod@yahoo.ie> wrote:

> From: Luzipher McLeod <luziphermcleod@yahoo.ie>
> Subject: Re: [dm-crypt] Kernel BUG (fs/bio.c:1499) when copying more =
files to an encrypted device
> To: "Mandeep Singh Baines" <msb@chromium.org>
> Cc: dm-crypt@saout.de, linux-raid@vger.kernel.org
> Date: Monday, 30 January, 2012, 0:46
> Hi Mandeep,
>=20
> sorry for the long delay, I couldn't get around to try this
> earlier.
> I did as you suggested and copied the bio_multi_split
> function into bio.c, and added its signature to bio.h (as
> done by the original patch by Neil Brown). Then I replaced
> the call to bio_split with bio_multi_split in
> linear_make_request.
> Unfortunately I fail with the forward-porting. Compilation
> results in:
>=20
> fs/bio.c: In function 'bio_multi_split':
> fs/bio.c:1585:23: error: 'struct bio' has no member named
> 'bi_iocnt'
> fs/bio.c:1591:8: error: 'struct bio' has no member named
> 'bi_offset'
> fs/bio.c:1592:15: error: 'struct bio' has no member named
> 'bi_offset'
> fs/bio.c:1593:5: error: 'struct bio' has no member named
> 'bi_offset'
> fs/bio.c:1598:12: error: 'struct bio' has no member named
> 'bi_offset'
> make[1]: *** [fs/bio.o] Error 1
> make: *** [fs] Error 2
>=20
> Further examination reveals, that 'struct bio', as defined
> in blk_types.h really doesn't have those members anymore and
> I can't determine an easy replacement for those. The whole
> original patch also doesn't touch 'struct bio', so I'm at a
> loss what to do.
>=20
> Thanks for any pointers or hints how to resolve this !
>=20
> Regards,
> Luzipher
>=20
>=20
>=20
>=20
> --- On Wed, 25/1/12, Mandeep Singh Baines <msb@chromium.org>
> wrote:
>=20
> > From: Mandeep Singh Baines <msb@chromium.org>
> > Subject: Re: [dm-crypt] Kernel BUG (fs/bio.c:1499) when
> copying more files to an encrypted device
> > To: "Mandeep Singh Baines" <msb@chromium.org>
> > Cc: "Luzipher McLeod" <luziphermcleod@yahoo.ie>,
> dm-crypt@saout.de,
> linux-raid@vger.kernel.org
> > Date: Wednesday, 25 January, 2012, 23:46
> > +cc linux-raid
> >=20
> > Mandeep Singh Baines (msb@chromium.org)
> > wrote:
> > > Luzipher McLeod (luziphermcleod@yahoo.ie)
> > wrote:
> > > > Hi Mandeep,
> > > >=20
> > > > Thanks fpr your quick answer. So, what can be
> done
> > about this ? Should I try to apply that patch you
> linked to
> > ? (but I guess a patch from 2007 won't apply cleanly
> ...)
> > > >=20
> > >=20
> > > Hi Luzipher,
> > >=20
> > > I wouldn't apply the patch directly. Just copy
> > bio_multi_split (might
> > > need to do some forward porting) and then modify
> > linear_make_request to
> > > use bio_multi_split instead of bio_split.
> > >=20
> > > But I'm not really an expert on this particular
> code.
> > I'm hoping someone
> > > else will confirm that this is in fact the bug and
> not
> > a side effect of
> > > something else. Its seem reasonble that you could
> get a
> > bio that is
> > > multi-page and falls on a boundary (spans two or
> more
> > devices). So I
> > > suspect this is the bug.
> > >=20
> > > Regards,
> > > Mandeep
> > >=20
> > > > Regards,
> > > > Luzipher
> > > >=20
> > > >=20
> > > >=20
> > > > --- On Wed, 25/1/12, Mandeep Singh Baines
> <msb@chromium.org>
> > wrote:
> > > >=20
> > > > > From: Mandeep Singh Baines <msb@chromium.org>
> > > > > Subject: Re: [dm-crypt] Kernel BUG
> > (fs/bio.c:1499) when copying more files to an
> encrypted
> > device
> > > > > To: "Luzipher McLeod" <luziphermcleod@yahoo.ie>
> > > > > Cc: dm-crypt@saout.de,
> > "NeilBrown" <neilb@suse.de>
> > > > > Date: Wednesday, 25 January, 2012, 2:14
> > > > > Luzipher McLeod (luziphermcleod@yahoo.ie)
> > > > > wrote:
> > > > > > Hi :-)
> > > > > >=20
> > > > > > A few days ago I encountered a
> kernel
> > bug while copying
> > > > > files to an encrypted filesystem. The
> > specific stack for the
> > > > > filesystem is:
> btrfs-on-crypt-on-mdraid.
> > Vasts amounts of
> > > > > data copied without problems (about
> 6.3TB
> > with 1.1 TB
> > > > > remaining), but when copying a certain
> > directory, the kernel
> > > > > bug surfaces. I repeatedly deleted the
> > affected directory
> > > > > and tried to re-copy it, but it always
> fails
> > at the same
> > > > > point (or close to that). More recent
> test
> > showed that I
> > > > > could copy a few more files to the
> filesystem
> > to a different
> > > > > directory, but it very quickly failed
> there
> > as well (a few
> > > > > megabytes later).
> > > > > > After talking to the btrfs devs on
> > freenode (as btrfs
> > > > > is the most experimental thing in the
> stack,
> > they came to
> > > > > the conclusion that it's most probably
> the
> > crypto layer.
> > > > > >=20
> > > > > > Some details:
> > > > > > gentoo kernel 3.2.1 (custom config
> and
> > ubuntu config)
> > > > > > mdraid: linear, 4 disks, each 2TB
> (total
> > 8TB)
> > > > > > crypt: setup via cryptsetup -c
> > aes-xts-plain64 -h plain
> > > > > -s 512 -d - create tempraid
> > /dev/md/tempraid_lin
> > > > > >=20
> > > > > > I'd appreciate any help with this
> and
> > would be happy to
> > > > > test patches or provide more debug
> info.
> > > > > >=20
> > > > > > Thanks and Regards,
> > > > > > Luzipher
> > > > > >=20
> > > > > >=20
> > > > > >=20
> > > > > >=20
> > > > > > The kernel bug output retrieved by
> > netconsole (also at
> > > > > http://pastebin.com/sjJy7QE4 ):
> > > > > >=A0 =A0=A0=A0[=A0 294.538422]
> netconsole:
> > > > > local port 6666
> > > > > >=A0 =A0=A0=A0[=A0 333.423583] SysRq :
> > > > > Changing Loglevel
> > > > > >=A0 =A0=A0=A0[=A0 333.423609] Loglevel
> > > > > set to 9
> > > > > >=A0 =A0=A0=A0[=A0 424.248405]
> > > > > ------------[ cut here ]------------
> > > > > >=A0 =A0=A0=A0[=A0 424.248447] kernel BUG
> > > > > at fs/bio.c:1499!
> > > > >=20
> > > > > Hi Luzipher,
> > > > >=20
> > > > > Looks like the BUG is because bio_split
> only
> > works on
> > > > > single-page iovecs.
> > > > >=20
> > > > > I see a relevant (old) patch from Neil
> Brown
> > here:
> > > > >=20
> > > > > https://lkml.org/lkml/2007/7/30/496
> > > > >=20
> > > > > Regards,
> > > > > Mandeep
> > > > >=20
> > > >=20
> >=20
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
