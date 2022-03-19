Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5A24C433F5
	for <linux-raid@archiver.kernel.org>; Sat, 19 Mar 2022 16:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237861AbiCSQil (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 19 Mar 2022 12:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbiCSQil (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 19 Mar 2022 12:38:41 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CE0710DA
        for <linux-raid@vger.kernel.org>; Sat, 19 Mar 2022 09:37:19 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0148F1F37B;
        Sat, 19 Mar 2022 16:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1647707838; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jX9h0YsUAFhhwOxAUU19T/LQXeg13nFDA9kSbdUb+IY=;
        b=Bnj8CXhQP9k/Fs54dJYkiK/VbRVQQn/6M/GT32asyo51LDi+Nx9hcwpvhZjlk77nsINYvs
        mHRwQLGC+ExK9+oaIV68G2Uzy4SvEySiEd6JGvauwrprV2uZNVSwdOBqTW+C84z1dMxxZj
        M9xLxJWH7vdYoQwpBSrIhBT5Qprqch0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1647707838;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jX9h0YsUAFhhwOxAUU19T/LQXeg13nFDA9kSbdUb+IY=;
        b=4bng//XJrstTM2GM2sICIYz8AWAgpun0qUaWdXTfhbGctUzastdAa2sm4VQ2TgQKCYOsLE
        zwX6oaLDBmwnDzBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 24162132C1;
        Sat, 19 Mar 2022 16:37:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2Wi+NbsGNmLOIAAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 19 Mar 2022 16:37:15 +0000
Message-ID: <27bb9720-f044-97fb-9ff0-2f27e72fc42c@suse.de>
Date:   Sun, 20 Mar 2022 00:37:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH 1/2] Replace error prone signal() with sigaction()
Content-Language: en-US
To:     Lukasz Florczak <lukasz.florczak@linux.intel.com>
Cc:     jes@trained-monkey.org, pmenzel@molgen.mpg.de,
        linux-raid@vger.kernel.org
References: <20220221120521.16846-1-lukasz.florczak@linux.intel.com>
 <20220221120521.16846-2-lukasz.florczak@linux.intel.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220221120521.16846-2-lukasz.florczak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2/21/22 8:05 PM, Lukasz Florczak wrote:
> Up to this date signal() was used which implementation could vary [1].
> Sigaction() call is preferred. This commit introduces replacement
> from signal() to sigaction() by the use of signal_s() wrapper.
> Also remove redundant signal.h header includes.
>
> [1] https://man7.org/linux/man-pages/man2/signal.2.html
>
> Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>


This patch looks fine to me, and no error/warning in compiling.


Acked-by: Coly Li <colyli@suse.de>


Coly Li


> ---
>   Grow.c       |  4 ++--
>   Monitor.c    |  5 +++--
>   managemon.c  |  1 -
>   mdadm.h      | 22 ++++++++++++++++++++++
>   mdmon.c      |  1 -
>   monitor.c    |  1 -
>   probe_roms.c |  6 +++---
>   raid6check.c | 25 +++++++++++++++----------
>   util.c       |  1 -
>   9 files changed, 45 insertions(+), 21 deletions(-)
>
> diff --git a/Grow.c b/Grow.c
> index 9c6fc95e..021897e1 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -26,7 +26,6 @@
>   #include	<sys/mman.h>
>   #include	<stddef.h>
>   #include	<stdint.h>
> -#include	<signal.h>
>   #include	<sys/wait.h>
>   
>   #if ! defined(__BIG_ENDIAN) && ! defined(__LITTLE_ENDIAN)
> @@ -3560,7 +3559,8 @@ started:
>   		fd = -1;
>   	mlockall(MCL_FUTURE);
>   
> -	signal(SIGTERM, catch_term);
> +	if (signal_s(SIGTERM, catch_term) == SIG_ERR)
> +		goto release;
>   
>   	if (st->ss->external) {
>   		/* metadata handler takes it from here */
> diff --git a/Monitor.c b/Monitor.c
> index 30c031a2..40388b64 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -26,7 +26,6 @@
>   #include	"md_p.h"
>   #include	"md_u.h"
>   #include	<sys/wait.h>
> -#include	<signal.h>
>   #include	<limits.h>
>   #include	<syslog.h>
>   #ifndef NO_LIBUDEV
> @@ -435,8 +434,10 @@ static void alert(char *event, char *dev, char *disc, struct alert_info *info)
>   		if (mp) {
>   			FILE *mdstat;
>   			char hname[256];
> +
>   			gethostname(hname, sizeof(hname));
> -			signal(SIGPIPE, SIG_IGN);
> +			signal_s(SIGPIPE, SIG_IGN);
> +
>   			if (info->mailfrom)
>   				fprintf(mp, "From: %s\n", info->mailfrom);
>   			else
> diff --git a/managemon.c b/managemon.c
> index bb7334cf..0e9bdf00 100644
> --- a/managemon.c
> +++ b/managemon.c
> @@ -106,7 +106,6 @@
>   #include	"mdmon.h"
>   #include	<sys/syscall.h>
>   #include	<sys/socket.h>
> -#include	<signal.h>
>   
>   static void close_aa(struct active_array *aa)
>   {
> diff --git a/mdadm.h b/mdadm.h
> index c7268a71..26e7e5cd 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -46,6 +46,7 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
>   #include	<string.h>
>   #include	<syslog.h>
>   #include	<stdbool.h>
> +#include	<signal.h>
>   /* Newer glibc requires sys/sysmacros.h directly for makedev() */
>   #include	<sys/sysmacros.h>
>   #ifdef __dietlibc__
> @@ -1729,6 +1730,27 @@ static inline char *to_subarray(struct mdstat_ent *ent, char *container)
>   	return &ent->metadata_version[10+strlen(container)+1];
>   }
>   
> +/**
> + * signal_s() - Wrapper for sigaction() with signal()-like interface.
> + * @sig: The signal to set the signal handler to.
> + * @handler: The signal handler.
> + *
> + * Return: previous handler or SIG_ERR on failure.
> + */
> +static inline sighandler_t signal_s(int sig, sighandler_t handler)
> +{
> +	struct sigaction new_act;
> +	struct sigaction old_act;
> +
> +	new_act.sa_handler = handler;
> +	new_act.sa_flags = 0;
> +
> +	if (sigaction(sig, &new_act, &old_act) == 0)
> +		return old_act.sa_handler;
> +
> +	return SIG_ERR;
> +}
> +
>   #ifdef DEBUG
>   #define dprintf(fmt, arg...) \
>   	fprintf(stderr, "%s: %s: "fmt, Name, __func__, ##arg)
> diff --git a/mdmon.c b/mdmon.c
> index c71e62c6..5570574b 100644
> --- a/mdmon.c
> +++ b/mdmon.c
> @@ -56,7 +56,6 @@
>   #include	<errno.h>
>   #include	<string.h>
>   #include	<fcntl.h>
> -#include	<signal.h>
>   #include	<dirent.h>
>   #ifdef USE_PTHREADS
>   #include	<pthread.h>
> diff --git a/monitor.c b/monitor.c
> index e0d3be67..b877e595 100644
> --- a/monitor.c
> +++ b/monitor.c
> @@ -22,7 +22,6 @@
>   #include "mdmon.h"
>   #include <sys/syscall.h>
>   #include <sys/select.h>
> -#include <signal.h>
>   
>   static char *array_states[] = {
>   	"clear", "inactive", "suspended", "readonly", "read-auto",
> diff --git a/probe_roms.c b/probe_roms.c
> index 7ea04c7a..94c80c2c 100644
> --- a/probe_roms.c
> +++ b/probe_roms.c
> @@ -22,7 +22,6 @@
>   #include "probe_roms.h"
>   #include "mdadm.h"
>   #include <unistd.h>
> -#include <signal.h>
>   #include <fcntl.h>
>   #include <sys/mman.h>
>   #include <sys/stat.h>
> @@ -69,7 +68,8 @@ static int probe_address16(const __u16 *ptr, __u16 *val)
>   
>   void probe_roms_exit(void)
>   {
> -	signal(SIGBUS, SIG_DFL);
> +	signal_s(SIGBUS, SIG_DFL);
> +
>   	if (rom_fd >= 0) {
>   		close(rom_fd);
>   		rom_fd = -1;
> @@ -98,7 +98,7 @@ int probe_roms_init(unsigned long align)
>   	if (roms_init())
>   		return -1;
>   
> -	if (signal(SIGBUS, sigbus) == SIG_ERR)
> +	if (signal_s(SIGBUS, sigbus) == SIG_ERR)
>   		rc = -1;
>   	if (rc == 0) {
>   		fd = open("/dev/mem", O_RDONLY);
> diff --git a/raid6check.c b/raid6check.c
> index a8e6005b..99477761 100644
> --- a/raid6check.c
> +++ b/raid6check.c
> @@ -24,7 +24,6 @@
>   
>   #include "mdadm.h"
>   #include <stdint.h>
> -#include <signal.h>
>   #include <sys/mman.h>
>   
>   #define CHECK_PAGE_BITS (12)
> @@ -130,30 +129,36 @@ void raid6_stats(int *disk, int *results, int raid_disks, int chunk_size)
>   }
>   
>   int lock_stripe(struct mdinfo *info, unsigned long long start,
> -		int chunk_size, int data_disks, sighandler_t *sig) {
> +		int chunk_size, int data_disks, sighandler_t *sig)
> +{
>   	int rv;
> +
> +	sig[0] = signal_s(SIGTERM, SIG_IGN);
> +	sig[1] = signal_s(SIGINT, SIG_IGN);
> +	sig[2] = signal_s(SIGQUIT, SIG_IGN);
> +
> +	if (sig[0] == SIG_ERR || sig[1] == SIG_ERR || sig[2] == SIG_ERR)
> +		return 1;
> +
>   	if(mlockall(MCL_CURRENT | MCL_FUTURE) != 0) {
>   		return 2;
>   	}
>   
> -	sig[0] = signal(SIGTERM, SIG_IGN);
> -	sig[1] = signal(SIGINT, SIG_IGN);
> -	sig[2] = signal(SIGQUIT, SIG_IGN);
> -
>   	rv = sysfs_set_num(info, NULL, "suspend_lo", start * chunk_size * data_disks);
>   	rv |= sysfs_set_num(info, NULL, "suspend_hi", (start + 1) * chunk_size * data_disks);
>   	return rv * 256;
>   }
>   
> -int unlock_all_stripes(struct mdinfo *info, sighandler_t *sig) {
> +int unlock_all_stripes(struct mdinfo *info, sighandler_t *sig)
> +{
>   	int rv;
>   	rv = sysfs_set_num(info, NULL, "suspend_lo", 0x7FFFFFFFFFFFFFFFULL);
>   	rv |= sysfs_set_num(info, NULL, "suspend_hi", 0);
>   	rv |= sysfs_set_num(info, NULL, "suspend_lo", 0);
>   
> -	signal(SIGQUIT, sig[2]);
> -	signal(SIGINT, sig[1]);
> -	signal(SIGTERM, sig[0]);
> +	signal_s(SIGQUIT, sig[2]);
> +	signal_s(SIGINT, sig[1]);
> +	signal_s(SIGTERM, sig[0]);
>   
>   	if(munlockall() != 0)
>   		return 3;
> diff --git a/util.c b/util.c
> index 3d05d074..cc94f96e 100644
> --- a/util.c
> +++ b/util.c
> @@ -35,7 +35,6 @@
>   #include	<poll.h>
>   #include	<ctype.h>
>   #include	<dirent.h>
> -#include	<signal.h>
>   #include	<dlfcn.h>
>   
>   


