Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44263C433F5
	for <linux-raid@archiver.kernel.org>; Tue,  8 Feb 2022 08:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352028AbiBHIwR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Feb 2022 03:52:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352078AbiBHIwK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 8 Feb 2022 03:52:10 -0500
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C1BC03FED3
        for <linux-raid@vger.kernel.org>; Tue,  8 Feb 2022 00:52:06 -0800 (PST)
Received: from [192.168.0.2] (ip5f5aebc2.dynamic.kabel-deutschland.de [95.90.235.194])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 9B35861E64846;
        Tue,  8 Feb 2022 09:52:04 +0100 (CET)
Message-ID: <17c41b6e-ed53-aeed-87e0-a6cbf96f44a2@molgen.mpg.de>
Date:   Tue, 8 Feb 2022 09:52:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH] Replace error prone signal() with sigaction()
Content-Language: en-US
To:     Lukasz Florczak <lukasz.florczak@intel.com>
Cc:     Jes Sorensen <jes@trained-monkey.org>, linux-raid@vger.kernel.org
References: <20220208152915.12858-1-lukasz.florczak@intel.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220208152915.12858-1-lukasz.florczak@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Lukasz,


Am 08.02.22 um 16:29 schrieb Lukasz Florczak:
> Up to this date signal() was used which is deprecated [1].
> Sigaction() call is preferred. This commit introduces replacement
> from signal() to sigaction() by the use of signal_s() wrapper.
> Also remove redundant signal.h header includes.

signal(2) also says:

>        * By  default, in glibc 2 and later, the signal() wrapper function does
>          not invoke the kernel system call.  Instead,  it  calls  sigaction(2)
>          using flags that supply BSD semantics.  This default behavior is pro‐
>          vided  as  long  as  a  suitable  feature  test  macro  is   defined:
>          _BSD_SOURCE  on  glibc  2.19  and earlier or _DEFAULT_SOURCE in glibc
>          2.19 and later.  (By default, these  macros  are  defined;  see  fea‐
>          ture_test_macros(7)  for  details.)   If such a feature test macro is
>          not defined, then signal() provides System V semantics.

Does that mean, it should still be replaced?

> Moving signal setting in Monitor.c out of the alert() function makes it more clear as
> it was set to ignore SIGPIPE every time alert() was called, but was never set back to default again.
> Now SIGPIPE is ignored for whole duration of the program just once.

Can you please reflow the lines of the commit message body to 75 
characters per line?

Also, could you please separate the second part into a separate commit?


Kind regards,

Paul


> [1] https://man7.org/linux/man-pages/man2/signal.2.html
> 
> Signed-off-by: Lukasz Florczak <lukasz.florczak@intel.com>
> ---
>   Grow.c       |  4 ++--
>   Monitor.c    |  7 +++++--
>   managemon.c  |  1 -
>   mdadm.h      | 22 ++++++++++++++++++++++
>   mdmon.c      |  1 -
>   monitor.c    |  1 -
>   probe_roms.c |  6 +++---
>   raid6check.c | 25 +++++++++++++++----------
>   util.c       |  1 -
>   9 files changed, 47 insertions(+), 21 deletions(-)
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
> index 30c031a2..222568cb 100644
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
> @@ -160,6 +159,9 @@ int Monitor(struct mddev_dev *devlist,
>   	info.mailfrom = mailfrom;
>   	info.dosyslog = dosyslog;
>   
> +	if (info.mailaddr)
> +		signal_s(SIGPIPE, SIG_IGN);
> +
>   	if (share){
>   		if (check_one_sharer(c->scan))
>   			return 1;
> @@ -435,8 +437,9 @@ static void alert(char *event, char *dev, char *disc, struct alert_info *info)
>   		if (mp) {
>   			FILE *mdstat;
>   			char hname[256];
> +
>   			gethostname(hname, sizeof(hname));
> -			signal(SIGPIPE, SIG_IGN);
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
