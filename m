Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60245C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 23 Mar 2022 09:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbiCWJEO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Mar 2022 05:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233051AbiCWJEN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 23 Mar 2022 05:04:13 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FF672E2D
        for <linux-raid@vger.kernel.org>; Wed, 23 Mar 2022 02:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648026164; x=1679562164;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=qkVoFqNSTUwnat+X8Db4x1ZJDo75is82seezVZhUOfA=;
  b=aFgl8NrAmrAKYhAJihwMEA7MW1GGGSIv7IatvPjILE072tWpIi98g51y
   ZvXWT47GPFpt4QKdGCgyE71rNDDnKGCD73L7Otz23R0GURUGJy/r5gpTr
   kZZa0LjQah2e1M+6116mocqp9isgZZHQ0fsd2gtRiGZTQOaRPgo55Szn+
   OoxRF4pjO7iqUs5WuEOPt9tWYltMfJtckpPHCnHMl0ihLs3bUNVSmyaP+
   pLdP6zuoTIO1Djnwp6DGPzuT50cMkOJDvQJHXKyFq57jWZN0WJC5TgW0z
   b5kPKTaH0panWuu9H7nPP5iJDBRurBNtZoW5FbXMX5fXvTpmFEngZ7lyJ
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10294"; a="344493635"
X-IronPort-AV: E=Sophos;i="5.90,203,1643702400"; 
   d="scan'208";a="344493635"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 02:02:43 -0700
X-IronPort-AV: E=Sophos;i="5.90,203,1643702400"; 
   d="scan'208";a="560808282"
Received: from ktanska-mobl.ger.corp.intel.com (HELO [10.252.58.48]) ([10.252.58.48])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 02:02:42 -0700
Message-ID: <9a062f0c-fcea-c543-3a46-05395c747fcd@linux.intel.com>
Date:   Wed, 23 Mar 2022 10:02:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From:   "Tanska, Kinga" <kinga.tanska@linux.intel.com>
Subject: Re: [PATCH] Mdmonitor: Fix segfault and improve logging
To:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Kinga Tanska <kinga.tanska@intel.com>
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org, colyli@suse.de
References: <20220321123234.28769-1-kinga.tanska@intel.com>
 <e5502af7-be1c-da7f-af3d-ca36d45e6301@molgen.mpg.de>
In-Reply-To: <e5502af7-be1c-da7f-af3d-ca36d45e6301@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

I will send splitted patches in next messages. There are steps to reproduce:

1. Stop mdmonitor instance e.g.

# systemctl stop mdmonitor

2. Run mdmonitor for non-md device e.g.

# mdadm --monitor /dev/nvme1n1


Call trace:

#0  0x00007ffff7617518 in __strcpy_sse2_unaligned () from 
/usr/lib64/libc.so.6
#1  0x000000000042bc9e in check_array ()
#2  0x000000000042c7af in Monitor ()
#3  0x0000000000406edc in main ()


Regards,

Kinga Tanska


On 3/21/2022 1:45 PM, Paul Menzel wrote:
Dear Kinga, dear Oleksandr,


Am 21.03.22 um 13:32 schrieb Kinga Tanska:
> From: Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>
>
> Check that devices passed to mdmonitor are md arrays.
> Also, change logging, so mdmonitor in verbose mode will report its
> configuration.

Thank you for the patch. As these are two distinct changes, could you 
please split it into two commits?

If you could add a reproducer the segmentation fault, that’d also be great.


Kind regards,

Paul


