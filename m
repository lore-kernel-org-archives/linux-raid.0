Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB3BC7EE23
	for <linux-raid@archiver.kernel.org>; Fri, 26 May 2023 14:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244043AbjEZOoW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 26 May 2023 10:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237052AbjEZOoP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 26 May 2023 10:44:15 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D864E64
        for <linux-raid@vger.kernel.org>; Fri, 26 May 2023 07:43:37 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 16A7821AFB;
        Fri, 26 May 2023 14:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1685112176; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EJFXGPU4lE1oaj4GkfLCHh5RLyDCrcv1pD0fRYYPBgM=;
        b=jApbLe1MUF1qKKVxTehITDs2mz5IPP50RhhYlQFp4PCCkX8bz7DlV8gbG65BuxVkD4V9gZ
        juVNJri8vgQnh3HK+OUo7E5G+kinPeYfgr9AW0MFNz7uIScDetjmNM2iSDBFHT2VkdyKVp
        UYLXcIYPTFi15ogTlgsrU9COg4HGMj8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1685112176;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EJFXGPU4lE1oaj4GkfLCHh5RLyDCrcv1pD0fRYYPBgM=;
        b=5fzEwpVB0yY9UNwcZXW0/hR/y1gA49NMqa3qK1V5FClS2GTUkVJ61vaaWacrtnWgrpRtF5
        kjKWTS8V8C9DNDDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C2D6E13A21;
        Fri, 26 May 2023 14:42:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id LGQzI27FcGSneQAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 26 May 2023 14:42:54 +0000
Date:   Fri, 26 May 2023 22:42:52 +0800
From:   Coly Li <colyli@suse.de>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>,
        Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH v2] Incremental: remove obsoleted calls to udisks
Message-ID: <yhcjmt2pbhcq4feq7nywa5rx26huvobq6brg4erldhmo37j37x@qj7i2hr2n7f3>
References: <20230525170843.4616-1-colyli@suse.de>
 <20230526095200.00004c9c@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230526095200.00004c9c@linux.intel.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, May 26, 2023 at 09:52:00AM +0200, Mariusz Tkaczyk wrote:
