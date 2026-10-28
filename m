Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793178205;
	b=eT1GuGu3rb3VjLCKmrwfzs6s2FckzXpFbNUxhwRgf703XSGBHtw3Ej3BIzrvyW5cwT0K
	 +gizKe/K1l+2BAziGMbcoOOPf2u67jVJgE8W4/mdX1DVdaORs3gvLlKGSizQYb+WzpLky
	 Bzf+Ep3El13f90mhXoDZEQc0hx/LjxMweIsvRfBjKY1B7irZjKKhL/2ynhroAiwFa1+I7
	 Cj0y4wT2a74P+wWe312sL8C6sCmmmENYQyC8CGvKU6MdShEgfNXLqgXM9vMwX7vuf4gMl
	 eg6aVBrRAWs6m+IXnPKrNdfxfij/Rp3XkFpL8gOoYrKVVhkjySH148cETVdsyv9Wmdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793178205;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:Organization:X-Mailer:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=5LM6dfhHTA3rkyS+UFL/6ZhiUcBegGEnqQ7x54XgQoQ=;
	b=uGgaYtpjJkHJfBoHOpCODVa+zaSVP8RjQ57vAq8KUMFgCQ0soDzAB7XYs4VbUwvlnExx
	 miNBJ1T1yEXjATze6qJcyL+vgVuciML6gCHjk7/99VOs9nJtXlQ+0FuLo+GHN4tbtZf3M
	 WZ9dDpNhT0r20QW3J7hTTcZ6nnquIMFhczfRTVEPAFKkuDVW3TOMfjxPMGonnEw0kDnna
	 yljkIgLGG4gVgR7EdRnahlaEcZt+vOxWsHgrEWahlyW3p5rV9J92ZvAYnxeu25Pt+iGIw
	 d4NhgL0NbcF9GpTd13MNQJmKXbXdnWMd2NbWMfLKrKPqiOjy5bptb2AFwkbQxRU4kpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZZHs+FgO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14C2606A31A
	for <linux-raid@vger.kernel.org>; Wed, 28 Oct 2026 09:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZZHs+FgO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870F51F031E1;
	Wed, 28 Oct 2026 09:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793178204;
	bh=5LM6dfhHTA3rkyS+UFL/6ZhiUcBegGEnqQ7x54XgQoQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZZHs+FgOOcCaSxfGome1I2TW4V/rphGP8qIOPIZ7Shu7wBrWuDR9i2WYW1cvkfE2E
	 c0UtoPXKu5XD2z+FxKae1JkEI+5npLcctokUgE7Z+1nGG/86j208NYeE5lmbCT8BoZ
	 PfNlSQ2UGtbUKvwzJsNQLqrAXYZKsB6X90t2pD2GPuhcn60gCt+aR6RqAdDe9Tdyai
	 MpxuJmj1gZuSPREYQyQnRfCCmf4Adyg+Q9BVCdt6TqQXMzqxp9lTbNtjs7FNmIjIyF
	 n0qajgDiqIGSwEgx4fk4nYuV+vAatN+148N3UJYzKOL7pF/H0OsKrnoYvq/OD4Od6m
	 6omdEfsUPHaNQ==
Date: Wed, 28 Oct 2026 10:03:17 +0100
From: Mariusz Tkaczyk <mtkaczyk@kernel.org>
To: "Masalkhi, Abd Alrhman" <abd.masalkhi@gatech.edu>
Cc: "blazej.kucman@graidtech.com" <blazej.kucman@graidtech.com>,
 "ncroxon@redhat.com" <ncroxon@redhat.com>, "xni@redhat.com"
 <xni@redhat.com>, "song@kernel.org" <song@kernel.org>, "yukuai@kernel.org"
 <yukuai@kernel.org>, "linux-raid@vger.kernel.org"
 <linux-raid@vger.kernel.org>
