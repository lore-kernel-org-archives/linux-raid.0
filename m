From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: [PATCH] Assemble: print error message if mdadm fails assembling
 with --uuid option
Date: Thu, 16 Apr 2020 10:45:38 +0200
Message-ID: <261f11dd-9532-75dd-b068-87d04de5feb6@cloud.ionos.com>
References: <20190416160817.10526-1-gi-oh.kim@cloud.ionos.com>
 <CA+res+ThMMp0HDfECEwbt-L+F0MD77hKe0TvN+AwPF1c9REYDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+res+ThMMp0HDfECEwbt-L+F0MD77hKe0TvN+AwPF1c9REYDg@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: jes@trained-monkey.org
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Jes,

Could you consider to merge this one before release 4.2?

Thanks,
Guoqing

> Subject: [PATCH] Assemble: print error message if mdadm fails
> assembling with --uuid option
> To: <linux-raid@vger.kernel.org>
> Cc: <neilb@suse.com>, <jsorensen@fb.com>,
> <jinpu.wang@cloud.ionos.com>, Gioh Kim <gi-oh.kim@cloud.ionos.com>
>
>
> When mdadm tries to assemble one working device and one zeroed-out device,
> it failed but print successful message because there is --uuid option.
>
> Following script always reproduce it.
>
> dd if=/dev/zero of=/dev/ram0 oflag=direct
> dd if=/dev/zero of=/dev/ram1 oflag=direct
> ./mdadm -C /dev/md111 -e 1.2 --uuid="12345678:12345678:12345678:12345678" \
>      -l1 -n2 /dev/ram0 /dev/ram1
> ./mdadm -S /dev/md111
> dd if=/dev/zero of=/dev/ram1 oflag=direct
> ./mdadm -A /dev/md111 --uuid="12345678:12345678:12345678:12345678" \
>      /dev/ram0 /dev/ram1
>
> Following is message from mdadm.
>
> mdadm: No super block found on /dev/ram1 (Expected magic a92b4efc, got 00000000)
> mdadm: no RAID superblock on /dev/ram1
> mdadm: /dev/md111 assembled from 1 drive - need all 2 to start it (use
> --run to insist).
>
> The mdadm say that it assembled but mdadm does not create /dev/md111.
> The message is wrong.
>
> After applying this patch, mdadm reports error correctly as following.
>
> mdadm: No super block found on /dev/ram1 (Expected magic a92b4efc, got 00000000)
> mdadm: no RAID superblock on /dev/ram1
> mdadm: /dev/ram1 has no superblock - assembly aborted
>
> Signed-off-by: Gioh Kim <gi-oh.kim@cloud.ionos.com>
> ---
>   Assemble.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Assemble.c b/Assemble.c
> index 420c7b3..c1542f9 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -269,7 +269,7 @@ static int select_devices(struct mddev_dev *devlist,
>                          if (auto_assem || !inargv)
>                                  /* Ignore unrecognised devices during
> auto-assembly */
>                                  goto loop;
> -                       if (ident->uuid_set || ident->name[0] ||
> +                       if (ident->name[0] ||
>                              ident->super_minor != UnSet)
>                                  /* Ignore unrecognised device if looking for
>                                   * specific array */
> --
> 2.19.1
