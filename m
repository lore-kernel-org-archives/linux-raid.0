Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A395644E
	for <linux-raid@vger.kernel.org>; Mon, 18 Mar 2024 18:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710784850; cv=none; b=lkg+T73tiuv/qiR6zNxmdl5Su5Jayj+FofWSl8SjLo1aq18k0DzK4+KXjM9SSB8F/5IfBxgq8bUjisv31orOZu2oWBSHbnhNRI6QG2h3PRPMlMEW2lTfPwBD3mZKe0tR9psXHeseB7HD9nG4c0sgddkDLjxw3bn5JBj91TmkHEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710784850; c=relaxed/simple;
	bh=OES84+7byXumjHSAOGTBO3R15VYn1ttuzpawWvt9q7I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ldmoO5xWQ9XyoaUWUUvqn7SUElQSbY0LXTXiO5JsynPDiEHdC38XMBJZZIrsWfQe3yZGpVJKcQiFMzs36J02Gac6vapGm4fUjXQIYBCJY2+LhzcVg1cd407bfzjJN2Fui8GMYFM3lpKZE/FmN0Xl7fiEajDLC0ENlLR8N2lzpt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.178.112] (p57b378ee.dip0.t-ipconnect.de [87.179.120.238])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id B65B861E5FE06;
	Mon, 18 Mar 2024 19:00:20 +0100 (CET)
Message-ID: <d9b973fb-c7cf-4d6e-9a3c-092893112b0d@molgen.mpg.de>
Date: Mon, 18 Mar 2024 19:00:20 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] Add key ENCRYPTION_NO_VERIFY to conf
Content-Language: en-US
To: Blazej Kucman <blazej.kucman@intel.com>
Cc: mariusz.tkaczyk@linux.intel.com, jes@trained-monkey.org,
 linux-raid@vger.kernel.org
References: <20240318162535.13674-1-blazej.kucman@intel.com>
 <20240318162535.13674-4-blazej.kucman@intel.com>
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20240318162535.13674-4-blazej.kucman@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear Blazej,


Thank you for your patch.

Am 18.03.24 um 17:25 schrieb Blazej Kucman:
> Add ENCRYPTION_NO_VERIFY config key and allow to disable
> checking encryption status for given type of drives.
> 
> The key is introduced because of SATA Opal disks for which
> TPM commands must be enabled in libata kernel module,
> (libata.allow_tpm=1), otherwise it is impossible to verify
> encryption status. TPM commands are disabled by default.
> 
> Currently the key only supports the "sata_opal" value,
> if necessary, the functionality is ready to support more types of disks.

Please use 75 characters per line consistently.

Maybe document how to test this feature, preferebly with QEMU.

> Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
> ---
>   config.c           | 25 ++++++++++++++++++++++++-
>   drive_encryption.c | 16 ++++++++++++----
>   mdadm.conf.5.in    | 13 +++++++++++++
>   mdadm.h            |  1 +
>   4 files changed, 50 insertions(+), 5 deletions(-)
> 
> diff --git a/config.c b/config.c
> index 44f7dd2f..b46d71cb 100644
> --- a/config.c
> +++ b/config.c
> @@ -81,7 +81,7 @@ char DefaultAltConfDir[] = CONFFILE2 ".d";
>   
>   enum linetype { Devices, Array, Mailaddr, Mailfrom, Program, CreateDev,
>   		Homehost, HomeCluster, AutoMode, Policy, PartPolicy, Sysfs,
> -		MonitorDelay, LTEnd };
> +		MonitorDelay, EncryptionNoVerify, LTEnd };
>   char *keywords[] = {
>   	[Devices]  = "devices",
>   	[Array]    = "array",
> @@ -96,6 +96,7 @@ char *keywords[] = {
>   	[PartPolicy]="part-policy",
>   	[Sysfs]    = "sysfs",
>   	[MonitorDelay] = "monitordelay",
> +	[EncryptionNoVerify] = "ENCRYPTION_NO_VERIFY",
>   	[LTEnd]    = NULL
>   };
>   
> @@ -729,6 +730,19 @@ void monitordelayline(char *line)
>   	}
>   }
>   
> +static bool sata_opal_encryption_no_verify;
> +void encryption_no_verify_line(char *line)
> +{
> +	char *word;
> +
> +	for (word = dl_next(line); word != line; word = dl_next(word)) {
> +		if (strcasecmp(word, "sata_opal") == 0)
> +			sata_opal_encryption_no_verify = true;
> +		else
> +			pr_err("unrecognised word on ENCRYPTION_NO_VERIFY line: %s\n", word);
> +	}
> +}
> +
>   char auto_yes[] = "yes";
>   char auto_no[] = "no";
>   char auto_homehost[] = "homehost";
> @@ -913,6 +927,9 @@ void conf_file(FILE *f)
>   		case MonitorDelay:
>   			monitordelayline(line);
>   			break;
> +		case EncryptionNoVerify:
> +			encryption_no_verify_line(line);
> +			break;
>   		default:
>   			pr_err("Unknown keyword %s\n", line);
>   		}
> @@ -1075,6 +1092,12 @@ int conf_get_monitor_delay(void)
>   	return monitor_delay;
>   }
>   
> +bool conf_get_sata_opal_encryption_no_verify(void)
> +{
> +	load_conffile();
> +	return sata_opal_encryption_no_verify;
> +}
> +
>   struct createinfo *conf_get_create_info(void)
>   {
>   	load_conffile();
> diff --git a/drive_encryption.c b/drive_encryption.c
> index 8421e374..5b9cdc00 100644
> --- a/drive_encryption.c
> +++ b/drive_encryption.c
> @@ -656,10 +656,18 @@ get_ata_encryption_information(int disk_fd, struct encryption_information *infor
>   	if (status == MDADM_STATUS_ERROR)
>   		return MDADM_STATUS_ERROR;
>   
> -	if (is_ata_trusted_computing_supported(buffer_identify) &&
> -	    !sysfs_is_libata_allow_tpm_enabled(verbose)) {
> -		pr_vrb("For SATA with Trusted Computing support, required libata.tpm_enabled=1.\n");
> -		return MDADM_STATUS_ERROR;
> +	/* Possible OPAL support, further checks require tpm_enabled.*/
> +	if (is_ata_trusted_computing_supported(buffer_identify)) {
> +		/* OPAL SATA encryption checking disabled. */
> +		if (conf_get_sata_opal_encryption_no_verify())
> +			return MDADM_STATUS_SUCCESS;
> +
> +		if (!sysfs_is_libata_allow_tpm_enabled(verbose)) {
> +			pr_vrb("Detected SATA drive /dev/%s with Trusted Computing support.\n",
> +			       fd2kname(disk_fd));
> +			pr_vrb("Cannot verify encryption state. Required libata.tpm_enabled=1.\n");

Require*s*?

> +			return MDADM_STATUS_ERROR;
> +		}
>   	}
>   
>   	ata_opal_status = is_ata_opal(disk_fd, buffer_identify, verbose);
> diff --git a/mdadm.conf.5.in b/mdadm.conf.5.in
> index 787e51e9..afb0a296 100644
> --- a/mdadm.conf.5.in
> +++ b/mdadm.conf.5.in
> @@ -636,6 +636,17 @@ If multiple
>   .B MINITORDELAY
>   lines are provided, only first non-zero value is considered.
>   
> +.TP
> +.B ENCRYPTION_NO_VERIFY
> +The
> +.B ENCRYPTION_NO_VERIFY
> +disables encryption verification for devices with particular encryption support detected.
> +Currently, only verification of SATA OPAL encryption can be disabled.
> +It does not disable ATA security encryption verification.
> +Available parameter
> +.I "sata_opal".
> +
> +
>   .SH FILES
>   
>   .SS {CONFFILE}
> @@ -744,6 +755,8 @@ SYSFS uuid=bead5eb6:31c17a27:da120ba2:7dfda40d group_thread_cnt=4
>   sync_speed_max=1000000
>   .br
>   MONITORDELAY 60
> +.br
> +ENCRYPTION_NO_VERIFY sata_opal
>   
>   .SH SEE ALSO
>   .BR mdadm (8),
> diff --git a/mdadm.h b/mdadm.h
> index f64bb783..9d98693b 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1673,6 +1673,7 @@ extern char *conf_get_program(void);
>   extern char *conf_get_homehost(int *require_homehostp);
>   extern char *conf_get_homecluster(void);
>   extern int conf_get_monitor_delay(void);
> +extern bool conf_get_sata_opal_encryption_no_verify(void);
>   extern char *conf_line(FILE *file);
>   extern char *conf_word(FILE *file, int allow_key);
>   extern void print_quoted(char *str);

The diff looks good.


Kind regards,

Paul
