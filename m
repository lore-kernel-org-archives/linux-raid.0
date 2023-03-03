Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C400C64EC4
	for <linux-raid@archiver.kernel.org>; Fri,  3 Mar 2023 08:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbjCCIhH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Mar 2023 03:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbjCCIhG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Mar 2023 03:37:06 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E23D23326
        for <linux-raid@vger.kernel.org>; Fri,  3 Mar 2023 00:36:33 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id F36B720382;
        Fri,  3 Mar 2023 08:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677832561; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B+BUgZKI5jarAmOfhBga1VUF9KgY1Uzyzx+se/xvQok=;
        b=bmUskaclZXmmClLVsZV9vcjfRjRdkMa88Om2n/u+R9+yiT0xULDdVcXGvOtrg2xyQNLscn
        Q5XLdu1+YXHjE0PxIpohnr2KCVvKZXSflCT36oqR556moVc1j9+XfsBkidJsHUr6phYtkO
        AB8W1wcXPf5MdFFzH552GtEaGmSJ3TQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677832561;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B+BUgZKI5jarAmOfhBga1VUF9KgY1Uzyzx+se/xvQok=;
        b=9Ymqlsf+REifgnIF1XGhi0J284CT2ZvQ+SU6WNg2XkLOkce8d2PWgOqyjZMcytf4T9cALV
        TqL9YEFjr8d7K9CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 08C49139D3;
        Fri,  3 Mar 2023 08:35:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ItcgMm2xAWRiTwAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 03 Mar 2023 08:35:57 +0000
Date:   Fri, 3 Mar 2023 16:35:52 +0800
From:   Coly Li <colyli@suse.de>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Kinga Tanska <kinga.tanska@linux.intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH mdadm v7 5/7] mdadm: Add --write-zeros option for Create
Message-ID: <ZAGxaMa2z10uFuN5@enigma.lan>
References: <20230301204135.39230-1-logang@deltatee.com>
 <20230301204135.39230-6-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230301204135.39230-6-logang@deltatee.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Mar 01, 2023 at 01:41:33PM -0700, Logan Gunthorpe wrote:
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
> Reviewed-by: Xiao Ni <xni@redhat.com>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

Acked-by: Coly Li <colyli@suse.de>

Thanks.