Subject: Re: [PATCH] mdadm: Deprecate the obsolete --auto-detect option
Message-ID: <20261028100317.3b964788@kernel.org>
In-Reply-To: <20261015130326.442915-1-abd.masalkhi@gatech.edu>
References: <20261015130326.442915-1-abd.masalkhi@gatech.edu>
Organization: Linux Development
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.50; x86_64-suse-linux-gnu)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Oct 2026 13:03:59 +0000
"Masalkhi, Abd Alrhman" <abd.masalkhi@gatech.edu> wrote:

> From: Abd-Alrhman Masalkhi <abd.masalkhi@gatech.edu>
> 
> --auto-detect opened md0 (9:0) and issued the RAID_AUTORUN ioctl to
> ask the kernel to start the arrays it had auto-detected. The kernel
> removed this ioctl in commit d82fa81c2364 ("md: replace the
> RAID_AUTORUN ioctl with a direct function call"). Before that, it
> worked only when md was built into the kernel. Since then, md_ioctl()

Redhat still builds-in md into kernel so there is chance that someone
is using it.


> has rejected it with ENOTTY, making --auto-detect ineffective on
> current kernels.


Hello,
Do you mind to submit github PRs for mdadm patches?
https://github.com/md-raid-utilities/mdadm

mdadm community is the most active over the github today.

Indeed, it has been removed 6 years ago. The question is if 6 years is
enough to stop supporting the configurations with new mdadm and old
kernel. I think it is not enough.

I would do that at least 10 years after kernel part removed.

What can be done here is warning and improved error message saying that
"The option is deprecated and probably it is not supported with this
kernel". If you wish you can be more detailed and add validation
against kernel version but I have no hard feeling to that. It is minor
case, probably not used because no one ever complained about the removed
ioctl.

You can left some TODO message saying that after 2030y it can
removed- that would be helpful for future maintainers.

Thanks,
Mariusz

> 
> Remove autodetect(). Keep the option for now to avoid breaking
> existing scripts, and print a warning message when it is used.
> 
> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gatech.edu>
> ---
>  Manage.c | 13 -------------
>  mdadm.c  |  2 +-
>  mdadm.h  |  1 -
>  3 files changed, 1 insertion(+), 15 deletions(-)
> 
> diff --git a/Manage.c b/Manage.c
> index 40d52cfc..d38336a0 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -1738,19 +1738,6 @@ abort:
>  	return !test && busy ? 2 : 1;
>  }
>  
> -int autodetect(void)
> -{
> -	/* Open any md device, and issue the RAID_AUTORUN ioctl */
> -	int rv = 1;
> -	int fd = dev_open("9:0", O_RDONLY);
> -	if (fd >= 0) {
> -		if (ioctl(fd, RAID_AUTORUN, 0) == 0)
> -			rv = 0;
> -		close_fd(&fd);
> -	}
> -	return rv;
> -}
> -
>  int Update_subarray(char *dev, char *subarray, enum update_opt
> update, struct mddev_ident *ident, int verbose)
>  {
> diff --git a/mdadm.c b/mdadm.c
> index 2517b037..c4e234e3 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -1744,7 +1744,7 @@ int main(int argc, char *argv[])
>  			rv = Incremental(devlist, &c, ss);
>  		break;
>  	case AUTODETECT:
> -		autodetect();
> +		pr_err("--auto-detect has no effect. It is
> deprecated and will be removed in future releases.\n"); break;
>  	}
>  	if (ss) {
> diff --git a/mdadm.h b/mdadm.h
> index deac7a56..985951d3 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1434,7 +1434,6 @@ extern int Manage_stop(char *devname, int fd,
> int quiet, extern int Manage_subdevs(char *devname, int fd,
>  			  struct mddev_dev *devlist, int verbose,
> int test, enum update_opt update, int force);
> -extern int autodetect(void);
>  extern int Grow_Add_device(char *devname, int fd, char *newdev);
>  extern int Grow_addbitmap(char *devname, int fd,
>  			  struct context *c, struct shape *s);

