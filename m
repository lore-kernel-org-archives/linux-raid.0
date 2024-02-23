Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F051428B
	for <linux-raid@vger.kernel.org>; Fri, 23 Feb 2024 08:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708675590; cv=none; b=rkdu/kVnvGbrGcjmFY9ZgapLnKWK4hpj8In1r1y93TCcEke61fHvDbrsPWFd2MDZRqihTV8uEqKzrW4GU7ZNskm6WZS8DdwfhBN6U+aIsXXupgWoxSyiGEewFDbP6qxwYjZHXv15aVHcZgLslJ+wlAvetlxIBLRmybIUlzYEMtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708675590; c=relaxed/simple;
	bh=recvHMcQCJdBXfFzFyhInml8RuE+kooV1Lh5Q5lmxoA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kPVo8nX97IP6i5Fpt0uT+a0Xtn6MorotmiQeYNqCwacCGk2cPfZ37CKH/heyu7CI0p4XCYhxgZQflxT9JZGkd0oOTaR2jicdpB7TAKzTLikQeIqoOXldljbVrCi+dp3VB7YT8N5kVR1+yE3X/WtSumGT1hvPhTudcrFiodYdyhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gOXl4NTM; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gOXl4NTM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708675585; x=1740211585;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=recvHMcQCJdBXfFzFyhInml8RuE+kooV1Lh5Q5lmxoA=;
  b=gOXl4NTMK0/M7Pmegw3AETH8VppgpOxtsvUfeMNILbvxjHf0rPaXwNYl
   MIUf9JQlhqm6H3aYstUIEWbmcRRQZx5feNmneML+Xco86mls+StRA7naS
   V5HA7k6ApPtMlOQkt80N6rv4sZFMVt7WFWrMvQs58/0PJ4Bj8N/8rMKSv
   jLdZ2S0LcJnZec4g2oWhCKkzwhxjIHo01D4+32f4QzDw1/9fYacrXKX7m
   3URBxsEpfCjZYj/YlteBSf7EckaK7uVsgMB0ZuBpwoImt99vO9U/NIfrx
   9hcW2tFCkKV2vpU3hahMK42lf+GDNNxJNhlHqAdUnFtgCxY4aJQrDgG1p
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10992"; a="2859993"
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="2859993"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2024 00:06:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="5840476"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.1.223])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2024 00:06:22 -0800
Date: Fri, 23 Feb 2024 09:06:16 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Khem Raj <raj.khem@gmail.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH] restripe.c: Use _FILE_OFFSET_BITS to enable largefile
 support
Message-ID: <20240223090616.000033e4@linux.intel.com>
In-Reply-To: <20240220165158.3521874-1-raj.khem@gmail.com>
References: <20240220165158.3521874-1-raj.khem@gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 20 Feb 2024 08:51:58 -0800
Khem Raj <raj.khem@gmail.com> wrote:

