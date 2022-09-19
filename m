Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB212ECAAD3
	for <linux-raid@archiver.kernel.org>; Mon, 19 Sep 2022 08:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiISIlz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 19 Sep 2022 04:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiISIlv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 19 Sep 2022 04:41:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2204411A2F
        for <linux-raid@vger.kernel.org>; Mon, 19 Sep 2022 01:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663576909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6o21+BqPPBZ+0uYSBm/DhTHOUbJFt1cD1MEC4N9iKsU=;
        b=MaJ1esQs1qmyB30pvEuzoBN4qZvGflshEnCSWHPDJW9O49HDXVSJpuSeUgKLMVjxx/6/v5
        E5QiK9he5PFwr/nH/+d+D/LGxeSyhEZMs7faquVH6MhSMoQZ5GrSSlxgKdRqRsu0uBGYxH
        xdD2Rw8SVIyjiF5J2ZaTtBmqPxFGyWs=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-247-QWbEt258N_iEGgHp_WFlzg-1; Mon, 19 Sep 2022 04:41:47 -0400
X-MC-Unique: QWbEt258N_iEGgHp_WFlzg-1
Received: by mail-pf1-f198.google.com with SMTP id a3-20020aa795a3000000b0054b94ce7d12so4391515pfk.17
        for <linux-raid@vger.kernel.org>; Mon, 19 Sep 2022 01:41:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=6o21+BqPPBZ+0uYSBm/DhTHOUbJFt1cD1MEC4N9iKsU=;
        b=HGsMMISUsL7dJ5oGpMe8eDVtUPFG35D72BacPLAhoZR/UyQDDzWBT8vJC6pk/58wJm
         DB9noxnArEu4VEPqPADq1XkFnRAg+ZGMhUm7+XJ1mx/vMBKu8g0eVsSl55Z4TqrRWwqI
         4I5MGiwR/c02YcdBuT3/9AHGOEG/qyiRZjgeLpR9EaVO78IvY3sc1cyRRIiieYhetefp
         lFylTqyUOkjC0IdhCnmDP9BdLQSIa06YQT9tWrwhxyJBtJiPCCdA7q3M5djfP+QBKqYg
         uvGVipftv6HRAmcHHT1X5ppFdoXnmo3eAWc1XVslVj6X4+hX1ZM3bKuKk9tTXd0SiP5c
         ijtQ==
X-Gm-Message-State: ACrzQf3ETD5KriUl1WBhVFPm3/L4b2MpyQ5fQdvp0Aael/TMNLIWxiZj
        yxBxbJIbaU80J+7/sNhnlYoTlvP+N+CgKdrc7APe2DEibmI3PqQi2mx4BrHOXxFDqH1o8jECPgP
        BJdj4McldJuex3hWM08BxwVvWov5kSGz2/yH+lA==
X-Received: by 2002:a17:90b:4c46:b0:203:7c2a:defe with SMTP id np6-20020a17090b4c4600b002037c2adefemr8784996pjb.40.1663576906890;
        Mon, 19 Sep 2022 01:41:46 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7cgAV/DhplUyNpvysMgUYOzQbWDtum+hyN9uEcftTZfTSV2f52kn+rO0ZbGpfI+9DSSn8hzurazCaA4GGB+p0=
X-Received: by 2002:a17:90b:4c46:b0:203:7c2a:defe with SMTP id
 np6-20020a17090b4c4600b002037c2adefemr8784982pjb.40.1663576906571; Mon, 19
 Sep 2022 01:41:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220908230847.5749-1-logang@deltatee.com> <20220908230847.5749-2-logang@deltatee.com>