> ---
>  Create.c | 176 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  ReadMe.c |   2 +
>  mdadm.c  |   9 +++
>  mdadm.h  |   5 ++
>  4 files changed, 190 insertions(+), 2 deletions(-)
> 
> diff --git a/Create.c b/Create.c
> index 4acda30c5256..bbe9e13dc76d 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -26,6 +26,10 @@
>  #include	"md_u.h"
>  #include	"md_p.h"
>  #include	<ctype.h>
> +#include	<fcntl.h>
> +#include	<signal.h>
> +#include	<sys/signalfd.h>
> +#include	<sys/wait.h>
>  
>  static int round_size_and_verify(unsigned long long *size, int chunk)
>  {
> @@ -91,9 +95,149 @@ int default_layout(struct supertype *st, int level, int verbose)
>  	return layout;
>  }
>  
> +static pid_t write_zeroes_fork(int fd, struct shape *s, struct supertype *st,
> +			       struct mddev_dev *dv)
> +
> +{
> +	const unsigned long long req_size = 1 << 30;
> +	unsigned long long offset_bytes, size_bytes, sz;
> +	sigset_t sigset;
> +	int ret = 0;
> +	pid_t pid;
> +
> +	size_bytes = KIB_TO_BYTES(s->size);
> +
> +	/*
> +	 * If size_bytes is zero, this is a zoned raid array where
> +	 * each disk is of a different size and uses its full
> +	 * disk. Thus zero the entire disk.
> +	 */
> +	if (!size_bytes && !get_dev_size(fd, dv->devname, &size_bytes))
> +		return -1;
> +
> +	if (dv->data_offset != INVALID_SECTORS)
> +		offset_bytes = SEC_TO_BYTES(dv->data_offset);
> +	else
> +		offset_bytes = SEC_TO_BYTES(st->data_offset);
> +
> +	pr_info("zeroing data from %lld to %lld on: %s\n",
> +		offset_bytes, size_bytes, dv->devname);
> +
> +	pid = fork();
> +	if (pid < 0) {
> +		pr_err("Could not fork to zero disks: %s\n", strerror(errno));
> +		return pid;
> +	} else if (pid != 0) {
> +		return pid;
> +	}
> +
> +	sigemptyset(&sigset);
> +	sigaddset(&sigset, SIGINT);
> +	sigprocmask(SIG_UNBLOCK, &sigset, NULL);
> +
> +	while (size_bytes) {
> +		/*
> +		 * Split requests to the kernel into 1GB chunks seeing the
> +		 * fallocate() call is not interruptible and blocking a
> +		 * ctrl-c for several minutes is not desirable.
> +		 *
> +		 * 1GB is chosen as a compromise: the user may still have
> +		 * to wait several seconds if they ctrl-c on devices that
> +		 * zero slowly, but will reduce the number of requests
> +		 * required and thus the overhead on devices that perform
> +		 * better.
> +		 */
> +		sz = size_bytes;
> +		if (sz >= req_size)
> +			sz = req_size;
> +
> +		if (fallocate(fd, FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE,
> +			      offset_bytes, sz)) {
> +			pr_err("zeroing %s failed: %s\n", dv->devname,
> +			       strerror(errno));
> +			ret = 1;
> +			break;
> +		}
> +
> +		offset_bytes += sz;
> +		size_bytes -= sz;
> +	}
> +
> +	exit(ret);
> +}
> +
> +static int wait_for_zero_forks(int *zero_pids, int count)
> +{
> +	int wstatus, ret = 0, i, sfd, wait_count = 0;
> +	struct signalfd_siginfo fdsi;
> +	bool interrupted = false;
> +	sigset_t sigset;
> +	ssize_t s;
> +
> +	for (i = 0; i < count; i++)
> +		if (zero_pids[i])
> +			wait_count++;
> +	if (!wait_count)
> +		return 0;
> +
> +	sigemptyset(&sigset);
> +	sigaddset(&sigset, SIGINT);
> +	sigaddset(&sigset, SIGCHLD);
> +	sigprocmask(SIG_BLOCK, &sigset, NULL);
> +
> +	sfd = signalfd(-1, &sigset, 0);
> +	if (sfd < 0) {
> +		pr_err("Unable to create signalfd: %s\n", strerror(errno));
> +		return 1;
> +	}
> +
> +	while (1) {
> +		s = read(sfd, &fdsi, sizeof(fdsi));
> +		if (s != sizeof(fdsi)) {
> +			pr_err("Invalid signalfd read: %s\n", strerror(errno));
> +			close(sfd);
> +			return 1;
> +		}
> +
> +		if (fdsi.ssi_signo == SIGINT) {
> +			printf("\n");
> +			pr_info("Interrupting zeroing processes, please wait...\n");
> +			interrupted = true;
> +		} else if (fdsi.ssi_signo == SIGCHLD) {
> +			if (!--wait_count)
> +				break;
> +		}
> +	}
> +
> +	close(sfd);
> +
> +	for (i = 0; i < count; i++) {
> +		if (!zero_pids[i])
> +			continue;
> +
> +		waitpid(zero_pids[i], &wstatus, 0);
> +		zero_pids[i] = 0;
> +		if (!WIFEXITED(wstatus) || WEXITSTATUS(wstatus))
> +			ret = 1;
> +	}
> +
> +	if (interrupted) {
> +		pr_err("zeroing interrupted!\n");
> +		return 1;
> +	}
> +
> +	if (ret)
> +		pr_err("zeroing failed!\n");
> +	else
> +		pr_info("zeroing finished\n");
> +
> +	return ret;
> +}
> +
>  static int add_disk_to_super(int mdfd, struct shape *s, struct context *c,
>  		struct supertype *st, struct mddev_dev *dv,
> -		struct mdinfo *info, int have_container, int major_num)
> +		struct mdinfo *info, int have_container, int major_num,
> +		int *zero_pid)
>  {
>  	dev_t rdev;
>  	int fd;
> @@ -148,6 +292,14 @@ static int add_disk_to_super(int mdfd, struct shape *s, struct context *c,
>  	}
>  	st->ss->getinfo_super(st, info, NULL);
>  
> +	if (fd >= 0 && s->write_zeroes) {
> +		*zero_pid = write_zeroes_fork(fd, s, st, dv);
> +		if (*zero_pid <= 0) {
> +			ioctl(mdfd, STOP_ARRAY, NULL);
> +			return 1;
> +		}
> +	}
> +
>  	if (have_container && c->verbose > 0)
>  		pr_err("Using %s for device %d\n",
>  		       map_dev(info->disk.major, info->disk.minor, 0),
> @@ -224,10 +376,23 @@ static int add_disks(int mdfd, struct mdinfo *info, struct shape *s,
>  {
>  	struct mddev_dev *moved_disk = NULL;
>  	int pass, raid_disk_num, dnum;
> +	int zero_pids[total_slots];
>  	struct mddev_dev *dv;
>  	struct mdinfo *infos;
> +	sigset_t sigset, orig_sigset;
>  	int ret = 0;
>  
> +	/*
> +	 * Block SIGINT so the main thread will always wait for the
> +	 * zeroing processes when being interrupted. Otherwise the
> +	 * zeroing processes will finish their work in the background
> +	 * keeping the disk busy.
> +	 */
> +	sigemptyset(&sigset);
> +	sigaddset(&sigset, SIGINT);
> +	sigprocmask(SIG_BLOCK, &sigset, &orig_sigset);
> +	memset(zero_pids, 0, sizeof(zero_pids));
> +
>  	infos = xmalloc(sizeof(*infos) * total_slots);
>  	enable_fds(total_slots);
>  	for (pass = 1; pass <= 2; pass++) {
> @@ -261,7 +426,7 @@ static int add_disks(int mdfd, struct mdinfo *info, struct shape *s,
>  
>  				ret = add_disk_to_super(mdfd, s, c, st, dv,
>  						&infos[dnum], have_container,
> -						major_num);
> +						major_num, &zero_pids[dnum]);
>  				if (ret)
>  					goto out;
>  
> @@ -287,6 +452,10 @@ static int add_disks(int mdfd, struct mdinfo *info, struct shape *s,
>  		}
>  
>  		if (pass == 1) {
> +			ret = wait_for_zero_forks(zero_pids, total_slots);
> +			if (ret)
> +				goto out;
> +
>  			ret = update_metadata(mdfd, s, st, map, info,
>  					      chosen_name);
>  			if (ret)
> @@ -295,7 +464,10 @@ static int add_disks(int mdfd, struct mdinfo *info, struct shape *s,
>  	}
>  
>  out:
> +	if (ret)
> +		wait_for_zero_forks(zero_pids, total_slots);
>  	free(infos);
> +	sigprocmask(SIG_SETMASK, &orig_sigset, NULL);
>  	return ret;
>  }
>  
> diff --git a/ReadMe.c b/ReadMe.c
> index bd8d50d28661..db251ed2f3d4 100644
> --- a/ReadMe.c
> +++ b/ReadMe.c
> @@ -138,6 +138,7 @@ struct option long_options[] = {
>      {"size",	  1, 0, 'z'},
>      {"auto",	  1, 0, Auto}, /* also for --assemble */
>      {"assume-clean",0,0, AssumeClean },
> +    {"write-zeroes",0,0, WriteZeroes },
>      {"metadata",  1, 0, 'e'}, /* superblock format */
>      {"bitmap",	  1, 0, Bitmap},
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
> index 57e8e6fa64b9..4685ad6b06c2 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -590,6 +590,10 @@ int main(int argc, char *argv[])
>  			s.assume_clean = 1;
>  			continue;
>  
> +		case O(CREATE, WriteZeroes):
> +			s.write_zeroes = 1;
> +			continue;
> +
>  		case O(GROW,'n'):
>  		case O(CREATE,'n'):
>  		case O(BUILD,'n'): /* number of raid disks */
> @@ -1251,6 +1255,11 @@ int main(int argc, char *argv[])
>  		}
>  	}
>  
> +	if (s.write_zeroes && !s.assume_clean) {
> +		pr_info("Disk zeroing requested, setting --assume-clean to skip resync\n");
> +		s.assume_clean = 1;
> +	}
> +
>  	if (!mode && devs_found) {
>  		mode = MISC;
>  		devmode = 'Q';
> diff --git a/mdadm.h b/mdadm.h
> index 8bd65fba1887..211cfcd54f92 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -275,6 +275,9 @@ static inline void __put_unaligned32(__u32 val, void *p)
>  
>  #define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))
>  
> +#define KIB_TO_BYTES(x)	((x) << 10)
> +#define SEC_TO_BYTES(x)	((x) << 9)
> +
>  extern const char Name[];
>  
>  struct md_bb_entry {
> @@ -435,6 +438,7 @@ extern char Version[], Usage[], Help[], OptionHelp[],
>   */
>  enum special_options {
>  	AssumeClean = 300,
> +	WriteZeroes,
>  	BitmapChunk,
>  	WriteBehind,
>  	ReAdd,
> @@ -640,6 +644,7 @@ struct shape {
>  	int	bitmap_chunk;
>  	char	*bitmap_file;
>  	int	assume_clean;
> +	bool	write_zeroes;
>  	int	write_behind;
>  	unsigned long long size;
>  	unsigned long long data_offset;
> -- 
> 2.30.2
> 

-- 
Coly Li