> On Fri, 26 May 2023 01:08:43 +0800
> Coly Li <colyli@suse.de> wrote:
> 
> > Utilility udisks is removed from udev upstream, calling this obsoleted
> > command in run_udisks() doesn't make any sense now.
> > 
> > This patch removes the calls chain of udisks, which includes routines
> > run_udisk(), force_remove(), and 2 locations where force_remove() are
> > called. Considering force_remove() is removed with udisks util, it is
> > fair to remove Manage_stop() inside force_remove() as well.
> > 
> > After force_remove() is not called anymore, if Manage_subdevs() returns
> > failure due to a busy array, nothing else to do. If the failure is from
> > a broken array and verbose information is wanted, a warning message will
> > be printed by pr_err().
> > 
> > Signed-off-by: Coly Li <colyli@suse.de>
> > Cc: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
> > Cc: Jes Sorensen <jes@trained-monkey.org>
> > ---
> > Changelog,
> > v2: improve based on code review comments from Mariusz.
> > v1: initial version.
> > 
> >  Incremental.c | 88 ++++++++++++++++++++++++---------------------------
> >  1 file changed, 42 insertions(+), 46 deletions(-)
> > 
> > diff --git a/Incremental.c b/Incremental.c
> > index f13ce02..d390a08 100644
> > --- a/Incremental.c
> > +++ b/Incremental.c
> > @@ -1628,56 +1628,38 @@ release:
> >  	return rv;
> >  }
> >  
> > -static void run_udisks(char *arg1, char *arg2)
> > -{
> > -	int pid = fork();
> > -	int status;
> > -	if (pid == 0) {
> > -		manage_fork_fds(1);
> > -		execl("/usr/bin/udisks", "udisks", arg1, arg2, NULL);
> > -		execl("/bin/udisks", "udisks", arg1, arg2, NULL);
> > -		exit(1);
> > -	}
> > -	while (pid > 0 && wait(&status) != pid)
> > -		;
> > -}
> > -
> > -static int force_remove(char *devnm, int fd, struct mdinfo *mdi, int verbose)
> > -{
> > -	int rv;
> > -	int devid = devnm2devid(devnm);
> > -
> > -	run_udisks("--unmount", map_dev(major(devid), minor(devid), 0));
> > -	rv = Manage_stop(devnm, fd, verbose, 1);
> > -	if (rv) {
> > -		/* At least we can try to trigger a 'remove' */
> > -		sysfs_uevent(mdi, "remove");
> > -		if (verbose)
> > -			pr_err("Fail to stop %s too.\n", devnm);
> > -	}
> > -	return rv;
> > -}
> > -
> >  static void remove_from_member_array(struct mdstat_ent *memb,
> >  				    struct mddev_dev *devlist, int verbose)
> >  {
> >  	int rv;
> >  	struct mdinfo mmdi;
> > +	char buf[32];
> 
> Another place where we hard-coding array size. We already
> addressed it (patch is waiting for internal regression), so please left it as is
> for now. Just to let everyone know.
>

Yes, I agree. It should be good to do one thing in each patch. The hard-coding
array size should be addressed in another patch series.

 
> >  	int subfd = open_dev(memb->devnm);
> >  
> > -	if (subfd >= 0) {
> > -		rv = Manage_subdevs(memb->devnm, subfd, devlist, verbose,
> > -				    0, UOPT_UNDEFINED, 0);
> > -		if (rv & 2) {
> > -			if (sysfs_init(&mmdi, -1, memb->devnm))
> > -				pr_err("unable to initialize sysfs for:
> > %s\n",
> > -				       memb->devnm);
> > -			else
> > -				force_remove(memb->devnm, subfd, &mmdi,
> > -					     verbose);
> > +	if (subfd < 0)
> > +		return;
> > +
> > +	rv = Manage_subdevs(memb->devnm, subfd, devlist, verbose,
> > +			    0, UOPT_UNDEFINED, 0);
> > +	if (rv) {
> > +		/*
> > +		 * If the array is busy or no verbose info
> > +		 * desired, nonthing else to do.
> > +		 */
> > +		if ((rv & 2) || verbose <= 0)
> > +			goto close;
> > +
> > +		/* Otherwise if failed due to a broken array, warn */
> > +		if (sysfs_init(&mmdi, -1, memb->devnm) == 0 &&
> > +		    sysfs_get_str(&mmdi, NULL, "array_state",
> > +				  buf, sizeof(buf)) > 0 &&
> > +		    strncmp(buf, "broken", 6) == 0) {
> > +			pr_err("Fail to remove %s from broken array.\n",
> > +			       memb->devnm);
> 
> The codes above and below are almost the same now, can we move them to a
> function?

There is a little difference on calling sysfs_init(), the second location
doesn’t call sysfs_init(). It is possible to use a condition variable to
handle the difference, but that will be another extra complication and
not worthy IMHO.


> >  		}
> > -		close(subfd);
> >  	}
> > +close:
> > +	close(subfd);
> >  }
> >  
> >  /*
> > @@ -1760,11 +1742,22 @@ int IncrementalRemove(char *devname, char *id_path,
> > int verbose) } else {
> >  		rv |= Manage_subdevs(ent->devnm, mdfd, &devlist,
> >  				    verbose, 0, UOPT_UNDEFINED, 0);
> > -		if (rv & 2) {
> > -		/* Failed due to EBUSY, try to stop the array.
> > -		 * Give udisks a chance to unmount it first.
> > -		 */
> > -			rv = force_remove(ent->devnm, mdfd, &mdi, verbose);
> > +		if (rv) {
> I would prefer to reverse logic to make one indentation less (if that is
> possible):
> if (rv != 0)
>     goto end;
> but it is fine anyway.

Indeed I tends to remove all the warning messages, and do nothing else more
if rv != 0 from Manage_subdevs(). How do you think of this idea? Checking the
array state indeed doesn't help too much.

> 
> > +			/*
> > +			 * If the array is busy or no verbose info
> > +			 * desired, nothing else to do.
> > +			 */
> > +			if ((rv & 2) || verbose <= 0)
> > +				goto end;
> > +
> > +			/* Otherwise if failed due to a broken array, warn */
> > +			if (sysfs_get_str(&mdi, NULL, "array_state",
> > +					  buf, sizeof(buf)) > 0 &&
> > +			    strncmp(buf, "broken", 6) == 0) {
> 
> Broken is defined in sysfs_array_states[], can we use it?
> if (map_name(sysfs_array_states, buf) == ARRAY_BROKEN)
> I know that it could looks like a little overhead but compiler should do
> the job here.

Yes, I am aware of this. But the existed coding style in this file is the hard
coded strncmp(). So if we do want to print the warning for a broken array, it
would be better to add the map_name() fixing in another patch. I mean, do one
thing in single patch.


> > +				pr_err("Fail to remove %s from broken
> > array.\n",
> > +				       ent->devnm);
> Not exactly, The broken may be raised even if disk is removed. It is a case for
> raid456 and raid1/10 with fail_last_dev=1. I would say just "%s is in broken
> state.\n" 
> Should be exclude arrays which are already broken (broken was set before we
> called mdadm -If)? I don't see printing this message everytime as a problem, but
> it is something you should consider.
>

Indeed, I still suggest to remove all the pr_err() stuffs, they cannot help too
much, and introduce extra complication.

 
> And I forgot to say it eariler, could you consider adding test/s for both IMSM and native?
> It is something that should be tested.
> Sorry, scope is growing :(

Sure, it's good idea, let's do it later.

Thank you for the code review.

-- 
Coly Li
