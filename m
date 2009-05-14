From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: Subject: [001/001 ] raid0 remove hashing, variable chunk size
Date: Thu, 14 May 2009 09:14:26 +0530
Message-ID: <37d33d830905132044w1dc0b375ha3e5a07cb2a34066@mail.gmail.com>
References: <1242237805.8753.6.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1242237805.8753.6.camel@raz>
Sender: linux-raid-owner@vger.kernel.org
To: raz ben yehuda <raziebe@013.net>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 13, 2009 at 11:33 PM, raz ben yehuda <raziebe@013.net> wrot=
e:
> 1. Beautify raid0 code
> 2. Remove hashing
> 3. Chunk size of 4K*n instead of 4K*2^n ( must apply a patch to mdadm=
 ).
> patch was tested with backward compatibility to 2.6.18. i did not tes=
t 32bit, i do have
> a 32bit compiler for 2.6.30-rc2.
> =A0md.c =A0 =A0| =A0 24 ++-
> =A0raid0.c | =A0428 ++++++++++++++++++++++++++++++-------------------=
---------------
> =A0raid0.h | =A0 =A03
> =A03 files changed, 221 insertions(+), 234 deletions(-)
> Signed-of-By : Neil Brown neilb@suse.de
> ---
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ed5727c..068e18d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -444,8 +444,10 @@ static sector_t calc_num_sectors(mdk_rdev_t *rde=
v, unsigned chunk_size)
> =A0{
> =A0 =A0 =A0 =A0sector_t num_sectors =3D rdev->sb_start;
>
> - =A0 =A0 =A0 if (chunk_size)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_sectors &=3D ~((sector_t)chunk_size=
/512 - 1);
> + =A0 =A0 =A0 if (chunk_size) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int chunk_sects =3D chunk_size>>9;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_sectors =3D (num_sectors/chunk_sect=
s)*chunk_sects;
> + =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0return num_sectors;
> =A0}
>
> @@ -3512,7 +3514,7 @@ min_sync_store(mddev_t *mddev, const char *buf,=
 size_t len)
>
> =A0 =A0 =A0 =A0/* Must be a multiple of chunk_size */
> =A0 =A0 =A0 =A0if (mddev->chunk_size) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (min & (sector_t)((mddev->chunk_size=
>>9)-1))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (min % (sector_t)(mddev->chunk_size>=
>9))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0mddev->resync_min =3D min;
> @@ -3549,7 +3551,7 @@ max_sync_store(mddev_t *mddev, const char *buf,=
 size_t len)
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Must be a multiple of chunk_size */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (mddev->chunk_size) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (max & (sector_t)((m=
ddev->chunk_size>>9)-1))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (max % (sector_t)(md=
dev->chunk_size>>9))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return=
 -EINVAL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mddev->resync_max =3D max;
