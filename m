Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EFDCC4167B
	for <linux-raid@archiver.kernel.org>; Wed, 28 Dec 2022 15:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbiL1PHi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 28 Dec 2022 10:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233595AbiL1PHg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 28 Dec 2022 10:07:36 -0500
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E8213D6D
        for <linux-raid@vger.kernel.org>; Wed, 28 Dec 2022 07:07:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1672240047; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=inFq/YB47s5suQCw77yIfwwKBA/ppQ6MpMlhCJEgZDfzrQb2MXzasz9vgxVZVcBhFtmPMviQrdHkUSoxyPCmJNHDhM0njwJNdUVb1NB9qClGj0nrS4JCPBEPQrBICum6rFlDUOrnLvlzXOtfXdfuIf3wJ10fKav2vb0zUqBYGdY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1672240047; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=8zbQqHMl4gWUUbTH9gKsGaV/9KNuI90ogvkRtROJm30=; 
        b=hxDtCrQZmwVEpxw0wAXIi1v5DjXtF5JK+MQnmmNcC6L/p18qTQ62jpYpl8MLLd+Jdz7KSZ1FzKiUwcKRxCyTkVgJQtuEVnV2xaLR5ZuO28oHRsQTJPdHbuJN3pLSE8JyadiIDSokOUVUGrT3vjMzmPc1waGW31wBwXgpXIknubw=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1672240044210771.9224258736807; Wed, 28 Dec 2022 16:07:24 +0100 (CET)
Message-ID: <bef57069-acdb-3a2f-b691-2c438c4247fb@trained-monkey.org>
Date:   Wed, 28 Dec 2022 10:07:22 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH 2/3] mdadm: refactor ident->name handling
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, colyli@suse.de
Cc:     linux-raid@vger.kernel.org
References: <20221221115019.26276-1-mariusz.tkaczyk@linux.intel.com>
 <20221221115019.26276-3-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20221221115019.26276-3-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/21/22 06:50, Mariusz Tkaczyk wrote:
> Move duplicated code for both config.c and mdadm.c to new functions.
> Add error enum in mdadm.h. Use MD_NAME_MAX instead hardcoded value
> in mddev_ident. Use secure functions.
> 
> In next patch POSIX validation is added.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Hi Mariusz,

I appreciate the work to consolidate duplicate code. However, I am not a
fan of new typedefs, in addition you return status_t codes in functions
changed to return error_t, which is inconsistent.

I would prefer if we move towards standard POSIX error codes instead of
trying to invent new ones.

Thanks,
Jes

