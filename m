Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9551C77B75
	for <linux-raid@archiver.kernel.org>; Fri,  5 May 2023 16:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbjEEQyU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 5 May 2023 12:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbjEEQyQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 5 May 2023 12:54:16 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AC2191FE
        for <linux-raid@vger.kernel.org>; Fri,  5 May 2023 09:54:15 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id AAFEB2030B;
        Fri,  5 May 2023 16:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1683305653; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tvzc3LaHZCYfKhOMgXiS0VAVz0t6YJqjTJ/LWBbGfeI=;
        b=XdiybYDmSYhqXvetf8Hnq/BTrrbPuvSi3k7OgvJqyMyvLoXFIZz6rNEeXg2LzU7Sm8mNL1
        eGrdbqVJvxQAZmtBravy/82C0HoH64d7OKwDGIRb9fQonucsykrJkEgt81BSbgkLa2vy3O
        8VRnqHDHDvQXCdn3XOe6R5VN3kE3iJw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1683305653;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tvzc3LaHZCYfKhOMgXiS0VAVz0t6YJqjTJ/LWBbGfeI=;
        b=6QfzvyzUdBrdp82mQ8iwZzVVNoh8oLifPlbulJRq8ym1c3fjOi27tOrJdvtNTGjo349bbM
        bT9bXRtb9lW0q1Ag==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8380513513;
        Fri,  5 May 2023 16:54:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id JodNE7Q0VWSgNQAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 05 May 2023 16:54:12 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH] Incremental: remove obsoleted calls to udisks
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230505104910.00000aa9@linux.intel.com>
Date:   Sat, 6 May 2023 00:54:00 +0800
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C488DEFA-F2F3-4340-9D89-AFC87E7F5E39@suse.de>
References: <20230505052231.7787-1-colyli@suse.de>
 <20230505104910.00000aa9@linux.intel.com>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
X-Mailer: Apple Mail (2.3731.500.231)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, May 05, 2023 at 10:49:10AM +0200, Mariusz Tkaczyk wrote:
> On Fri,  5 May 2023 13:22:31 +0800
> Coly Li <colyli@suse.de> wrote:
>=20
>> Utilility udisks is removed from udev upstream, calling this =
obsoleted
>> command in run_udisks() doesn't make any sense now.
>>=20
>> This patch removes the calls chain of udisks, which includes routines
>> run_udisk(), force_remove(), and 2 locations where force_remove() are
>> called.
>>=20
>> In remove_from_member_array() and IncrementalRemove(), if return =
value
>> of calling Manage_subdevs() is not 0, don't call force_remove() and =
only
>> print error message when parameter 'verbose' is true.
>>=20
>> Signed-off-by: Coly Li <colyli@suse.de>
>> Cc: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
>> Cc: Jes Sorensen <jes@trained-monkey.org>
>> ---
>> Incremental.c | 50 +++++++-------------------------------------------
>> 1 file changed, 7 insertions(+), 43 deletions(-)
>>=20
>> diff --git a/Incremental.c b/Incremental.c
>> index 49a71f7..e1a953a 100644
>> --- a/Incremental.c
>> +++ b/Incremental.c
>> @@ -1630,54 +1630,18 @@ release:
>> 	return rv;
>> }
>>=20
>> -static void run_udisks(char *arg1, char *arg2)
>> -{
>> -	int pid =3D fork();
>> -	int status;
>> -	if (pid =3D=3D 0) {
>> -		manage_fork_fds(1);
>> -		execl("/usr/bin/udisks", "udisks", arg1, arg2, NULL);
>> -		execl("/bin/udisks", "udisks", arg1, arg2, NULL);
>> -		exit(1);
>> -	}
>> -	while (pid > 0 && wait(&status) !=3D pid)
>> -		;
>> -}
>> -
>> -static int force_remove(char *devnm, int fd, struct mdinfo *mdi, int =
verbose)
>> -{
>> -	int rv;
>> -	int devid =3D devnm2devid(devnm);
>> -
>> -	run_udisks("--unmount", map_dev(major(devid), minor(devid), 0));
>> -	rv =3D Manage_stop(devnm, fd, verbose, 1);
>=20
> Hi Coly,
> Please see that you removed Manage_stop(). Now mdadm won't try to
> stop failed arrays. It is good change but please describe it.

Copied. I will describe in commit log when I remove the call to =
Manage_stop().


>=20
>> -	if (rv) {
>> -		/* At least we can try to trigger a 'remove' */
>> -		sysfs_uevent(mdi, "remove");
>> -		if (verbose)
>> -			pr_err("Fail to stop %s too.\n", devnm);
>> -	}
>> -	return rv;
>> -}
>> -
>> static void remove_from_member_array(struct mdstat_ent *memb,
>> 				    struct mddev_dev *devlist, int =
verbose)
>> {
>> 	int rv;
>> -	struct mdinfo mmdi;
>> 	int subfd =3D open_dev(memb->devnm);
>>=20
>> 	if (subfd >=3D 0) {
>> 		rv =3D Manage_subdevs(memb->devnm, subfd, devlist, =
verbose,
>> 				    0, UOPT_UNDEFINED, 0);
>> -		if (rv & 2) {
>> -			if (sysfs_init(&mmdi, -1, memb->devnm))
>> -				pr_err("unable to initialize sysfs for:
>> %s\n",
>> -				       memb->devnm);
>> -			else
>> -				force_remove(memb->devnm, subfd, &mmdi,
>> -					     verbose);
>> -		}
>> +		if ((rv & 2) && verbose)
>=20
> There is a rule (at least we at Intel tried to follow) to use indirect
> comparisons only for pointers. I know that we don't have log level in =
mdadm,
> we need to compare with values directly:
> if ((rv & 2) && verbose > 0)
>=20
> It is not mandatory, just to let you know.

I see difference ways to check verbose are mixed. But yes, comparing =
directly
with values is better. I will follow your suggestion.

>> +			pr_err("Fail to remove %s from array.\n",
>> memb->devnm);
>=20
> Could we make this error less "dangerous"? I mean that someone may =
think that
> something is wrong here but it is not - the message is expected in =
case when
> raid becomes failed. Note that for raid5 disk is removed from array =
but EBUSY
> is returned anyway. Maybe we should check for MD_BROKEN in array_state =
to
> differentiate and make errors more detailed?
>=20
> Same applies to the native case below.

I agree. Let me improve this.


>=20
>> 		close(subfd);
>> 	}
>> }
>> @@ -1763,10 +1727,10 @@ int IncrementalRemove(char *devname, char =
*id_path,
>> int verbose) rv |=3D Manage_subdevs(ent->devnm, mdfd, &devlist,
>> 				    verbose, 0, UOPT_UNDEFINED, 0);
>> 		if (rv & 2) {
>> -		/* Failed due to EBUSY, try to stop the array.
>> -		 * Give udisks a chance to unmount it first.
>> -		 */
>> -			rv =3D force_remove(ent->devnm, mdfd, &mdi, =
verbose);
>> +			if (verbose)
>> +				pr_err("Fail to remove %s from =
array.\n",
>> ent->devnm);
>> +			/* Only return 0 or 1 */
>> +			rv =3D !!rv;
> we are in if (rv & 2) so I think that we can simply set rv =3D 1, am I =
right?
>=20

OK, I will change it.

>> 			goto end;
>> 		}
>> 	}

Thanks for your review.

--=20
Coly Li
