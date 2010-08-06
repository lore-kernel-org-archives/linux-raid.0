From: Neil Brown <neilb@suse.de>
Subject: Re: ANNOUNCE: mdadm 3.1.3 - A tool for managing Soft RAID under
 Linux
Date: Fri, 6 Aug 2010 20:02:34 +1000
Message-ID: <20100806200234.79818035@notabene>
References: <19547.45749.153826.476559@notabene.brown>
	<alpine.DEB.1.10.1008060906060.19930@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1008060906060.19930@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 6 Aug 2010 09:08:03 +0200 (CEST)
Mikael Abrahamsson <swmike@swm.pp.se> wrote:

> On Fri, 6 Aug 2010, Neil Brown wrote:
>=20
> >
> > I am pleased to announce the availability of
> >   mdadm version 3.1.3
>=20
> I get the following compile error:
>=20
> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -=
ggdb=20
> -DSendmail=3D\""/usr/sbin/sendmail -t"\" -DCONFFILE=3D\"/etc/mdadm.co=
nf\"=20
> -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\" -DMAP_DIR=3D\"/dev/.mdadm\"=20
> -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/dev/.mdadm\" -DUSE_PTHREADS   -=
c -o=20
> super-intel.o super-intel.c
> cc1: warnings being treated as errors
> super-intel.c: In function =E2=80=98imsm_process_update=E2=80=99:
> super-intel.c:5393: error: format not a string literal and no format =
arguments
> super-intel.c:5393: error: format not a string literal and no format =
arguments
> make: *** [super-intel.o] Error 1
>=20
> This is on a ubuntu 10.04 system with their 2.6.32 kernel.
>=20
> mdadm-3.1.2 compiles fine on the same system.
>=20

Thanks for the report - I guess you have a newer compiler than me.

Below patch should fix it, or just
    make CWFLAGS=3D
as the code will still do the right thing.

NeilBrown

diff --git a/super-intel.c b/super-intel.c
index 4cebc8d..b880a74 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5390,7 +5390,7 @@ static void imsm_process_update(struct supertype =
*st,
 			break;
 		}
=20
-		snprintf((char *) dev->volume, MAX_RAID_SERIAL_LEN, name);
+		snprintf((char *) dev->volume, MAX_RAID_SERIAL_LEN, "%s", name);
 		super->updates_pending++;
 		break;
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
