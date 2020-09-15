Return-Path: <SRS0=ezIp=CY=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7F18C433E2
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 15:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E35720872
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 15:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbgIOPmi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Sep 2020 11:42:38 -0400
Received: from static.214.254.202.116.clients.your-server.de ([116.202.254.214]:45346
        "EHLO ciao.gmane.io" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727429AbgIOPmT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Sep 2020 11:42:19 -0400
Received: from list by ciao.gmane.io with local (Exim 4.92)
        (envelope-from <linux-raid@m.gmane-mx.org>)
        id 1kID0C-0000tB-GH
        for linux-raid@vger.kernel.org; Tue, 15 Sep 2020 17:36:16 +0200
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-raid@vger.kernel.org
From:   "Andrey Jr. Melnikov" <temnota.am@gmail.com>
Subject: Re: [PATCH V2 1/2] Check hostname file empty or not when creating raid device
Date:   Tue, 15 Sep 2020 18:27:29 +0300
Message-ID: <v3373h-8sh.ln1@banana.localnet>
References: <1600155882-4488-1-git-send-email-xni@redhat.com> <1600155882-4488-2-git-send-email-xni@redhat.com>
User-Agent: tin/2.2.1-20140504 ("Tober an Righ") (UNIX) (Linux/4.4.66-bananian (armv7l))
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Xiao Ni <xni@redhat.com> wrote:
> If /etc/hostname is empty and the hostname is decided by network(dhcp, e.g.), there is a
> risk that raid device will not be in active state after boot. It will be auto-read-only
> state. It depends on the boot sequence. If the storage starts before network. The system
> detects disks first, udev rules are triggered and raid device is assemble automatically.
> But the network hasn't started successfully. So mdadm can't get the right hostname. The
> raid device will be treated as a foreign raid.
> Add a note message if /etc/hostname is empty when creating a raid device.

> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  mdadm.c |  3 +++
>  mdadm.h |  1 +
>  util.c  | 19 +++++++++++++++++++
>  3 files changed, 23 insertions(+)

> diff --git a/mdadm.c b/mdadm.c
> index 1b3467f..e551958 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -1408,6 +1408,9 @@ int main(int argc, char *argv[])
>         if (c.homehost == NULL && c.require_homehost)
>                 c.homehost = conf_get_homehost(&c.require_homehost);
>         if (c.homehost == NULL || strcasecmp(c.homehost, "<system>") == 0) {
> +               if (check_hostname())
> +                       pr_err("Note: The file /etc/hostname is empty. There is a risk the raid\n"
> +                               "      can't be active after boot\n");
>                 if (gethostname(sys_hostname, sizeof(sys_hostname)) == 0) {
>                         sys_hostname[sizeof(sys_hostname)-1] = 0;
>                         c.homehost = sys_hostname;
> diff --git a/mdadm.h b/mdadm.h
> index 399478b..3ef1209 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1480,6 +1480,7 @@ extern int parse_cluster_confirm_arg(char *inp, char **devname, int *slot);
>  extern int check_ext2(int fd, char *name);
>  extern int check_reiser(int fd, char *name);
>  extern int check_raid(int fd, char *name);
> +extern int check_hostname(void);
>  extern int check_partitions(int fd, char *dname,
>                             unsigned long long freesize,
>                             unsigned long long size);
> diff --git a/util.c b/util.c
> index 579dd42..de5bad0 100644
> --- a/util.c
> +++ b/util.c
> @@ -694,6 +694,25 @@ int check_raid(int fd, char *name)
>         return 1;
>  }
>  
> +/* It checks /etc/hostname has value or not */
> +int check_hostname()
> +{
> +       int fd, ret = 0;
> +       char buf[256];
> +
> +       fd = open("/etc/hostname", O_RDONLY);
> +       if (fd < 0) {
> +               ret = 1;
> +               goto out;
> +       }
> +
> +       if (read(fd, buf, sizeof(buf)) == 0)
> +               ret = 1;

Why not use stat() here, since you don't use file content?
Also, any error from read() - mean file "not empty". This is right?

> +out:
> +       close(fd);
> +       return ret;
> +}
> +
>  int fstat_is_blkdev(int fd, char *devname, dev_t *rdev)
>  {
>         struct stat stb;

