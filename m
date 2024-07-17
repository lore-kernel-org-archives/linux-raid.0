Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A743936134
	for <linux-raid@vger.kernel.org>; Wed, 17 Jul 2024 09:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721208803; cv=none; b=DyxJY70kNCmmTF0b6xp6wiyLnnruy+ZFbXD5iCZa6hzcacCOYhxfMOgqvD4GKkzgUm8WZenwqIYexy1UbP1D0a23Ikd/NuwQalT8LB/SdqJ82Tzwos5sExIVtQqwHcgNhXim2+cjSpuIUo3EEAbkH9SIZVhf3tdVUDk3xeS7dCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721208803; c=relaxed/simple;
	bh=/L6VIpaKI9fNApKHxt9EJcXcm61F+HIML+OReMN7aoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DcXwBEd0kP4v5QXBLYyyfKQ5yifWBFFrJI2OXrh5HggkLgun0Rm8SoHZnN/HZYe4GXe2hm1ejDl1QAlsE2kH7L7lW++M14XdBQmpl+KA1xnFPw/6HpM6nJPHBTvUhE1A/Gf9OOucXz8rrEesurtK1lKMz6kbcC9wbGkQw1cg9d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HxZX8Onj; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HxZX8Onj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721208802; x=1752744802;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/L6VIpaKI9fNApKHxt9EJcXcm61F+HIML+OReMN7aoQ=;
  b=HxZX8OnjYXHSkMPvqBobdhVLEKo/SaRXpsZ7b2hNlZm/hfj2rAsK8j1r
   6n/tF9juD2UaNRt6sgwMRTfOOimO7kzswwQbiZRGC11LFVy5Hl31S1C3c
   7ecIW74FsFLBONLQKZIWNaq2tyiD0IqVxK4eiCDP3wQMeHdx5LvCDkEeu
   gFekrFxQ8LAqZhpZSASLWLSlZhYu/DW6fWA5VOYtGn7TtXrwf6LFB/9Us
   FRJf6FU8TIdLl0R+Er4TxenDzCTrPLeGUFcwbyXZYqeWrG1R/mk0Y+fLC
   cKlkWvM77DPj2C9uD+Z5AOpgIRRciFM+2s7Ma/Xfr73eqP1jXZaeCzR0o
   g==;
X-CSE-ConnectionGUID: HITfbyVmTKiTLVnxPaMwfg==
X-CSE-MsgGUID: 4fpTLXfUQJSi0GSqNOHa3w==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="21602680"
X-IronPort-AV: E=Sophos;i="6.09,214,1716274800"; 
   d="scan'208";a="21602680"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2024 02:33:21 -0700
X-CSE-ConnectionGUID: DaCbVA09R9O0V+VDdWmyPA==
X-CSE-MsgGUID: oOdXkRkwS4SXEIEkZkTUzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,214,1716274800"; 
   d="scan'208";a="50404960"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.82.157])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2024 02:33:20 -0700
Date: Wed, 17 Jul 2024 11:33:15 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: ncroxon@redhat.com, linux-raid@vger.kernel.org
Subject: Re: [PATCH 02/15] mdadm/Grow: fix coverity issue CHECKED_RETURN
Message-ID: <20240717113315.00002fd3@linux.intel.com>
In-Reply-To: <20240715073604.30307-3-xni@redhat.com>
References: <20240715073604.30307-1-xni@redhat.com>
	<20240715073604.30307-3-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 15 Jul 2024 15:35:51 +0800
Xiao Ni <xni@redhat.com> wrote:

> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  Grow.c | 43 ++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 36 insertions(+), 7 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index b135930d05b8..7ae967bda067 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -3261,7 +3261,12 @@ static int reshape_array(char *container, int fd, char
> *devname, /* This is a spare that wants to
>  					 * be part of the array.
>  					 */
> -					add_disk(fd, st, info2, d);
> +					if (add_disk(fd, st, info2, d) < 0) {
> +						pr_err("Can not add disk
> %s\n",
> +								d->sys_name);
> +						free(info2);
> +						goto release;
> +					}
>  				}
>  			}
>  			sysfs_free(info2);
> @@ -4413,7 +4418,10 @@ static void validate(int afd, int bfd, unsigned long
> long offset) */
>  	if (afd < 0)
>  		return;
> -	lseek64(bfd, offset - 4096, 0);
> +	if (lseek64(bfd, offset - 4096, 0) < 0) {
> +		pr_err("lseek64 fails %d:%s\n", errno, strerror(errno));

You are using same error message in many places, shouldn't we propose something
like:

__off64_t lseek64_log_err (int __fd, __off64_t __offset, int __whence)
{
    __off64_t ret = lseek64(fd, __offset, __whence);
    if (ret < 0)
         pr_err("lseek64 fails %d:%s\n", errno, strerror(errno));

    return ret;
    
}

lseek64 errors are unusual, they are exceptional, and I'm fine with logging
same error message but I would prefer to avoid repeating same message in code.
In case of debug, developer can do some backtracking, starting from this
function rather than hunt for the particular error message you used multiple
times.

> +		return;


> +	}
>  	if (read(bfd, &bsb2, 512) != 512)
>  		fail("cannot read bsb");
>  	if (bsb2.sb_csum != bsb_csum((char*)&bsb2,
> @@ -4444,12 +4452,19 @@ static void validate(int afd, int bfd, unsigned long
> long offset) }
>  		}
>  
> -		lseek64(bfd, offset, 0);
> +		if (lseek64(bfd, offset, 0) < 0) {
> +			pr_err("lseek64 fails %d:%s\n", errno,
> strerror(errno));

> +			goto out;
> +		}
>  		if ((unsigned long long)read(bfd, bbuf, len) != len) {
>  			//printf("len %llu\n", len);
>  			fail("read first backup failed");
>  		}
> -		lseek64(afd, __le64_to_cpu(bsb2.arraystart)*512, 0);
> +
> +		if (lseek64(afd, __le64_to_cpu(bsb2.arraystart)*512, 0) < 0)
> {
> +			pr_err("lseek64 fails %d:%s\n", errno,
> strerror(errno));
> +			goto out;
> +		}
>  		if ((unsigned long long)read(afd, abuf, len) != len)
>  			fail("read first from array failed");
>  		if (memcmp(bbuf, abuf, len) != 0)
> @@ -4466,15 +4481,25 @@ static void validate(int afd, int bfd, unsigned long
> long offset) bbuf = xmalloc(abuflen);
>  		}
>  
> -		lseek64(bfd, offset+__le64_to_cpu(bsb2.devstart2)*512, 0);
> +		if (lseek64(bfd, offset+__le64_to_cpu(bsb2.devstart2)*512,
> 0) < 0) {
> +			pr_err("lseek64 fails %d:%s\n", errno,
> strerror(errno));
> +			goto out;
> +		}
>  		if ((unsigned long long)read(bfd, bbuf, len) != len)
>  			fail("read second backup failed");
> -		lseek64(afd, __le64_to_cpu(bsb2.arraystart2)*512, 0);
> +		if (lseek64(afd, __le64_to_cpu(bsb2.arraystart2)*512, 0) <
> 0) {
> +			pr_err("lseek64 fails %d:%s\n", errno,
> strerror(errno));
> +			goto out;
> +		}
>  		if ((unsigned long long)read(afd, abuf, len) != len)
>  			fail("read second from array failed");
>  		if (memcmp(bbuf, abuf, len) != 0)
>  			fail("data2 compare failed");
>  	}
> +out:
> +	free(abuf);
> +	free(bbuf);
> +	return;
>  }
>  
>  int child_monitor(int afd, struct mdinfo *sra, struct reshape *reshape,
> @@ -5033,7 +5058,11 @@ int Grow_continue_command(char *devname, int fd,
> struct context *c) goto Grow_continue_command_exit;
>  		}
>  		content = &array;
> -		sysfs_init(content, fd, NULL);
> +		if (sysfs_init(content, fd, NULL) < 0) {
> +			pr_err("sysfs_init fails\n");

Better error message is:
pr_err("failed to initialize sysfs.\n");
or
pr_err("unable to initialize sysfs for %s\n",st->devnm);

It is more user friendly.

It is already used multiple times so perhaps we can consider similar approach
to proposed in for lseek, we can move move printing error to sysfs_init().

What do you think?

Thanks,
Mariusz
