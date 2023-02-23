Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C23B0C61DA4
	for <linux-raid@archiver.kernel.org>; Thu, 23 Feb 2023 13:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbjBWNkB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Feb 2023 08:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234067AbjBWNj7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Feb 2023 08:39:59 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5AF1A49F
        for <linux-raid@vger.kernel.org>; Thu, 23 Feb 2023 05:39:57 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A85581F8D7;
        Thu, 23 Feb 2023 13:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677159596; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TXFsts7nN3ALFKClGhdGklff1ORJm67ZlxXj5araN6c=;
        b=XVSeY364sNtYYdF6g2gNMlBKwdukBbm05JmUAPtYkyargwAm0HxtaS7g1eQJ7He+QwRKDk
        jcalBAVn0NU+kfzi5nvyxxYWliS3FSngbMMdFl/ELh6Mza46t3Se7SNUDbmGcgU6MGpx+r
        wXqGBQiFsUqW3VD+hHR58S2krz09MtY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677159596;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TXFsts7nN3ALFKClGhdGklff1ORJm67ZlxXj5araN6c=;
        b=/qMEHB5CPaFpmjC6lwmKQPpkEwziwU7s+7zSBuNVkss+Hya35EsmkfGsViYGAi86BwCLX0
        sg4eq2Z+KspRrtDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 542DD139B5;
        Thu, 23 Feb 2023 13:39:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 5jsACKts92PQewAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 23 Feb 2023 13:39:55 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH v3 2/8] Mdmonitor: Pass events to alert() using enums
 instead of strings
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230202112706.14228-3-mateusz.grzonka@intel.com>
Date:   Thu, 23 Feb 2023 21:39:41 +0800
Cc:     linux-raid <linux-raid@vger.kernel.org>, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <05396455-956B-4D07-B11D-36DBB086B962@suse.de>
References: <20230202112706.14228-1-mateusz.grzonka@intel.com>
 <20230202112706.14228-3-mateusz.grzonka@intel.com>
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Feb 02, 2023 at 12:27:00PM +0100, Mateusz Grzonka wrote:
> Add events enum, and mapping_t struct, that maps them to strings, so
> that enums are passed around instead of strings.
>=20
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>

Acked-by: Coly Li <colyli@suse.de>