> @@ -3992,12 +3994,20 @@ static int do_md_run(mddev_t * mddev)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * chunk-size has to be a power of 2
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ( (1 << ffz(~chunk_size)) !=3D chunk=
_size) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((1 << ffz(~chunk_size)) !=3D chunk_=
size
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 && mddev->level !=3D 0)=
 {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_ERR "chunk=
_size of %d not valid\n", chunk_size);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> -
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 * raid0 chunk size has to divide by a p=
age
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mddev->level =3D=3D 0 && (chunk_siz=
e % 4096)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_ERR "chunk_=
size of %d not valid\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 chunk_size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* devices must have minimum size of o=
ne chunk */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_for_each_entry(rdev, &mddev->disk=
s, same_set) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (test_bit(Faulty, &=
rdev->flags))
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index c08d755..990ec6c 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -53,32 +53,49 @@ static int raid0_congested(void *data, int bits)
> =A0}
>
>
> -static int create_strip_zones (mddev_t *mddev)
> +static void raid0_dump_zones(mddev_t *mddev)
> =A0{
> - =A0 =A0 =A0 int i, c, j;
> - =A0 =A0 =A0 sector_t current_start, curr_zone_start;
> - =A0 =A0 =A0 sector_t min_spacing;
> + =A0 =A0 =A0 int j, k, h;
> + =A0 =A0 =A0 char b[BDEVNAME_SIZE];
> =A0 =A0 =A0 =A0raid0_conf_t *conf =3D mddev_to_conf(mddev);
> - =A0 =A0 =A0 mdk_rdev_t *smallest, *rdev1, *rdev2, *rdev;
> - =A0 =A0 =A0 struct strip_zone *zone;
> - =A0 =A0 =A0 int cnt;
> + =A0 =A0 =A0 printk(KERN_INFO "***** %s configuration ******",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mdname(mddev));
> + =A0 =A0 =A0 h =3D 0;
> + =A0 =A0 =A0 for (j =3D 0; j < conf->nr_strip_zones; j++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk("\nzone%d", j);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk("=3D[");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (k =3D 0; k < conf->strip_zone[j].n=
b_dev; k++)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk("%s/", bdevname(
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 conf->s=
trip_zone[j].dev[k]->bdev, b));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk("]\n\t zone offset=3D%llu device=
 offset=3D%llu size=3D%llukb\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsigned long long)con=
f->strip_zone[j].zone_start,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsigned long long)con=
f->strip_zone[j].dev_start,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsigned long long)con=
f->strip_zone[j].sectors>>1);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 printk(KERN_INFO "**********************************\n\=
n");
> +}
> +
> +
> +static void raid0_count_zones(mddev_t *mddev, struct list_head *disk=
s)
> +{
> + =A0 =A0 =A0 int c =3D 0;
> =A0 =A0 =A0 =A0char b[BDEVNAME_SIZE];
> -
> + =A0 =A0 =A0 mdk_rdev_t =A0*rdev1, *rdev2;
> + =A0 =A0 =A0 raid0_conf_t *conf =3D mddev_to_conf(mddev);
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * The number of 'same size groups'
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0conf->nr_strip_zones =3D 0;
> -
> - =A0 =A0 =A0 list_for_each_entry(rdev1, &mddev->disks, same_set) {
> + =A0 =A0 =A0 list_for_each_entry(rdev1, disks, same_set) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_INFO "raid0: looking at %s=
\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bdevname(rdev1->bdev,b=
));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0c =3D 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_for_each_entry(rdev2, &mddev->disk=
s, same_set) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_for_each_entry(rdev2, disks, same_=
set) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_INFO "raid=
0: =A0 comparing %s(%llu)",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bdevname=
(rdev1->bdev,b),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bdevname=
(rdev1->bdev, b),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsigned=
 long long)rdev1->sectors);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_INFO " with=
 %s(%llu)\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bdevname=
