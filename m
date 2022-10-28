Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E2C2C38A02
	for <linux-raid@archiver.kernel.org>; Fri, 28 Oct 2022 15:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiJ1Ppf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Oct 2022 11:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiJ1Ppd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Oct 2022 11:45:33 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC69BBF03
        for <linux-raid@vger.kernel.org>; Fri, 28 Oct 2022 08:45:32 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 04BC01FA9B;
        Fri, 28 Oct 2022 15:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1666971931; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fcw09R+lkgEL8qkPNpc5CUjX7tSokBf+tyy8BMTsw4U=;
        b=qOtUmqVqAmuuky6YCDkUVovEjcATSNWZicvSK9dykray49X22/unqpwxril0KEmzbpd/D6
        hmoFh0dI839GzxGt/rHPOQYTdhFRqNnESgAtLuddsOeMSL/e66RXVDrWnHwm/9VBVjRCDs
        8XiBXHw9cGgUUBd73oVZqkYN8ab1kVk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1666971931;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fcw09R+lkgEL8qkPNpc5CUjX7tSokBf+tyy8BMTsw4U=;
        b=Anamxd2R4WuGKEvna+YmYoTgxHnTCL+90XGmAlcLOhj0rFxmXRSOYeSV2Iqtt44+zyoUBo
        0FWg5sXPrTQrS8Cg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2EC2B13A6E;
        Fri, 28 Oct 2022 15:45:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id U3ENOxn5W2P2VAAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 28 Oct 2022 15:45:29 +0000
Message-ID: <026c2540-8a80-e80a-77a0-83822d7876bd@suse.de>
Date:   Fri, 28 Oct 2022 23:45:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
From:   Coly Li <colyli@suse.de>
Subject: Re: [PATCH 3/9] Mdmonitor: Pass events to alert() using enums instead
 of strings
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
References: <20220907125657.12192-1-mateusz.grzonka@intel.com>
 <20220907125657.12192-4-mateusz.grzonka@intel.com>
Content-Language: en-US
In-Reply-To: <20220907125657.12192-4-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/7/22 8:56 PM, Mateusz Grzonka wrote:
> Add events enum, and mapping_t struct, that maps them to strings, so
> that enums are passed around instead of strings.
>
> Signed-off-by: Mateusz Grzonka<mateusz.grzonka@intel.com>
> ---
>   Monitor.c | 136 +++++++++++++++++++++++++++++++++---------------------
>   1 file changed, 83 insertions(+), 53 deletions(-)

[snipped]