> ---
> Monitor.c | 136 +++++++++++++++++++++++++++++++++---------------------
> 1 file changed, 83 insertions(+), 53 deletions(-)
>=20
> diff --git a/Monitor.c b/Monitor.c
> index 9ef4dab8..029e9efd 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -32,6 +32,8 @@
> #include	<libudev.h>
> #endif
>=20
> +#define EVENT_NAME_MAX 32
> +
> struct state {
> 	char devname[MD_NAME_MAX + sizeof("/dev/md/")];	/* length of =
"/dev/md/" + device name + terminating byte*/
> 	char devnm[MD_NAME_MAX];	/* to sync with mdstat info */
> @@ -65,10 +67,43 @@ struct alert_info {
> 	int dosyslog;
> 	int test;
> } info;
> +
> +enum event {
> +	EVENT_SPARE_ACTIVE =3D 0,
> +	EVENT_NEW_ARRAY,
> +	EVENT_MOVE_SPARE,
> +	EVENT_TEST_MESSAGE,
> +	EVENT_REBUILD_STARTED,
> +	EVENT_REBUILD,
> +	EVENT_REBUILD_FINISHED,
> +	EVENT_SPARES_MISSING,
> +	EVENT_DEVICE_DISAPPEARED,
> +	EVENT_FAIL,
> +	EVENT_FAIL_SPARE,
> +	EVENT_DEGRADED_ARRAY,
> +	EVENT_UNKNOWN
> +};
> +
> +mapping_t events_map[] =3D {
> +	{"SpareActive", EVENT_SPARE_ACTIVE},
> +	{"NewArray", EVENT_NEW_ARRAY},
> +	{"MoveSpare", EVENT_MOVE_SPARE},
> +	{"TestMessage", EVENT_TEST_MESSAGE},
> +	{"RebuildStarted", EVENT_REBUILD_STARTED},
> +	{"Rebuild", EVENT_REBUILD},
> +	{"RebuildFinished", EVENT_REBUILD_FINISHED},
> +	{"SparesMissing", EVENT_SPARES_MISSING},
> +	{"DeviceDisappeared", EVENT_DEVICE_DISAPPEARED},
> +	{"Fail", EVENT_FAIL},
> +	{"FailSpare", EVENT_FAIL_SPARE},
> +	{"DegradedArray", EVENT_DEGRADED_ARRAY},
> +	{NULL, EVENT_UNKNOWN}
> +};
> +
> static int make_daemon(char *pidfile);
> static int check_one_sharer(int scan);
> static void write_autorebuild_pid(void);
> -static void alert(const char *event, const char *dev, const char =
*disc);
> +static void alert(const enum event event_enum, const unsigned int =
progress, const char *dev, const char *disc);
> static int check_array(struct state *st, struct mdstat_ent *mdstat, =
int increments, char *prefer);
> static int add_new_arrays(struct mdstat_ent *mdstat, struct state =
**statelist);
> static void try_spare_migration(struct state *statelist);
> @@ -415,7 +450,7 @@ static void write_autorebuild_pid()
> 	}
> }
>=20
> -static void execute_alert_cmd(const char *event, const char *dev, =
const char *disc)
> +static void execute_alert_cmd(const char *event_name, const char =
*dev, const char *disc)
> {
> 	int pid =3D fork();
>=20
> @@ -427,12 +462,12 @@ static void execute_alert_cmd(const char *event, =
const char *dev, const char *di
> 		pr_err("Cannot fork to execute alert command");
> 		break;
> 	case 0:
> -		execl(info.alert_cmd, info.alert_cmd, event, dev, disc, =
NULL);
> +		execl(info.alert_cmd, info.alert_cmd, event_name, dev, =
disc, NULL);
> 		exit(2);
> 	}
> }
>=20
> -static void send_event_email(const char *event, const char *dev, =
const char *disc)
> +static void send_event_email(const char *event_name, const char *dev, =
const char *disc)
> {
> 	FILE *mp, *mdstat;
> 	char buf[BUFSIZ];
> @@ -450,9 +485,9 @@ static void send_event_email(const char *event, =
const char *dev, const char *dis
> 	else
> 		fprintf(mp, "From: %s monitoring <root>\n", Name);
> 	fprintf(mp, "To: %s\n", info.mailaddr);
> -	fprintf(mp, "Subject: %s event on %s:%s\n\n", event, dev, =
info.hostname);
> +	fprintf(mp, "Subject: %s event on %s:%s\n\n", event_name, dev, =
info.hostname);
> 	fprintf(mp, "This is an automatically generated mail message. =
\n");
> -	fprintf(mp, "A %s event had been detected on md device %s.\n\n", =
event, dev);
> +	fprintf(mp, "A %s event had been detected on md device %s.\n\n", =
event_name, dev);
>=20
> 	if (disc && disc[0] !=3D ' ')
> 		fprintf(mp,
> @@ -474,20 +509,20 @@ static void send_event_email(const char *event, =
const char *dev, const char *dis
> 	pclose(mp);
> }
>=20
> -static void log_event_to_syslog(const char *event, const char *dev, =
const char *disc)
> +static void log_event_to_syslog(const enum event event_enum, const =
char *event_name, const char *dev, const char *disc)
> {
> 	int priority;
> 	/* Log at a different severity depending on the event.
> 	 *
> 	 * These are the critical events:  */
> -	if (strncmp(event, "Fail", 4) =3D=3D 0 ||
> -		strncmp(event, "Degrade", 7) =3D=3D 0 ||
> -		strncmp(event, "DeviceDisappeared", 17) =3D=3D 0)
> +	if (event_enum =3D=3D EVENT_FAIL ||
> +	    event_enum =3D=3D EVENT_DEGRADED_ARRAY ||
> +	    event_enum =3D=3D EVENT_DEVICE_DISAPPEARED)
> 		priority =3D LOG_CRIT;
> 	/* Good to know about, but are not failures: */
> -	else if (strncmp(event, "Rebuild", 7) =3D=3D 0 ||
> -			strncmp(event, "MoveSpare", 9) =3D=3D 0 ||
> -			strncmp(event, "Spares", 6) !=3D 0)
> +	else if (event_enum =3D=3D EVENT_REBUILD ||
> +		 event_enum =3D=3D EVENT_MOVE_SPARE ||
> +		 event_enum =3D=3D EVENT_SPARES_MISSING)
> 		priority =3D LOG_WARNING;
> 	/* Everything else: */
> 	else
> @@ -495,33 +530,37 @@ static void log_event_to_syslog(const char =
*event, const char *dev, const char *
>=20
> 	if (disc && disc[0] !=3D ' ')
> 		syslog(priority,
> -			"%s event detected on md device %s, component =
device %s", event, dev, disc);
> +		       "%s event detected on md device %s, component =
device %s",
> +		       event_name, dev, disc);
> 	else if (disc)
> -		syslog(priority, "%s event detected on md device %s: =
%s", event, dev, disc);
> +		syslog(priority, "%s event detected on md device %s: =
%s", event_name, dev, disc);
> 	else
> -		syslog(priority, "%s event detected on md device %s", =
event, dev);
> +		syslog(priority, "%s event detected on md device %s", =
event_name, dev);
> }
>=20
> -static void alert(const char *event, const char *dev, const char =
*disc)
> +static void alert(const enum event event_enum, const unsigned int =
progress, const char *dev, const char *disc)
> {
> -	if (!info.alert_cmd && !info.mailaddr && !info.dosyslog) {
> -		time_t now =3D time(0);
> +	char event_name[EVENT_NAME_MAX];
>=20
> -		printf("%1.15s: %s on %s %s\n", ctime(&now) + 4,
> -		       event, dev, disc?disc:"unknown device");
> +	if (event_enum =3D=3D EVENT_REBUILD) {
> +		snprintf(event_name, sizeof(event_name), "%s%02d",
> +			 map_num_s(events_map, EVENT_REBUILD), =
progress);
> +	} else {
> +		snprintf(event_name, sizeof(event_name), "%s", =
map_num_s(events_map, event_enum));
> 	}
> +
> 	if (info.alert_cmd)
> -		execute_alert_cmd(event, dev, disc);
> +		execute_alert_cmd(event_name, dev, disc);
>=20
> -	if (info.mailaddr && (strncmp(event, "Fail", 4) =3D=3D 0 ||
> -			       strncmp(event, "Test", 4) =3D=3D 0 ||
> -			       strncmp(event, "Spares", 6) =3D=3D 0 ||
> -			       strncmp(event, "Degrade", 7) =3D=3D 0)) {
> -		send_event_email(event, dev, disc);
> +	if (info.mailaddr && (event_enum =3D=3D EVENT_FAIL ||
> +			      event_enum =3D=3D EVENT_TEST_MESSAGE ||
> +			      event_enum =3D=3D EVENT_SPARES_MISSING ||
> +			      event_enum =3D=3D EVENT_DEGRADED_ARRAY)) {
> +		send_event_email(event_name, dev, disc);
> 	}
>=20
> 	if (info.dosyslog)
> -		log_event_to_syslog(event, dev, disc);
> +		log_event_to_syslog(event_enum, event_name, dev, disc);
> }
>=20
> static int check_array(struct state *st, struct mdstat_ent *mdstat,
> @@ -546,7 +585,7 @@ static int check_array(struct state *st, struct =
mdstat_ent *mdstat,
> 	unsigned long redundancy_only_flags =3D 0;
>=20
> 	if (info.test)
> -		alert("TestMessage", dev, NULL);
> +		alert(EVENT_TEST_MESSAGE, 0, dev, NULL);
>=20
> 	retval =3D 0;
>=20
> @@ -595,7 +634,7 @@ static int check_array(struct state *st, struct =
mdstat_ent *mdstat,
> 	 */
> 	if (sra->array.level =3D=3D 0 || sra->array.level =3D=3D -1) {
> 		if (!st->err && !st->from_config)
> -			alert("DeviceDisappeared", dev, " Wrong-Level");
> +			alert(EVENT_DEVICE_DISAPPEARED, 0, dev, " =
Wrong-Level");
> 		st->err++;
> 		goto out;
> 	}
> @@ -612,7 +651,7 @@ static int check_array(struct state *st, struct =
mdstat_ent *mdstat,
> 		st->percent =3D RESYNC_NONE;
> 		new_array =3D 1;
> 		if (!is_container)
> -			alert("NewArray", st->devname, NULL);
> +			alert(EVENT_NEW_ARRAY, 0, st->devname, NULL);
> 	}
>=20
> 	if (st->utime =3D=3D array.utime && st->failed =3D=3D =
sra->array.failed_disks &&
> @@ -625,29 +664,20 @@ static int check_array(struct state *st, struct =
mdstat_ent *mdstat,
> 	}
> 	if (st->utime =3D=3D 0 && /* new array */
> 	    mse->pattern && strchr(mse->pattern, '_') /* degraded */)
> -		alert("DegradedArray", dev, NULL);
> +		alert(EVENT_DEGRADED_ARRAY, 0, dev, NULL);
>=20
> 	if (st->utime =3D=3D 0 && /* new array */ st->expected_spares > =
0 &&
> 	    sra->array.spare_disks < st->expected_spares)
> -		alert("SparesMissing", dev, NULL);
> +		alert(EVENT_SPARES_MISSING, 0, dev, NULL);
> 	if (st->percent < 0 && st->percent !=3D RESYNC_UNKNOWN &&
> 	    mse->percent >=3D 0)
> -		alert("RebuildStarted", dev, NULL);
> +		alert(EVENT_REBUILD_STARTED, 0, dev, NULL);
> 	if (st->percent >=3D 0 && mse->percent >=3D 0 &&
> 	    (mse->percent / increments) > (st->percent / increments)) {
> -		char percentalert[18];
> -		/*
> -		 * "RebuildNN" (10 chars) or "RebuildStarted" (15 chars)
> -		 */
> -
> 		if((mse->percent / increments) =3D=3D 0)
> -			snprintf(percentalert, sizeof(percentalert),
> -				 "RebuildStarted");
> +			alert(EVENT_REBUILD_STARTED, 0, dev, NULL);
> 		else
> -			snprintf(percentalert, sizeof(percentalert),
> -				 "Rebuild%02d", mse->percent);
> -
> -		alert(percentalert, dev, NULL);
> +			alert(EVENT_REBUILD, mse->percent, dev, NULL);
> 	}
>=20
> 	if (mse->percent =3D=3D RESYNC_NONE && st->percent >=3D 0) {
> @@ -660,9 +690,9 @@ static int check_array(struct state *st, struct =
mdstat_ent *mdstat,
> 			snprintf(cnt, sizeof(cnt),
> 				 " mismatches found: %d (on raid level =
%d)",
> 				 sra->mismatch_cnt, sra->array.level);
> -			alert("RebuildFinished", dev, cnt);
> +			alert(EVENT_REBUILD_FINISHED, 0, dev, cnt);
> 		} else
> -			alert("RebuildFinished", dev, NULL);
> +			alert(EVENT_REBUILD_FINISHED, 0, dev, NULL);
> 	}
> 	st->percent =3D mse->percent;
>=20
> @@ -716,14 +746,14 @@ static int check_array(struct state *st, struct =
mdstat_ent *mdstat,
> 		change =3D newstate ^ st->devstate[i];
> 		if (st->utime && change && !st->err && !new_array) {
> 			if ((st->devstate[i]&change) & (1 << =
MD_DISK_SYNC))
> -				alert("Fail", dev, dv);
> +				alert(EVENT_FAIL, 0, dev, dv);
> 			else if ((newstate & (1 << MD_DISK_FAULTY)) &&
> 				 (disc.major || disc.minor) &&
> 				 st->devid[i] =3D=3D makedev(disc.major,
> 							 disc.minor))
> -				alert("FailSpare", dev, dv);
> +				alert(EVENT_FAIL_SPARE, 0, dev, dv);
> 			else if ((newstate&change) & (1 << =
MD_DISK_SYNC))
> -				alert("SpareActive", dev, dv);
> +				alert(EVENT_SPARE_ACTIVE, 0, dev, dv);
> 		}
> 		st->devstate[i] =3D newstate;
> 		st->devid[i] =3D makedev(disc.major, disc.minor);
> @@ -747,7 +777,7 @@ static int check_array(struct state *st, struct =
mdstat_ent *mdstat,
>=20
>  disappeared:
> 	if (!st->err && !is_container)
> -		alert("DeviceDisappeared", dev, NULL);
> +		alert(EVENT_DEVICE_DISAPPEARED, 0, dev, NULL);
> 	st->err++;
> 	goto out;
> }
> @@ -806,7 +836,7 @@ static int add_new_arrays(struct mdstat_ent =
*mdstat, struct state **statelist)
> 				st->parent_devnm[0] =3D 0;
> 			*statelist =3D st;
> 			if (info.test)
> -				alert("TestMessage", st->devname, NULL);
> +				alert(EVENT_TEST_MESSAGE, 0, =
st->devname, NULL);
> 			new_found =3D 1;
> 		}
> 	return new_found;
> @@ -1029,7 +1059,7 @@ static void try_spare_migration(struct state =
*statelist)
> 				if (devid > 0 &&
> 				    move_spare(from->devname, =
to->devname,
> 					       devid)) {
> -					alert("MoveSpare", to->devname, =
from->devname);
> +					alert(EVENT_MOVE_SPARE, 0, =
to->devname, from->devname);
> 					break;
> 				}
> 			}
> --=20
> 2.26.2
>=20

--=20
Coly Li