(rdev2->bdev,b),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_INFO "with =
%s(%llu)\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bdevname=
(rdev2->bdev, b),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsigned=
 long long)rdev2->sectors);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rdev2 =3D=3D rdev1=
) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk=
(KERN_INFO "raid0: =A0 END\n");
> @@ -103,81 +120,75 @@ static int create_strip_zones (mddev_t *mddev)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0printk(KERN_INFO "raid0: FINAL %d zones\n", conf->nr_s=
trip_zones);
> +}
>
> - =A0 =A0 =A0 conf->strip_zone =3D kzalloc(sizeof(struct strip_zone)*
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 conf->n=
r_strip_zones, GFP_KERNEL);
> - =A0 =A0 =A0 if (!conf->strip_zone)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> - =A0 =A0 =A0 conf->devlist =3D kzalloc(sizeof(mdk_rdev_t*)*
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 conf->n=
r_strip_zones*mddev->raid_disks,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 GFP_KER=
NEL);
> - =A0 =A0 =A0 if (!conf->devlist)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>
> - =A0 =A0 =A0 /* The first zone must contain all devices, so here we =
check that
> - =A0 =A0 =A0 =A0* there is a proper alignment of slots to devices an=
d find them all
> - =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 zone =3D &conf->strip_zone[0];
> - =A0 =A0 =A0 cnt =3D 0;
> - =A0 =A0 =A0 smallest =3D NULL;
> - =A0 =A0 =A0 zone->dev =3D conf->devlist;
> - =A0 =A0 =A0 list_for_each_entry(rdev1, &mddev->disks, same_set) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 int j =3D rdev1->raid_disk;
> +/*
> + * The first zone must contain all devices, so here we check that
> + * there is a proper alignment of slots to devices and find them all
> + */
> +static int raid0_create_first_zone(mddev_t *mddev, struct list_head =
*disks)
> +{
> + =A0 =A0 =A0 mdk_rdev_t *smallest =3D NULL;
> + =A0 =A0 =A0 mdk_rdev_t =A0*rdev;
> + =A0 =A0 =A0 int cnt =3D 0;
> + =A0 =A0 =A0 raid0_conf_t *conf =3D mddev_to_conf(mddev);
> + =A0 =A0 =A0 struct strip_zone *zone0 =3D &conf->strip_zone[0];
>
> + =A0 =A0 =A0 zone0->dev =3D conf->devlist;
> + =A0 =A0 =A0 list_for_each_entry(rdev, disks, same_set) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int j =3D rdev->raid_disk;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (j < 0 || j >=3D mddev->raid_disks)=
 {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_ERR "raid0=
: bad disk number %d - "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"abort=
ing!\n", j);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto abort;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (zone->dev[j]) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (zone0->dev[j]) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_ERR "raid0=
: multiple devices for %d - "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"abort=
ing!\n", j);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto abort;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 zone->dev[j] =3D rdev1;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk_queue_stack_limits(mddev->queue,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0rdev1->bdev->bd_disk->queue);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* as we don't honour merge_bvec_fn, we=
 must never risk
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* violating it, so limit ->max_secto=
r to one PAGE, as
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* a one page request is never in vio=
lation.
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rdev1->bdev->bd_disk->queue->merge_=
bvec_fn &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mddev->queue->max_sectors > (PA=
GE_SIZE>>9))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk_queue_max_sectors(m=
ddev->queue, PAGE_SIZE>>9);
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!smallest || (rdev1->sectors < smal=
lest->sectors))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 smallest =3D rdev1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 zone0->dev[j] =3D rdev;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!smallest || (rdev->sectors < small=
est->sectors))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 smallest =3D rdev;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cnt++;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0if (cnt !=3D mddev->raid_disks) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_ERR "raid0: too few disks =
(%d of %d) - "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"aborting!\n", cnt, md=
dev->raid_disks);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto abort;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 zone->nb_dev =3D cnt;
> - =A0 =A0 =A0 zone->sectors =3D smallest->sectors * cnt;
> - =A0 =A0 =A0 zone->zone_start =3D 0;
> + =A0 =A0 =A0 zone0->nb_dev =3D cnt;
> + =A0 =A0 =A0 zone0->sectors =3D smallest->sectors * cnt;
> + =A0 =A0 =A0 zone0->zone_start =3D 0;
> + =A0 =A0 =A0 return 0;
> +}
> +
>
> - =A0 =A0 =A0 current_start =3D smallest->sectors;
> - =A0 =A0 =A0 curr_zone_start =3D zone->sectors;
> +
> +static void raid0_set_higher_zones(mddev_t *mddev)
> +{
> + =A0 =A0 =A0 int i, j, c;
> + =A0 =A0 =A0 mdk_rdev_t *rdev;
> + =A0 =A0 =A0 struct strip_zone *zone;
> + =A0 =A0 =A0 raid0_conf_t *conf =3D mddev_to_conf(mddev);
> + =A0 =A0 =A0 mdk_rdev_t *smallest;
> + =A0 =A0 =A0 sector_t current_start =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 conf->strip_zone[0].sectors/conf->strip=
_zone[0].nb_dev;
> + =A0 =A0 =A0 sector_t curr_zone_start =3D conf->strip_zone[0].sector=
s;
>
> =A0 =A0 =A0 =A0/* now do the other zones */
> - =A0 =A0 =A0 for (i =3D 1; i < conf->nr_strip_zones; i++)
> - =A0 =A0 =A0 {
> + =A0 =A0 =A0 for (i =3D 1; i < conf->nr_strip_zones; i++) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0zone =3D conf->strip_zone + i;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0zone->dev =3D conf->strip_zone[i-1].de=
v + mddev->raid_disks;
> -
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_INFO "raid0: zone %d\n", i=
);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0zone->dev_start =3D current_start;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0smallest =3D NULL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0c =3D 0;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (j=3D0; j<cnt; j++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (j =3D 0; j < conf->strip_zone[0].n=
b_dev; j++) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0char b[BDEVNAME_SIZE];
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rdev =3D conf->strip_z=
one[0].dev[j];
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_INFO "raid0=
: checking %s ...",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk("raid0: checking=
 %s ...",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bdevna=
me(rdev->bdev, b));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rdev->sectors <=3D=
 current_start) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk=