In-Reply-To: <20220908230847.5749-2-logang@deltatee.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Mon, 19 Sep 2022 16:41:35 +0800
Message-ID: <CALTww29eUptrS6kmxZ6N3u1T0Q_+o2PyjY09cdd9vzbcDsU9Bw@mail.gmail.com>
Subject: Re: [PATCH mdadm v2 1/2] mdadm: Add --discard option for Create
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Sep 9, 2022 at 7:09 AM Logan Gunthorpe <logang@deltatee.com> wrote:
>
> Add the --discard option for Create which will send BLKDISCARD requests to
> all disks before assembling the array. This is a fast way to know the
> current state of all the disks. If the discard request zeros the data
> on the disks (as is common but not universal) then the array is in a
> state with correct parity. Thus the initial sync may be skipped.
>
> After issuing each discard request, check if the first page of the
> block device is zero. If it is, it is safe to assume the entire
> disk should be zero. If it's not report an error.
>
> If all the discard requests are successful and there are no missing
> disks thin it is safe to set assume_clean as we know the array is clean.
>
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---
>  Create.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++----
>  ReadMe.c |  1 +
>  mdadm.c  |  4 ++++
>  mdadm.h  |  2 ++
>  4 files changed, 58 insertions(+), 4 deletions(-)
>
> diff --git a/Create.c b/Create.c
> index e06ec2ae96a1..52bb88bccd53 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -26,6 +26,12 @@
>  #include       "md_u.h"
>  #include       "md_p.h"
>  #include       <ctype.h>
> +#include       <sys/ioctl.h>
> +
> +#ifndef BLKDISCARD
> +#define BLKDISCARD _IO(0x12,119)
> +#endif
> +#include       <fcntl.h>
>
>  static int round_size_and_verify(unsigned long long *size, int chunk)
>  {
> @@ -91,6 +97,38 @@ int default_layout(struct supertype *st, int level, int verbose)
>         return layout;
>  }
>
> +static int discard_device(struct context *c, int fd, const char *devname,
> +                         unsigned long long offset, unsigned long long size)
> +{
> +       uint64_t range[2] = {offset, size};
> +       unsigned long buf[4096 / sizeof(unsigned long)];
> +       unsigned long i;
> +
> +       if (c->verbose)
> +               printf("discarding data from %lld to %lld on: %s\n",
> +                      offset, size, devname);
> +
> +       if (ioctl(fd, BLKDISCARD, &range)) {
> +               pr_err("discard failed on '%s': %m\n", devname);
> +               return 1;
> +       }
> +
> +       if (pread(fd, buf, sizeof(buf), offset) != sizeof(buf)) {
> +               pr_err("failed to readback '%s' after discard: %m\n", devname);
> +               return 1;
> +       }
> +
> +       for (i = 0; i < ARRAY_SIZE(buf); i++) {
> +               if (buf[i]) {
> +                       pr_err("device did not read back zeros after discard on '%s': %lx\n",
> +                              devname, buf[i]);
> +                       return 1;
> +               }
> +       }
> +
> +       return 0;
> +}
> +
>  int Create(struct supertype *st, char *mddev,
>            char *name, int *uuid,
>            int subdevs, struct mddev_dev *devlist,
> @@ -607,7 +645,7 @@ int Create(struct supertype *st, char *mddev,
>          * as missing, so that a reconstruct happens (faster than re-parity)
>          * FIX: Can we do this for raid6 as well?
>          */
> -       if (st->ss->external == 0 && s->assume_clean == 0 &&
> +       if (st->ss->external == 0 && s->assume_clean == 0 && s->discard == 0 &&
>             c->force == 0 && first_missing >= s->raiddisks) {
>                 switch (s->level) {
>                 case 4:
> @@ -624,8 +662,8 @@ int Create(struct supertype *st, char *mddev,
>         /* For raid6, if creating with 1 missing drive, make a good drive
>          * into a spare, else the create will fail
>          */
> -       if (s->assume_clean == 0 && c->force == 0 && first_missing < s->raiddisks &&
> -           st->ss->external == 0 &&
> +       if (s->assume_clean == 0 && s->discard == 0 && c->force == 0 &&
> +           first_missing < s->raiddisks && st->ss->external == 0 &&
>             second_missing >= s->raiddisks && s->level == 6) {
>                 insert_point = s->raiddisks - 1;
>                 if (insert_point == first_missing)
> @@ -686,7 +724,7 @@ int Create(struct supertype *st, char *mddev,
>              (insert_point < s->raiddisks || first_missing < s->raiddisks)) ||
>             (s->level == 6 && (insert_point < s->raiddisks ||
>                                second_missing < s->raiddisks)) ||
> -           (s->level <= 0) || s->assume_clean) {
> +           (s->level <= 0) || s->assume_clean || s->discard) {
>                 info.array.state = 1; /* clean, but one+ drive will be missing*/
>                 info.resync_start = MaxSector;
>         } else {
> @@ -945,6 +983,15 @@ int Create(struct supertype *st, char *mddev,
>                                 }
>                                 if (fd >= 0)
>                                         remove_partitions(fd);
> +
> +                               if (s->discard &&
> +                                   discard_device(c, fd, dv->devname,
> +                                                  dv->data_offset << 9,
> +                                                  s->size << 10)) {
> +                                       ioctl(mdfd, STOP_ARRAY, NULL);
> +                                       goto abort_locked;
> +                               }
> +

Hi Logan

When creating a raid device without specifying data offset,
dv->data_offset is always 1 (INVALID_SECTORS).
If users specify data offset, we need to use dv->data_offset. If users
don't specify it, we need to use
st->data_offset.

For super1, in the function write_init_super1, before writing
superblock to disk, it checks data_offset. If it's
INVALID_SECTORS, it will use st->data_offset (the default value of
specific superblock)

And for s->size, if the raid device is a raid0, s->size is 0 here. I
see you and Mariusz talked about the raid0
zone. If the raid0 is created with disks of different size, it can
have more than one zone.
e.g.  disk1(10G)   disk2(20G)  disk3(30G)
disk1   disk2    disk3
10G     10G      10G  (zone0)
            10G      10G  (zone1)  (The zone1 is behind zone0)
                         10G  (zone2)

If the user doesn't specify size, it will use all space of the disk
and create zones and we can discard
the whole disk in this situation.

Regards
Xiao

>                                 if (st->ss->add_to_super(st, &inf->disk,
>                                                          fd, dv->devname,
>                                                          dv->data_offset)) {
> diff --git a/ReadMe.c b/ReadMe.c
> index 7f94847e9769..544a057f83a0 100644
> --- a/ReadMe.c
> +++ b/ReadMe.c
> @@ -138,6 +138,7 @@ struct option long_options[] = {
>      {"size",     1, 0, 'z'},
>      {"auto",     1, 0, Auto}, /* also for --assemble */
>      {"assume-clean",0,0, AssumeClean },
> +    {"discard",          0, 0, Discard },
>      {"metadata",  1, 0, 'e'}, /* superblock format */
>      {"bitmap",   1, 0, Bitmap},
>      {"bitmap-chunk", 1, 0, BitmapChunk},
> diff --git a/mdadm.c b/mdadm.c
> index 972adb524dfb..049cdce1cdd2 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -602,6 +602,10 @@ int main(int argc, char *argv[])
>                         s.assume_clean = 1;
>                         continue;
>
> +               case O(CREATE, Discard):
> +                       s.discard = true;
> +                       continue;
> +
>                 case O(GROW,'n'):
>                 case O(CREATE,'n'):
>                 case O(BUILD,'n'): /* number of raid disks */
> diff --git a/mdadm.h b/mdadm.h
> index 941a5f3823a0..a1e0bc9f01ad 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -433,6 +433,7 @@ extern char Version[], Usage[], Help[], OptionHelp[],
>   */
>  enum special_options {
>         AssumeClean = 300,
> +       Discard,
>         BitmapChunk,
>         WriteBehind,
>         ReAdd,
> @@ -593,6 +594,7 @@ struct shape {
>         int     bitmap_chunk;
>         char    *bitmap_file;
>         int     assume_clean;
> +       bool    discard;
>         int     write_behind;
>         unsigned long long size;
>         unsigned long long data_offset;
> --
> 2.30.2
>

