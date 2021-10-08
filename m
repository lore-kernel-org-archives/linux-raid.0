Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01A1AC433EF
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 11:12:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA3996101A
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 11:12:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240117AbhJHLN7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Oct 2021 07:13:59 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17263 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232378AbhJHLN7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Oct 2021 07:13:59 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1633691520; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=DadFA+H9Lr2I1+vkyrvz870RRmP3Xamo5QubmDtC88NXIH0gVpePuPcfGgFlxiz9efwwtflMlLBZDrD7DBe++iuesO2udtWFK02o2bXERrwA+8v35q2SmYFs/HiopDrLuTT0k6o1QzEaMmqZhXQJbINnZl0HCBbsGnX0iXOSNmI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1633691520; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=l8jiljpp5Kep/1xlplSNEYFL9kblKSss10BSP+A6vXY=; 
        b=jqBjZo+CfHYFrB0l+uWWAqfokBOXJ+PQ6B7wx0HrGYWA3Q8Rog2Uisgaf2ULjdlkMKzVIi+7wLWtazbPRLhm8nr0GY875SNcL8NsA+1hjH5j41gMYoZzbnem0ztzNysQYwEo9QocchqSaedg/w3iq5W2mzeOnBie8E6cDNFAGoU=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [100.110.16.7] (163.114.131.1 [163.114.131.1]) by mx.zoho.eu
        with SMTPS id 16336915178121018.8309150003505; Fri, 8 Oct 2021 13:11:57 +0200 (CEST)
Subject: Re: [PATCH] Refactor parse_num and use it to parse optarg.
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org
References: <20210902094812.25818-1-mateusz.grzonka@intel.com>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <a6805349-f80e-a62e-16db-37d5c8de8363@trained-monkey.org>
Date:   Fri, 8 Oct 2021 07:11:57 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210902094812.25818-1-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/2/21 5:48 AM, Mateusz Grzonka wrote:
> Use parse_num instead of atoi to parse optarg. Replace atoi by strtol.
> Move inst to int conversion into manage_new. Add better error handling.
> 
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
> ---
>  lib.c         | 28 ++++++++++++++++++++++++++++
>  managemon.c   | 32 ++++++++++++++++++++------------
>  mdadm.c       | 50 ++++++++++++++++++--------------------------------
>  mdadm.h       |  4 ++--
>  super-ddf.c   | 17 ++++++++---------
>  super-intel.c | 10 +++++-----
>  util.c        | 13 ++-----------
>  7 files changed, 83 insertions(+), 71 deletions(-)

Mariusz,

I have gone ahead and applied this. Some comments:

1) In the future please try and keep unrelated changes in separate
   patches. Ie. strncmp() has nothing to do with parse_num()
2) Why arbitrarily restrict parse_num() to positive values only? You are
   returning an int after all, and return a separate error value, so it
   could allow for signed values.

Thanks,
Jes