> Signed-off-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> ---
>   Monitor.c | 36 ++++++++++++++++++++++++------------
>   mdadm.h   |  1 +
>   mdopen.c  | 17 +++++++++++++++++
>   util.c    |  2 +-
>   4 files changed, 43 insertions(+), 13 deletions(-)
>
> diff --git a/Monitor.c b/Monitor.c
> index f5412299..bd417d04 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -137,24 +137,27 @@ int Monitor(struct mddev_dev *devlist,
>       struct mddev_ident *mdlist;
>       int delay_for_event = c->delay;
>   -    if (!mailaddr) {
> +    if (!mailaddr)
>           mailaddr = conf_get_mailaddr();
> -        if (mailaddr && ! c->scan)
> -            pr_err("Monitor using email address \"%s\" from config 
> file\n",
> -                   mailaddr);
> -    }
> -    mailfrom = conf_get_mailfrom();
>   -    if (!alert_cmd) {
> +    if (!alert_cmd)
>           alert_cmd = conf_get_program();
> -        if (alert_cmd && !c->scan)
> -            pr_err("Monitor using program \"%s\" from config file\n",
> -                   alert_cmd);
> -    }
> +
> +    mailfrom = conf_get_mailfrom();
> +
>       if (c->scan && !mailaddr && !alert_cmd && !dosyslog) {
>           pr_err("No mail address or alert command - not monitoring.\n");
>           return 1;
>       }
> +
> +    if (c->verbose) {
> +        pr_err("Monitor is started with delay %ds\n", c->delay);
> +        if (mailaddr)
> +            pr_err("Monitor using email address %s\n", mailaddr);
> +        if (alert_cmd)
> +            pr_err("Monitor using program %s\n", alert_cmd);
> +    }
> +
>       info.alert_cmd = alert_cmd;
>       info.mailaddr = mailaddr;
>       info.mailfrom = mailfrom;
> @@ -183,6 +186,10 @@ int Monitor(struct mddev_dev *devlist,
>                   continue;
>               if (strcasecmp(mdlist->devname, "<ignore>") == 0)
>                   continue;
> +
> +            if (!is_mddev(mdlist->devname))
> +                return 1;
> +
>               st = xcalloc(1, sizeof *st);
>               if (mdlist->devname[0] == '/')
>                   st->devname = xstrdup(mdlist->devname);
> @@ -204,7 +211,12 @@ int Monitor(struct mddev_dev *devlist,
>           struct mddev_dev *dv;
>             for (dv = devlist; dv; dv = dv->next) {
> -            struct state *st = xcalloc(1, sizeof *st);
> +            struct state *st;
> +
> +            if (!is_mddev(dv->devname))
> +                return 1;
> +
> +            st = xcalloc(1, sizeof *st);
>               mdlist = conf_get_ident(dv->devname);
>               st->devname = xstrdup(dv->devname);
>               st->next = statelist;
> diff --git a/mdadm.h b/mdadm.h
> index 8f8841d8..03151c34 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1607,6 +1607,7 @@ extern int create_mddev(char *dev, char *name, 
> int autof, int trustworthy,
>   #define    FOREIGN    2
>   #define    METADATA 3
>   extern int open_mddev(char *dev, int report_errors);
> +extern int is_mddev(char *dev);
>   extern int open_container(int fd);
>   extern int metadata_container_matches(char *metadata, char *devnm);
>   extern int metadata_subdev_matches(char *metadata, char *devnm);
> diff --git a/mdopen.c b/mdopen.c
> index 245be537..d18c9319 100644
> --- a/mdopen.c
> +++ b/mdopen.c
> @@ -475,6 +475,23 @@ int open_mddev(char *dev, int report_errors)
>       return mdfd;
>   }
>   +/**
> + * is_mddev() - check that file name passed is an md device.
> + * @dev: file name that has to be checked.
> + * Return: 1 if file passed is an md device, 0 if not.
> + */
> +int is_mddev(char *dev)
> +{
> +    int fd = open_mddev(dev, 1);
> +
> +    if (fd >= 0) {
> +        close(fd);
> +        return 1;
> +    }
> +
> +    return 0;
> +}
> +
>   char *find_free_devnm(int use_partitions)
>   {
>       static char devnm[32];
> diff --git a/util.c b/util.c
> index cdf1da24..003b2f86 100644
> --- a/util.c
> +++ b/util.c
> @@ -268,7 +268,7 @@ int md_array_active(int fd)
>            * GET_ARRAY_INFO doesn't provide access to the proper state
>            * information, so fallback to a basic check for raid_disks 
> != 0
>            */
> -        ret = ioctl(fd, GET_ARRAY_INFO, &array);
> +        ret = md_get_array_info(fd, &array);
>       }
>         return !ret;
