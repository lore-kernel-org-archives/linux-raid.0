Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0748BC4321E
	for <linux-raid@archiver.kernel.org>; Mon, 21 Nov 2022 15:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbiKUPLM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 21 Nov 2022 10:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbiKUPKy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 21 Nov 2022 10:10:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714CFCB696
        for <linux-raid@vger.kernel.org>; Mon, 21 Nov 2022 07:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669042867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WFs6khUkJnjNiuK64dmINLm8JpjmpHEqXteOsTAPoEM=;
        b=hBUpg+nVcdNvqDC3SvoCvdgttFdIBSqzax6dsrxR7LyyytjH8iP8h5SpJFaYC4uuwusHHi
        P7mU7eVotEaqVSyK6dswe84oVjPeBasOCXdyC2t2i7WYd/h3YZJmpmqhmmUCLzx5JSWi4B
        LTav5MAxCat9Fpj6gZLzSH9CVz0p4Ro=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-378-WCDoll1jPS2I1qCjw1b8Vg-1; Mon, 21 Nov 2022 10:01:05 -0500
X-MC-Unique: WCDoll1jPS2I1qCjw1b8Vg-1
Received: by mail-pl1-f198.google.com with SMTP id i8-20020a170902c94800b0018712ccd6bbso9486799pla.1
        for <linux-raid@vger.kernel.org>; Mon, 21 Nov 2022 07:01:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WFs6khUkJnjNiuK64dmINLm8JpjmpHEqXteOsTAPoEM=;
        b=fi1CQWoxhrUzxdA6a7TUXA/ePE+U6I/3PMJgx5PNrrXaFEkEQm7A3fpZk3mpVhLjbw
         sJl+vGQX1Dwp3eXRY9emoiYY1KFXq8A/0KMqbpjU9MalOyyDDc6u8ETaV50B2iA8YG0S
         MOBRt3SzNr/5lrUkTPcEPVpf+/HaqJkwg4tcJSpW+OPUmwmDX+IHW4qWl5/a2tqK18Yr
         T1jrRIz5EDt9HCKJhID/+WdRQRfiVzsyaOziJQpmb7WkgpPevvDVTTm5yYpPPpMSddRD
         JYg5cg1K+K8ycxxWDfoJog00JvyFkazqhVbsc7Dvs3qyYca+P6g/FJ8QeSvDZRL34t3g
         Ygmw==
X-Gm-Message-State: ANoB5pnt7/DQ/nD9KWu1Un32aXZ7neD2RnO7dlgRPO+lfnpHBvIBjL1S
        hFyVKEIauaz9X72pVQ7bZVeJU6fxqGtD4shwV5l3fWMeUWUn6TAObd5xje7adD6vgYZuns3IoQ3
        COXn3XmHg7BASvtOEqoIHxSYLsBWQtgGcNMPjAA==
X-Received: by 2002:a05:6a00:1348:b0:56b:e27f:76ee with SMTP id k8-20020a056a00134800b0056be27f76eemr2528025pfu.31.1669042862008;
        Mon, 21 Nov 2022 07:01:02 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6w3CG6bXiELdmxfS+nWIyQgmfRGb9vcxSic5vDPxoIRwfnPDS6EX9Xf3g2rVjnTcGJpdy9MeOZGug62j7RaDM=
X-Received: by 2002:a05:6a00:1348:b0:56b:e27f:76ee with SMTP id
 k8-20020a056a00134800b0056be27f76eemr2527974pfu.31.1669042861575; Mon, 21 Nov
 2022 07:01:01 -0800 (PST)
MIME-Version: 1.0
References: <20221116235009.79875-1-logang@deltatee.com> <20221116235009.79875-6-logang@deltatee.com>
In-Reply-To: <20221116235009.79875-6-logang@deltatee.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Mon, 21 Nov 2022 23:00:50 +0800
Message-ID: <CALTww2-e+K66J=hekxyc7rC7=yMrP-uiJPDgQWtiPuZSV29tYg@mail.gmail.com>
Subject: Re: [PATCH mdadm v5 5/7] mdadm: Add --write-zeros option for Create
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Kinga Tanska <kinga.tanska@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Logan

I did a test, but it always fails to create the raid device.
Maybe it's better to init interrupted to false?

[root@bogon mdadm]# mdadm -CR /dev/md0 -l5 -n3 /dev/nvme3n1
/dev/nvme4n1 /dev/nvme5n1 --size=10G --write-zeroes
...
mdadm: Defaulting to version 1.2 metadata
mdadm: zeroing data from 135266304 to 10737418240 on: /dev/nvme3n1
mdadm: zeroing data from 135266304 to 10737418240 on: /dev/nvme4n1
mdadm: zeroing data from 135266304 to 10737418240 on: /dev/nvme5n1
break for while
I'm here

