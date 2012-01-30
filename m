From: Luzipher McLeod <luziphermcleod-CVfgzVlYcRg@public.gmane.org>
Subject: Re: Kernel BUG (fs/bio.c:1499) when copying more files
	to an encrypted device
Date: Mon, 30 Jan 2012 00:46:09 +0000 (GMT)
Message-ID: <1327884369.77187.YahooMailClassic@web24106.mail.ird.yahoo.com>
References: <20120125234612.GM4656@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org>
In-Reply-To: <20120125234612.GM4656-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://www.saout.de/mailman/options/dm-crypt>,
 <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.saout.de/pipermail/dm-crypt>
List-Post: <mailto:dm-crypt-4q3lyFh4P1g@public.gmane.org>
List-Help: <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=help>
List-Subscribe: <http://www.saout.de/mailman/listinfo/dm-crypt>,
 <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=subscribe>
Errors-To: dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org
Sender: dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org
To: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: dm-crypt-4q3lyFh4P1g@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

Hi Mandeep,

sorry for the long delay, I couldn't get around to try this earlier.
I did as you suggested and copied the bio_multi_split function into bio.c, =
and added its signature to bio.h (as done by the original patch by Neil Bro=
wn). Then I replaced the call to bio_split with bio_multi_split in linear_m=
ake_request.
Unfortunately I fail with the forward-porting. Compilation results in:

fs/bio.c: In function 'bio_multi_split':
fs/bio.c:1585:23: error: 'struct bio' has no member named 'bi_iocnt'
fs/bio.c:1591:8: error: 'struct bio' has no member named 'bi_offset'
fs/bio.c:1592:15: error: 'struct bio' has no member named 'bi_offset'
fs/bio.c:1593:5: error: 'struct bio' has no member named 'bi_offset'
fs/bio.c:1598:12: error: 'struct bio' has no member named 'bi_offset'
make[1]: *** [fs/bio.o] Error 1
make: *** [fs] Error 2

Further examination reveals, that 'struct bio', as defined in blk_types.h r=
eally doesn't have those members anymore and I can't determine an easy repl=
acement for those. The whole original patch also doesn't touch 'struct bio'=
, so I'm at a loss what to do.

Thanks for any pointers or hints how to resolve this !

Regards,
Luzipher




--- On Wed, 25/1/12, Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:

> From: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Subject: Re: [dm-crypt] Kernel BUG (fs/bio.c:1499) when copying more file=
s to an encrypted device
> To: "Mandeep Singh Baines" <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Cc: "Luzipher McLeod" <luziphermcleod-CVfgzVlYcRg@public.gmane.org>, dm-crypt-4q3lyFh4P1g@public.gmane.org, linux=
-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Date: Wednesday, 25 January, 2012, 23:46
> +cc linux-raid
> =

> Mandeep Singh Baines (msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org)
> wrote:
> > Luzipher McLeod (luziphermcleod-CVfgzVlYcRg@public.gmane.org)
> wrote:
> > > Hi Mandeep,
> > > =

> > > Thanks fpr your quick answer. So, what can be done
> about this ? Should I try to apply that patch you linked to
> ? (but I guess a patch from 2007 won't apply cleanly ...)
> > > =

> > =

> > Hi Luzipher,
> > =

> > I wouldn't apply the patch directly. Just copy
> bio_multi_split (might
> > need to do some forward porting) and then modify
> linear_make_request to
> > use bio_multi_split instead of bio_split.
> > =

> > But I'm not really an expert on this particular code.
> I'm hoping someone
> > else will confirm that this is in fact the bug and not
> a side effect of
> > something else. Its seem reasonble that you could get a
> bio that is
> > multi-page and falls on a boundary (spans two or more
> devices). So I
> > suspect this is the bug.
> > =

> > Regards,
> > Mandeep
> > =

> > > Regards,
> > > Luzipher
> > > =

> > > =

> > > =

> > > --- On Wed, 25/1/12, Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> wrote:
> > > =

> > > > From: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> > > > Subject: Re: [dm-crypt] Kernel BUG
> (fs/bio.c:1499) when copying more files to an encrypted
> device
> > > > To: "Luzipher McLeod" <luziphermcleod-CVfgzVlYcRg@public.gmane.org>
> > > > Cc: dm-crypt-4q3lyFh4P1g@public.gmane.org,
> "NeilBrown" <neilb-l3A5Bk7waGM@public.gmane.org>
> > > > Date: Wednesday, 25 January, 2012, 2:14
> > > > Luzipher McLeod (luziphermcleod-CVfgzVlYcRg@public.gmane.org)
> > > > wrote:
> > > > > Hi :-)
> > > > > =

> > > > > A few days ago I encountered a kernel
> bug while copying
> > > > files to an encrypted filesystem. The
> specific stack for the
> > > > filesystem is: btrfs-on-crypt-on-mdraid.
> Vasts amounts of
> > > > data copied without problems (about 6.3TB
> with 1.1 TB
> > > > remaining), but when copying a certain
> directory, the kernel
> > > > bug surfaces. I repeatedly deleted the
> affected directory
> > > > and tried to re-copy it, but it always fails
> at the same
> > > > point (or close to that). More recent test
> showed that I
> > > > could copy a few more files to the filesystem
> to a different
> > > > directory, but it very quickly failed there
> as well (a few
> > > > megabytes later).
> > > > > After talking to the btrfs devs on
> freenode (as btrfs
> > > > is the most experimental thing in the stack,
> they came to
> > > > the conclusion that it's most probably the
> crypto layer.
> > > > > =

> > > > > Some details:
> > > > > gentoo kernel 3.2.1 (custom config and
> ubuntu config)
> > > > > mdraid: linear, 4 disks, each 2TB (total
> 8TB)
> > > > > crypt: setup via cryptsetup -c
> aes-xts-plain64 -h plain
> > > > -s 512 -d - create tempraid
> /dev/md/tempraid_lin
> > > > > =

> > > > > I'd appreciate any help with this and
> would be happy to
> > > > test patches or provide more debug info.
> > > > > =

> > > > > Thanks and Regards,
> > > > > Luzipher
> > > > > =

> > > > > =

> > > > > =

> > > > > =

> > > > > The kernel bug output retrieved by
> netconsole (also at
> > > > http://pastebin.com/sjJy7QE4 ):
> > > > >=A0 =A0=A0=A0[=A0 294.538422] netconsole:
> > > > local port 6666
> > > > >=A0 =A0=A0=A0[=A0 333.423583] SysRq :
> > > > Changing Loglevel
> > > > >=A0 =A0=A0=A0[=A0 333.423609] Loglevel
> > > > set to 9
> > > > >=A0 =A0=A0=A0[=A0 424.248405]
> > > > ------------[ cut here ]------------
> > > > >=A0 =A0=A0=A0[=A0 424.248447] kernel BUG
> > > > at fs/bio.c:1499!
> > > > =

> > > > Hi Luzipher,
> > > > =

> > > > Looks like the BUG is because bio_split only
> works on
> > > > single-page iovecs.
> > > > =

> > > > I see a relevant (old) patch from Neil Brown
> here:
> > > > =

> > > > https://lkml.org/lkml/2007/7/30/496
> > > > =

> > > > Regards,
> > > > Mandeep
> > > > =

> > > =

> =

_______________________________________________
dm-crypt mailing list
dm-crypt-4q3lyFh4P1g@public.gmane.org
http://www.saout.de/mailman/listinfo/dm-crypt
