From: "Dan Williams" <dan.j.williams@gmail.com>
Subject: Re: raid 5 read performance
Date: Sat, 5 Aug 2006 10:31:39 -0700
Message-ID: <e9c3a7c20608051031v2e82c118sd08f7f9cddcca9ce@mail.gmail.com>
References: <5d96567b0606090850q6185e6a0u8b16860b4f826d4f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d96567b0606090850q6185e6a0u8b16860b4f826d4f@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

> Neil hello
>
> Sorry for the delay. too many things to do.
>
> I have implemented all said in :
> http://www.spinics.net/lists/raid/msg11838.html
>
> As always I have some questions:
>
> 1.  mergeable_bvec
>      I did not understand first i must admit. now i do not see how it
> differs from the
>      one of raid0.  so i  actually copied it and renamed it.
>
> 2. statistics.
>     i have added md statistics since the code does not reach the
> statics in make_request.
>     it returns from make_request before that.
>
> 3. i have added the new retry list called toread_aligned to raid5_conf_t .
>     hope this is correct.
>
> 4.  your instructions are to add a failed bio to sh, but it does not
> say to handle it directly.
>     i have tried it and something is missing here. raid5d handle
> stripes only if  conf->handle_list is not empty. i added handle_stripe
> and and release_stripe of my own.
>    this way i managed to get from the completion routine:
>    "R5: read error corrected!! " message . ( i have tested by failing
> a ram disk ).
>
>
> 5. I am going to test the non common path heavily before submitting
> you the patch ( on real disks  and use  several file systems and
> several chunk sizes).
>  It is quite a big patch so I need to know which kernel do you want me
> to use ? i am using poor 2.6.15.
>
> I thank you
> --
> Raz
Hi Raz,

What is the status of this patch?  Anything I can help out with, like
testing or forward porting to the latest kernel?

Thanks,

Dan
