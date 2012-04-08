From: Anuj Goel <talk2anuj@gmail.com>
Subject: Re: doubt in chunk_aligned_read()
Date: Sun, 8 Apr 2012 15:47:01 -0400
Message-ID: <CANSbrrpP-Bt96NFRX5WO1QvVHsQciP2G1H+RoQi8NPJ-RF1JCQ@mail.gmail.com>
References: <CANSbrrp_LByxog3q265ruHxJxxJRhE2SfvPgzx8EK4FyL-7KOg@mail.gmail.com>
 <20120405113800.4a1da21e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120405113800.4a1da21e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks for the hint !!

I have few more doubts in the function,

static int chunk_aligned_read(mddev_t *mddev, struct bio * raid_bio)

if all the preliminary checks pass, we increment active_aligned_reads
and call generic_make_request() which will add this bio to the
"current->bio_list".
This being an asynchronous read, chunk_aligned_read returns and the
result of the read will be notified by the registered callback
function "raid5_align_endio".
Based on this understanding, I have some questions below:

1. How and when is the read from the disk initiated ?

2. The bio passed to raid5_align_endio() is the one which was cloned
in chunk_aligned read(). The below statement in raid5_align_endio()
extracts the original bio :
struct bio* raid_bi  =3D bi->bi_private;
My doubt is in the assignment,
rdev =3D (void*)raid_bi->bi_next;
raid_bi is the original bio and its bi_next field should have been
pointing to the next bio in the request queue "current->bio_list"  (if
active_aligned_reads is > 0 ). How can this point to a rdev structure
? Or better put,  where do we make the bio->bi_next point to a rdev
struct ?

3. after this, we have,
    i) mddev =3D rdev->mddev;
    ii) conf =3D mddev->private;
    iii) rdev_dec_pending(rdev, conf->mddev);
In the call in line iii) we could have just sent the mddev retrieved
in line i). I am curious if there is a specific reason for reading it
again from the raid configuration struct "conf" ? Could there be a
case when mddev in line i) can be different from the conf->mddev in
line iii)  ??

On Wed, Apr 4, 2012 at 9:38 PM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 4 Apr 2012 21:25:53 -0400 Anuj Goel <talk2anuj@gmail.com> wro=
te:
>
>> HI Guys,
>>
>> Why is the below call needed in the function =A0chunk_aligned_read()
>>
>> =A0 =A0 =A0 align_bi =3D bio_clone_mddev(raid_bio, GFP_NOIO, mddev);
>>
>> Why do we need to create a clone of the bio passed to
>> chunk_aligned_read(mddev_t *mddev, struct bio * raid_bio) ??
>
> Think about what happens if the read fails.
>
> NeilBrown
>
>
>>
>> --
>> Best Regards,
>> Anuj Goel
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Regards,
Anuj Goel
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
