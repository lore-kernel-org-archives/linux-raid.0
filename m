Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59B9FC433EF
	for <linux-raid@archiver.kernel.org>; Wed,  1 Jun 2022 11:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352685AbiFALX5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Jun 2022 07:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352625AbiFALXi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Jun 2022 07:23:38 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A53356F95
        for <linux-raid@vger.kernel.org>; Wed,  1 Jun 2022 04:22:47 -0700 (PDT)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 38FC761EA1929;
        Wed,  1 Jun 2022 13:22:44 +0200 (CEST)
Message-ID: <21a8b838-fc20-3657-6ee9-45b5aed10b62@molgen.mpg.de>
Date:   Wed, 1 Jun 2022 13:22:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2] Grow: Split Grow_reshape into helper function.
Content-Language: en-US
To:     Mateusz Kusiak <mateusz.kusiak@intel.com>
Cc:     jes@trained-monkey.org, colyli@suse.de, linux-raid@vger.kernel.org
References: <20220601092840.19986-1-mateusz.kusiak@intel.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220601092840.19986-1-mateusz.kusiak@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Mateusz,


Am 01.06.22 um 11:28 schrieb Mateusz Kusiak:

Could you please remove the dot/period at the end of the commit message 
summary [1]?

> Grow_reshape should be splitted into helper functions given it's size.

1.  be split
2.  s/it's/its/

> Add helper function for preparing reshape on external metadata.
> Close cfd file descriptor.

Maybe format this as a list.

> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
> ---
> 
> Changes since v1:
> - changed int val to int *val and int index to unsigned char index in
>    is_bit_set()
> - fixed typo in is_bit_set() description
> - changed context->array_state to &context->array.state
> 
> ---
>   Grow.c  | 124 ++++++++++++++++++++++++++++++--------------------------
>   mdadm.h |   1 +
>   util.c  |  14 +++++++
>   3 files changed, 81 insertions(+), 58 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index 9c6fc95e..6b8daf4a 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1774,6 +1774,65 @@ static int reshape_container(char *container, char *devname,
>   			     char *backup_file, int verbose,
>   			     int forked, int restart, int freeze_reshape);
>   
> +/**
> + * prepare_external_reshape() - prepares update on external metadata if supported.
> + * @devname: Device name.
> + * @subarray: Subarray.
> + * @st: Supertype.
> + * @container: Container.
> + * @cfd: Container file descriptor.
> + *
> + * Function checks that the requested reshape is supported on external metadata,
> + * and performs an initial check that the container holds the pre-requisite
> + * spare devices (mdmon owns final validation).
> + *
> + * Return: 0 on success, else error code

-1 and 1 are returned. What is the difference?

> + */
> +static int prepare_external_reshape(char *devname, char *subarray,
> +				    struct supertype *st, char *container,
> +				    const int cfd)
> +{
> +	struct mdinfo *cc = NULL;
> +	struct mdinfo *content = NULL;
> +
> +	if (st->ss->load_container(st, cfd, NULL)) {
> +		pr_err("Cannot read superblock for %s\n", devname);
> +		return 1;
> +	}
> +
> +	if (!st->ss->container_content)
> +		return -1;
> +
> +	cc = st->ss->container_content(st, subarray);
> +	for (content = cc; content ; content = content->next) {
> +		/*
> +		 * check if reshape is allowed based on metadata
> +		 * indications stored in content.array.status
> +		 */
> +		if (is_bit_set(&content->array.state, MD_SB_BLOCK_VOLUME) ||
> +		    is_bit_set(&content->array.state, MD_SB_BLOCK_CONTAINER_RESHAPE)) {
> +			pr_err("Cannot reshape arrays in container with unsupported metadata: %s(%s)\n",
> +			       devname, container);
> +			goto error;
> +		}
> +		if (content->consistency_policy == CONSISTENCY_POLICY_PPL) {
> +			pr_err("Operation not supported when ppl consistency policy is enabled\n");
> +			goto error;
> +		}
> +		if (content->consistency_policy == CONSISTENCY_POLICY_BITMAP) {
> +			pr_err("Operation not supported when write-intent bitmap consistency policy is enabled\n");
> +			goto error;
> +		}
> +	}
> +	sysfs_free(cc);
> +	if (mdmon_running(container))
> +		st->update_tail = &st->updates;
> +	return 0;
> +error:
> +	sysfs_free(cc);
> +	return 1;
> +}
> +
>   int Grow_reshape(char *devname, int fd,
>   		 struct mddev_dev *devlist,
>   		 unsigned long long data_offset,
> @@ -1801,7 +1860,7 @@ int Grow_reshape(char *devname, int fd,
>   	struct supertype *st;
>   	char *subarray = NULL;
>   
> -	int frozen;
> +	int frozen = 0;
>   	int changed = 0;
>   	char *container = NULL;
>   	int cfd = -1;
> @@ -1810,7 +1869,7 @@ int Grow_reshape(char *devname, int fd,
>   	int added_disks;
>   
>   	struct mdinfo info;
> -	struct mdinfo *sra;
> +	struct mdinfo *sra = NULL;
>   
>   	if (md_get_array_info(fd, &array) < 0) {
>   		pr_err("%s is not an active md array - aborting\n",
> @@ -1867,13 +1926,7 @@ int Grow_reshape(char *devname, int fd,
>   		}
>   	}
>   
> -	/* in the external case we need to check that the requested reshape is
> -	 * supported, and perform an initial check that the container holds the
> -	 * pre-requisite spare devices (mdmon owns final validation)
> -	 */
>   	if (st->ss->external) {
> -		int retval;
> -
>   		if (subarray) {
>   			container = st->container_devnm;
>   			cfd = open_dev_excl(st->container_devnm);
> @@ -1889,58 +1942,13 @@ int Grow_reshape(char *devname, int fd,
>   			return 1;
>   		}
>   
> -		retval = st->ss->load_container(st, cfd, NULL);
> -
> -		if (retval) {
> -			pr_err("Cannot read superblock for %s\n", devname);
> +		rv = prepare_external_reshape(devname, subarray, st,
> +					      container, cfd);
> +		if (rv > 0) {
>   			free(subarray);
> -			return 1;
> -		}
> -
> -		/* check if operation is supported for metadata handler */
> -		if (st->ss->container_content) {
> -			struct mdinfo *cc = NULL;
> -			struct mdinfo *content = NULL;
> -
> -			cc = st->ss->container_content(st, subarray);
> -			for (content = cc; content ; content = content->next) {
> -				int allow_reshape = 1;
> -
> -				/* check if reshape is allowed based on metadata
> -				 * indications stored in content.array.status
> -				 */
> -				if (content->array.state &
> -				    (1 << MD_SB_BLOCK_VOLUME))
> -					allow_reshape = 0;
> -				if (content->array.state &
> -				    (1 << MD_SB_BLOCK_CONTAINER_RESHAPE))
> -					allow_reshape = 0;
> -				if (!allow_reshape) {
> -					pr_err("cannot reshape arrays in container with unsupported metadata: %s(%s)\n",
> -					       devname, container);
> -					sysfs_free(cc);
> -					free(subarray);
> -					return 1;
> -				}
> -				if (content->consistency_policy ==
> -				    CONSISTENCY_POLICY_PPL) {
> -					pr_err("Operation not supported when ppl consistency policy is enabled\n");
> -					sysfs_free(cc);
> -					free(subarray);
> -					return 1;
> -				}
> -				if (content->consistency_policy ==
> -				    CONSISTENCY_POLICY_BITMAP) {
> -					pr_err("Operation not supported when write-intent bitmap is enabled\n");
> -					sysfs_free(cc);
> -					free(subarray);
> -					return 1;
> -				}
> -			}
> -			sysfs_free(cc);
> +			close(cfd);
> +			goto release;
>   		}
> -		if (mdmon_running(container))
> -			st->update_tail = &st->updates;
>   	}
>   
>   	added_disks = 0;
> diff --git a/mdadm.h b/mdadm.h
> index c7268a71..7bf9147d 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1528,6 +1528,7 @@ extern int stat_is_blkdev(char *devname, dev_t *rdev);
>   extern bool is_dev_alive(char *path);
>   extern int get_mdp_major(void);
>   extern int get_maj_min(char *dev, int *major, int *minor);
> +extern bool is_bit_set(int *val, unsigned char index);
>   extern int dev_open(char *dev, int flags);
>   extern int open_dev(char *devnm);
>   extern void reopen_mddev(int mdfd);
> diff --git a/util.c b/util.c
> index 3d05d074..c13c81d7 100644
> --- a/util.c
> +++ b/util.c
> @@ -1028,6 +1028,20 @@ int get_maj_min(char *dev, int *major, int *minor)
>   		*e == 0);
>   }
>   
> +/**
> + * is_bit_set() - get bit value by index.
> + * @val: value.
> + * @index: index of the bit (LSB numbering).
> + *
> + * Return: bit value.
> + */
> +bool is_bit_set(int *val, unsigned char index)
> +{
> +	if ((*val) & (1 << index))
> +		return true;
> +	return false;

Maybe:

     return (*val) & (1 << index)

> +}
> +
>   int dev_open(char *dev, int flags)
>   {
>   	/* like 'open', but if 'dev' matches %d:%d, create a temp


Kind regards,

Paul


[1]: https://cbea.ms/git-commit/
