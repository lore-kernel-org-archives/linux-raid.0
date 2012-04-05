From: Anuj Goel <talk2anuj@gmail.com>
Subject: Re: doubt in chunk_aligned_read()
Date: Wed, 4 Apr 2012 21:56:26 -0400
Message-ID: <CANSbrrrcL4jpder74Dhpx3sxKFOjD=ywCc8=Gcf24Tb7tOUfNg@mail.gmail.com>
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

cool :)
Thanks !!

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
>> Experimental Computer Science Lab
>> Stony Brook University.
>> Cell: +1-801-209-5873
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Regards,
Anuj Goel
Experimental Computer Science Lab
Stony Brook University.
Cell: +1-801-209-5873
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
