From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: linear raid : mddev not protected in linear_add
Date: Wed, 20 May 2009 21:40:01 +0530
Message-ID: <37d33d830905200910u6066b668p968604477991ec5c@mail.gmail.com>
References: <37d33d830905190523l1ae7536al83ed1255cba3050d@mail.gmail.com>
	 <18963.14770.706341.139054@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18963.14770.706341.139054@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

On Wed, May 20, 2009 at 4:28 AM, Neil Brown <neilb@suse.de> wrote:
> On Tuesday May 19, sandeepksinha@gmail.com wrote:
>> Hi,
>>
>> In linear_add( ), the mddev is gets changed.
>> Don't we require to lock/unlock around mddev inorder to avoid races?
>>
>
> A good question.
>
> To be able to answer it, we must also ask "what races do we need to
> avoid". =A0Did you have some possible races in mind?
>

I see mddev being referenced in md.c (md layer) for lot of operations.
Actually for almost all operations we pass through it. i.e get array
info.

> In linear add there are 3 lines which are in an important order:
>
> =A0 =A0 =A0 =A0mddev->private =3D newconf;
> =A0 =A0 =A0 =A0mddev->raid_disks++;
> =A0 =A0 =A0 =A0....
> =A0 =A0 =A0 =A0set_capacity(mddev->gendisk, mddev->array_sectors);
>
> Until raid_disks in incremented, there will be no attempt to access
> the extra information in ->private.
> Until the set_capacity, there will be no attempt to send IO beyond th=
e
> reach of raid_disks.
> So except that it might be wise to insert some barrier()s, it looks
> OK.... =A0or it did.
>
> I just noticed that the new 'which_dev' checks mddev->raid_disks,
> where as the old which_dev did not.
>
> So if:
> =A0which_dev takes a copy of mddev->private,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 linear_ad=
d changes mddev->private
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 linear_ad=
d changes raid_disks
> =A0which_dev takes a copy of mddev->raid_disks
>
> then which_dev will have a raid_disks which points beyond the end of
> conf->disks. =A0If the target sector were beyond the end of the origi=
nal
> array, we could fall off the end of that array which would be bad.
> However as the sector number will have been tested again the size of
> the array (in bio_check_eod from generic_make_request), that cannot
> happen. =A0Unless which_dev was called from linear_mergeable_bvec...
>
Yes, this is true.

> I suspect in light of this it would be best to:
> =A01/ insert a barrier() between setting ->private and setting
> =A0 =A0 =A0->raid_disks
> =A02/ in which_dev, read ->raid_disks before ->private, and put a
> =A0 =A0 =A0barrier in between.
>

Do you suggest implementing barrier functions for linear raid?
Can you elaborate on this a bit more please?

> We could possibly use rcu_dereference and rcu_assign_pointer, and
> maybe even make use of rcu to free the old conf structure promptly
> rather than keeping it around until the array is stopped.
> That would require careful placement of rcu_read_{,un}lock around
> access to ->private.
>
> Probably best to just put barriers in for now, and leave the rcu
> stuff.
>
k.
> NeilBrown
>
>
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