(KERN_INFO " nope.\n");
> @@ -197,54 +208,38 @@ static int create_strip_zones (mddev_t *mddev)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0zone->sectors =3D (smallest->sectors -=
 current_start) * c;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_INFO "raid0: zone->nb_dev:=
 %d, sectors: %llu\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0zone->nb_dev, (unsigne=
d long long)zone->sectors);
> -
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0zone->zone_start =3D curr_zone_start;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0curr_zone_start +=3D zone->sectors;
> -
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0current_start =3D smallest->sectors;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_INFO "raid0: current zone =
start: %llu\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned long long)cu=
rrent_start);
> =A0 =A0 =A0 =A0}
> +}
>
> - =A0 =A0 =A0 /* Now find appropriate hash spacing.
> - =A0 =A0 =A0 =A0* We want a number which causes most hash entries to=
 cover
> - =A0 =A0 =A0 =A0* at most two strips, but the hash table must be at =
most
> - =A0 =A0 =A0 =A0* 1 PAGE. =A0We choose the smallest strip, or contig=
uous collection
> - =A0 =A0 =A0 =A0* of strips, that has big enough size. =A0We never c=
onsider the last
> - =A0 =A0 =A0 =A0* strip though as it's size has no bearing on the ef=
ficacy of the hash
> - =A0 =A0 =A0 =A0* table.
> - =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 conf->spacing =3D curr_zone_start;
> - =A0 =A0 =A0 min_spacing =3D curr_zone_start;
> - =A0 =A0 =A0 sector_div(min_spacing, PAGE_SIZE/sizeof(struct strip_z=
one*));
> - =A0 =A0 =A0 for (i=3D0; i < conf->nr_strip_zones-1; i++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 sector_t s =3D 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (j =3D i; j < conf->nr_strip_zones =
- 1 &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 s < min=
_spacing; j++)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 s +=3D conf->strip_zone=
[j].sectors;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (s >=3D min_spacing && s < conf->spa=
cing)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 conf->spacing =3D s;
> - =A0 =A0 =A0 }
> +static int raid0_create_strip_zones(mddev_t *mddev, struct list_head=
 *disks)
> +{
> + =A0 =A0 =A0 raid0_conf_t *conf =3D mddev_to_conf(mddev);
>
> + =A0 =A0 =A0 raid0_count_zones(mddev, disks);
> + =A0 =A0 =A0 conf->strip_zone =3D kzalloc(sizeof(struct strip_zone)*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 conf->n=
r_strip_zones, GFP_KERNEL);
> + =A0 =A0 =A0 if (!conf->strip_zone)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> + =A0 =A0 =A0 conf->devlist =3D kzalloc(sizeof(mdk_rdev_t *)*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 conf->n=
r_strip_zones*mddev->raid_disks,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 GFP_KER=
NEL);
> + =A0 =A0 =A0 if (!conf->devlist)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> + =A0 =A0 =A0 if (raid0_create_first_zone(mddev, disks))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> + =A0 =A0 =A0 raid0_set_higher_zones(mddev);
> =A0 =A0 =A0 =A0mddev->queue->unplug_fn =3D raid0_unplug;
> -
> =A0 =A0 =A0 =A0mddev->queue->backing_dev_info.congested_fn =3D raid0_=
congested;
> =A0 =A0 =A0 =A0mddev->queue->backing_dev_info.congested_data =3D mdde=
v;
> -
> =A0 =A0 =A0 =A0printk(KERN_INFO "raid0: done.\n");
> =A0 =A0 =A0 =A0return 0;
> - abort:
> - =A0 =A0 =A0 return 1;
> =A0}
>
> -/**
> - * =A0 =A0 raid0_mergeable_bvec -- tell bio layer if a two requests =
can be merged
> - * =A0 =A0 @q: request queue
> - * =A0 =A0 @bvm: properties of new bio
> - * =A0 =A0 @biovec: the request that could be merged to it.
> - *
> - * =A0 =A0 Return amount of bytes we can accept at this offset
> - */
> =A0static int raid0_mergeable_bvec(struct request_queue *q,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct=
 bvec_merge_data *bvm,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct=
 bio_vec *biovec)
