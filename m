From: Jean-Rene Cormier <jean-rene.cormier@cipanb.ca>
Subject: Re: mkraid segfault
Date: 10 Feb 2003 19:40:29 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1044920450.249.9.camel@forbidden>
References: <1044900385.23029.9.camel@localhost.localdomain>
	<3E48002A.1040901@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E48002A.1040901@mvista.com>
To: Steven Dake <sdake@mvista.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is the output I get with GDB:

(gdb) file mkraid
Reading symbols from mkraid...done.
(gdb) run /dev/md0
Starting program: /usr/src/raidtools-1.00.3/mkraid /dev/md0
handling MD device /dev/md0
analyzing super-block
disk 0: /dev/hde1, 60051568kB, raid superblock at 60051456kB

Program received signal SIGSEGV, Segmentation fault.
*__GI_fgets_unlocked (buf=3D0x8059638 "\f$=AD=FB", n=3D4096, fp=3D0x0) =
at
iofgets_u.c:46
46        old_error =3D fp->_IO_file_flags & _IO_ERR_SEEN;
(gdb) where
#0  *__GI_fgets_unlocked (buf=3D0x8059638 "\f$=AD=FB", n=3D4096, fp=3D0=
x0)
    at iofgets_u.c:46
#1  0x400ebb0a in __getmntent_r (stream=3D0x0, mp=3D0x40140dfc,
    buffer=3D0x8059638 "\f$=AD=FB", bufsiz=3D4096) at mntent_r.c:116
#2  0x400eb99e in getmntent (stream=3D0x0) at mntent.c:53
#3  0x0804ba8e in sanity_checks ()
#4  0x0804bfb4 in analyze_sb ()
#5  0x08049229 in makeOneRaid ()
#6  0x08049957 in main ()
#7  0x4002deca in __libc_start_main (main=3D0x80492c0 <main>, argc=3D2,
    ubp_av=3D0xbffffdd4, init=3D0x8048cf0 <_init>, fini=3D0x400143c0
<_rtld_local>,
    rtld_fini=3D0, stack_end=3D0x1000) at
=2E./sysdeps/generic/libc-start.c:144

Anybody knows what all this means? :)

Jean-Rene Cormier

On Mon, 2003-02-10 at 15:40, Steven Dake wrote:
> compile with the -g flag, run gdb a.out
> and type "where" and give the output to the list
>=20
> Thanks
> -steve
>=20
> Jean-Rene Cormier wrote:
>=20
> >I just compiled the raid-tools 1.00.3 on my Linux 2.4.20 box with Gl=
ibc
> >3.2.1. I created the partitions on my 2 HDs with a FD type and when =
I
> >try to do a mkraid /dev/md0 I get a segfault. Anybody had this probl=
em
> >before?
> >
> >Thanks
> >
> >Jean-Rene Cormier
> >
> >
> >
> >-
> >To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> >
> > =20
> >
>=20


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
