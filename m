Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2F11991C2
	for <linux-raid@vger.kernel.org>; Thu, 25 Jul 2024 13:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721914492; cv=none; b=ilonFyGJGOz8G5Er8wfOGXqGCWPx7ylTMfM9pC0Qpvnj0TD9v3c+4E/JU9S1XE3rdnGActTpektIJ7Ww8o2+IXd6oAu8KGDixb0AJWQ1VMIAdABmKt+/I14VEpg220i+JlIC0ddS/935QOdpOsUyCHBasnGURHlbMMGP0lx0nJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721914492; c=relaxed/simple;
	bh=HFZqy4uJQBMyiJWcVF8rPjYUg3tjBdq+qkRS7SXanAA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=LOk49S0PU2+9B9rh50+tUzXpmGJfXRorTK1sX6k0PkotsNVN9e0TOtZpdW+CukbjL4EViph8eMGmqPGNS/pa/8vjveij1mdx6uihwEu9TzwWEO5b9R/lKoyQtEuKnOt5yekzdTj8TmoQA4QKDeIds78w/DYdsT8ya1RwQowX3HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MrLhV9pn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MrLhV9pn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721914488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eL6FNT5LYRvkBguQtAYodjbB2c0Zj6aor6p/2Ihj1B4=;
	b=MrLhV9pnAz8mDnQSzWfcdSdaqDgmJG2yPiGkL+swgue61lMFeALEKUN2fO42HMInFK62Qx
	HtipSo+IBfyOWZgZmeRs1gzG0z4OtfWxbqKWoMDIs/fWabxdbqj+Vgs1ozS27BWeOMLP2a
	H5sAal0Dcjg0CTJd+OiZVu5PQ3yYPck=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-sEZDt5u0MAi4Xf-R2UowGA-1; Thu, 25 Jul 2024 09:34:47 -0400
X-MC-Unique: sEZDt5u0MAi4Xf-R2UowGA-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6b7980fc855so12491236d6.2
        for <linux-raid@vger.kernel.org>; Thu, 25 Jul 2024 06:34:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721914485; x=1722519285;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eL6FNT5LYRvkBguQtAYodjbB2c0Zj6aor6p/2Ihj1B4=;
        b=Ot8s4lfVzG0E2bnsPkj/98D5v8SHmgbxr4TkSmeynrZzqJoFRaF041XccIka0h13zw
         0h6yMlYKj6LTkJ59vbLJd0hDnAqwqCqNcs4W6FoDrhTZCFQ8yvqj3a/sXaGsOMu7ukUT
         217qRx9UFiOQVa+tLvv/ZwBcrP2jrYK6aYADrcDt4guAbryigIjPSU84zLQUOwSr25bm
         t4GIfBPrv27MZvAruVunETIOnnL1ko19cfRBz+V7LPoBJTpnrJZOReqnZaACKq2YuhTj
         pdMRzonaq6WJzDuiVetjGZqBIhE4gKS5Q/E/0ElXYgLEyedHLQSEYUmh2pSnO0cFSpYy
         uVxg==
X-Gm-Message-State: AOJu0YwpBDyBtsK7cb/JAsHPRRyvIaRbmFHlJPf5NsEzmAcBt25Sfgwg
	Ci14soGYtkSqRNqjIChucE2ToSLSPIKWA5QUFhjWptmDqLmYR/ta+aiVqn+RGlLK7zi1Z686Jw6
	MZXil/N9M+q06SY9fRWsmDJPaZay1qlSP2RE1jM6z570/nZeNi4VELN8CHyP0ZN+06qY=
X-Received: by 2002:a05:6214:240e:b0:6b5:7e0b:eafc with SMTP id 6a1803df08f44-6bb3cac4b4bmr31052506d6.38.1721914484956;
        Thu, 25 Jul 2024 06:34:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH6G7shu5Ui4Trs2SMGBH0RC2Pb7552Rr8LgEBcjG0VbObMSEvs+6zXuZzxaULpKQRIhlHOPw==
X-Received: by 2002:a05:6214:240e:b0:6b5:7e0b:eafc with SMTP id 6a1803df08f44-6bb3cac4b4bmr31052196d6.38.1721914484329;
        Thu, 25 Jul 2024 06:34:44 -0700 (PDT)
