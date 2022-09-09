Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84EE9ECAAD3
	for <linux-raid@archiver.kernel.org>; Fri,  9 Sep 2022 09:58:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiIIJ6M (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 9 Sep 2022 05:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiIIJ56 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 9 Sep 2022 05:57:58 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6555112B34B
        for <linux-raid@vger.kernel.org>; Fri,  9 Sep 2022 02:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662717477; x=1694253477;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0SNWqumiTMiEYUjTia7h0Y6IXL3HBCgZV/7N45/yKM8=;
  b=e3F/hQxHudnM+tIBDo72H+nNcx1ANM+tT2y/VeYKF87/I8uJxD1RZ/XT
   rSmXspvnD8OsLcWPh6Vr8EnckagkXFGIx4RL0LqQXv7bENnYq0K0R14v7
   8BRlQW26PUDYT17OgC6kxHPuIbf9rouB/7Azn9+q5jLPZBdEHX41WGaaj
   jGeUFiS32ciR0FJ1V1AEMWm2mQr1AlcewUHx/p3gyYv4H2Zze5Pydm3tE
   Lbp2K9FayG3uZRjuWlSbZRj/pE/5+5EZzphNTMesRzo9uIJcFr7eEkR03
   zK0oQM52narX+V3d8UL2kQNwORuJaWY3zvNF+UXr3PVz1C7rJhsokl5LW
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="298780465"
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="298780465"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 02:57:56 -0700
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="677098346"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.45.91])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 02:57:53 -0700
Date:   Fri, 9 Sep 2022 11:57:49 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH mdadm v2 1/2] mdadm: Add --discard option for Create
Message-ID: <20220909115749.00007431@linux.intel.com>
In-Reply-To: <20220908230847.5749-2-logang@deltatee.com>
References: <20220908230847.5749-1-logang@deltatee.com>
        <20220908230847.5749-2-logang@deltatee.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Logan,
See comments below.

Thanks,
Mariusz

On Thu,  8 Sep 2022 17:08:46 -0600
Logan Gunthorpe <logang@deltatee.com> wrote:

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

Please update message. We agreed in v1 that missing disks and discard features
are not related, right?

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
>  #include	"md_u.h"
>  #include	"md_p.h"
>  #include	<ctype.h>
> +#include	<sys/ioctl.h>
> +
> +#ifndef BLKDISCARD
> +#define BLKDISCARD _IO(0x12,119)
> +#endif
> +#include	<fcntl.h>
>  
>  static int round_size_and_verify(unsigned long long *size, int chunk)
>  {
> @@ -91,6 +97,38 @@ int default_layout(struct supertype *st, int level, int
> verbose) return layout;
>  }
>  
> +static int discard_device(struct context *c, int fd, const char *devname,
> +			  unsigned long long offset, unsigned long long size)

Will be great if you can description.