> ---
>  config.c | 35 +++++++++++++++++++++++++++--------
>  lib.c    | 16 ++++++++++++++++
>  mdadm.c  | 16 ++++------------
>  mdadm.h  | 21 +++++++++++++++------
>  util.c   | 20 ++++++++++++++++++++
>  5 files changed, 82 insertions(+), 26 deletions(-)
> 
> diff --git a/config.c b/config.c
> index eeedd0c6..7d3eb6fc 100644
> --- a/config.c
> +++ b/config.c
> @@ -147,6 +147,32 @@ inline void ident_init(struct mddev_ident *ident)
>  	ident->uuid_set = 0;
>  }
>  
> +/**
> + * ident_set_name()- set name in &mddev_ident.
> + * @ident: pointer to &mddev_ident.
> + * @name: name to be set.
> + *
> + * If criteria passed, set name in @ident.
> + *
> + * Return: %STATUS_SUCCESS or %STATUS_ERROR.
> + */
> +status_t ident_set_name(struct mddev_ident *ident, const char *name)
> +{
> +	assert(name);
> +	assert(ident);
> +
> +	if (ident->name[0]) {
> +		pr_err("Name can be specified once, second value is '%s'.\n", name);
> +		return STATUS_ERROR;
> +	}
> +
> +	if (check_mdname(name) == STATUS_ERROR)
> +		return STATUS_ERROR;
> +
> +	snprintf(ident->name, MD_NAME_MAX + 1, "%s", name);
> +	return STATUS_SUCCESS;
> +}
> +
>  struct conf_dev {
>  	struct conf_dev *next;
>  	char *name;
> @@ -445,14 +471,7 @@ void arrayline(char *line)
>  					mis.super_minor = minor;
>  			}
>  		} else if (strncasecmp(w, "name=", 5) == 0) {
> -			if (mis.name[0])
> -				pr_err("only specify name once, %s ignored.\n",
> -					w);
> -			else if (strlen(w + 5) > 32)
> -				pr_err("name too long, ignoring %s\n", w);
> -			else
> -				strcpy(mis.name, w + 5);
> -
> +			ident_set_name(&mis, w + 5);
>  		} else if (strncasecmp(w, "bitmap=", 7) == 0) {
>  			if (mis.bitmap_file)
>  				pr_err("only specify bitmap file once. %s ignored\n",
> diff --git a/lib.c b/lib.c
> index e395b28d..624580e1 100644
> --- a/lib.c
> +++ b/lib.c
> @@ -27,6 +27,22 @@
>  #include	<ctype.h>
>  #include	<limits.h>
>  
> +/**
> + * is_strnlen_lq() - Check if string length is lower or equal to requested.
> + * @str: string to check.
> + * @max_len: max length.
> + *
> + * @str length must be bigger than 0 and be lower or equal @max_len, including termination byte.
> + */
> +bool is_strnlen_lq(const char * const str, size_t max_len)
> +{
> +	assert(str);
> +
> +	size_t _len = strnlen(str, max_len);
> +
> +	return (_len < max_len && _len != 0);
> +}
> +
>  bool is_dev_alive(char *path)
>  {
>  	if (!path)
> diff --git a/mdadm.c b/mdadm.c
> index 74fdec31..5bd3d5a7 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -686,20 +686,14 @@ int main(int argc, char *argv[])
>  		case O(CREATE,'N'):
>  		case O(ASSEMBLE,'N'):
>  		case O(MISC,'N'):
> -			if (ident.name[0]) {
> -				pr_err("name cannot be set twice.   Second value %s.\n", optarg);
> -				exit(2);
> -			}
>  			if (mode == MISC && !c.subarray) {
>  				pr_err("-N/--name only valid with --update-subarray in misc mode\n");
>  				exit(2);
>  			}
> -			if (strlen(optarg) > 32) {
> -				pr_err("name '%s' is too long, 32 chars max.\n",
> -					optarg);
> +
> +			if (ident_set_name(&ident, optarg) != STATUS_SUCCESS)
>  				exit(2);
> -			}
> -			strcpy(ident.name, optarg);
> +
>  			continue;
>  
>  		case O(ASSEMBLE,'m'): /* super-minor for array */
> @@ -1341,10 +1335,8 @@ int main(int argc, char *argv[])
>  		} else {
>  			char *bname = basename(devlist->devname);
>  
> -			if (strlen(bname) > MD_NAME_MAX) {
> -				pr_err("Name %s is too long.\n", devlist->devname);
> +			if (check_mdname(bname))
>  				exit(1);
> -			}
>  
>  			ret = stat(devlist->devname, &stb);
>  			if (ident.super_minor == -2 && ret != 0) {
> diff --git a/mdadm.h b/mdadm.h
> index 23ffe977..b68fa4bc 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -275,6 +275,11 @@ static inline void __put_unaligned32(__u32 val, void *p)
>  
>  #define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))
>  
> +/**
> + * This is true for native and DDF, IMSM allows 16.
> + */
> +#define MD_NAME_MAX 32
> +
>  extern const char Name[];
>  
>  struct md_bb_entry {
> @@ -406,6 +411,12 @@ struct spare_criteria {
>  	unsigned int sector_size;
>  };
>  
> +typedef enum status {
> +	STATUS_SUCCESS = 0,
> +	STATUS_ERROR,
> +	STATUS_UNDEF,
> +} status_t;
> +
>  enum mode {
>  	ASSEMBLE=1,
>  	BUILD,
> @@ -528,7 +539,7 @@ struct mddev_ident {
>  
>  	int	uuid_set;
>  	int	uuid[4];
> -	char	name[33];
> +	char	name[MD_NAME_MAX + 1];
>  
>  	int super_minor;
>  
> @@ -1538,6 +1549,7 @@ extern int check_partitions(int fd, char *dname,
>  extern int fstat_is_blkdev(int fd, char *devname, dev_t *rdev);
>  extern int stat_is_blkdev(char *devname, dev_t *rdev);
>  
> +extern bool is_strnlen_lq(const char * const str, size_t max_len);
>  extern bool is_dev_alive(char *path);
>  extern int get_mdp_major(void);
>  extern int get_maj_min(char *dev, int *major, int *minor);
> @@ -1555,6 +1567,7 @@ extern void manage_fork_fds(int close_all);
>  extern int continue_via_systemd(char *devnm, char *service_name);
>  
>  extern void ident_init(struct mddev_ident *ident);
> +extern status_t ident_set_name(struct mddev_ident *ident, const char *name);
>  
>  extern int parse_auto(char *str, char *msg, int config);
>  extern struct mddev_ident *conf_get_ident(char *dev);
> @@ -1634,6 +1647,7 @@ extern void print_r10_layout(int layout);
>  
>  extern char *find_free_devnm(int use_partitions);
>  
> +extern error_t check_mdname(const char *name);
>  extern void put_md_name(char *name);
>  extern char *devid2kname(dev_t devid);
>  extern char *devid2devnm(dev_t devid);
> @@ -1923,11 +1937,6 @@ enum r0layout {
>  /* And another special number needed for --data_offset=variable */
>  #define VARIABLE_OFFSET 3
>  
> -/**
> - * This is true for native and DDF, IMSM allows 16.
> - */
> -#define MD_NAME_MAX 32
> -
>  /**
>   * is_container() - check if @level is &LEVEL_CONTAINER
>   * @level: level v> 
> diff --git a/config.c b/config.c
> index dc1620c1..eeedd0c6 100644
> --- a/config.c
> +++ b/config.c
> @@ -119,6 +119,34 @@ int match_keyword(char *word)
>  	return -1;
>  }
>  
> +/**
> + * ident_init() - Set defaults.
> + * @ident: ident pointer, not NULL.
> + */
> +inline void ident_init(struct mddev_ident *ident)
> +{
> +	assert(ident);
> +
> +	ident->assembled = false;
> +	ident->autof = 0;
> +	ident->bitmap_fd = -1;
> +	ident->bitmap_file = NULL;
> +	ident->container = NULL;
> +	ident->devices = NULL;
> +	ident->devname = NULL;
> +	ident->level = UnSet;
> +	ident->member = NULL;
> +	ident->name[0] = 0;
> +	ident->next = NULL;
> +	ident->raid_disks = UnSet;
> +	ident->spare_group = NULL;
> +	ident->spare_disks = 0;
> +	ident->st = NULL;
> +	ident->super_minor = UnSet;
> +	ident->uuid[0] = 0;
> +	ident->uuid_set = 0;
> +}
> +
>  struct conf_dev {
>  	struct conf_dev *next;
>  	char *name;
> @@ -363,22 +391,7 @@ void arrayline(char *line)
>  	struct mddev_ident mis;
>  	struct mddev_ident *mi;
>  
> -	mis.uuid_set = 0;
> -	mis.super_minor = UnSet;
> -	mis.level = UnSet;
> -	mis.raid_disks = UnSet;
> -	mis.spare_disks = 0;
> -	mis.devices = NULL;
> -	mis.devname = NULL;
> -	mis.spare_group = NULL;
> -	mis.autof = 0;
> -	mis.next = NULL;
> -	mis.st = NULL;
> -	mis.bitmap_fd = -1;
> -	mis.bitmap_file = NULL;
> -	mis.name[0] = 0;
> -	mis.container = NULL;
> -	mis.member = NULL;
> +	ident_init(&mis);
>  
>  	for (w = dl_next(line); w != line; w = dl_next(w)) {
>  		if (w[0] == '/' || strchr(w, '=') == NULL) {
> diff --git a/mdadm.c b/mdadm.c
> index 972adb52..74fdec31 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -107,25 +107,13 @@ int main(int argc, char *argv[])
>  
>  	srandom(time(0) ^ getpid());
>  
> -	ident.uuid_set = 0;
> -	ident.level = UnSet;
> -	ident.raid_disks = UnSet;
> -	ident.super_minor = UnSet;
> -	ident.devices = 0;
> -	ident.spare_group = NULL;
> -	ident.autof = 0;
> -	ident.st = NULL;
> -	ident.bitmap_fd = -1;
> -	ident.bitmap_file = NULL;
> -	ident.name[0] = 0;
> -	ident.container = NULL;
> -	ident.member = NULL;
> -
>  	if (get_linux_version() < 2006015) {
>  		pr_err("This version of mdadm does not support kernels older than 2.6.15\n");
>  		exit(1);
>  	}
>  
> +	ident_init(&ident);
> +
>  	while ((option_index = -1),
>  	       (opt = getopt_long(argc, argv, shortopt, long_options,
>  				  &option_index)) != -1) {
> diff --git a/mdadm.h b/mdadm.h
> index 3673494e..23ffe977 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -33,8 +33,10 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
>  # endif
>  #endif
>  
> +#include	<assert.h>
>  #include	<sys/types.h>
>  #include	<sys/stat.h>
> +#include	<stdarg.h>
>  #include	<stdint.h>
>  #include	<stdlib.h>
>  #include	<time.h>
> @@ -1552,6 +1554,8 @@ extern void enable_fds(int devices);
>  extern void manage_fork_fds(int close_all);
>  extern int continue_via_systemd(char *devnm, char *service_name);
>  
> +extern void ident_init(struct mddev_ident *ident);
> +
>  extern int parse_auto(char *str, char *msg, int config);
>  extern struct mddev_ident *conf_get_ident(char *dev);
>  extern struct mddev_dev *conf_get_devs(void);
> @@ -1779,8 +1783,7 @@ static inline sighandler_t signal_s(int sig, sighandler_t handler)
>  #define dprintf_cont(fmt, arg...) \
>          ({ if (0) fprintf(stderr, fmt, ##arg); 0; })
>  #endif
> -#include <assert.h>
> -#include <stdarg.h>
> +
>  static inline int xasprintf(char **strp, const char *fmt, ...) {
>  	va_list ap;
>  	int ret;alue
> diff --git a/util.c b/util.c
> index 26ffdcea..b2a4ea21 100644
> --- a/util.c
> +++ b/util.c
> @@ -932,6 +932,26 @@ int get_data_disks(int level, int layout, int raid_disks)
>  	return data_disks;
>  }
>  
> +/**
> + * check_md_name()- check if MD device name is correct.
> + * @name: name to check.
> + *
> + * In case of error, message is printed.
> + *
> + * Return: %STATUS_SUCCESS or %STATUS_ERROR.
> + */
> +error_t check_mdname(const char * const name)
> +{
> +	assert(name);
> +
> +	if (!is_strnlen_lq(name, MD_NAME_MAX + 1)) {
> +		pr_err("Name '%s' is too long or empty, %d characters max.\n", name, MD_NAME_MAX);
> +		return STATUS_ERROR;
> +	}
> +
> +	return STATUS_SUCCESS;
> +}
> +
>  dev_t devnm2devid(char *devnm)
>  {
>  	/* First look in /sys/block/$DEVNM/dev for %d:%d