>   
> -static void alert(const char *event, const char *dev, const char *disc)
> +static void alert(const enum event event_enum, const unsigned int progress, const char *dev, const char *disc)
>   {
> -	if (!info.alert_cmd && !info.mailaddr && !info.dosyslog) {
> -		time_t now = time(0);
> +	char event_name[EVENT_NAME_MAX];
>   
> -		printf("%1.15s: %s on %s %s\n", ctime(&now) + 4,
> -		       event, dev, disc?disc:"unknown device");
> +	if (event_enum == EVENT_REBUILD) {
> +		snprintf(event_name, sizeof(event_name), "%s%02d",
> +			 map_num_s(events_map, EVENT_REBUILD), progress);
> +	} else {
> +		snprintf(event_name, sizeof(event_name), "%s", map_num_s(events_map, event_enum));
>   	}
> +

I am not sure whether it is fine to change the output message. I don’t 
object it, just not sure it is right or not right.

All rested part looks good to me.


Acked-by: Coly Li <colyli@suse.de>


Thanks.

Coly Li


>   	if (info.alert_cmd)
> -		execute_alert_cmd(event, dev, disc);
> +		execute_alert_cmd(event_name, dev, disc);
>   
> -	if (info.mailaddr && (strncmp(event, "Fail", 4) == 0 ||
> -			       strncmp(event, "Test", 4) == 0 ||
> -			       strncmp(event, "Spares", 6) == 0 ||
> -			       strncmp(event, "Degrade", 7) == 0)) {
> -		send_event_email(event, dev, disc);
> +	if (info.mailaddr && (event_enum == EVENT_FAIL ||
> +			      event_enum == EVENT_TEST_MESSAGE ||
> +			      event_enum == EVENT_SPARES_MISSING ||
> +			      event_enum == EVENT_DEGRADED_ARRAY)) {
> +		send_event_email(event_name, dev, disc);
>   	}
>   
>   	if (info.dosyslog)
> -		log_event_to_syslog(event, dev, disc);
> +		log_event_to_syslog(event_enum, event_name, dev, disc);
>   }
>   
>   static int check_array(struct state *st, struct mdstat_ent *mdstat,
> @@ -536,7 +575,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
>   	unsigned long redundancy_only_flags = 0;
>   
>   	if (info.test)
> -		alert("TestMessage", dev, NULL);
> +		alert(EVENT_TEST_MESSAGE, 0, dev, NULL);
>   
>   	retval = 0;
>   
> @@ -585,7 +624,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
>   	 */
>   	if (sra->array.level == 0 || sra->array.level == -1) {
>   		if (!st->err && !st->from_config)
> -			alert("DeviceDisappeared", dev, " Wrong-Level");
> +			alert(EVENT_DEVICE_DISAPPEARED, 0, dev, " Wrong-Level");
>   		st->err++;
>   		goto out;
>   	}
> @@ -602,7 +641,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
>   		st->percent = RESYNC_NONE;
>   		new_array = 1;
>   		if (!is_container)
> -			alert("NewArray", st->devname, NULL);
> +			alert(EVENT_NEW_ARRAY, 0, st->devname, NULL);
>   	}
>   
>   	if (st->utime == array.utime && st->failed == sra->array.failed_disks &&
> @@ -615,29 +654,20 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
>   	}
>   	if (st->utime == 0 && /* new array */
>   	    mse->pattern && strchr(mse->pattern, '_') /* degraded */)
> -		alert("DegradedArray", dev, NULL);
> +		alert(EVENT_DEGRADED_ARRAY, 0, dev, NULL);
>   
>   	if (st->utime == 0 && /* new array */ st->expected_spares > 0 &&
>   	    sra->array.spare_disks < st->expected_spares)
> -		alert("SparesMissing", dev, NULL);
> +		alert(EVENT_SPARES_MISSING, 0, dev, NULL);
>   	if (st->percent < 0 && st->percent != RESYNC_UNKNOWN &&
>   	    mse->percent >= 0)
> -		alert("RebuildStarted", dev, NULL);
> +		alert(EVENT_REBUILD_STARTED, 0, dev, NULL);
>   	if (st->percent >= 0 && mse->percent >= 0 &&
>   	    (mse->percent / increments) > (st->percent / increments)) {
> -		char percentalert[18];
> -		/*
> -		 * "RebuildNN" (10 chars) or "RebuildStarted" (15 chars)
> -		 */
> -
>   		if((mse->percent / increments) == 0)
> -			snprintf(percentalert, sizeof(percentalert),
> -				 "RebuildStarted");
> +			alert(EVENT_REBUILD_STARTED, 0, dev, NULL);
>   		else
> -			snprintf(percentalert, sizeof(percentalert),
> -				 "Rebuild%02d", mse->percent);
> -
> -		alert(percentalert, dev, NULL);
> +			alert(EVENT_REBUILD, mse->percent, dev, NULL);
>   	}
>   
>   	if (mse->percent == RESYNC_NONE && st->percent >= 0) {
> @@ -650,9 +680,9 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
>   			snprintf(cnt, sizeof(cnt),
>   				 " mismatches found: %d (on raid level %d)",
>   				 sra->mismatch_cnt, sra->array.level);
> -			alert("RebuildFinished", dev, cnt);
> +			alert(EVENT_REBUILD_FINISHED, 0, dev, cnt);
>   		} else
> -			alert("RebuildFinished", dev, NULL);
> +			alert(EVENT_REBUILD_FINISHED, 0, dev, NULL);
>   	}
>   	st->percent = mse->percent;
>   
> @@ -706,14 +736,14 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
>   		change = newstate ^ st->devstate[i];
>   		if (st->utime && change && !st->err && !new_array) {
>   			if ((st->devstate[i]&change) & (1 << MD_DISK_SYNC))
> -				alert("Fail", dev, dv);
> +				alert(EVENT_FAIL, 0, dev, dv);
>   			else if ((newstate & (1 << MD_DISK_FAULTY)) &&
>   				 (disc.major || disc.minor) &&
>   				 st->devid[i] == makedev(disc.major,
>   							 disc.minor))
> -				alert("FailSpare", dev, dv);
> +				alert(EVENT_FAIL_SPARE, 0, dev, dv);
>   			else if ((newstate&change) & (1 << MD_DISK_SYNC))
> -				alert("SpareActive", dev, dv);
> +				alert(EVENT_SPARE_ACTIVE, 0, dev, dv);
>   		}
>   		st->devstate[i] = newstate;
>   		st->devid[i] = makedev(disc.major, disc.minor);
> @@ -737,7 +767,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
>   
>    disappeared:
>   	if (!st->err && !is_container)
> -		alert("DeviceDisappeared", dev, NULL);
> +		alert(EVENT_DEVICE_DISAPPEARED, 0, dev, NULL);
>   	st->err++;
>   	goto out;
>   }
> @@ -797,7 +827,7 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist)
>   				st->parent_devnm[0] = 0;
>   			*statelist = st;
>   			if (info.test)
> -				alert("TestMessage", st->devname, NULL);
> +				alert(EVENT_TEST_MESSAGE, 0, st->devname, NULL);
>   			new_found = 1;
>   		}
>   	return new_found;
> @@ -1020,7 +1050,7 @@ static void try_spare_migration(struct state *statelist)
>   				if (devid > 0 &&
>   				    move_spare(from->devname, to->devname,
>   					       devid)) {
> -					alert("MoveSpare", to->devname, from->devname);
> +					alert(EVENT_MOVE_SPARE, 0, to->devname, from->devname);
>   					break;
>   				}
>   			}


