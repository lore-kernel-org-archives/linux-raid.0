From: Nix <nix@esperi.org.uk>
Subject: Re: [PATCH*2] mdadm works with uClibc from SVN
Date: Tue, 27 Jun 2006 10:40:44 +0100
Message-ID: <8764ingcmb.fsf@hades.wkstn.nix>
References: <87wtbbjxd4.fsf@hades.wkstn.nix>
	<17567.25412.387397.430549@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17567.25412.387397.430549@cse.unsw.edu.au> (Neil Brown's message of "26 Jun 2006 05:32:28 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 26 Jun 2006, Neil Brown said:
> On Tuesday June 20, nix@esperi.org.uk wrote:
>> For some time, mdadm's been dumping core on me in my uClibc-built
>> initramfs. As you might imagine this is somewhat frustrating, not le=
ast
>> since my root filesystem's in LVM on RAID. Half an hour ago I got ar=
ound
>> to debugging this.
>>=20
>> Imagine my surprise when I found that it was effectively guaranteed =
to
>> crash: map_dev() in util.c is stubbed out for uClibc builds, and
>> returns -1 at all times. That means that code in, among other places=
,
>> config.c:load_partitions() is guaranteed to segfault, which is a bit
>> tough if you're using the (sane) default `DEVICE partitions' in your
>> mdadm.conf.
>=20
> I'm confused.  map_dev doesn't return -1, it returns NULL.

Yes, that was a typo on my part.

> And the code in load_partitions() handles a NULL return.

Er, what?

The code in load_partitions() in mdadm 2.5.1 and below says

,----[ config.c:load_partitions() ]
| name =3D map_dev(major, minor, 1);
|=20
| d =3D malloc(sizeof(*d));
| d->devname =3D strdup(name);
`----

So if map_dev() returns NULL, we do a strdup(NULL) -> crash inside
uClibc.

> So I cannot see why it would be core dumping.
> If you have more details, I'd be really interested.

Backtrace (against uClibc compiled with debugging symbols, tested
against a temporary RAID array on a loopback device):

(gdb) run
Starting program: /usr/packages/mdadm/i686-loki/mdadm.uclibc --assemble=
 --uuid=3D572aeae1:532641bf:49c9aec5:6036454d /dev/md127

Program received signal SIGSEGV, Segmentation fault.
0x080622f8 in strlen (s=3D0x0) at libc/string/i386/strlen.c:40
40      libc/string/i386/strlen.c: No such file or directory.
        in libc/string/i386/strlen.c
(gdb) bt
#0  0x080622f8 in strlen (s=3D0x0) at libc/string/i386/strlen.c:40
#1  0x08062d1d in strdup (s1=3D0x0) at libc/string/strdup.c:30
#2  0x0804b0df in load_partitions () at config.c:247
#3  0x0804b77c in conf_get_devs (conffile=3D0x0) at config.c:715
#4  0x0804d685 in Assemble (st=3D0x0, mddev=3D0xbf9c753e "/dev/md127", =
mdfd=3D6, ident=3D0xbf9c630c, conffile=3D0x0, devlist=3D0x0, backup_fil=
e=3D0x0, readonly=3D0, runstop=3D0, update=3D0x0, homehost=3D0x0,
    verbose=3D0, force=3D0) at Assemble.c:184
#5  0x08049d62 in main (argc=3D4, argv=3D0xbf9c6514) at mdadm.c:958
(gdb) frame 2
#2  0x0804b0df in load_partitions () at config.c:247
247                     d->devname =3D strdup(name);
(gdb) info locals
name =3D 0x0
mp =3D 0xbf9c5a34 "     0    9873360 hda\n"
f =3D (FILE *) 0x807b018
buf =3D "   3     0    9873360 hda\n", '\0' <repeats 546 times>, "1\000=
\000\000\000\000((=FF=FF=FF\177\021", '\0' <repeats 15 times>, "\021\00=
0\000\000\231\231\231\031Z]\234=BF\000\000(\005=FF=FF=FF\177=BC\\\234=BF=
=D3U\006\bZ]\234=BF\000\000\000\000\n", '\0' <repeats 15 times>, "d^\23=
4=BF=CF=C8\004\bX]\234=BF\000\000\000\000\n\000\000\000\000\000Linux", =
'\0' <repeats 60 times>, "loki\000)", '\0' <repeats 43 times>, "\006", =
'\0' <repeats 15 times>, "2.6.17-s\000\000\000\000=E0]\234=BF=DF=C9\005=
\b|]\234=BF=F0]\234=BF", '\0' <repeats 12 times>...
rv =3D (mddev_dev_t) 0x0


I hope the bug's more obvious now :)

> That said: utils doesn't handle the case for 'ftw not available' as
> well as it could.  I will fix that.

The __UCLIBC_HAS_FTW__ macro in <features.h> is the right way to do tha=
t
for uClibc, as Luca noted.

--=20
`NB: Anyone suggesting that we should say "Tibibytes" instead of
 Terabytes there will be hunted down and brutally slain.
 That is all.' --- Matthew Wilcox
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