> @@ -254,124 +249,119 @@ static int raid0_mergeable_bvec(struct reques=
t_queue *q,
> =A0 =A0 =A0 =A0int max;
> =A0 =A0 =A0 =A0unsigned int chunk_sectors =3D mddev->chunk_size >> 9;
> =A0 =A0 =A0 =A0unsigned int bio_sectors =3D bvm->bi_size >> 9;
> -
> - =A0 =A0 =A0 max =3D =A0(chunk_sectors - ((sector & (chunk_sectors -=
 1)) + bio_sectors)) << 9;
> - =A0 =A0 =A0 if (max < 0) max =3D 0; /* bio_add cannot handle a nega=
tive return */
> + =A0 =A0 =A0 max =3D =A0(chunk_sectors - ((sector % chunk_sectors) +=
 bio_sectors)) << 9;
> + =A0 =A0 =A0 if (max < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 max =3D 0;/* =A0bio_add cannot handle a=
 negative return */
> =A0 =A0 =A0 =A0if (max <=3D biovec->bv_len && bio_sectors =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return biovec->bv_len;
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return max;
> + =A0 =A0 =A0 return 0;
> =A0}
>
> +
> =A0static sector_t raid0_size(mddev_t *mddev, sector_t sectors, int r=
aid_disks)
> =A0{
> - =A0 =A0 =A0 sector_t array_sectors =3D 0;
> + =A0 =A0 =A0 int i;
> =A0 =A0 =A0 =A0mdk_rdev_t *rdev;
> + =A0 =A0 =A0 sector_t array_sectors =3D 0;
> + =A0 =A0 =A0 raid0_conf_t *conf =3D mddev_to_conf(mddev);
> + =A0 =A0 =A0 mdk_rdev_t **devlist =3D conf->strip_zone[0].dev;
> + =A0 =A0 =A0 for (i =3D 0; i < mddev->raid_disks; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdev =3D devlist[i];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (test_bit(In_sync, &rdev->flags))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 array_sectors +=3D rdev=
->sectors;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return array_sectors;
> +}
>
> - =A0 =A0 =A0 WARN_ONCE(sectors || raid_disks,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "%s does not support generic reshap=
e\n", __func__);
> +static void raid0_set_queue_limits(mddev_t *mddev)
> +{
> + =A0 =A0 =A0 mdk_rdev_t =A0*rdev;
>
> - =A0 =A0 =A0 list_for_each_entry(rdev, &mddev->disks, same_set)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 array_sectors +=3D rdev->sectors;
> + =A0 =A0 =A0 list_for_each_entry(rdev, &mddev->disks, same_set) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk_queue_stack_limits(mddev->queue,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rdev->bd=
ev->bd_disk->queue);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* as we don't honour merge_bvec_fn, we=
 must never risk
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* violating it, so limit ->max_secto=
r to one PAGE, as
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* a one page request is never in vio=
lation.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rdev->bdev->bd_disk->queue->merge_b=
vec_fn &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mddev->queue->max_sectors > (PA=
GE_SIZE>>9))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk_queue_max_sectors(m=
ddev->queue, PAGE_SIZE>>9);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 printk(KERN_INFO "raid0:%s queue limits: hardware"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 " segments=3D%d physical segments=3D%d\=
n"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 " max hardware sectors =3D %d max secto=
rs %d\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mdname(mddev),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mddev->queue->max_hw_segments,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mddev->queue->max_phys_segments,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mddev->queue->max_hw_sectors,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mddev->queue->max_sectors);
> +}
> +
> +/* calculate the max read-ahead size.
> + * For read-ahead of large files to be effective, we need to
> + * readahead at least twice a whole stripe. i.e. number of devices
> + * multiplied by chunk size times 2.
> + * If an individual device has an ra_pages greater than the
> + * chunk size, then we will not drive that device as hard as it
> + * wants. =A0We consider this a configuration error: a larger
> + * chunksize should be used in that case.
> + */
> +static void raid0_set_max_ra(mddev_t *mddev)
> +{
> + =A0 =A0 =A0 int stripe =3D mddev->raid_disks * mddev->chunk_size / =
PAGE_SIZE;
> + =A0 =A0 =A0 if (mddev->queue->backing_dev_info.ra_pages < 2*stripe)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mddev->queue->backing_dev_info.ra_pages=
 =3D 2*stripe;
>
> - =A0 =A0 =A0 return array_sectors;
> =A0}
>
> -static int raid0_run (mddev_t *mddev)
> +static int raid0_is_power2_chunk(mddev_t *mddev)
> =A0{
> - =A0 =A0 =A0 unsigned =A0cur=3D0, i=3D0, nb_zone;
> - =A0 =A0 =A0 s64 sectors;
> - =A0 =A0 =A0 raid0_conf_t *conf;
> + =A0 =A0 =A0 if ((1 << ffz(~mddev->chunk_size)) =3D=3D mddev->chunk_=
size)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> + =A0 =A0 =A0 return 0;
> +}
>
> +static int raid0_run(mddev_t *mddev)
> +{
> + =A0 =A0 =A0 raid0_conf_t *conf;
> + =A0 =A0 =A0 int segment_boundary;
> =A0 =A0 =A0 =A0if (mddev->chunk_size =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_ERR "md/raid0: non-zero ch=
unk size required.\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
> =A0 =A0 =A0 =A0}

Are we not handling this in mdadm itself, I think so  ?
[09:03:40 sinhas]$ sudo mdadm -C /dev/md0 -n2 -l0  -c0 /dev/sda5 /dev/s=
da6 -f
mdadm: invalid chunk/rounding value: 0


I think we also make sure that chunk size > 4K. I tested it.


> - =A0 =A0 =A0 printk(KERN_INFO "%s: setting max_sectors to %d, segmen=
t boundary to %d\n",
> + =A0 =A0 =A0 blk_queue_max_sectors(mddev->queue, mddev->chunk_size>>=
9);
> + =A0 =A0 =A0 if (!raid0_is_power2_chunk(mddev)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_INFO "raid0: not power 2 ch=
unk size\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 segment_boundary =3D ~(ffz(~mddev->chun=
k_size))>>1;
> + =A0 =A0 =A0 } else{
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_INFO "raid0: is power 2 chu=
nk size\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 segment_boundary =3D (mddev->chunk_size=
>>1)-1;
> + =A0 =A0 =A0 }

I hope this piece of code gets executed someday,

[09:03:22 sinhas]$ sudo mdadm -C /dev/md0 -n2 -l0  -c62 /dev/sda5 /dev/=
sda6 -f
[sudo] password for sinhas:
mdadm: invalid chunk/rounding value: 62


> + =A0 =A0 =A0 blk_queue_segment_boundary(mddev->queue, segment_bounda=
ry);
> + =A0 =A0 =A0 printk(KERN_INFO "%s: setting max_sectors"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 " to %d, segment bounda=
ry to %d\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mdname(mddev),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mddev->chunk_size >> 9,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0(mddev->chunk_size>>1)-1);
> - =A0 =A0 =A0 blk_queue_max_sectors(mddev->queue, mddev->chunk_size >=
> 9);
> - =A0 =A0 =A0 blk_queue_segment_boundary(mddev->queue, (mddev->chunk_=
size>>1) - 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0segment_boundary);
> =A0 =A0 =A0 =A0mddev->queue->queue_lock =3D &mddev->queue->__queue_lo=
ck;
>
> - =A0 =A0 =A0 conf =3D kmalloc(sizeof (raid0_conf_t), GFP_KERNEL);
> + =A0 =A0 =A0 conf =3D kmalloc(sizeof(raid0_conf_t), GFP_KERNEL);
> =A0 =A0 =A0 =A0if (!conf)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0mddev->private =3D (void *)conf;
> -
> =A0 =A0 =A0 =A0conf->strip_zone =3D NULL;
> =A0 =A0 =A0 =A0conf->devlist =3D NULL;
> - =A0 =A0 =A0 if (create_strip_zones (mddev))
> + =A0 =A0 =A0 if (raid0_create_strip_zones(mddev, &mddev->disks))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_free_conf;
> -
> =A0 =A0 =A0 =A0/* calculate array device size */
> - =A0 =A0 =A0 md_set_array_sectors(mddev, raid0_size(mddev, 0, 0));
> -
> - =A0 =A0 =A0 printk(KERN_INFO "raid0 : md_size is %llu sectors.\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsigned long long)mddev->array_sector=
s);
> - =A0 =A0 =A0 printk(KERN_INFO "raid0 : conf->spacing is %llu sectors=
=2E\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsigned long long)conf->spacing);
> - =A0 =A0 =A0 {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 sector_t s =3D raid0_size(mddev, 0, 0);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 sector_t space =3D conf->spacing;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 int round;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 conf->sector_shift =3D 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sizeof(sector_t) > sizeof(u32)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*shift down space and =
s so that sector_div will work */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 while (space > (sector_=
t) (~(u32)0)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 s >>=3D=
 1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 space >=
>=3D 1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 s +=3D =
1; /* force round-up */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 conf->s=
ector_shift++;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 round =3D sector_div(s, (u32)space) ? 1=
 : 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 nb_zone =3D s + round;
> - =A0 =A0 =A0 }
> - =A0 =A0 =A0 printk(KERN_INFO "raid0 : nb_zone is %d.\n", nb_zone);
> -
> - =A0 =A0 =A0 printk(KERN_INFO "raid0 : Allocating %zu bytes for hash=
=2E\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nb_zone=
*sizeof(struct strip_zone*));
> - =A0 =A0 =A0 conf->hash_table =3D kmalloc (sizeof (struct strip_zone=
 *)*nb_zone, GFP_KERNEL);
> - =A0 =A0 =A0 if (!conf->hash_table)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_free_conf;
> - =A0 =A0 =A0 sectors =3D conf->strip_zone[cur].sectors;
> -
> - =A0 =A0 =A0 conf->hash_table[0] =3D conf->strip_zone + cur;
> - =A0 =A0 =A0 for (i=3D1; i< nb_zone; i++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 while (sectors <=3D conf->spacing) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cur++;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sectors +=3D conf->stri=
p_zone[cur].sectors;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 sectors -=3D conf->spacing;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 conf->hash_table[i] =3D conf->strip_zon=
e + cur;
> - =A0 =A0 =A0 }
> - =A0 =A0 =A0 if (conf->sector_shift) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 conf->spacing >>=3D conf->sector_shift;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* round spacing up so when we divide b=
y it, we
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* err on the side of too-low, which =
is safest
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 conf->spacing++;
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 /* calculate the max read-ahead size.
> - =A0 =A0 =A0 =A0* For read-ahead of large files to be effective, we =
need to
> - =A0 =A0 =A0 =A0* readahead at least twice a whole stripe. i.e. numb=
er of devices
> - =A0 =A0 =A0 =A0* multiplied by chunk size times 2.
> - =A0 =A0 =A0 =A0* If an individual device has an ra_pages greater th=
an the
> - =A0 =A0 =A0 =A0* chunk size, then we will not drive that device as =
hard as it
> - =A0 =A0 =A0 =A0* wants. =A0We consider this a configuration error: =
a larger
> - =A0 =A0 =A0 =A0* chunksize should be used in that case.
> - =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 int stripe =3D mddev->raid_disks * mdde=
v->chunk_size / PAGE_SIZE;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mddev->queue->backing_dev_info.ra_p=
ages < 2* stripe)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mddev->queue->backing_d=
ev_info.ra_pages =3D 2* stripe;
> - =A0 =A0 =A0 }
> -
> -
> + =A0 =A0 =A0 md_set_array_sectors(mddev, raid0_size(mddev, 0, mddev-=
>raid_disks));
> + =A0 =A0 =A0 raid0_set_queue_limits(mddev);
> + =A0 =A0 =A0 raid0_set_max_ra(mddev);
> =A0 =A0 =A0 =A0blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bve=
c);
> + =A0 =A0 =A0 raid0_dump_zones(mddev);
> =A0 =A0 =A0 =A0return 0;
>
> =A0out_free_conf:
> @@ -388,8 +378,6 @@ static int raid0_stop (mddev_t *mddev)
> =A0 =A0 =A0 =A0raid0_conf_t *conf =3D mddev_to_conf(mddev);
>
> =A0 =A0 =A0 =A0blk_sync_queue(mddev->queue); /* the unplug fn referen=
ces 'conf'*/
> - =A0 =A0 =A0 kfree(conf->hash_table);
> - =A0 =A0 =A0 conf->hash_table =3D NULL;
> =A0 =A0 =A0 =A0kfree(conf->strip_zone);
> =A0 =A0 =A0 =A0conf->strip_zone =3D NULL;
> =A0 =A0 =A0 =A0kfree(conf);
> @@ -398,15 +386,36 @@ static int raid0_stop (mddev_t *mddev)
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> +
> +static void raid0_position_bio(mddev_t *mddev, struct bio *bio, sect=
or_t sector)
> +{
> + =A0 =A0 =A0 sector_t sect_in_chunk;
> + =A0 =A0 =A0 mdk_rdev_t *tmp_dev;
> + =A0 =A0 =A0 sector_t chunk_in_dev;
> + =A0 =A0 =A0 sector_t rsect;
> + =A0 =A0 =A0 sector_t x;
> + =A0 =A0 =A0 raid0_conf_t *conf =3D mddev_to_conf(mddev);
> + =A0 =A0 =A0 sector_t chunk_sects =3D mddev->chunk_size >> 9;
> + =A0 =A0 =A0 struct strip_zone *zone =3D &conf->strip_zone[0];
> +
> + =A0 =A0 =A0 while (sector >=3D zone->zone_start + zone->sectors)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 zone++;
> + =A0 =A0 =A0 sect_in_chunk =3D sector % chunk_sects;
> + =A0 =A0 =A0 x =3D (sector - zone->zone_start) / chunk_sects;
> + =A0 =A0 =A0 sector_div(x, zone->nb_dev);
> + =A0 =A0 =A0 chunk_in_dev =3D x;
> + =A0 =A0 =A0 x =3D sector / chunk_sects;
> + =A0 =A0 =A0 tmp_dev =3D zone->dev[sector_div(x, zone->nb_dev)];
> + =A0 =A0 =A0 rsect =3D (chunk_in_dev * chunk_sects) + zone->dev_star=
t + sect_in_chunk;
> + =A0 =A0 =A0 bio->bi_bdev =3D tmp_dev->bdev;
> + =A0 =A0 =A0 bio->bi_sector =3D rsect + tmp_dev->data_offset;
> +}
> +
> +
> =A0static int raid0_make_request (struct request_queue *q, struct bio=
 *bio)
> =A0{
> =A0 =A0 =A0 =A0mddev_t *mddev =3D q->queuedata;
> - =A0 =A0 =A0 unsigned int sect_in_chunk, chunksect_bits, chunk_sects=
;
> - =A0 =A0 =A0 raid0_conf_t *conf =3D mddev_to_conf(mddev);
> - =A0 =A0 =A0 struct strip_zone *zone;
> - =A0 =A0 =A0 mdk_rdev_t *tmp_dev;
> - =A0 =A0 =A0 sector_t chunk;
> - =A0 =A0 =A0 sector_t sector, rsect;
> + =A0 =A0 =A0 unsigned int chunk_sects =3D mddev->chunk_size >> 9;
> =A0 =A0 =A0 =A0const int rw =3D bio_data_dir(bio);
> =A0 =A0 =A0 =A0int cpu;
>
> @@ -414,18 +423,14 @@ static int raid0_make_request (struct request_q=
ueue *q, struct bio *bio)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bio_endio(bio, -EOPNOTSUPP);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0}
> -
> =A0 =A0 =A0 =A0cpu =3D part_stat_lock();
> =A0 =A0 =A0 =A0part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
> =A0 =A0 =A0 =A0part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw]=
,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bio_sectors(bio));
> =A0 =A0 =A0 =A0part_stat_unlock();
>
> - =A0 =A0 =A0 chunk_sects =3D mddev->chunk_size >> 9;
> - =A0 =A0 =A0 chunksect_bits =3D ffz(~chunk_sects);
> - =A0 =A0 =A0 sector =3D bio->bi_sector;
> -
> - =A0 =A0 =A0 if (unlikely(chunk_sects < (bio->bi_sector & (chunk_sec=
ts - 1)) + (bio->bi_size >> 9))) {
> + =A0 =A0 =A0 if (unlikely(chunk_sects < ((bio->bi_sector % chunk_sec=
ts)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 + (bio->bi_size >> 9)))=
) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct bio_pair *bp;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Sanity check -- queue functions sho=
uld prevent this happening */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (bio->bi_vcnt !=3D 1 ||
> @@ -434,7 +439,8 @@ static int raid0_make_request (struct request_que=
ue *q, struct bio *bio)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* This is a one page bio that upper l=
ayers
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * refuse to split for us, so we need =
to split it.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 bp =3D bio_split(bio, chunk_sects - (bi=
o->bi_sector & (chunk_sects - 1)));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bp =3D bio_split(bio, chunk_sects -
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 (bio->bi_sector % chunk_sects));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (raid0_make_request(q, &bp->bio1))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0generic_make_request(&=
bp->bio1);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (raid0_make_request(q, &bp->bio2))
> @@ -443,34 +449,7 @@ static int raid0_make_request (struct request_qu=
eue *q, struct bio *bio)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bio_pair_release(bp);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0}
> -
> -
> - =A0 =A0 =A0 {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 sector_t x =3D sector >> conf->sector_s=
hift;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 sector_div(x, (u32)conf->spacing);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 zone =3D conf->hash_table[x];
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 while (sector >=3D zone->zone_start + zone->sectors)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 zone++;
> -
> - =A0 =A0 =A0 sect_in_chunk =3D bio->bi_sector & (chunk_sects - 1);
> -
> -
> - =A0 =A0 =A0 {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 sector_t x =3D (sector - zone->zone_sta=
rt) >> chunksect_bits;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 sector_div(x, zone->nb_dev);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 chunk =3D x;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 x =3D sector >> chunksect_bits;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 tmp_dev =3D zone->dev[sector_div(x, zon=
e->nb_dev)];
> - =A0 =A0 =A0 }
> - =A0 =A0 =A0 rsect =3D (chunk << chunksect_bits) + zone->dev_start +=
 sect_in_chunk;
> -
> - =A0 =A0 =A0 bio->bi_bdev =3D tmp_dev->bdev;
> - =A0 =A0 =A0 bio->bi_sector =3D rsect + tmp_dev->data_offset;
> -
> + =A0 =A0 =A0 raid0_position_bio(mddev, bio, bio->bi_sector);
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * Let the main block layer submit the IO and resolve =
recursion:
> =A0 =A0 =A0 =A0 */
> @@ -485,6 +464,7 @@ bad_map:
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> +
> =A0static void raid0_status (struct seq_file *seq, mddev_t *mddev)
> =A0{
> =A0#undef MD_DEBUG
> diff --git a/drivers/md/raid0.h b/drivers/md/raid0.h
> index 824b12e..2a73f94 100644
> --- a/drivers/md/raid0.h
> +++ b/drivers/md/raid0.h
> @@ -16,9 +16,6 @@ struct raid0_private_data
> =A0 =A0 =A0 =A0struct strip_zone *strip_zone;
> =A0 =A0 =A0 =A0mdk_rdev_t **devlist; /* lists of rdevs, pointed to by=
 strip_zone->dev */
> =A0 =A0 =A0 =A0int nr_strip_zones;
> -
> - =A0 =A0 =A0 sector_t spacing;
> - =A0 =A0 =A0 int sector_shift; /* shift this before divide by spacin=
g */
> =A0};
>
> =A0typedef struct raid0_private_data raid0_conf_t;
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Regards,
Sandeep.





 =09
=93To learn is to change. Education is a process that changes the learn=
er.=94
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