> +{
> +	uint64_t range[2] = {offset, size};
Probably you don't need to specify [2] but it is not an issue I think.

> +	unsigned long buf[4096 / sizeof(unsigned long)];

Can you use any define for 4096? 

> +	unsigned long i;
> +
> +	if (c->verbose)
> +		printf("discarding data from %lld to %lld on: %s\n",
> +		       offset, size, devname);
> +
> +	if (ioctl(fd, BLKDISCARD, &range)) {
> +		pr_err("discard failed on '%s': %m\n", devname);
> +		return 1;
> +	}
> +
> +	if (pread(fd, buf, sizeof(buf), offset) != sizeof(buf)) {
> +		pr_err("failed to readback '%s' after discard: %m\n",
> devname);
> +		return 1;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(buf); i++) {
> +		if (buf[i]) {
> +			pr_err("device did not read back zeros after discard
> on '%s': %lx\n",
> +			       devname, buf[i]);
In previous version I wanted to leave the message on stderr, but just move a
data (buf[i]) to debug, or if (verbose > 0).
I think that printing binary data in error message is not necessary.

BTW. I'm not sure if discard ensures that data will be all zero. It causes that
drive drops all references but I doesn't mean that data is zeroed. Could you
please check it in documentation? Should we expect zeroes?

> +			return 1;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  int Create(struct supertype *st, char *mddev,
>  	   char *name, int *uuid,
>  	   int subdevs, struct mddev_dev *devlist,
> @@ -607,7 +645,7 @@ int Create(struct supertype *st, char *mddev,
>  	 * as missing, so that a reconstruct happens (faster than re-parity)
>  	 * FIX: Can we do this for raid6 as well?
>  	 */
> -	if (st->ss->external == 0 && s->assume_clean == 0 &&
> +	if (st->ss->external == 0 && s->assume_clean == 0 && s->discard == 0
> && c->force == 0 && first_missing >= s->raiddisks) {
>  		switch (s->level) {
>  		case 4:
> @@ -624,8 +662,8 @@ int Create(struct supertype *st, char *mddev,
>  	/* For raid6, if creating with 1 missing drive, make a good drive
>  	 * into a spare, else the create will fail
>  	 */
> -	if (s->assume_clean == 0 && c->force == 0 && first_missing <
> s->raiddisks &&
> -	    st->ss->external == 0 &&
> +	if (s->assume_clean == 0 && s->discard == 0 && c->force == 0 &&
> +	    first_missing < s->raiddisks && st->ss->external == 0 &&
>  	    second_missing >= s->raiddisks && s->level == 6) {
>  		insert_point = s->raiddisks - 1;
>  		if (insert_point == first_missing)
> @@ -686,7 +724,7 @@ int Create(struct supertype *st, char *mddev,
>  	     (insert_point < s->raiddisks || first_missing < s->raiddisks))
> || (s->level == 6 && (insert_point < s->raiddisks ||
>  			       second_missing < s->raiddisks)) ||
> -	    (s->level <= 0) || s->assume_clean) {
> +	    (s->level <= 0) || s->assume_clean || s->discard) {
>  		info.array.state = 1; /* clean, but one+ drive will be
> missing*/ info.resync_start = MaxSector;
>  	} else {
> @@ -945,6 +983,15 @@ int Create(struct supertype *st, char *mddev,
>  				}
>  				if (fd >= 0)
>  					remove_partitions(fd);
> +
> +				if (s->discard &&
> +				    discard_device(c, fd, dv->devname,
> +						   dv->data_offset << 9,
> +						   s->size << 10)) {
> +					ioctl(mdfd, STOP_ARRAY, NULL);
> +					goto abort_locked;
> +				}
> +
Feel free to use up to 100 char in one line it is allowed now.
Why we need dv->data_offset << 9 and  s->size << 10 here?
How this applies to zoned raid0?

>  				if (st->ss->add_to_super(st, &inf->disk,
>  							 fd, dv->devname,
>  							 dv->data_offset)) {
> diff --git a/ReadMe.c b/ReadMe.c
> index 7f94847e9769..544a057f83a0 100644
> --- a/ReadMe.c
> +++ b/ReadMe.c
> @@ -138,6 +138,7 @@ struct option long_options[] = {
>      {"size",	  1, 0, 'z'},
>      {"auto",	  1, 0, Auto}, /* also for --assemble */
>      {"assume-clean",0,0, AssumeClean },
> +    {"discard",	  0, 0, Discard },
>      {"metadata",  1, 0, 'e'}, /* superblock format */
>      {"bitmap",	  1, 0, Bitmap},
>      {"bitmap-chunk", 1, 0, BitmapChunk},
> diff --git a/mdadm.c b/mdadm.c
> index 972adb524dfb..049cdce1cdd2 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -602,6 +602,10 @@ int main(int argc, char *argv[])
>  			s.assume_clean = 1;
>  			continue;
>  
> +		case O(CREATE, Discard):
> +			s.discard = true;
> +			continue;
> +

I would like to set s.assume_clean=true along with discard. Then will be no need
to modify other conditions. If we are assuming that after discard all is zeros
then we can skip resync, right? According to message, it should be.
Please add message for user and set assume_clean too.

>  		case O(GROW,'n'):
>  		case O(CREATE,'n'):
>  		case O(BUILD,'n'): /* number of raid disks */
> diff --git a/mdadm.h b/mdadm.h
> index 941a5f3823a0..a1e0bc9f01ad 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -433,6 +433,7 @@ extern char Version[], Usage[], Help[], OptionHelp[],
>   */
>  enum special_options {
>  	AssumeClean = 300,
> +	Discard,
>  	BitmapChunk,
>  	WriteBehind,
>  	ReAdd,
> @@ -593,6 +594,7 @@ struct shape {
>  	int	bitmap_chunk;
>  	char	*bitmap_file;
>  	int	assume_clean;
> +	bool	discard;
>  	int	write_behind;
>  	unsigned long long size;
>  	unsigned long long data_offset;

