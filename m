From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 3/3] md: 'array_size' sysfs attribute
Date: Fri, 6 Mar 2009 11:20:21 -0700
Message-ID: <e9c3a7c20903061020v43c3e738n4d643e147abb7afb@mail.gmail.com>
References: <20090306002341.9882.61625.stgit@dwillia2-linux.ch.intel.com>
	 <20090306002458.9882.82188.stgit@dwillia2-linux.ch.intel.com>
	 <20090306161559.GJ32416@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090306161559.GJ32416@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, jacek.danecki@intel.com
List-Id: linux-raid.ids

On Fri, Mar 6, 2009 at 9:15 AM, Andre Noll <maan@systemlinux.org> wrote=
:
> On 17:24, Dan Williams wrote:
>> Allow userspace to set the size of the array according to the follow=
ing
>> semantics:
>>
>> 1/ size must be <=3D to the size returned by mddev->pers->size(mddev=
, 0, 0)
>> =A0 =A0a) If size is set before the array is running, do_md_run will=
 fail
>> =A0 =A0 =A0 if size is greater than the default size
>> =A0 =A0b) A reshape attempt that reduces the default size to less th=
an the set
>> =A0 =A0 =A0 array size should be blocked
>> 2/ once userspace sets the size the kernel will not change it
>
> This holds only until the array is stopped and reassembled (for
> example due to a reboot). Is that correct and intended?

Yes.  For arrays that need this the size is recorded in the metadata,
so it will be persistent across reboots.  For the reshape-to-smaller
size cases mdadm will need to remember to set this accordingly.

>
>> +static ssize_t
>> +array_size_store(mddev_t *mddev, const char *buf, size_t len)
>> +{
>> + =A0 =A0 unsigned long long sectors;
>> + =A0 =A0 struct block_device *bdev;
>> +
>> + =A0 =A0 if (strncmp(buf, "default", 7) =3D=3D 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (mddev->pers)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sectors =3D mddev->pers->s=
ize(mddev, 0, 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sectors =3D mddev->array_s=
ectors;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 mddev->external_size =3D 0;
>> + =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 int err;
>> + =A0 =A0 =A0 =A0 =A0 =A0 sector_t new;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D strict_strtoull(buf, 10, &sectors)=
;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (err < 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return err;
>> + =A0 =A0 =A0 =A0 =A0 =A0 sectors *=3D 2;
>> + =A0 =A0 =A0 =A0 =A0 =A0 new =3D sectors;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (new !=3D sectors) /* overflow */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>
> Is it possible that already the "sectors *=3D 2" overflows? If this
> happens a much too small value is going to be stored by set_capacity(=
)
> later.

That is true.  If we overflow the blocks->sectors conversion we should
be returning an error.  This is also needs to be fixed up in
rdev_size_store and size_store.

>
>> + =A0 =A0 mddev->array_sectors =3D sectors;
>> + =A0 =A0 set_capacity(mddev->gendisk, mddev->array_sectors);
>> + =A0 =A0 if (mddev->pers) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 bdev =3D bdget_disk(mddev->gendisk, 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (bdev) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_lock(&bdev->bd_inode=
->i_mutex);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i_size_write(bdev->bd_inod=
e,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
(loff_t)mddev->array_sectors << 9);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&bdev->bd_ino=
de->i_mutex);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bdput(bdev);
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>
> bdev is only used inside the if (mddev->pers). No need to define it a=
t
> the top of the function.
>

ok

>> @@ -4043,7 +4108,17 @@ static int do_md_run(mddev_t * mddev)
>> =A0 =A0 =A0 err =3D mddev->pers->run(mddev);
>> =A0 =A0 =A0 if (err)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_ERR "md: pers->run() failed =
=2E..\n");
>> - =A0 =A0 else if (mddev->pers->sync_request) {
>> + =A0 =A0 else if (mddev->pers->size(mddev, 0, 0) < mddev->array_sec=
tors) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 WARN_ONCE(!mddev->external_size, "%s: defa=
ult size too small,"
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 " but 'external_size' =
not in effect?\n", __func__);
>> + =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_ERR
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"md: invalid array_size %ll=
u > default size %llu\n",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned long long)mddev->=
array_sectors / 2,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned long long)mddev->=
pers->size(mddev, 0, 0) / 2);
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D -EINVAL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 mddev->pers->stop(mddev);
>> + =A0 =A0 }
>
> What's the point of the WARN_ONCE() if it is followed by a printk() t=
hat
> is always being printed?
>

There is a subtle difference.  In both cases it is an error, but the
WARN_ONCE is checking for a kernel coding bug while the printk will
also trigger on a bad value from userspace.

>> =A0void md_set_size(mddev_t *mddev, sector_t array_sectors)
>> =A0{
>> + =A0 =A0 WARN(!mddev_is_locked(mddev), "%s: unlocked mddev!\n", __f=
unc__);
>
> An unlocked mddev would actually be a bug, no?

A bug, yes, but not a fatal one.  The user can now report the warning
and fix up the size because the system stayed running.

> Also, the name
> "md_set_size" is a bit unfortunate as an exported function name becau=
se
> it's not clear from the name that the size should be specified in
> sectors. "md_set_sector_count" or "md_set_array_sectors" is probably
> clearer.

Admittedly a minor issue, not much different than the lack of clarity
for set_capacity(), but I will go ahead and make this
md_set_array_sectors.

Thanks,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
