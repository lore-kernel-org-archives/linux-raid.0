From: Krzysztof Adamski <k@adamski.org>
Subject: Re: Failed drive in raid6 while doing data-check
Date: Sun, 03 Jun 2012 14:38:07 -0400
Message-ID: <1338748687.28212.296.camel@oxygen.netxsys.com>
References: <1338744674.28212.293.camel@oxygen.netxsys.com>
	 <CA+sTkh5rvJpfgCd6HVJrziutW_z97CU3ueCW05CbKGo7JY8TTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sTkh5rvJpfgCd6HVJrziutW_z97CU3ueCW05CbKGo7JY8TTg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Igor M Podlesny <for.poige+lsr@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2012-06-04 at 02:32 +0800, Igor M Podlesny wrote:
> On 4 June 2012 01:31, Krzysztof Adamski <k@adamski.org> wrote:
> [=E2=80=A6]
> > The cat /proc/mdstat is:
> > Personalities : [raid1] [raid6] [raid5] [raid4]
> > md7 : active raid6 sdd2[0] sdab2[11] sdaa2[10] sdz2[9] sdy2[8] sde2=
[7] sdh2[6] sdf2[5] sdg2[4] sdb2[3](F) sdc2[2] sda2[1]
> >      29283121600 blocks super 1.2 level 6, 32k chunk, algorithm 2 [=
12/11] [UUU_UUUUUUUU]
> >      [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>.......]  check =3D 6=
5.3% (1913765076/2928312160) finish=3D44345.9min speed=3D381K/sec
> >      bitmap: 1/22 pages [4KB], 65536KB chunk
> >
> > I don't really want to wait 30 days for this to finish, what is cor=
rect
> > thing to do before I replace the failed drive?
>=20
>    Is stripe_cache_size reasonably adjusted?
>=20
I hope so.

# cat /sys/block/md7/md/stripe_cache_size
32768

# mdadm -E /dev/sdd2
/dev/sdd2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 3fe8cdcf:d7b1a55c:d8c07daa:c7c3021b
           Name : rogen:7  (local to host rogen)
  Creation Time : Thu Nov  3 13:31:13 2011
     Raid Level : raid6
   Raid Devices : 12

 Avail Dev Size : 5856624640 (2792.66 GiB 2998.59 GB)
     Array Size : 58566243200 (27926.56 GiB 29985.92 GB)
  Used Dev Size : 5856624320 (2792.66 GiB 2998.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 26f3ab68:62de305e:0720d287:ad4624a4

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Jun  3 12:43:57 2012
       Checksum : c6da765f - correct
         Events : 23610

         Layout : left-symmetric
     Chunk Size : 32K

   Device Role : Active device 0
   Array State : AAA.AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
