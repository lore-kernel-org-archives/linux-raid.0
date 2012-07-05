From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: [patch 2/3 v4]raid1: read balance chooses idlest disk for SSD
Date: Thu, 5 Jul 2012 10:04:48 -0300
Message-ID: <CABYL=TqgOmuL4JLT1-pmUWgeVHH+veuNB4K5BSW5=zW0iL6C_Q@mail.gmail.com>
References: <20120705092057.GB27956@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120705092057.GB27956@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

nice, just another question...
 since this use mixed raid disks (different types) could we improve
the algorithm to diferent hard disk speed, for example a raid1 with
7200 and 15000 rpm?
the distance continue the same but it will include a 'speed' factor
speed=3D1/rpm
(distance*speed)
or something to select fastest disk in the array
i don=B4t want to use write-mostly since it can reduce my total number
of read disks, but with this we could use the fastest disk with more
frequency without lose array 'speed'





2012/7/5 Shaohua Li <shli@kernel.org>
>
> SSD hasn't spindle, distance between requests means nothing. And the
> original
> distance based algorithm sometimes can cause severe performance issue=
 for
> SSD
> raid.
>
> Considering two thread groups, one accesses file A, the other access =
file
> B.
> The first group will access one disk and the second will access the o=
ther
> disk,
> because requests are near from one group and far between groups. In t=
his
> case,
> read balance might keep one disk very busy but the other relative idl=
e.
> For
> SSD, we should try best to distribute requests to as more disks as
> possible.
> There isn't spindle move penality anyway.
>
> With below patch, I can see more than 50% throughput improvement some=
times
> depending on workloads.
>
> The only exception is small requests can be merged to a big request w=
hich
> typically can drive higher throughput for SSD too. Such small request=
s are
> sequential reads. Unlike hard disk, sequential read which can't be me=
rged
> (for
> example direct IO, or read without readahead) can be ignored for SSD.
> Again
> there is no spindle move penality. readahead dispatches small request=
s and
> such
> requests can be merged.
>
> Last patch can help detect sequential read well, at least if concurre=
nt
> read
> number isn't greater than raid disk number. In that case, distance ba=
sed
> algorithm doesn't work well too.
>
> V2: For hard disk and SSD mixed raid, doesn't use distance based algo=
rithm
> for
> random IO too. This makes the algorithm generic for raid with SSD.
>
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid1.c |   34 +++++++++++++++++++++++++++++++---
>  1 file changed, 31 insertions(+), 3 deletions(-)
>
> Index: linux/drivers/md/raid1.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid1.c       2012-07-04 15:25:11.817869519
> +0800
> +++ linux/drivers/md/raid1.c    2012-07-04 15:42:30.280816275 +0800
> @@ -483,9 +483,11 @@ static int read_balance(struct r1conf *c
>         const sector_t this_sector =3D r1_bio->sector;
>         int sectors;
>         int best_good_sectors;
> -       int best_disk;
> +       int best_disk, best_dist_disk, best_pending_disk;
> +       int has_nonrot_disk;
>         int i;
>         sector_t best_dist;
> +       unsigned int min_pending;
>         struct md_rdev *rdev;
>         int choose_first;
>
> @@ -498,8 +500,12 @@ static int read_balance(struct r1conf *c
>   retry:
>         sectors =3D r1_bio->sectors;
>         best_disk =3D -1;
> +       best_dist_disk =3D -1;
>         best_dist =3D MaxSector;
> +       best_pending_disk =3D -1;
> +       min_pending =3D UINT_MAX;
>         best_good_sectors =3D 0;
> +       has_nonrot_disk =3D 0;
>
>         if (conf->mddev->recovery_cp < MaxSector &&
>             (this_sector + sectors >=3D conf->next_resync))
> @@ -511,6 +517,7 @@ static int read_balance(struct r1conf *c
>                 sector_t dist;
>                 sector_t first_bad;
>                 int bad_sectors;
> +               unsigned int pending;
>
>                 int disk =3D i;
>                 if (disk >=3D conf->raid_disks * 2)
> @@ -573,22 +580,43 @@ static int read_balance(struct r1conf *c
>                 } else
>                         best_good_sectors =3D sectors;
>
> +               has_nonrot_disk |=3D
> blk_queue_nonrot(bdev_get_queue(rdev->bdev));
> +               pending =3D atomic_read(&rdev->nr_pending);
>                 dist =3D abs(this_sector -
> conf->mirrors[disk].head_position);
>                 if (choose_first
>                     /* Don't change to another disk for sequential re=
ads
> */
>                     || conf->mirrors[disk].next_seq_sect =3D=3D this_=
sector
>                     || dist =3D=3D 0
>                     /* If device is idle, use it */
> -                   || atomic_read(&rdev->nr_pending) =3D=3D 0) {
> +                   || pending =3D=3D 0) {
>                         best_disk =3D disk;
>                         break;
>                 }
> +
> +               if (min_pending > pending) {
> +                       min_pending =3D pending;
> +                       best_pending_disk =3D disk;
> +               }
> +
>                 if (dist < best_dist) {
>                         best_dist =3D dist;
> -                       best_disk =3D disk;
> +                       best_dist_disk =3D disk;
>                 }
>         }
>
> +       /*
> +        * If all disks are rotational, choose the closest disk. If a=
ny
> disk is
> +        * non-rotational, choose the disk with less pending request =
even
> the
> +        * disk is rotational, which might/might not be optimal for r=
aids
> with
> +        * mixed ratation/non-rotational disks depending on workload.
> +        */
> +       if (best_disk =3D=3D -1) {
> +               if (has_nonrot_disk)
> +                       best_disk =3D best_pending_disk;
> +               else
> +                       best_disk =3D best_dist_disk;
> +       }
> +
>         if (best_disk >=3D 0) {
>                 rdev =3D rcu_dereference(conf->mirrors[best_disk].rde=
v);
>                 if (!rdev)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




--
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