[root@bogon mdadm]# git diff
diff --git a/Create.c b/Create.c
index 11636efb..aabb316c 100644
--- a/Create.c
+++ b/Create.c
@@ -203,8 +203,10 @@ static int wait_for_zero_forks(int *zero_pids, int count)
                        pr_info("Interrupting zeroing processes,
please wait...\n");
                        interrupted = true;
                } else if (fdsi.ssi_signo == SIGCHLD) {
-                       if (!--wait_count)
+                       if (!--wait_count) {
+                               printf("break for while\n");
                                break;
+                       }
                }
        }

@@ -220,8 +222,10 @@ static int wait_for_zero_forks(int *zero_pids, int count)
                        ret = 1;
        }

-       if (interrupted)
+       if (interrupted) {
+               printf("I'm here\n");
                return 1;
+       }

On Thu, Nov 17, 2022 at 7:50 AM Logan Gunthorpe <logang@deltatee.com> wrote:
>
> Add the --write-zeros option for Create which will send a write zeros
> request to all the disks before assembling the array. After zeroing
> the array, the disks will be in a known clean state and the initial
> sync may be skipped.
>
> Writing zeroes is best used when there is a hardware offload method
> to zero the data. But even still, zeroing can take several minutes on
> a large device. Because of this, all disks are zeroed in parallel using
> their own forked process and a message is printed to the user. The main
> process will proceed only after all the zeroing processes have completed
> successfully.
>
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Acked-by: Kinga Tanska <kinga.tanska@linux.intel.com>
> ---
>  Create.c | 173 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  ReadMe.c |   2 +
>  mdadm.c  |   9 +++
>  mdadm.h  |   5 ++
>  4 files changed, 187 insertions(+), 2 deletions(-)
>
> diff --git a/Create.c b/Create.c
> index 4acda30c5256..11636efbb12b 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -26,6 +26,10 @@
>  #include       "md_u.h"
>  #include       "md_p.h"
>  #include       <ctype.h>
> +#include       <fcntl.h>
> +#include       <signal.h>
> +#include       <sys/signalfd.h>
> +#include       <sys/wait.h>
>
>  static int round_size_and_verify(unsigned long long *size, int chunk)
>  {
> @@ -91,9 +95,146 @@ int default_layout(struct supertype *st, int level, int verbose)
>         return layout;
>  }
>
> +static pid_t write_zeroes_fork(int fd, struct shape *s, struct supertype *st,
> +                              struct mddev_dev *dv)
> +
> +{
> +       const unsigned long long req_size = 1 << 30;
> +       unsigned long long offset_bytes, size_bytes, sz;
> +       sigset_t sigset;
> +       int ret = 0;
> +       pid_t pid;
> +
> +       size_bytes = KIB_TO_BYTES(s->size);
> +
> +       /*
> +        * If size_bytes is zero, this is a zoned raid array where
> +        * each disk is of a different size and uses its full
> +        * disk. Thus zero the entire disk.
> +        */
> +       if (!size_bytes && !get_dev_size(fd, dv->devname, &size_bytes))
> +               return -1;
> +
> +       if (dv->data_offset != INVALID_SECTORS)
> +               offset_bytes = SEC_TO_BYTES(dv->data_offset);
> +       else
> +               offset_bytes = SEC_TO_BYTES(st->data_offset);
> +
> +       pr_info("zeroing data from %lld to %lld on: %s\n",
> +               offset_bytes, size_bytes, dv->devname);
> +
> +       pid = fork();
> +       if (pid < 0) {
> +               pr_err("Could not fork to zero disks: %m\n");
> +               return pid;
> +       } else if (pid != 0) {
> +               return pid;
> +       }
> +
> +       sigemptyset(&sigset);
> +       sigaddset(&sigset, SIGINT);
> +       sigprocmask(SIG_UNBLOCK, &sigset, NULL);
> +
> +       while (size_bytes) {
> +               /*
> +                * Split requests to the kernel into 1GB chunks seeing the
> +                * fallocate() call is not interruptible and blocking a
> +                * ctrl-c for several minutes is not desirable.
> +                *
> +                * 1GB is chosen as a compromise: the user may still have
> +                * to wait several seconds if they ctrl-c on devices that
> +                * zero slowly, but will reduce the number of requests
> +                * required and thus the overhead on devices that perform
> +                * better.
> +                */
> +               sz = size_bytes;
> +               if (sz >= req_size)
> +                       sz = req_size;
> +
> +               if (fallocate(fd, FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE,
> +                             offset_bytes, sz)) {
> +                       pr_err("zeroing %s failed: %m\n", dv->devname);
> +                       ret = 1;
> +                       break;
> +               }
> +
> +               offset_bytes += sz;
> +               size_bytes -= sz;
> +       }
> +
> +       exit(ret);
> +}
> +
> +static int wait_for_zero_forks(int *zero_pids, int count)
> +{
> +       int wstatus, ret = 0, i, sfd, wait_count = 0;
> +       struct signalfd_siginfo fdsi;
> +       bool interrupted;
> +       sigset_t sigset;
> +       ssize_t s;
> +
> +       for (i = 0; i < count; i++)
> +               if (zero_pids[i])
> +                       wait_count++;
> +       if (!wait_count)
> +               return 0;
> +
> +       sigemptyset(&sigset);
> +       sigaddset(&sigset, SIGINT);
> +       sigaddset(&sigset, SIGCHLD);
> +       sigprocmask(SIG_BLOCK, &sigset, NULL);
> +
> +       sfd = signalfd(-1, &sigset, 0);
> +       if (sfd < 0) {
> +               pr_err("Unable to create signalfd: %m");
> +               return 1;
> +       }
> +
> +       while (1) {
> +               s = read(sfd, &fdsi, sizeof(fdsi));
> +               if (s != sizeof(fdsi)) {
> +                       pr_err("Invalid signalfd read: %m");
> +                       close(sfd);
> +                       return 1;
> +               }
> +
> +               if (fdsi.ssi_signo == SIGINT) {
> +                       printf("\n");
> +                       pr_info("Interrupting zeroing processes, please wait...\n");
> +                       interrupted = true;
> +               } else if (fdsi.ssi_signo == SIGCHLD) {
> +                       if (!--wait_count)
> +                               break;
> +               }
> +       }
> +
> +       close(sfd);
> +
> +       for (i = 0; i < count; i++) {
> +               if (!zero_pids[i])
> +                       continue;
> +
> +               waitpid(zero_pids[i], &wstatus, 0);
> +               zero_pids[i] = 0;
> +               if (!WIFEXITED(wstatus) || WEXITSTATUS(wstatus))
> +                       ret = 1;
> +       }
> +
> +       if (interrupted)
> +               return 1;
> +
> +       if (ret)
> +               pr_err("zeroing failed!\n");
> +       else
> +               pr_info("zeroing finished\n");
> +
> +       return ret;
> +}
> +
>  static int add_disk_to_super(int mdfd, struct shape *s, struct context *c,
>                 struct supertype *st, struct mddev_dev *dv,
> -               struct mdinfo *info, int have_container, int major_num)
> +               struct mdinfo *info, int have_container, int major_num,
> +               int *zero_pid)
>  {
>         dev_t rdev;
>         int fd;
> @@ -148,6 +289,14 @@ static int add_disk_to_super(int mdfd, struct shape *s, struct context *c,
>         }
>         st->ss->getinfo_super(st, info, NULL);
>
> +       if (fd >= 0 && s->write_zeroes) {
> +               *zero_pid = write_zeroes_fork(fd, s, st, dv);
> +               if (*zero_pid <= 0) {
> +                       ioctl(mdfd, STOP_ARRAY, NULL);
> +                       return 1;
> +               }
> +       }
> +
>         if (have_container && c->verbose > 0)
>                 pr_err("Using %s for device %d\n",
>                        map_dev(info->disk.major, info->disk.minor, 0),
> @@ -224,10 +373,23 @@ static int add_disks(int mdfd, struct mdinfo *info, struct shape *s,
>  {
>         struct mddev_dev *moved_disk = NULL;
>         int pass, raid_disk_num, dnum;
> +       int zero_pids[total_slots];
>         struct mddev_dev *dv;
>         struct mdinfo *infos;
> +       sigset_t sigset, orig_sigset;
>         int ret = 0;
>
> +       /*
> +        * Block SIGINT so the main thread will always wait for the
> +        * zeroing processes when being interrupted. Otherwise the
> +        * zeroing processes will finish their work in the background
> +        * keeping the disk busy.
> +        */
> +       sigemptyset(&sigset);
> +       sigaddset(&sigset, SIGINT);
> +       sigprocmask(SIG_BLOCK, &sigset, &orig_sigset);
> +       memset(zero_pids, 0, sizeof(zero_pids));
> +
>         infos = xmalloc(sizeof(*infos) * total_slots);
>         enable_fds(total_slots);
>         for (pass = 1; pass <= 2; pass++) {
> @@ -261,7 +423,7 @@ static int add_disks(int mdfd, struct mdinfo *info, struct shape *s,
>
>                                 ret = add_disk_to_super(mdfd, s, c, st, dv,
>                                                 &infos[dnum], have_container,
> -                                               major_num);
> +                                               major_num, &zero_pids[dnum]);
>                                 if (ret)
>                                         goto out;
>
> @@ -287,6 +449,10 @@ static int add_disks(int mdfd, struct mdinfo *info, struct shape *s,
>                 }
>
>                 if (pass == 1) {
> +                       ret = wait_for_zero_forks(zero_pids, total_slots);
> +                       if (ret)
> +                               goto out;
> +
>                         ret = update_metadata(mdfd, s, st, map, info,
>                                               chosen_name);
>                         if (ret)
> @@ -295,7 +461,10 @@ static int add_disks(int mdfd, struct mdinfo *info, struct shape *s,
>         }
>
>  out:
> +       if (ret)
> +               wait_for_zero_forks(zero_pids, total_slots);
>         free(infos);
> +       sigprocmask(SIG_SETMASK, &orig_sigset, NULL);
>         return ret;
>  }
>
> diff --git a/ReadMe.c b/ReadMe.c
> index 50a5e36d05fc..9424bfc3eeca 100644
> --- a/ReadMe.c
> +++ b/ReadMe.c
> @@ -138,6 +138,7 @@ struct option long_options[] = {
>      {"size",     1, 0, 'z'},
>      {"auto",     1, 0, Auto}, /* also for --assemble */
>      {"assume-clean",0,0, AssumeClean },
> +    {"write-zeroes",0,0, WriteZeroes },
>      {"metadata",  1, 0, 'e'}, /* superblock format */
>      {"bitmap",   1, 0, Bitmap},
>      {"bitmap-chunk", 1, 0, BitmapChunk},
> @@ -390,6 +391,7 @@ char Help_create[] =
>  "  --write-journal=      : Specify journal device for RAID-4/5/6 array\n"
>  "  --consistency-policy= : Specify the policy that determines how the array\n"
>  "                     -k : maintains consistency in case of unexpected shutdown.\n"
> +"  --write-zeroes        : Write zeroes to the disks before creating. This will bypass initial sync.\n"
>  "\n"
>  ;
>
> diff --git a/mdadm.c b/mdadm.c
> index 972adb524dfb..141838bd394f 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -602,6 +602,10 @@ int main(int argc, char *argv[])
>                         s.assume_clean = 1;
>                         continue;
>
> +               case O(CREATE, WriteZeroes):
> +                       s.write_zeroes = 1;
> +                       continue;
> +
>                 case O(GROW,'n'):
>                 case O(CREATE,'n'):
>                 case O(BUILD,'n'): /* number of raid disks */
> @@ -1306,6 +1310,11 @@ int main(int argc, char *argv[])
>                 }
>         }
>
> +       if (s.write_zeroes && !s.assume_clean) {
> +               pr_info("Disk zeroing requested, setting --assume-clean to skip resync\n");
> +               s.assume_clean = 1;
> +       }
> +
>         if (!mode && devs_found) {
>                 mode = MISC;
>                 devmode = 'Q';
> diff --git a/mdadm.h b/mdadm.h
> index 18c24915e94c..82e920fb523a 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -273,6 +273,9 @@ static inline void __put_unaligned32(__u32 val, void *p)
>
>  #define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))
>
> +#define KIB_TO_BYTES(x)        ((x) << 10)
> +#define SEC_TO_BYTES(x)        ((x) << 9)
> +
>  extern const char Name[];
>
>  struct md_bb_entry {
> @@ -433,6 +436,7 @@ extern char Version[], Usage[], Help[], OptionHelp[],
>   */
>  enum special_options {
>         AssumeClean = 300,
> +       WriteZeroes,
>         BitmapChunk,
>         WriteBehind,
>         ReAdd,
> @@ -593,6 +597,7 @@ struct shape {
>         int     bitmap_chunk;
>         char    *bitmap_file;
>         int     assume_clean;
> +       bool    write_zeroes;
>         int     write_behind;
>         unsigned long long size;
>         unsigned long long data_offset;
> --
> 2.30.2
>

