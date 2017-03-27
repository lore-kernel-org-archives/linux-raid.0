From: =?UTF-8?B?546L6YeR5rWm?= <jinpuwang@gmail.com>
Subject: Re: [mdadm PATCH 2/5] Retry HOT_REMOVE_DISK a few times.
Date: Mon, 27 Mar 2017 09:51:56 +0200
Message-ID: <CAD9gYJLxPR14ep3B7f5EGF1hSqYZ1fVNAUW+iJeoy5zjMDwA_Q@mail.gmail.com>
References: <149058575542.15679.9804611071393072863.stgit@noble> <149058581564.15679.7099618010536570804.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <149058581564.15679.7099618010536570804.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Jes Sorensen <jes.sorensen@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,
>
> +int hot_remove_disk(int mdfd, unsigned long dev)
> +{
> +       int cnt = 5;
> +       int ret;
> +
> +       /* HOT_REMOVE_DISK can fail with EBUSY if there are
> +        * outstanding IO requests to the device.
> +        * In this case, it can be helpful to wait a little while,
> +        * up to half a second, for that IO to flush.
> +        */
> +       while ((ret = ioctl(mdfd, HOT_REMOVE_DISK, dev)) == -1 &&
> +              errno == EBUSY &&
> +              cnt-- > 0)
> +               usleep(10000);
> +
> +       return ret;
> +}
The comments is different with the code, 50000 us = 50 ms not half a seconds.

Other than that.

It looks good to me!

Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>

Thanks,
Jack

> +
>  int set_array_info(int mdfd, struct supertype *st, struct mdinfo *info)
>  {
>         /* Initialise kernel's knowledge of array.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
