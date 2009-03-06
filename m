From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/3] md: add 'size' as a personality method
Date: Fri, 6 Mar 2009 10:55:52 -0700
Message-ID: <e9c3a7c20903060955n1689eaer22e37da2b0e9cba2@mail.gmail.com>
References: <20090306002341.9882.61625.stgit@dwillia2-linux.ch.intel.com>
	 <20090306002448.9882.88409.stgit@dwillia2-linux.ch.intel.com>
	 <20090306161551.GI32416@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090306161551.GI32416@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, jacek.danecki@intel.com
List-Id: linux-raid.ids

On Fri, Mar 6, 2009 at 9:15 AM, Andre Noll <maan@systemlinux.org> wrote=
:
> On 17:24, Dan Williams wrote:
>> +raid10_size(mddev_t *mddev, sector_t sectors, int raid_disks)
>> +{
>> + =A0 =A0 sector_t size;
>> + =A0 =A0 int chunk_shift;
>> + =A0 =A0 conf_t *conf =3D mddev_to_conf(mddev);
>> + =A0 =A0 int chunk_size =3D mddev->chunk_size;
>> +
>> + =A0 =A0 if (!raid_disks)
>> + =A0 =A0 =A0 =A0 =A0 =A0 raid_disks =3D mddev->raid_disks;
>> + =A0 =A0 if (!sectors)
>> + =A0 =A0 =A0 =A0 =A0 =A0 sectors =3D mddev->dev_sectors;
>> +
>> + =A0 =A0 chunk_shift =3D ffz(~chunk_size) - 9;
>> + =A0 =A0 size =3D sectors >> chunk_shift;
>> + =A0 =A0 sector_div(size, conf->far_copies);
>> + =A0 =A0 size =3D size * raid_disks;
>> + =A0 =A0 sector_div(size, conf->near_copies);
>> +
>> + =A0 =A0 return size << chunk_shift;
>> +}
>
> Is there a reason you are recomputing chunk_shift instead of using
> conf->chunk_shift.
>

This is a leftover from an earlier version of the patch where I was
allowing chunk_size to specified.  Since we do not support chunk_size
reshaping I dropped the extra argument, will clean this up as well.

>> +static sector_t
>> +raid5_size(mddev_t *mddev, sector_t sectors, int raid_disks)
>> +{
>> + =A0 =A0 raid5_conf_t *conf =3D mddev_to_conf(mddev);
>> + =A0 =A0 int chunk_size =3D mddev->chunk_size;
>> +
>> + =A0 =A0 if (!sectors)
>> + =A0 =A0 =A0 =A0 =A0 =A0 sectors =3D mddev->dev_sectors;
>> + =A0 =A0 if (!raid_disks)
>> + =A0 =A0 =A0 =A0 =A0 =A0 raid_disks =3D conf->previous_raid_disks;
>> +
>> + =A0 =A0 sectors &=3D ~(chunk_size / 512 - 1);
>
> Don't we need a cast to sector_t here?
>

Yes.

Thanks,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
