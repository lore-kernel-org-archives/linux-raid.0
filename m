Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7174C61DA4
	for <linux-raid@archiver.kernel.org>; Thu, 23 Feb 2023 13:41:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbjBWNl4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Feb 2023 08:41:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234238AbjBWNlx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Feb 2023 08:41:53 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5B94608E
        for <linux-raid@vger.kernel.org>; Thu, 23 Feb 2023 05:41:50 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BE1E92025C;
        Thu, 23 Feb 2023 13:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677159708; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dDl5bajDdfR81YaMJtBzCZwqDB2FPZubFb4tfN2bmlk=;
        b=FeJrYSf2CkxTw/Wj6yUfwaNxk+2JuYD2ER19ssesemSVnfh05aO7QOeNmRDp3GvWo+Bhym
        tlgmYPkZa15sXZwGy03M6lU3p5l2wsMBg8peE6Q93UUqEJRGzglCcZZzNIDgnm1++nzSu2
        PvhA0HSo0EdRgjINl7cL1iY7F0dmeeM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677159708;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dDl5bajDdfR81YaMJtBzCZwqDB2FPZubFb4tfN2bmlk=;
        b=LxzuVQZ/1ggUPihgM9xSnEdmLsjhuBKJWtLJARkPn6mZ5L06P7VDOrmygOZOxrdWaQMsU8
        2g09pTUbKtY3NVDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4B619139B5;
        Thu, 23 Feb 2023 13:41:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8H0FBRtt92MOfQAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 23 Feb 2023 13:41:47 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH v3 7/8] Mdmonitor: Improve udev event handling
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230202112706.14228-8-mateusz.grzonka@intel.com>
Date:   Thu, 23 Feb 2023 21:41:36 +0800
Cc:     linux-raid <linux-raid@vger.kernel.org>, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <36CE9E87-0BE6-44B7-970A-5E753E5AC68E@suse.de>
References: <20230202112706.14228-1-mateusz.grzonka@intel.com>
 <20230202112706.14228-8-mateusz.grzonka@intel.com>
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Feb 02, 2023 at 12:27:05PM +0100, Mateusz Grzonka wrote:
> Mdmonitor is waiting for udev queue to become empty.
> Even if the queue becomes empty, udev might still be processing last =
event.
> However we want to wait and wake up mdmonitor when udev finished
> processing events..
>=20
> Also, the udev queue interface is considered legacy and should not be
> used outside of udev.
>=20
> Use udev monitor instead, and wake up mdmonitor on every event =
triggered
> by udev for md block device.
>=20
> We need to generate more change events from kernel, because they are
> missing in some situations, for example, when rebuild started.
> This will be addressed in a separate patch.
>=20
> Move udev specific code into separate functions, and place them in =
udev.c file.
> Also move use_udev() logic from lib.c into newly created file.
>=20
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>

Acked-by: Coly Li <colyli@suse.de>