Received: from [192.168.50.193] ([134.195.185.129])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bb3faf453esm7275606d6.131.2024.07.25.06.34.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jul 2024 06:34:43 -0700 (PDT)
Message-ID: <deb3544b-0591-400e-8504-ca0da1172022@redhat.com>
Date: Thu, 25 Jul 2024 09:34:41 -0400
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] mdadm: Follow POSIX Portable Character Set
From: Nigel Croxon <ncroxon@redhat.com>
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org, colyli@suse.de
References: <20230601072750.20796-1-mariusz.tkaczyk@linux.intel.com>
 <20230601072750.20796-7-mariusz.tkaczyk@linux.intel.com>
 <9c9cb559-a5cf-4b3d-94c1-952404f665bb@redhat.com>
Content-Language: en-US
In-Reply-To: <9c9cb559-a5cf-4b3d-94c1-952404f665bb@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/25/24 9:30 AM, Nigel Croxon wrote:
>
> On 6/1/23 3:27 AM, Mariusz Tkaczyk wrote:
>> When the user creates a device with a name that contains whitespace,
>> mdadm timeouts and throws an error. This issue is caused by udev, which
>> truncates /dev/md link until the first whitespace.
>>
>> This patch introduces prohibition of characters other than A-Za-z0-9.-_
>> in the device name. Also, it prohibits using leading "-" in device name,
>> so name won't be confused with cli parameter.
>> Set of allowed characters is taken from POSIX 3.280 Portable Character
>> Set. Also, device name length now is limited to NAME_MAX.
>>
>> In some places, there are other requirements for string length (e.g. 
>> size
>> up to MD_NAME_MAX for device name). This routine is made to follow POSIX
>> and other, more strict limitations should be checked separately.
>> We are aware of the risk of regression in exceptional cases (as
>> escape_devname function is removed) that should be fixed by updating
>> the array name.
>>
>> The POSIX validation is added for:
>> - 'name' parameter in every mode.
>> - first devlist entry, for Build, Create, Assemble, Manage, Grow.
>> - config entries, both devname and "name=".
>>
>> Additionally, some manual cleanups are made.
>>
>> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
>> ---
>>   Detail.c          | 17 ++++--------
>>   config.c          | 13 ++++++---
>>   lib.c             | 58 ++++++++++++++++++++++++++++-----------
>>   mdadm.8.in        | 70 ++++++++++++++++++++---------------------------
>>   mdadm.conf.5.in   |  4 ---
>>   mdadm.h           |  2 +-
>>   super-intel.c     | 47 ++++++++++++++++---------------
>>   tests/00confnames |  4 +--
>>   8 files changed, 113 insertions(+), 102 deletions(-)
>>
>> diff --git a/Detail.c b/Detail.c
>> index 206d88e3..57ac336f 100644
>> --- a/Detail.c
>> +++ b/Detail.c
>> @@ -254,11 +254,9 @@ int Detail(char *dev, struct context *c)
>>               fname_from_uuid(st, info, nbuf, ':');
>>               printf("MD_UUID=%s\n", nbuf + 5);
>>               mp = map_by_uuid(&map, info->uuid);
>> -            if (mp && mp->path && strncmp(mp->path, DEV_MD_DIR, 
>> DEV_MD_DIR_LEN) == 0) {
>> -                printf("MD_DEVNAME=");
>> -                print_escape(mp->path + DEV_MD_DIR_LEN);
>> -                putchar('\n');
>> -            }
>> +
>> +            if (mp && mp->path && strncmp(mp->path, DEV_MD_DIR, 
>> DEV_MD_DIR_LEN) == 0)
>> +                printf("MD_DEVNAME=%s\n", mp->path + DEV_MD_DIR_LEN);
>>                 if (st->ss->export_detail_super)
>>                   st->ss->export_detail_super(st);
>> @@ -271,12 +269,9 @@ int Detail(char *dev, struct context *c)
>>                   __fname_from_uuid(mp->uuid, 0, nbuf, ':');
>>                   printf("MD_UUID=%s\n", nbuf+5);
>>               }
>> -            if (mp && mp->path &&
>> -                strncmp(mp->path, DEV_MD_DIR, DEV_MD_DIR_LEN) == 0) {
>> -                printf("MD_DEVNAME=");
>> -                print_escape(mp->path + DEV_MD_DIR_LEN);
>> -                putchar('\n');
>> -            }
>> +            if (mp && mp->path && strncmp(mp->path, DEV_MD_DIR, 
>> DEV_MD_DIR_LEN) == 0)
>> +                printf("MD_DEVNAME=%s\n", mp->path + DEV_MD_DIR_LEN);
>> +
>>               map_free(map);
>>           }
>>           if (!c->no_devices && sra) {
>> diff --git a/config.c b/config.c
>> index d80747a2..38a903c5 100644
>> --- a/config.c
>> +++ b/config.c
>> @@ -199,9 +199,9 @@ inline void ident_init(struct mddev_ident *ident)
>>    *    /dev/md_d{number} (legacy)
>>    *    /dev/md_{name}
>>    *    /dev/md/{name}
>> - *    {name} - anything that doesn't start from '/' or '<'.
>> + *    {name}
>>    *
>> - * {name} must follow name's criteria.
>> + * {name} must follow name's criteria and be POSIX compatible.
>>    * If criteria passed, duplicate memory and set devname in @ident.
>>    *
>>    * Return: %MDADM_STATUS_SUCCESS or %MDADM_STATUS_ERROR.
>> @@ -241,8 +241,8 @@ mdadm_status_t _ident_set_devname(struct 
>> mddev_ident *ident, const char *devname
>>       else
>>           name = devname;
>>   -    if (*name == '/' || *name == '<') {
>> -        ident_log(prop_name, devname, "Cannot be started from \'/\' 
>> or \'<\'", cmdline);
>> +    if (is_name_posix_compatible(name) == false) {
>> +        ident_log(prop_name, name, "Not POSIX compatible", cmdline);
>>           return MDADM_STATUS_ERROR;
>>       }
>>   @@ -283,6 +283,11 @@ static mdadm_status_t _ident_set_name(struct 
>> mddev_ident *ident, const char *nam
>>           return MDADM_STATUS_ERROR;
>>       }
>>   +    if (is_name_posix_compatible(name) == false) {
>> +        ident_log(prop_name, name, "Not POSIX compatible", cmdline);
>> +        return MDADM_STATUS_ERROR;
>> +    }
>> +
>>       snprintf(ident->name, MD_NAME_MAX + 1, "%s", name);
>>       return MDADM_STATUS_SUCCESS;
>>   }
>> diff --git a/lib.c b/lib.c
>> index 999cd520..d40922d9 100644
>> --- a/lib.c
>> +++ b/lib.c
>> @@ -483,24 +483,50 @@ void print_quoted(char *str)
>>       putchar(q);
>>   }
>>   -void print_escape(char *str)
>> +/**
>> + * is_alphanum() - Check if sign is letter or digit.
>> + * @c: char to analyze.
>> + *
>> + * Similar to isalnum() but additional locales are excluded.
>> + *
>> + * Return: %true on success, %false otherwise.
>> + */
>> +bool is_alphanum(const char c)
>>   {
>> -    /* print str, but change space and tab to '_'
>> -     * as is suitable for device names
>> -     */
>> -    for (; *str; str++) {
>> -        switch (*str) {
>> -        case ' ':
>> -        case '\t':
>> -            putchar('_');
>> -            break;
>> -        case '/':
>> -            putchar('-');
>> -            break;
>> -        default:
>> -            putchar(*str);
>> -        }
>> +    if (isupper(c) || islower(c) || isdigit(c) != 0)
>> +        return true;
>> +    return false;
>> +}
>> +
>> +/**
>> + * is_name_posix_compatible() - Check if name is POSIX compatible.
>> + * @name: name to check.
>> + *
>> + *  POSIX portable file name character set contains ASCII letters,
>> + *  digits, '_', '.', and '-'. Also forbid leading '-'.
>> + *  The length of the name cannot exceed NAME_MAX - 1 (ensure NULL 
>> ending).
>> + *
>> + * Return: %true on success, %false otherwise.
>> + */
>> +bool is_name_posix_compatible(const char * const name)
>> +{
>> +    assert(name);
>> +
>> +    char allowed_symbols[] = "-_.";
>> +    const char *n = name;
>> +
>> +    if (!is_string_lq(name, NAME_MAX))
>> +        return false;
>> +
>> +    if (*n == '-')
>> +        return false;
>> +
>> +    while (*n != '\0') {
>> +        if (!is_alphanum(*n) && !strchr(allowed_symbols, *n))
>> +            return false;
>> +        n++;
>>       }
>> +    return true;
>>   }
>>     int check_env(char *name)
>> diff --git a/mdadm.8.in b/mdadm.8.in
>> index b7159509..3142436f 100644
>> --- a/mdadm.8.in
>> +++ b/mdadm.8.in
>> @@ -364,7 +364,7 @@ Use the Intel(R) Matrix Storage Manager metadata 
>> format.  This creates a
>>   which is managed in a similar manner to DDF, and is supported by an
>>   option-rom on some platforms:
>>   .IP
>> -.B 
>> https://www.intel.com/content/www/us/en/support/products/122484/memory-and-storage/ssd-software/intel-virtual-raid-on-cpu-intel-vroc.html
>> +.B https://www.intel.com/content/www/us/en/support/products/122484
>>   .PP
>>   .RE
>>   @@ -932,17 +932,14 @@ option will be ignored.
>>   .BR \-N ", " \-\-name=
>>   Set a
>>   .B name
>> -for the array.  This is currently only effective when creating an
>> -array with a version-1 superblock, or an array in a DDF container.
>> -The name is a simple textual string that can be used to identify array
>> -components when assembling.  If name is needed but not specified, it
>> -is taken from the basename of the device that is being created.
>> -e.g. when creating
>> -.I /dev/md/home
>> -the
>> -.B name
>> -will default to
>> -.IR home .
>> +for the array. It must be
>> +.BR "POSIX PORTABLE NAME"
>> +compatible and cannot be longer than 32 chars. This is effective 
>> when creating an array
>> +with a v1 metadata, or an external array.
>> +
>> +If name is needed but not specified, it is taken from the basename 
>> of the device
>> +that is being created. See
>> +.BR "DEVICE NAMES"
>>     .TP
>>   .BR \-R ", " \-\-run
>> @@ -1132,8 +1129,10 @@ is much safer.
>>     .TP
>>   .BR \-N ", " \-\-name=
>> -Specify the name of the array to assemble.  This must be the name
>> -that was specified when creating the array.  It must either match
>> +Specify the name of the array to assemble. It must be
>> +.BR "POSIX PORTABLE NAME"
>> +compatible and cannot be longer than 32 chars. This must be the name
>> +that was specified when creating the array. It must either match
>>   the name stored in the superblock exactly, or it must match
>>   with the current
>>   .I homehost
>> @@ -2179,14 +2178,17 @@ Usage:
>>   .I md-device
>>   .BI \-\-chunk= X
>>   .BI \-\-level= Y
>> -.br
>>   .BI \-\-raid\-devices= Z
>>   .I devices
>>     .PP
>> -This usage will initialise a new md array, associate some devices with
>> +This usage will initialize a new md array, associate some devices with
>>   it, and activate the array.
>>   +.I md-device
>> +is a new device. This could be standard name or chosen name. For 
>> details see:
>> +.BR "DEVICE NAMES"
>> +
>>   The named device will normally not exist when
>>   .I "mdadm \-\-create"
>>   is run, but will be created by
>> @@ -2227,24 +2229,6 @@ array.  This feature can be overridden with the
>>   .B \-\-force
>>   option.
>>   -When creating an array with version-1 metadata a name for the 
>> array is
>> -required.
>> -If this is not given with the
>> -.B \-\-name
>> -option,
>> -.I mdadm
>> -will choose a name based on the last component of the name of the
>> -device being created.  So if
>> -.B /dev/md3
>> -is being created, then the name
>> -.B 3
>> -will be chosen.
>> -If
>> -.B /dev/md/home
>> -is being created, then the name
>> -.B home
>> -will be used.
>> -
>>   When creating a partition based array, using
>>   .I mdadm
>>   with version-1.x metadata, the partition type should be set to
>> @@ -2429,12 +2413,10 @@ and
>>     The
>>   .B name
>> -option updates the subarray name in the metadata, it may not affect the
>> -device node name or the device node symlink until the subarray is
>> -re\-assembled.  If updating
>> -.B name
>> -would change the UUID of an active subarray this operation is blocked,
>> -and the command will end in an error.
>> +option updates the subarray name in the metadata. It must be
>> +.BR "POSIX PORTABLE NAME"
>> +compatible and cannot be longer than 32 chars. If successes, new 
>> value will be respected after
>> +next assembly.
>>     The
>>   .B ppl
>> @@ -3395,6 +3377,10 @@ When
>>   .B \-\-incremental
>>   mode is used, this file gets a list of arrays currently being created.
>>   +.SH POSIX PORTABLE NAME
>> +A valid name can only consist of characters "A-Za-z0-9.-_".
>> +The name cannot start with a leading "-" and cannot exceed 255 chars.
>> +
>>   .SH DEVICE NAMES
>>     .I mdadm
>> @@ -3416,6 +3402,10 @@ can be given, or just the suffix of the second 
>> sort of name, such as
>>   .I home
>>   can be given.
>>   +In every style, raw name must be compatible with
>> +.BR "POSIX PORTABLE NAME"
>> +and has to be no longer than 32 chars.
>> +
>>   When
>>   .I mdadm
>>   chooses device names during auto-assembly or incremental assembly, it
>> diff --git a/mdadm.conf.5.in b/mdadm.conf.5.in
>> index bc2295c2..94e23dd0 100644
>> --- a/mdadm.conf.5.in
>> +++ b/mdadm.conf.5.in
>> @@ -717,10 +717,6 @@ ARRAY /dev/md/home 
>> UUID=9187a482:5dde19d9:eea3cc4a:d646ab8b
>>   .br
>>              auto=part
>>   .br
>> -# The name of this array contains a space.
>> -.br
>> -ARRAY /dev/md9 name='Data Storage'
>> -.sp
>>   POLICY domain=domain1 metadata=imsm path=pci-0000:00:1f.2-scsi-*
>>   .br
>>              action=spare
>> diff --git a/mdadm.h b/mdadm.h
>> index 92a0beb5..db05d810 100644
>> --- a/mdadm.h
>> +++ b/mdadm.h
>> @@ -1617,6 +1617,7 @@ extern int check_raid(int fd, char *name);
>>   extern int check_partitions(int fd, char *dname,
>>                   unsigned long long freesize,
>>                   unsigned long long size);
>> +extern bool is_name_posix_compatible(const char *path);
>>   extern int fstat_is_blkdev(int fd, char *devname, dev_t *rdev);
>>   extern int stat_is_blkdev(char *devname, dev_t *rdev);
>>   @@ -1657,7 +1658,6 @@ extern int conf_get_monitor_delay(void);
>>   extern char *conf_line(FILE *file);
>>   extern char *conf_word(FILE *file, int allow_key);
>>   extern void print_quoted(char *str);
>> -extern void print_escape(char *str);
>>   extern int use_udev(void);
>>   extern unsigned long GCD(unsigned long a, unsigned long b);
>>   extern int conf_name_is_free(char *name);
>> diff --git a/super-intel.c b/super-intel.c
>> index ae0f4a8c..1aa5fec9 100644
>> --- a/super-intel.c
>> +++ b/super-intel.c
>> @@ -5533,40 +5533,37 @@ static void imsm_update_version_info(struct 
>> intel_super *super)
>>       }
>>   }
>>   -static int check_name(struct intel_super *super, char *name, int 
>> quiet)
>> +/**
>> + * imsm_check_name() - check imsm naming criteria.
>> + * @super: &intel_super pointer, not NULL.
>> + * @name: name to check.
>> + * @verbose: verbose level.
>> + *
>> + * Name must be no longer than &MAX_RAID_SERIAL_LEN and must be 
>> unique across volumes.
>> + *
>> + * Returns: &true if @name matches, &false otherwise.
>> + */
>> +static bool imsm_is_name_allowed(struct intel_super *super, const 
>> char * const name,
>> +                 const int verbose)
>>   {
>>       struct imsm_super *mpb = super->anchor;
>> -    char *reason = NULL;
>> -    char *start = name;
>> -    size_t len = strlen(name);
>>       int i;
>>   -    if (len > 0) {
>> -        while (isspace(start[len - 1]))
>> -            start[--len] = 0;
>> -        while (*start && isspace(*start))
>> -            ++start, --len;
>> -        memmove(name, start, len + 1);
>> +    if (is_string_lq(name, MAX_RAID_SERIAL_LEN + 1) == false) {
>> +        pr_vrb("imsm: Name \"%s\" is too long\n", name);
>> +        return false;
>>       }
>>   -    if (len > MAX_RAID_SERIAL_LEN)
>> -        reason = "must be 16 characters or less";
>> -    else if (len == 0)
>> -        reason = "must be a non-empty string";
>> -
>>       for (i = 0; i < mpb->num_raid_devs; i++) {
>>           struct imsm_dev *dev = get_imsm_dev(super, i);
>>             if (strncmp((char *) dev->volume, name, 
>> MAX_RAID_SERIAL_LEN) == 0) {
>> -            reason = "already exists";
>> -            break;
>> +            pr_vrb("imsm: Name \"%s\" already exists\n", name);
>> +            return false;
>>           }
>>       }
>>   -    if (reason && !quiet)
>> -        pr_err("imsm volume name %s\n", reason);
>> -
>> -    return !reason;
>> +    return true;
>>   }
>>     static int init_super_imsm_volume(struct supertype *st, 
>> mdu_array_info_t *info,
>> @@ -5661,8 +5658,9 @@ static int init_super_imsm_volume(struct 
>> supertype *st, mdu_array_info_t *info,
>>           }
>>       }
>>   -    if (!check_name(super, name, 0))
>> +    if (imsm_is_name_allowed(super, name, 1) == false)
>>           return 0;
>> +
>>       dv = xmalloc(sizeof(*dv));
>>       dev = xcalloc(1, sizeof(*dev) + sizeof(__u32) * 
>> (info->raid_disks - 1));
>>       /*
>> @@ -7975,7 +7973,7 @@ static int update_subarray_imsm(struct 
>> supertype *st, char *subarray,
>>           char *ep;
>>           int vol;
>>   -        if (!check_name(super, name, 0))
>> +        if (imsm_is_name_allowed(super, name, 1) == false)
>>               return 2;
>>             vol = strtoul(subarray, &ep, 10);
>> @@ -10302,7 +10300,8 @@ static void imsm_process_update(struct 
>> supertype *st,
>>               if (a->info.container_member == target)
>>                   break;
>>           dev = get_imsm_dev(super, u->dev_idx);
>> -        if (a || !check_name(super, name, 1)) {
>> +
>> +        if (a || !dev || imsm_is_name_allowed(super, name, 0) == 
>> false) {
>>               dprintf("failed to rename subarray-%d\n", target);
>>               break;
>>           }
>> diff --git a/tests/00confnames b/tests/00confnames
>> index 4990cb5e..9961772c 100644
>> --- a/tests/00confnames
>> +++ b/tests/00confnames
>> @@ -79,10 +79,10 @@ names_verify "/dev/md127" "name" "name"
>>   mdadm -S "/dev/md127"
>>     # 11. <devname> with some special symbols and locales, no <name>.
>> -# It needs to wait a while for timeout because udev cannot create a 
>> link - known issue.
>> +# <devname> should be ignored.
>>   names_make_conf $_UUID "tźż-\.,<>st+-" "empty" $config
>>   mdadm -I $dev0 --config=$config
>> -names_verify "/dev/md127" "tźż-\.,<>st+-" "name"
>> +names_verify "/dev/md127" "name" "name"
>>   mdadm -S "/dev/md127"
>>     # 12. No <devname> and <name> set.
>
> I'm getting feedback from the field.. that standard systems are now 
> seeing this new error message.
>
> # mdadm --detail --scan
> ARRAY /dev/md0 metadata=1.2 name=rhel810:0 
> UUID=bb08df39:e5015337:a253c6b0:6e31ebf6
>
> # mdadm --detail --scan > /etc/mdadm.conf
> # cat /etc/mdadm.conf
> ARRAY /dev/md0 metadata=1.2 name=rhel810:0 
> UUID=bb08df39:e5015337:a253c6b0:6e31ebf6
>
> # mdadm --detail --scan
> mdadm: Value "rhel810:0" cannot be set as name. Reason: Not POSIX 
> compatible. Value ignored.
> ARRAY /dev/md0 metadata=1.2 name=rhel810:0 
> UUID=bb08df39:e5015337:a253c6b0:6e31ebf6
> #
>
> I understand why, as we picked up ...
>
> commit e2eb503bd797908f515b58428b274f1ba6a05349
> Author: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> Date: Thu Jun 1 09:27:50 2023 +0200
>
> mdadm: Follow POSIX Portable Character Set
>
> The issue is, people use the standard method of 'mdadm --detail --scan 
> > /etc/mdadm.conf'.
>
> Which breaks the new rule.
>
>
>
I just found this new patch..  which will fix our fields issue.

commit dcc22ae74a864358b812327a423435b541789a36
Author: Mariusz Tkaczyk 
<mariusz.tkaczyk@linux.intel.com<mailto:mariusz.tkaczyk@linux.intel.com>>
Date: Thu Feb 1 12:32:41 2024 +0100super1: remove support for name= in 
config

So, no issue now... we just have to get this patch out to the field.




