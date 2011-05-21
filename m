From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: mdadm git, -Werror=unused-but-set-variable
Date: Sat, 21 May 2011 13:32:02 +0100
Message-ID: <BANLkTim6c6dPCE+JY=rpQDTHL37X4T5Ceg@mail.gmail.com>
References: <BANLkTinf5OaDXN5KMrdP5ZOCADS=zXRwnQ@mail.gmail.com>
	<20110521222718.55ac4bae@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110521222718.55ac4bae@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 21 May 2011 13:27, NeilBrown <neilb@suse.de> wrote:
> On Sat, 21 May 2011 11:20:01 +0100 Mathias Bur=C3=A9n <mathias.buren@=
gmail.com>
> wrote:
>
>> The git as of today "fails" to compile on my Archlinux system:
>>
>> =3D=3D> Starting build()...
>> =3D=3D> Fetching sources...
>> Cloning into ./mdadm...
>> remote: Counting objects: 9107, done.
>> remote: Compressing objects: 100% (6096/6096), done.
>> remote: Total 9107 (delta 6874), reused 3903 (delta 3004)
>> Receiving objects: 100% (9107/9107), 2.46 MiB | 12 KiB/s, done.
>> Resolving deltas: 100% (6874/6874), done.
>> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
>> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
>> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.co=
nf\"
>> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
>> -DMDMON_DIR=3D\"/dev/.mdadm\"
>> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS =C2=
=A0 -c -o
>> mdadm.o mdadm.c
>> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
>> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
>> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.co=
nf\"
>> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
>> -DMDMON_DIR=3D\"/dev/.mdadm\"
>> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS =C2=
=A0 -c -o
>> config.o config.c
>> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
>> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
>> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.co=
nf\"
>> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
>> -DMDMON_DIR=3D\"/dev/.mdadm\"
>> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS =C2=
=A0 -c -o
>> policy.o policy.c
>> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
>> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
>> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.co=
nf\"
>> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
>> -DMDMON_DIR=3D\"/dev/.mdadm\"
>> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS =C2=
=A0 -c -o
>> mdstat.o mdstat.c
>> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
>> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
>> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.co=
nf\"
>> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
>> -DMDMON_DIR=3D\"/dev/.mdadm\"
>> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS =C2=
=A0 -c -o
>> ReadMe.o ReadMe.c
>> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
>> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
>> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.co=
nf\"
>> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
>> -DMDMON_DIR=3D\"/dev/.mdadm\"
>> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS =C2=
=A0 -c -o
>> util.o util.c
>> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
>> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
>> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.co=
nf\"
>> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
>> -DMDMON_DIR=3D\"/dev/.mdadm\"
>> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS =C2=
=A0 -c -o
>> maps.o maps.c
>> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
>> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
>> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.co=
nf\"
>> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
>> -DMDMON_DIR=3D\"/dev/.mdadm\"
>> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS =C2=
=A0 -c -o
>> lib.o lib.c
>> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
>> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
>> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.co=
nf\"
>> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
>> -DMDMON_DIR=3D\"/dev/.mdadm\"
>> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS =C2=
=A0 -c -o
>> Manage.o Manage.c
>> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
>> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
>> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.co=
nf\"
>> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
>> -DMDMON_DIR=3D\"/dev/.mdadm\"
>> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS =C2=
=A0 -c -o
>> Assemble.o Assemble.c
>> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
>> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
>> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.co=
nf\"
>> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
>> -DMDMON_DIR=3D\"/dev/.mdadm\"
>> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS =C2=
=A0 -c -o
>> Build.o Build.c
>> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
>> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
>> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.co=
nf\"
>> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
>> -DMDMON_DIR=3D\"/dev/.mdadm\"
>> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS =C2=
=A0 -c -o
>> Create.o Create.c
>> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
>> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
>> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.co=
nf\"
>> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
>> -DMDMON_DIR=3D\"/dev/.mdadm\"
>> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS =C2=
=A0 -c -o
>> Detail.o Detail.c
>> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
>> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
>> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.co=
nf\"
>> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
>> -DMDMON_DIR=3D\"/dev/.mdadm\"
>> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS =C2=
=A0 -c -o
>> Examine.o Examine.c
>> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
>> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
>> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.co=
nf\"
>> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
>> -DMDMON_DIR=3D\"/dev/.mdadm\"
>> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS =C2=
=A0 -c -o
>> Grow.o Grow.c
>> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
>> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
>> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.co=
nf\"
>> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
>> -DMDMON_DIR=3D\"/dev/.mdadm\"
>> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS =C2=
=A0 -c -o
>> Monitor.o Monitor.c
>> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
>> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
>> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.co=
nf\"
>> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
>> -DMDMON_DIR=3D\"/dev/.mdadm\"
>> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS =C2=
=A0 -c -o
>> dlink.o dlink.c
>> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
>> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
>> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.co=
nf\"
>> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
>> -DMDMON_DIR=3D\"/dev/.mdadm\"
>> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS =C2=
=A0 -c -o
>> Kill.o Kill.c
>> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
>> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
>> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.co=
nf\"
>> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
>> -DMDMON_DIR=3D\"/dev/.mdadm\"
>> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS =C2=
=A0 -c -o
>> Query.o Query.c
>> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
>> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
>> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.co=
nf\"
>> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
>> -DMDMON_DIR=3D\"/dev/.mdadm\"
>> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS =C2=
=A0 -c -o
>> Incremental.o Incremental.c
>> Query.c: In function =E2=80=98Query=E2=80=99:
>> Query.c:38:16: error: variable =E2=80=98superrno=E2=80=99 set but no=
t used
>> [-Werror=3Dunused-but-set-variable]
>> cc1: all warnings being treated as errors
>>
>> make: *** [Query.o] Error 1
>> make: *** Waiting for unfinished jobs....
>> =3D=3D> ERROR: A failure occurred in build().
>> =C2=A0 =C2=A0 Aborting...
>>
>> This with gcc 4.6.0.
>>
>> Regards,
>> /M
>
> Thanks for the report.
> This patch will go in in the near future.
> (The variable has been unused since 2005 !!!)
>
> Thanks,
> NeilBrown
>
> diff --git a/Query.c b/Query.c
> index f9857d6..0b15e28 100644
> --- a/Query.c
> +++ b/Query.c
> @@ -35,7 +35,7 @@ int Query(char *dev)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int fd =3D open(dev, O_RDONLY);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int vers;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int ioctlerr;
> - =C2=A0 =C2=A0 =C2=A0 int superror, superrno;
> + =C2=A0 =C2=A0 =C2=A0 int superror;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct mdinfo info;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0mdu_array_info_t array;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct supertype *st =3D NULL;
> @@ -82,10 +82,9 @@ int Query(char *dev)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 array.spare_disks, array.spare_disks=3D=3D1?"":"s");
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0st =3D guess_super(fd);
> - =C2=A0 =C2=A0 =C2=A0 if (st) {
> + =C2=A0 =C2=A0 =C2=A0 if (st)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0superror =3D s=
t->ss->load_super(st, fd, dev);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 superrno =3D errno=
;
> - =C2=A0 =C2=A0 =C2=A0 } else
> + =C2=A0 =C2=A0 =C2=A0 else
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0superror =3D -=
1;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0close(fd);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (superror =3D=3D 0) {
>

2005, hah! Thanks :)

/M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
