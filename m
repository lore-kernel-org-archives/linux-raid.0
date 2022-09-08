Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2653BC38145
	for <linux-raid@archiver.kernel.org>; Thu,  8 Sep 2022 07:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiIHH4i (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Sep 2022 03:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiIHH4b (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 8 Sep 2022 03:56:31 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04873286C7
        for <linux-raid@vger.kernel.org>; Thu,  8 Sep 2022 00:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662623790; x=1694159790;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zz+gK4GCWRLTsVDb0EXTHh394X1oevcwUVPFlCor7Zc=;
  b=ItIKHvXBFUgiPSK7tYa9o4gDCOFissWWrwWGQscQ/FaygroXskVscjU5
   E8qFd3zjVlpbg8imV3k1kknxkgxiv3pssjvwjQvsDPovcr1oORGqXBEBQ
   vO8sts0lMjTJhJhRoOYsaWpYNZ7SiffPmD74ZrB+r7nDdhFp2FyYPS2lq
   BoRv7hOQ3UBgoDs4wU7S0pDcSlUpcB8G2P5VNUrLmbGwt9kMsI/UUwjpK
   rjli9pOzrsajIAVDflx3zJLreCNormh5lYt5tpZSERKCwaizSDMr6k+2r
   127TS9nQnIrZdsYRtt+zmY8botoXuZIPMYYM0Y8U6HTeB575HNqNemvff
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10463"; a="280129587"
X-IronPort-AV: E=Sophos;i="5.93,299,1654585200"; 
   d="scan'208";a="280129587"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 00:56:19 -0700
X-IronPort-AV: E=Sophos;i="5.93,299,1654585200"; 
   d="scan'208";a="676576593"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.47.178])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 00:56:16 -0700
Date:   Thu, 8 Sep 2022 09:56:11 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jsorensen@fb.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH mdadm 1/2] mdadm: Add --discard option for Create
Message-ID: <20220908095611.000072df@linux.intel.com>
In-Reply-To: <20220907200355.205045-2-logang@deltatee.com>
References: <20220907200355.205045-1-logang@deltatee.com>
        <20220907200355.205045-2-logang@deltatee.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Logan,
I like this idea but I have some question.

Thanks,
Mariusz

On Wed,  7 Sep 2022 14:03:54 -0600
Logan Gunthorpe <logang@deltatee.com> wrote:

> Add the --discard option for Create which will send BLKDISCARD requests to
> all disks before assembling the array. This is a fast way to know the
> current state of all the disks. If the discard request zeros the data
> on the disks (as is common but not universal) then the array is in a
> state with correct parity. Thus the initial sync may be skipped.

Are we discarding whole device or only space for array? I can see that we are
specifying range in ioctl.
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
>  Create.c | 75 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  ReadMe.c |  1 +
>  mdadm.c  |  4 +++
>  mdadm.h  |  2 ++
>  4 files changed, 82 insertions(+)
> 
> diff --git a/Create.c b/Create.c
> index e06ec2ae96a1..db99da1e8571 100644
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
> @@ -91,6 +97,63 @@ int default_layout(struct supertype *st, int level, int
> verbose) return layout;
>  }
>  
> +static int discard_device(const char *devname, unsigned long long size)
> +{
> +	uint64_t range[2] = {0, size};
Are we starting always from 0? If yest then it introduces bug. In IMSM there is
a matrix array conception. Two arrays on same drives.
I suspect that we are able to erase data from first array when we set --discard
during second volume creation.

> +	unsigned long buf[4096 / sizeof(unsigned long)];
> +	unsigned long i;
> +	int fd;
> +
> +	fd = open(devname, O_RDWR | O_EXCL);

Do we need to to open another RDWR descriptor, I think that mdadm will open
something again soon. We are opening descriptors many times, it generates
unnecessary uvents. We can incorporate it with existing logic and add
discarding just before st->ss->add_to_super() and discard every drive one by
one.
We will fail on error anyway.

> +	if (fd < 0) {
> +		pr_err("could not open device for discard: %s\n", devname);
> +		return 1;
> +	}

Please use is_fd_valid() here.

> +
> +	if (ioctl(fd, BLKDISCARD, &range)) {
> +		pr_err("discard failed on '%s': %m\n", devname);
> +		goto out_err;
> +	}
> +
> +	if (read(fd, buf, sizeof(buf)) != sizeof(buf)) {
> +		pr_err("failed to readback '%s' after discard: %m\n",
> devname);
> +		goto out_err;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(buf); i++) {
> +		if (buf[i]) {
> +			pr_err("device did not read back zeros after discard
> on '%s': %lx\n",
> +			       devname, buf[i]);
> +			goto out_err;
Do we really need to print data here? Could you move it to debug?

> +		}
> +	}
> +
> +	close(fd);
there is also close_fd() but I don't see it useful here.

> +	return 0;
> +
> +out_err:
> +	close(fd);
> +	return 1;
> +}
> +
> +static int discard_devices(struct context *c, struct mddev_dev *devlist,
> +			   unsigned long long size)
> +{
> +	struct mddev_dev *dv;
> +
> +	for (dv = devlist; dv; dv = dv->next) {
> +		if (!strcmp(dv->devname, "missing"))
> +			continue;
> +
> +		if (c->verbose)
> +			pr_err("discarding all data on: %s\n", dv->devname);
I know that mdadm is printing messages to stderr mainly but for this one,
stdout is enough IMO. I give it to you.

> +		if (discard_device(dv->devname, size))
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +
>  int Create(struct supertype *st, char *mddev,
>  	   char *name, int *uuid,
>  	   int subdevs, struct mddev_dev *devlist,
> @@ -603,6 +666,18 @@ int Create(struct supertype *st, char *mddev,
>  		}
>  	}
>  
> +	if (s->discard) {
> +		if (discard_devices(c, devlist, (s->size << 10) +
> +				    (st->data_offset << 9)))
> +			return 1;
> +
> +		/* All disks are zero so if there are none missing assume
> +		 * the array is clean
> +		 */
> +		if (first_missing >= s->raiddisks)
> +			s->assume_clean = 1;

IMO missing drive has nothing to do with clean conception but please correct me
I'm wrong. All assume_clean does is skipping resync after the creation and that
is true even if some drives are missing. Array will be still clean but will be
also degraded.

If I'm correct then it simplifies implementation because we can set
s.assume_clean if s.discard is set too in mdadm.c.

If I'm wrong what is the point of discard when resync is started anyway with
missing drive? Maybe those features should be mutually exclusive?

> +	}

> +
>  	/* If this is raid4/5, we want to configure the last active slot
>  	 * as missing, so that a reconstruct happens (faster than re-parity)
>  	 * FIX: Can we do this for raid6 as well?
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
> index 972adb524dfb..8dee85a54a6a 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -602,6 +602,10 @@ int main(int argc, char *argv[])
>  			s.assume_clean = 1;
>  			continue;
>  
> +		case O(CREATE, Discard):
> +			s.discard = 1;
please use true.

> +			continue;
> +
>  		case O(GROW,'n'):
>  		case O(CREATE,'n'):
>  		case O(BUILD,'n'): /* number of raid disks */
> diff --git a/mdadm.h b/mdadm.h
> index 941a5f3823a0..99769be57ac5 100644
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
> +	int	discard;

please use bool type.

>  	int	write_behind;
>  	unsigned long long size;
>  	unsigned long long data_offset;