> diff --git a/lib.c b/lib.c
> index 60890b95..76d1fbb9 100644
> --- a/lib.c
> +++ b/lib.c
> @@ -25,6 +25,7 @@
>  #include	"mdadm.h"
>  #include	"dlink.h"
>  #include	<ctype.h>
> +#include	<limits.h>
>  
>  /* This fill contains various 'library' style function.  They
>   * have no dependency on anything outside this file.
> @@ -534,3 +535,30 @@ void free_line(char *line)
>  	}
>  	dl_free(line);
>  }
> +
> +/**
> + * parse_num() - Parse int from string.
> + * @dest: Pointer to destination.
> + * @num: Pointer to string that is going to be parsed.
> + *
> + * If string contains anything after a number, error code is returned.
> + * The same happens when number is bigger than INT_MAX or smaller than 0.
> + * Writes to destination only if successfully read the number.
> + *
> + * Return: 0 on success, 1 otherwise.
> + */
> +int parse_num(int *dest, char *num)
> +{
> +	char *c = NULL;
> +	long temp;
> +
> +	if (!num)
> +		return 1;
> +
> +	errno = 0;
> +	temp = strtol(num, &c, 10);
> +	if (temp < 0 || temp > INT_MAX || *c || errno != 0 || num == c)
> +		return 1;
> +	*dest = temp;
> +	return 0;
> +}
> diff --git a/managemon.c b/managemon.c
> index 200cf83e..bb7334cf 100644
> --- a/managemon.c
> +++ b/managemon.c
> @@ -661,18 +661,17 @@ static void manage_new(struct mdstat_ent *mdstat,
>  	 * the monitor.
>  	 */
>  
> -	struct active_array *new;
> -	struct mdinfo *mdi, *di;
> -	char *inst;
> -	int i;
> +	struct active_array *new = NULL;
> +	struct mdinfo *mdi = NULL, *di;
> +	int i, inst;
>  	int failed = 0;
>  	char buf[40];
>  
>  	/* check if array is ready to be monitored */
>  	if (!mdstat->active || !mdstat->level)
>  		return;
> -	if (strcmp(mdstat->level, "raid0") == 0 ||
> -	    strcmp(mdstat->level, "linear") == 0)
> +	if (strncmp(mdstat->level, "raid0", strlen("raid0")) == 0 ||
> +	    strncmp(mdstat->level, "linear", strlen("linear")) == 0)
>  		return;
>  
>  	mdi = sysfs_read(-1, mdstat->devnm,
> @@ -691,7 +690,8 @@ static void manage_new(struct mdstat_ent *mdstat,
>  
>  	new->container = container;
>  
> -	inst = to_subarray(mdstat, container->devnm);
> +	if (parse_num(&inst, to_subarray(mdstat, container->devnm)) != 0)
> +		goto error;
>  
>  	new->info.array = mdi->array;
>  	new->info.component_size = mdi->component_size;
> @@ -724,7 +724,7 @@ static void manage_new(struct mdstat_ent *mdstat,
>  	new->safe_mode_delay_fd = sysfs_open2(new->info.sys_name, NULL,
>  					      "safe_mode_delay");
>  
> -	dprintf("inst: %s action: %d state: %d\n", inst,
> +	dprintf("inst: %d action: %d state: %d\n", inst,
>  		new->action_fd, new->info.state_fd);
>  
>  	if (mdi->safe_mode_delay >= 50)
> @@ -759,15 +759,13 @@ static void manage_new(struct mdstat_ent *mdstat,
>  	}
>  
>  	sysfs_free(mdi);
> +	mdi = NULL;
>  
>  	/* if everything checks out tell the metadata handler we want to
>  	 * manage this instance
>  	 */
>  	if (!aa_ready(new) || container->ss->open_new(container, new, inst) < 0) {
> -		pr_err("failed to monitor %s\n",
> -			mdstat->metadata_version);
> -		new->container = NULL;
> -		free_aa(new);
> +		goto error;
>  	} else {
>  		replace_array(container, victim, new);
>  		if (failed) {
> @@ -775,6 +773,16 @@ static void manage_new(struct mdstat_ent *mdstat,
>  			manage_member(mdstat, new);
>  		}
>  	}
> +	return;
> +
> +error:
> +	pr_err("failed to monitor %s\n", mdstat->metadata_version);
> +	if (new) {
> +		new->container = NULL;
> +		free_aa(new);
> +	}
> +	if (mdi)
> +		sysfs_free(mdi);
>  }
>  
>  void manage(struct mdstat_ent *mdstat, struct supertype *container)
> diff --git a/mdadm.c b/mdadm.c
> index 073b7241..a31ab99c 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -610,8 +610,7 @@ int main(int argc, char *argv[])
>  					s.raiddisks, optarg);
>  				exit(2);
>  			}
> -			s.raiddisks = parse_num(optarg);
> -			if (s.raiddisks <= 0) {
> +			if (parse_num(&s.raiddisks, optarg) != 0 || s.raiddisks <= 0) {
>  				pr_err("invalid number of raid devices: %s\n",
>  					optarg);
>  				exit(2);
> @@ -621,8 +620,7 @@ int main(int argc, char *argv[])
>  		case O(ASSEMBLE, Nodes):
>  		case O(GROW, Nodes):
>  		case O(CREATE, Nodes):
> -			c.nodes = parse_num(optarg);
> -			if (c.nodes < 2) {
> +			if (parse_num(&c.nodes, optarg) != 0 || c.nodes < 2) {
>  				pr_err("clustered array needs two nodes at least: %s\n",
>  					optarg);
>  				exit(2);
> @@ -647,8 +645,7 @@ int main(int argc, char *argv[])
>  					s.level);
>  				exit(2);
>  			}
> -			s.sparedisks = parse_num(optarg);
> -			if (s.sparedisks < 0) {
> +			if (parse_num(&s.sparedisks, optarg) != 0 || s.sparedisks < 0) {
>  				pr_err("invalid number of spare-devices: %s\n",
>  					optarg);
>  				exit(2);
> @@ -732,12 +729,9 @@ int main(int argc, char *argv[])
>  			}
>  			if (strcmp(optarg, "dev") == 0)
>  				ident.super_minor = -2;
> -			else {
> -				ident.super_minor = parse_num(optarg);
> -				if (ident.super_minor < 0) {
> -					pr_err("Bad super-minor number: %s.\n", optarg);
> -					exit(2);
> -				}
> +			else if (parse_num(&ident.super_minor, optarg) != 0 || ident.super_minor < 0) {
> +				pr_err("Bad super-minor number: %s.\n", optarg);
> +				exit(2);
>  			}
>  			continue;
>  
> @@ -907,8 +901,8 @@ int main(int argc, char *argv[])
>  
>  		case O(MONITOR,'r'): /* rebuild increments */
>  		case O(MONITOR,Increment):
> -			increments = atoi(optarg);
> -			if (increments > 99 || increments < 1) {
> +			if (parse_num(&increments, optarg) != 0
> +				|| increments > 99 || increments < 1) {
>  				pr_err("please specify positive integer between 1 and 99 as rebuild increments.\n");
>  				exit(2);
>  			}
> @@ -919,15 +913,10 @@ int main(int argc, char *argv[])
>  		case O(BUILD,'d'): /* delay for bitmap updates */
>  		case O(CREATE,'d'):
>  			if (c.delay)
> -				pr_err("only specify delay once. %s ignored.\n",
> -					optarg);
> -			else {
> -				c.delay = parse_num(optarg);
> -				if (c.delay < 1) {
> -					pr_err("invalid delay: %s\n",
> -						optarg);
> -					exit(2);
> -				}
> +				pr_err("only specify delay once. %s ignored.\n", optarg);
> +			else if (parse_num(&c.delay, optarg) != 0 || c.delay < 1) {
> +				pr_err("invalid delay: %s\n", optarg);
> +				exit(2);
>  			}
>  			continue;
>  		case O(MONITOR,'f'): /* daemonise */
> @@ -1209,18 +1198,15 @@ int main(int argc, char *argv[])
>  
>  		case O(GROW, WriteBehind):
>  		case O(BUILD, WriteBehind):
> -		case O(CREATE, WriteBehind): /* write-behind mode */
> +		case O(CREATE, WriteBehind):
>  			s.write_behind = DEFAULT_MAX_WRITE_BEHIND;
> -			if (optarg) {
> -				s.write_behind = parse_num(optarg);
> -				if (s.write_behind < 0 ||
> -				    s.write_behind > 16383) {
> -					pr_err("Invalid value for maximum outstanding write-behind writes: %s.\n\tMust be between 0 and 16383.\n", optarg);
> -					exit(2);
> -				}
> +			if (parse_num(&s.write_behind, optarg) != 0 ||
> +			s.write_behind < 0 || s.write_behind > 16383) {
> +				pr_err("Invalid value for maximum outstanding write-behind writes: %s.\n\tMust be between 0 and 16383.\n",
> +						optarg);
> +				exit(2);
>  			}
>  			continue;
> -
>  		case O(INCREMENTAL, 'r'):
>  		case O(INCREMENTAL, RebuildMapOpt):
>  			rebuild_map = 1;
> diff --git a/mdadm.h b/mdadm.h
> index 8f8841d8..53ea0de6 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1077,7 +1077,7 @@ extern struct superswitch {
>  
>  /* for mdmon */
>  	int (*open_new)(struct supertype *c, struct active_array *a,
> -			char *inst);
> +			int inst);
>  
>  	/* Tell the metadata handler the current state of the array.
>  	 * This covers whether it is known to be consistent (no pending writes)
> @@ -1488,7 +1488,7 @@ extern int parse_uuid(char *str, int uuid[4]);
>  extern int is_near_layout_10(int layout);
>  extern int parse_layout_10(char *layout);
>  extern int parse_layout_faulty(char *layout);
> -extern long parse_num(char *num);
> +extern int parse_num(int *dest, char *num);
>  extern int parse_cluster_confirm_arg(char *inp, char **devname, int *slot);
>  extern int check_ext2(int fd, char *name);
>  extern int check_reiser(int fd, char *name);
> diff --git a/super-ddf.c b/super-ddf.c
> index dc8e512f..afbe3b73 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -4057,20 +4057,19 @@ static int compare_super_ddf(struct supertype *st, struct supertype *tst,
>   * We need to confirm that the array matches the metadata in 'c' so
>   * that we don't corrupt any metadata.
>   */
> -static int ddf_open_new(struct supertype *c, struct active_array *a, char *inst)
> +static int ddf_open_new(struct supertype *c, struct active_array *a, int inst)
>  {
>  	struct ddf_super *ddf = c->sb;
> -	int n = atoi(inst);
>  	struct mdinfo *dev;
>  	struct dl *dl;
>  	static const char faulty[] = "faulty";
>  
> -	if (all_ff(ddf->virt->entries[n].guid)) {
> -		pr_err("subarray %d doesn't exist\n", n);
> +	if (all_ff(ddf->virt->entries[inst].guid)) {
> +		pr_err("subarray %d doesn't exist\n", inst);
>  		return -ENODEV;
>  	}
> -	dprintf("new subarray %d, GUID: %s\n", n,
> -		guid_str(ddf->virt->entries[n].guid));
> +	dprintf("new subarray %d, GUID: %s\n", inst,
> +		guid_str(ddf->virt->entries[inst].guid));
>  	for (dev = a->info.devs; dev; dev = dev->next) {
>  		for (dl = ddf->dlist; dl; dl = dl->next)
>  			if (dl->major == dev->disk.major &&
> @@ -4078,13 +4077,13 @@ static int ddf_open_new(struct supertype *c, struct active_array *a, char *inst)
>  				break;
>  		if (!dl || dl->pdnum < 0) {
>  			pr_err("device %d/%d of subarray %d not found in meta data\n",
> -				dev->disk.major, dev->disk.minor, n);
> +				dev->disk.major, dev->disk.minor, inst);
>  			return -1;
>  		}
>  		if ((be16_to_cpu(ddf->phys->entries[dl->pdnum].state) &
>  			(DDF_Online|DDF_Missing|DDF_Failed)) != DDF_Online) {
>  			pr_err("new subarray %d contains broken device %d/%d (%02x)\n",
> -			       n, dl->major, dl->minor,
> +			       inst, dl->major, dl->minor,
>  			       be16_to_cpu(ddf->phys->entries[dl->pdnum].state));
>  			if (write(dev->state_fd, faulty, sizeof(faulty)-1) !=
>  			    sizeof(faulty) - 1)
> @@ -4092,7 +4091,7 @@ static int ddf_open_new(struct supertype *c, struct active_array *a, char *inst)
>  			dev->curr_state = DS_FAULTY;
>  		}
>  	}
> -	a->info.container_member = n;
> +	a->info.container_member = inst;
>  	return 0;
>  }
>  
> diff --git a/super-intel.c b/super-intel.c
> index 83ddc000..08c64409 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -8263,19 +8263,19 @@ static int imsm_count_failed(struct intel_super *super, struct imsm_dev *dev,
>  }
>  
>  static int imsm_open_new(struct supertype *c, struct active_array *a,
> -			 char *inst)
> +			 int inst)
>  {
>  	struct intel_super *super = c->sb;
>  	struct imsm_super *mpb = super->anchor;
>  	struct imsm_update_prealloc_bb_mem u;
>  
> -	if (atoi(inst) >= mpb->num_raid_devs) {
> -		pr_err("subarry index %d, out of range\n", atoi(inst));
> +	if (inst >= mpb->num_raid_devs) {
> +		pr_err("subarry index %d, out of range\n", inst);
>  		return -ENODEV;
>  	}
>  
> -	dprintf("imsm: open_new %s\n", inst);
> -	a->info.container_member = atoi(inst);
> +	dprintf("imsm: open_new %d\n", inst);
> +	a->info.container_member = inst;
>  
>  	u.type = update_prealloc_badblocks_mem;
>  	imsm_update_metadata_locally(c, &u, sizeof(u));
> diff --git a/util.c b/util.c
> index cdf1da24..263e074a 100644
> --- a/util.c
> +++ b/util.c
> @@ -422,6 +422,8 @@ int parse_layout_10(char *layout)
>  
>  int parse_layout_faulty(char *layout)
>  {
> +	if (!layout)
> +		return -1;
>  	/* Parse the layout string for 'faulty' */
>  	int ln = strcspn(layout, "0123456789");
>  	char *m = xstrdup(layout);
> @@ -434,17 +436,6 @@ int parse_layout_faulty(char *layout)
>  	return mode | (atoi(layout+ln)<< ModeShift);
>  }
>  
> -long parse_num(char *num)
> -{
> -	/* Either return a valid number, or -1 */
> -	char *c;
> -	long rv = strtol(num, &c, 10);
> -	if (rv < 0 || *c || !num[0])
> -		return -1;
> -	else
> -		return rv;
> -}
> -
>  int parse_cluster_confirm_arg(char *input, char **devname, int *slot)
>  {
>  	char *dev;
> 