> ---
> Makefile  |   3 +-
> Manage.c  |   3 +-
> Monitor.c | 137 +++++++++++++++++++-------------------------------
> lib.c     |  13 -----
> mdadm.h   |   1 -
> mdopen.c  |   7 +--
> udev.c    | 147 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> udev.h    |  36 +++++++++++++
> 8 files changed, 241 insertions(+), 106 deletions(-)
> create mode 100644 udev.c
> create mode 100644 udev.h
>=20
> diff --git a/Makefile b/Makefile
> index 5eac1a4e..c4c40832 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -124,6 +124,7 @@ LDLIBS =3D -ldl
> # To explicitly disable libudev, set -DNO_LIBUDEV in CXFLAGS
> ifeq (, $(findstring -DNO_LIBUDEV,  $(CXFLAGS)))
> 	LDLIBS +=3D -ludev
> +	OBJS =3D udev.o
> endif
>=20
> INSTALL =3D /usr/bin/install
> @@ -145,7 +146,7 @@ else
> 	ECHO=3D:
> endif
>=20
> -OBJS =3D  mdadm.o config.o policy.o mdstat.o  ReadMe.o uuid.o util.o =
maps.o lib.o \
> +OBJS +=3D mdadm.o config.o policy.o mdstat.o  ReadMe.o uuid.o util.o =
maps.o lib.o \
> 	Manage.o Assemble.o Build.o \
> 	Create.o Detail.o Examine.o Grow.o Monitor.o dlink.o Kill.o =
Query.o \
> 	Incremental.o Dump.o \
> diff --git a/Manage.c b/Manage.c
> index fde6aba3..9c7b1b9c 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -25,6 +25,7 @@
> #include "mdadm.h"
> #include "md_u.h"
> #include "md_p.h"
> +#include "udev.h"
> #include <ctype.h>
>=20
> int Manage_ro(char *devname, int fd, int readonly)
> @@ -472,7 +473,7 @@ done:
> 			sysfs_uevent(mdi, "change");
> 	}
>=20
> -	if (devnm[0] && use_udev()) {
> +	if (devnm[0] && udev_is_available()) {
> 		struct map_ent *mp =3D map_by_devnm(&map, devnm);
> 		remove_devices(devnm, mp ? mp->path : NULL);
> 	}
> diff --git a/Monitor.c b/Monitor.c
> index 44918184..01133003 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -23,18 +23,17 @@
>  */
>=20
> #include	"mdadm.h"
> +#include	"udev.h"
> #include	"md_p.h"
> #include	"md_u.h"
> #include	<sys/wait.h>
> #include	<limits.h>
> #include	<syslog.h>
> -#ifndef NO_LIBUDEV
> -#include	<libudev.h>
> -#endif
>=20
> #define TASK_COMM_LEN 16
> #define EVENT_NAME_MAX 32
> #define AUTOREBUILD_PID_PATH MDMON_DIR "/autorebuild.pid"
> +#define FALLBACK_DELAY 5
>=20
> struct state {
> 	char devname[MD_NAME_MAX + sizeof("/dev/md/")];	/* length of =
"/dev/md/" + device name + terminating byte*/
> @@ -122,12 +121,11 @@ static void =
link_containers_with_subarrays(struct state *list);
> static void free_statelist(struct state *statelist);
> static int check_array(struct state *st, struct mdstat_ent *mdstat, =
int increments, char *prefer);
> static int check_one_sharer(int scan);
> -#ifndef NO_LIBUDEV
> -static int check_udev_activity(void);
> -#endif
> static void link_containers_with_subarrays(struct state *list);
> static int make_daemon(char *pidfile);
> static void try_spare_migration(struct state *statelist);
> +static void wait_for_events(int *delay_for_event, int c_delay);
> +static void wait_for_events_mdstat(int *delay_for_event, int =
c_delay);
> static int write_autorebuild_pid(void);
>=20
> int Monitor(struct mddev_dev *devlist,
> @@ -323,32 +321,12 @@ int Monitor(struct mddev_dev *devlist,
> 		if (!new_found) {
> 			if (oneshot)
> 				break;
> -			else if (!anyredundant) {
> +			if (!anyredundant) {
> 				pr_err("No array with redundancy =
detected, stopping\n");
> 				break;
> 			}
> -			else {
> -#ifndef NO_LIBUDEV
> -				/*
> -				 * Wait for udevd to finish new devices
> -				 * processing.
> -				 */
> -				if (mdstat_wait(delay_for_event) &&
> -				    check_udev_activity())
> -					pr_err("Error while waiting for =
UDEV to complete new devices processing\n");
> -#else
> -				int wait_result =3D =
mdstat_wait(delay_for_event);
> -				/*
> -				 * Give chance to process new device
> -				 */
> -				if (wait_result !=3D 0) {
> -					if (c->delay > 5)
> -						delay_for_event =3D 5;
> -				} else
> -					delay_for_event =3D c->delay;
> -#endif
> -				mdstat_close();
> -			}
> +
> +			wait_for_events(&delay_for_event, c->delay);
> 		}
> 		info.test =3D 0;
>=20
> @@ -371,6 +349,49 @@ int Monitor(struct mddev_dev *devlist,
> 	return 0;
> }
>=20
> +/*
> + * wait_for_events() - Waits for events on md devices.
> + * @delay_for_event: pointer to current event delay
> + * @c_delay: delay from config
> + */
> +static void wait_for_events(int *delay_for_event, int c_delay)
> +{
> +#ifndef NO_LIBUDEV
> +	if (udev_is_available()) {
> +		if (udev_wait_for_events(*delay_for_event) =3D=3D =
UDEV_STATUS_ERROR)
> +			pr_err("Error while waiting for udev =
events.\n");
> +		return;
> +	}
> +#endif
> +	wait_for_events_mdstat(delay_for_event, c_delay);
> +}
> +
> +/*
> + * wait_for_events_mdstat() - Waits for events on mdstat.
> + * @delay_for_event: pointer to current event delay
> + * @c_delay: delay from config
> + */
> +static void wait_for_events_mdstat(int *delay_for_event, int c_delay)
> +{
> +	int wait_result =3D mdstat_wait(*delay_for_event);
> +
> +	if (wait_result < 0) {
> +		pr_err("Error while waiting for events on mdstat.\n");
> +		return;
> +	}
> +
> +	/*
> +	 * Give chance to process new device
> +	 */
> +	if (wait_result !=3D 0) {
> +		if (c_delay > FALLBACK_DELAY)
> +			*delay_for_event =3D FALLBACK_DELAY;
> +	} else {
> +		*delay_for_event =3D c_delay;
> +	}
> +	mdstat_close();
> +}
> +
> static int make_daemon(char *pidfile)
> {
> 	/* Return:
> @@ -1251,64 +1272,6 @@ static void free_statelist(struct state =
*statelist)
> 	}
> }
>=20
> -#ifndef NO_LIBUDEV
> -/* function: check_udev_activity
> - * Description: Function waits for udev to finish
> - * events processing.
> - * Returns:
> - *		1 - detected error while opening udev
> - *		2 - timeout
> - *		0 - successfull completion
> - */
> -static int check_udev_activity(void)
> -{
> -	struct udev *udev =3D NULL;
> -	struct udev_queue *udev_queue =3D NULL;
> -	int timeout_cnt =3D 30;
> -	int rc =3D 0;
> -
> -	/*
> -	 * In rare cases systemd may not have udevm,
> -	 * in such cases just exit with rc 0
> -	 */
> -	if (!use_udev())
> -		goto out;
> -
> -	udev =3D udev_new();
> -	if (!udev) {
> -		rc =3D 1;
> -		goto out;
> -	}
> -
> -	udev_queue =3D udev_queue_new(udev);
> -	if (!udev_queue) {
> -		rc =3D 1;
> -		goto out;
> -	}
> -
> -	if (udev_queue_get_queue_is_empty(udev_queue))
> -		goto out;
> -
> -	while (!udev_queue_get_queue_is_empty(udev_queue)) {
> -		sleep(1);
> -
> -		if (timeout_cnt)
> -			timeout_cnt--;
> -		else {
> -			rc =3D 2;
> -			goto out;
> -		}
> -	}
> -
> -out:
> -	if (udev_queue)
> -		udev_queue_unref(udev_queue);
> -	if (udev)
> -		udev_unref(udev);
> -	return rc;
> -}
> -#endif
> -
> /* Not really Monitor but ... */
> int Wait(char *dev)
> {
> diff --git a/lib.c b/lib.c
> index e395b28d..96ba6e8d 100644
> --- a/lib.c
> +++ b/lib.c
> @@ -495,19 +495,6 @@ int check_env(char *name)
> 	return 0;
> }
>=20
> -int use_udev(void)
> -{
> -	static int use =3D -1;
> -	struct stat stb;
> -
> -	if (use < 0) {
> -		use =3D ((stat("/dev/.udev", &stb) =3D=3D 0 ||
> -			stat("/run/udev", &stb) =3D=3D 0) &&
> -		       check_env("MDADM_NO_UDEV") =3D=3D 0);
> -	}
> -	return use;
> -}
> -
> unsigned long GCD(unsigned long a, unsigned long b)
> {
> 	while (a !=3D b) {
> diff --git a/mdadm.h b/mdadm.h
> index 1674ce13..23c10a52 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1624,7 +1624,6 @@ extern char *conf_line(FILE *file);
> extern char *conf_word(FILE *file, int allow_key);
> extern void print_quoted(char *str);
> extern void print_escape(char *str);
> -extern int use_udev(void);
> extern unsigned long GCD(unsigned long a, unsigned long b);
> extern int conf_name_is_free(char *name);
> extern int conf_verify_devnames(struct mddev_ident *array_list);
> diff --git a/mdopen.c b/mdopen.c
> index d18c9319..afec34a4 100644
> --- a/mdopen.c
> +++ b/mdopen.c
> @@ -23,6 +23,7 @@
>  */
>=20
> #include "mdadm.h"
> +#include "udev.h"
> #include "md_p.h"
> #include <ctype.h>
>=20
> @@ -176,7 +177,7 @@ int create_mddev(char *dev, char *name, int autof, =
int trustworthy,
> 	char devnm[32];
> 	char cbuf[400];
>=20
> -	if (!use_udev())
> +	if (!udev_is_available())
> 		block_udev =3D 0;
>=20
> 	if (chosen =3D=3D NULL)
> @@ -383,7 +384,7 @@ int create_mddev(char *dev, char *name, int autof, =
int trustworthy,
> 	 * If we cannot detect udev, we need to make
> 	 * devices and links ourselves.
> 	 */
> -	if (!use_udev()) {
> +	if (!udev_is_available()) {
> 		/* Make sure 'devname' exists and 'chosen' is a symlink =
to it */
> 		if (lstat(devname, &stb) =3D=3D 0) {
> 			/* Must be the correct device, else error */
> @@ -507,7 +508,7 @@ char *find_free_devnm(int use_partitions)
> 			continue;
> 		if (!conf_name_is_free(devnm))
> 			continue;
> -		if (!use_udev()) {
> +		if (!udev_is_available()) {
> 			/* make sure it is new to /dev too, at least as =
a
> 			 * non-standard */
> 			dev_t devid =3D devnm2devid(devnm);
> diff --git a/udev.c b/udev.c
> new file mode 100644
> index 00000000..72a38f47
> --- /dev/null
> +++ b/udev.c
> @@ -0,0 +1,147 @@
> +/*
> + * mdadm - manage Linux "md" devices aka RAID arrays.
> + *
> + * Copyright (C) 2022 Mateusz Grzonka <mateusz.grzonka@intel.com>
> + *
> + *    This program is free software; you can redistribute it and/or =
modify
> + *    it under the terms of the GNU General Public License as =
published by
> + *    the Free Software Foundation; either version 2 of the License, =
or
> + *    (at your option) any later version.
> + *
> + *    This program is distributed in the hope that it will be useful,
> + *    but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *    GNU General Public License for more details.
> + *
> + *    You should have received a copy of the GNU General Public =
License
> + *    along with this program; if not, write to the Free Software
> + *    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  =
02111-1307  USA
> + */
> +
> +#include	"mdadm.h"
> +#include	"udev.h"
> +#include	"md_p.h"
> +#include	"md_u.h"
> +#include	<sys/wait.h>
> +#include	<signal.h>
> +#include	<limits.h>
> +#include	<syslog.h>
> +#include	<libudev.h>
> +
> +static struct udev *udev;
> +static struct udev_monitor *udev_monitor;
> +
> +/*
> + * udev_is_available() - Checks for udev in the system.
> + *
> + * Function looks whether udev binaries are available and =
MDADM_NO_UDEV env defined.
> + *
> + * Return:
> + * true if udev is available,
> + * false if not
> + */
> +bool udev_is_available(void)
> +{
> +	struct stat stb;
> +
> +	if (stat("/dev/.udev", &stb) !=3D 0 &&
> +	    stat("/run/udev", &stb) !=3D 0)
> +		return false;
> +	if (check_env("MDADM_NO_UDEV") =3D=3D 1)
> +		return false;
> +	return true;
> +}
> +
> +/*
> + * udev_initialize() - Initializes udev and udev_monitor structures.
> + *
> + * Function initializes udev, udev_monitor, and sets udev_monitor =
filter for block devices.
> + *
> + * Return:
> + * UDEV_STATUS_SUCCESS on success
> + * UDEV_STATUS_ERROR on error
> + * UDEV_STATUS_ERROR_NO_UDEV when udev not available
> + */
> +enum udev_status udev_initialize(void)
> +{
> +	if (!udev_is_available()) {
> +		pr_err("No udev.\n");
> +		return UDEV_STATUS_ERROR_NO_UDEV;
> +	}
> +
> +	udev =3D udev_new();
> +	if (!udev) {
> +		pr_err("Cannot initialize udev.\n");
> +		return UDEV_STATUS_ERROR;
> +	}
> +
> +	udev_monitor =3D udev_monitor_new_from_netlink(udev, "udev");
> +	if (!udev_monitor) {
> +		pr_err("Cannot initialize udev monitor.\n");
> +		udev =3D udev_unref(udev);
> +		return UDEV_STATUS_ERROR;
> +	}
> +
> +	if =
(udev_monitor_filter_add_match_subsystem_devtype(udev_monitor, "block", =
0) < 0) {
> +		pr_err("Cannot add udev monitor event filter for md =
devices.\n");
> +		udev_release();
> +		return UDEV_STATUS_ERROR;
> +	}
> +	if (udev_monitor_enable_receiving(udev_monitor) < 0) {
> +		pr_err("Cannot enable receiving udev events through udev =
monitor.\n");
> +		udev_release();
> +		return UDEV_STATUS_ERROR;
> +	}
> +	atexit(udev_release);
> +	return UDEV_STATUS_SUCCESS;
> +}
> +
> +/*
> + * udev_wait_for_events() - Waits for events from udev.
> + * @seconds: Timeout in seconds.
> + *
> + * Function waits udev events, wakes up on event or timeout.
> + *
> + * Return:
> + * UDEV_STATUS_SUCCESS on detected event
> + * UDEV_STATUS_TIMEOUT on timeout
> + * UDEV_STATUS_ERROR on error
> + */
> +enum udev_status udev_wait_for_events(int seconds)
> +{
> +	int fd;
> +	fd_set readfds;
> +	struct timeval tv;
> +	int ret;
> +
> +	if (!udev || !udev_monitor) {
> +		ret =3D udev_initialize();
> +		if (ret !=3D UDEV_STATUS_SUCCESS)
> +			return ret;
> +	}
> +
> +	fd =3D udev_monitor_get_fd(udev_monitor);
> +	if (fd < 0) {
> +		pr_err("Cannot access file descriptor associated with =
udev monitor.\n");
> +		return UDEV_STATUS_ERROR;
> +	}
> +
> +	FD_ZERO(&readfds);
> +	FD_SET(fd, &readfds);
> +	tv.tv_sec =3D seconds;
> +	tv.tv_usec =3D 0;
> +
> +	if (select(fd + 1, &readfds, NULL, NULL, &tv) > 0 && =
FD_ISSET(fd, &readfds))
> +		if (udev_monitor_receive_device(udev_monitor))
> +			return UDEV_STATUS_SUCCESS; /* event detected */
> +	return UDEV_STATUS_TIMEOUT;
> +}
> +
> +/*
> + * udev_release() - Drops references of udev and udev_monitor.
> + */
> +void udev_release(void)
> +{
> +	udev_monitor_unref(udev_monitor);
> +	udev_unref(udev);
> +}
> diff --git a/udev.h b/udev.h
> new file mode 100644
> index 00000000..515366e7
> --- /dev/null
> +++ b/udev.h
> @@ -0,0 +1,36 @@
> +/*
> + * mdadm - manage Linux "md" devices aka RAID arrays.
> + *
> + * Copyright (C) 2022 Mateusz Grzonka <mateusz.grzonka@intel.com>
> + *
> + *    This program is free software; you can redistribute it and/or =
modify
> + *    it under the terms of the GNU General Public License as =
published by
> + *    the Free Software Foundation; either version 2 of the License, =
or
> + *    (at your option) any later version.
> + *
> + *    This program is distributed in the hope that it will be useful,
> + *    but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *    GNU General Public License for more details.
> + *
> + *    You should have received a copy of the GNU General Public =
License
> + *    along with this program; if not, write to the Free Software
> + *    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  =
02111-1307  USA
> + */
> +
> +#ifndef MONITOR_UDEV_H
> +#define MONITOR_UDEV_H
> +
> +enum udev_status {
> +	UDEV_STATUS_ERROR_NO_UDEV =3D -2,
> +	UDEV_STATUS_ERROR,
> +	UDEV_STATUS_SUCCESS =3D 0,
> +	UDEV_STATUS_TIMEOUT
> +};
> +
> +bool udev_is_available(void);
> +enum udev_status udev_initialize(void);
> +enum udev_status udev_wait_for_events(int seconds);
> +void udev_release(void);
> +
> +#endif
> --=20
> 2.26.2
>=20

--=20
Coly Li
