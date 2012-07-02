From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: [patch 2/3 v3] raid1: read balance chooses idlest disk for SSD
Date: Sun, 1 Jul 2012 23:13:42 -0300
Message-ID: <CABYL=TpD7D0ec40fz6uo4LCPAKuxtkx5rD3JXfWTtuEYp3NLYQ@mail.gmail.com>
References: <20120702010840.197370335@kernel.org>
	<20120702011031.890864816@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120702011031.890864816@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, axboe@kernel.dk
List-Id: linux-raid.ids

nice =3D) very very nice =3D)
maybe to get better than this... select the disk with min(pending time)

time could be estimated with something like:
(distance * time/distance unit) + (blocks to read/write * time to
read/write 1 block) + (non sequencial penalty time)

for ssd:
    time/distance unit  =3D 0
    time to read/write 1 block =3D must test with each device
    non sequencial penalty time =3D must test with each device, but som=
e
tests show that non sequencial are near to sequencial reads
for hd:
    time/distance unit and time to read/write 1 block are proportional
with disk speed (rpm)
    non sequencial penalty time is proportional to distance and head
position, many disk specs show in specs that it=B4s take, in worst case=
,
near 10ms to start reading/writing, this time is the time to disk spin
one revolution and put head in right position
        check that time to read/write in rotational change with block
position and number of heads reading (blocks at center of disk are
slower, blocks far from center are faster)
         for ssd it=B4s change with allocation 'problems', (for write)
if a block is 'trimmed' it=B4s very fast, if block is used (dirty) it
must read block, change and write, this is a slower... in others
words... the time to read is related with position and mean disk/ssd
read/write times (for a 'good' aproximation not a ideal one...), this
algorithm (without pending information) give me 1% of mean improvement
in kernel 2.6.33 (must check but i think that=B4s right)



2012/7/1 Shaohua Li <shli@kernel.org>
>
> SSD hasn't spindle, distance between requests means nothing. And the =
original
> distance based algorithm sometimes can cause severe performance issue=
 for SSD
> raid.
>
> Considering two thread groups, one accesses file A, the other access =
file B.
> The first group will access one disk and the second will access the o=
ther disk,
> because requests are near from one group and far between groups. In t=
his case,
> read balance might keep one disk very busy but the other relative idl=
e.  For
> SSD, we should try best to distribute requests to as more disks as po=
ssible.
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
rged (for
> example direct IO, or read without readahead) can be ignored for SSD.=
 Again
> there is no spindle move penality. readahead dispatches small request=
s and such
> requests can be merged.
>
> Last patch can help detect sequential read well, at least if concurre=
nt read
> number isn't greater than raid disk number. In that case, distance ba=
sed
> algorithm doesn't work well too.
>
> V2: For hard disk and SSD mixed raid, doesn't use distance based algo=
rithm for
> random IO too. This makes the algorithm generic for raid with SSD.
>
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid1.c |   23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
>
> Index: linux/drivers/md/raid1.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid1.c       2012-06-28 16:56:20.846401902=
 +0800
> +++ linux/drivers/md/raid1.c    2012-06-29 14:13:23.856781798 +0800
> @@ -486,6 +486,7 @@ static int read_balance(struct r1conf *c
>         int best_disk;
>         int i;
>         sector_t best_dist;
> +       unsigned int min_pending;
>         struct md_rdev *rdev;
>         int choose_first;
>
> @@ -499,6 +500,7 @@ static int read_balance(struct r1conf *c
>         sectors =3D r1_bio->sectors;
>         best_disk =3D -1;
>         best_dist =3D MaxSector;
> +       min_pending =3D -1;
>         best_good_sectors =3D 0;
>
>         if (conf->mddev->recovery_cp < MaxSector &&
> @@ -511,6 +513,8 @@ static int read_balance(struct r1conf *c
>                 sector_t dist;
>                 sector_t first_bad;
>                 int bad_sectors;
> +               bool nonrot;
> +               unsigned int pending;
>
>                 int disk =3D i;
>                 if (disk >=3D conf->raid_disks)
> @@ -573,17 +577,32 @@ static int read_balance(struct r1conf *c
>                 } else
>                         best_good_sectors =3D sectors;
>
> +               nonrot =3D blk_queue_nonrot(bdev_get_queue(rdev->bdev=
));
> +               pending =3D atomic_read(&rdev->nr_pending);
>                 dist =3D abs(this_sector - conf->mirrors[disk].head_p=
osition);
>                 if (choose_first
>                     /* Don't change to another disk for sequential re=
ads */
>                     || conf->mirrors[disk].next_seq_sect =3D=3D this_=
sector
>                     || dist =3D=3D 0
>                     /* If device is idle, use it */
> -                   || atomic_read(&rdev->nr_pending) =3D=3D 0) {
> +                   || pending =3D=3D 0) {
>                         best_disk =3D disk;
>                         break;
>                 }
> -               if (dist < best_dist) {
> +
> +               /*
> +                * If all disks are rotational, choose the closest di=
sk. If any
> +                * disk is non-rotational, choose the disk with less =
pending
> +                * request even the disk is rotational, which might/m=
ight not
> +                * be optimal for raids with mixed ratation/non-rotat=
ional
> +                * disks depending on workload.
> +                */
> +               if (nonrot || min_pending !=3D -1) {
> +                       if (min_pending > pending) {
> +                               min_pending =3D pending;
> +                               best_disk =3D disk;
> +                       }
> +               } else if (dist < best_dist) {
>                         best_dist =3D dist;
>                         best_disk =3D disk;
>                 }
>
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