> Instead of using the lseek64 and friends, its better to enable it via
> the feature macro _FILE_OFFSET_BITS = 64 and let the C library deal with
> the width of types
> 
> Signed-off-by: Khem Raj <raj.khem@gmail.com>
> ---
>  restripe.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> --- a/restripe.c
> +++ b/restripe.c
> @@ -22,6 +22,9 @@
>   *    Email: <neilb@suse.de>
>   */
>  
> +/* Enable largefile support */
> +#define _FILE_OFFSET_BITS 64
> +
>  #include "mdadm.h"
>  #include <stdint.h>
>  
> @@ -581,7 +584,7 @@ int save_stripes(int *source, unsigned l
>  				       raid_disks, level, layout);
>  			if (dnum < 0) abort();
>  			if (source[dnum] < 0 ||
> -			    lseek64(source[dnum],
> +			    lseek(source[dnum],
>  				    offsets[dnum] + offset, 0) < 0 ||
>  			    read(source[dnum], buf+disk * chunk_size,
>  				 chunk_size) != chunk_size) {
> @@ -754,8 +757,8 @@ int restore_stripes(int *dest, unsigned
>  					   raid_disks, level, layout);
>  			if (src_buf == NULL) {
>  				/* read from file */
> -				if (lseek64(source, read_offset, 0) !=
> -					 (off64_t)read_offset) {
> +				if (lseek(source, read_offset, 0) !=
> +					 (off_t)read_offset) {
>  					rv = -1;
>  					goto abort;
>  				}
> @@ -816,7 +819,7 @@ int restore_stripes(int *dest, unsigned
>  		}
>  		for (i=0; i < raid_disks ; i++)
>  			if (dest[i] >= 0) {
> -				if (lseek64(dest[i],
> +				if (lseek(dest[i],
>  					 offsets[i]+offset, 0) < 0) {
>  					rv = -1;
>  					goto abort;
> @@ -866,7 +869,7 @@ int test_stripes(int *source, unsigned l
>  		int disk;
>  
>  		for (i = 0 ; i < raid_disks ; i++) {
> -			if ((lseek64(source[i], offsets[i]+start, 0) < 0) ||
> +			if ((lseek(source[i], offsets[i]+start, 0) < 0) ||
>  			    (read(source[i], stripes[i], chunk_size) !=
>  			     chunk_size)) {
>  				free(q);
> --- a/raid6check.c
> +++ b/raid6check.c
> @@ -22,6 +22,9 @@
>   *    Based on "restripe.c" from "mdadm" codebase
>   */
>  
> +/* Enable largefile support */
> +#define _FILE_OFFSET_BITS 64
> +
>  #include "mdadm.h"
>  #include <stdint.h>
>  #include <signal.h>
> @@ -279,9 +282,9 @@ int manual_repair(int chunk_size, int sy
>  	}
>  
>  	int write_res1, write_res2;
> -	off64_t seek_res;
> +	off_t seek_res;
>  
> -	seek_res = lseek64(source[fd1],
> +	seek_res = lseek(source[fd1],
>  			   offsets[fd1] + start * chunk_size, SEEK_SET);
>  	if (seek_res < 0) {
>  		fprintf(stderr, "lseek failed for failed_disk1\n");
> @@ -289,7 +292,7 @@ int manual_repair(int chunk_size, int sy
>  	}
>  	write_res1 = write(source[fd1], blocks[failed_slot1], chunk_size);
>  
> -	seek_res = lseek64(source[fd2],
> +	seek_res = lseek(source[fd2],
>  			   offsets[fd2] + start * chunk_size, SEEK_SET);
>  	if (seek_res < 0) {
>  		fprintf(stderr, "lseek failed for failed_disk2\n");
> @@ -374,7 +377,7 @@ int check_stripes(struct mdinfo *info, i
>  			goto exitCheck;
>  		}
>  		for (i = 0 ; i < raid_disks ; i++) {
> -			off64_t seek_res = lseek64(source[i], offsets[i] +
> start * chunk_size,
> +			off_t seek_res = lseek(source[i], offsets[i] + start
> * chunk_size, SEEK_SET);
>  			if (seek_res < 0) {
>  				fprintf(stderr, "lseek to source %d
> failed\n", i); --- a/swap_super.c
> +++ b/swap_super.c
> @@ -1,3 +1,6 @@
> +/* Enable largefile support */
> +#define _FILE_OFFSET_BITS 64
> +
>  #include <unistd.h>
>  #include <stdlib.h>
>  #include <fcntl.h>
> @@ -16,8 +19,6 @@
>  
>  #define MD_NEW_SIZE_SECTORS(x)		((x & ~(MD_RESERVED_SECTORS -
> 1)) - MD_RESERVED_SECTORS) 
> -extern long long lseek64(int, long long, int);
> -
>  int main(int argc, char *argv[])
>  {
>  	int fd, i;
> @@ -38,8 +39,8 @@ int main(int argc, char *argv[])
>  		exit(1);
>  	}
>  	offset = MD_NEW_SIZE_SECTORS(size) * 512LL;
> -	if (lseek64(fd, offset, 0) < 0LL) {
> -		perror("lseek64");
> +	if (lseek(fd, offset, 0) < 0LL) {
> +		perror("lseek");
>  		exit(1);
>  	}
>  	if (read(fd, super, 4096) != 4096) {
> @@ -68,8 +69,8 @@ int main(int argc, char *argv[])
>  		super[32*4+10*4 +i] = t;
>  	}
>  
> -	if (lseek64(fd, offset, 0) < 0LL) {
> -		perror("lseek64");
> +	if (lseek(fd, offset, 0) < 0LL) {
> +		perror("lseek");
>  		exit(1);
>  	}
>  	if (write(fd, super, 4096) != 4096) {
> 
Hi,

Applying: restripe.c: Use _FILE_OFFSET_BITS to enable largefile support
error: patch failed: raid6check.c:22
error: raid6check.c: patch does not apply
Patch failed at 0001 restripe.c: Use _FILE_OFFSET_BITS to enable largefile
support hint: Use 'git am --show-current-patch=diff' to see the failed patch
When you have resolved this problem, run "git am --continue".

I cannot apply this. Please try to rebase it to current master.
Also, I don't see git version signature at the end, perhaps it is broken?

-- 
2.35.3

Thanks,
Mariusz
