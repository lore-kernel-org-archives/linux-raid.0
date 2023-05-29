Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34F88C7EE29
	for <linux-raid@archiver.kernel.org>; Mon, 29 May 2023 07:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbjE2HyB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 May 2023 03:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjE2HyA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 May 2023 03:54:00 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49868AD
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 00:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685346838; x=1716882838;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MyaPZECoVOJfaeFJBRH3zkwH9g98qJkfmW2FXsBVnJY=;
  b=ho4bAv1nWkEXHhEH0zrdw2k7guOZku8hMJW+/nUuWPN0AIhFzjhOoivN
   GziiuUcGt8xm6OobilPKEVautDnov+SRPL9DqImdcRWx6LFAhNU//Txzq
   YSB4jgauHs70xcFrndTvWbmkd3eGhJUk6DHMunZ4MNhf/c9eSmY4FcJq7
   O1n6WxFYTVYpU3bxDgmjd+r7szDcK/pzrQm9u5qE0XpTWei9Qxo1fl7Dr
   KL3/qiEUkg/lS7IF7j6xrTZ6uWjGkWt2xvX1dES6eO7DdPbLuvbse9Rky
   Ui44kQ2tAW+hsdEqpMtMhYuEJ5WZ7xC2z6cRVxgnvllw3SZTKDqSSp7aj
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="382899478"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="382899478"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 00:53:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="952641882"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="952641882"
Received: from unknown (HELO localhost) ([10.237.142.65])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 00:53:56 -0700
Date:   Mon, 29 May 2023 09:53:52 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>,
        Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH v2] Incremental: remove obsoleted calls to udisks
Message-ID: <20230529095352.00004b6c@linux.intel.com>
In-Reply-To: <yhcjmt2pbhcq4feq7nywa5rx26huvobq6brg4erldhmo37j37x@qj7i2hr2n7f3>
References: <20230525170843.4616-1-colyli@suse.de>
        <20230526095200.00004c9c@linux.intel.com>
        <yhcjmt2pbhcq4feq7nywa5rx26huvobq6brg4erldhmo37j37x@qj7i2hr2n7f3>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 26 May 2023 22:42:52 +0800
Coly Li <colyli@suse.de> wrote:

> On Fri, May 26, 2023 at 09:52:00AM +0200, Mariusz Tkaczyk wrote:
> > On Fri, 26 May 2023 01:08:43 +0800
> > Coly Li <colyli@suse.de> wrote:
> >  =20
> > > Utilility udisks is removed from udev upstream, calling this obsoleted
> > > command in run_udisks() doesn't make any sense now.
> > >=20
> > > This patch removes the calls chain of udisks, which includes routines
> > > run_udisk(), force_remove(), and 2 locations where force_remove() are
> > > called. Considering force_remove() is removed with udisks util, it is
> > > fair to remove Manage_stop() inside force_remove() as well.
> > >=20
> > > After force_remove() is not called anymore, if Manage_subdevs() retur=
ns
> > > failure due to a busy array, nothing else to do. If the failure is fr=
om
> > > a broken array and verbose information is wanted, a warning message w=
ill
> > > be printed by pr_err().
> > >=20
> > > Signed-off-by: Coly Li <colyli@suse.de>
> > > Cc: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
> > > Cc: Jes Sorensen <jes@trained-monkey.org>
> > > ---
> > > Changelog,
> > > v2: improve based on code review comments from Mariusz.
> > > v1: initial version.
> > >=20
> > >  Incremental.c | 88 ++++++++++++++++++++++++-------------------------=
--
> > >  1 file changed, 42 insertions(+), 46 deletions(-)
> > >=20
> > > diff --git a/Incremental.c b/Incremental.c
> > > index f13ce02..d390a08 100644
> > > --- a/Incremental.c
> > > +++ b/Incremental.c
> > > @@ -1628,56 +1628,38 @@ release:
> > >  	return rv;
> > >  }
> > > =20
> > > -static void run_udisks(char *arg1, char *arg2)
> > > -{
> > > -	int pid =3D fork();
> > > -	int status;
> > > -	if (pid =3D=3D 0) {
> > > -		manage_fork_fds(1);
> > > -		execl("/usr/bin/udisks", "udisks", arg1, arg2, NULL);
> > > -		execl("/bin/udisks", "udisks", arg1, arg2, NULL);
> > > -		exit(1);
> > > -	}
> > > -	while (pid > 0 && wait(&status) !=3D pid)
> > > -		;
> > > -}
> > > -
> > > -static int force_remove(char *devnm, int fd, struct mdinfo *mdi, int
> > > verbose) -{
> > > -	int rv;
> > > -	int devid =3D devnm2devid(devnm);
> > > -
> > > -	run_udisks("--unmount", map_dev(major(devid), minor(devid), 0));
> > > -	rv =3D Manage_stop(devnm, fd, verbose, 1);
> > > -	if (rv) {
> > > -		/* At least we can try to trigger a 'remove' */
> > > -		sysfs_uevent(mdi, "remove");
> > > -		if (verbose)
> > > -			pr_err("Fail to stop %s too.\n", devnm);
> > > -	}
> > > -	return rv;
> > > -}
> > > -
> > >  static void remove_from_member_array(struct mdstat_ent *memb,
> > >  				    struct mddev_dev *devlist, int
> > > verbose) {
> > >  	int rv;
> > >  	struct mdinfo mmdi;
> > > +	char buf[32]; =20
> >=20
> > Another place where we hard-coding array size. We already
> > addressed it (patch is waiting for internal regression), so please left=
 it
> > as is for now. Just to let everyone know.
> > =20
>=20
> Yes, I agree. It should be good to do one thing in each patch. The hard-c=
oding
> array size should be addressed in another patch series.
>=20
> =20
> > >  	int subfd =3D open_dev(memb->devnm);
> > > =20
> > > -	if (subfd >=3D 0) {
> > > -		rv =3D Manage_subdevs(memb->devnm, subfd, devlist, verbose,
> > > -				    0, UOPT_UNDEFINED, 0);
> > > -		if (rv & 2) {
> > > -			if (sysfs_init(&mmdi, -1, memb->devnm))
> > > -				pr_err("unable to initialize sysfs for:
> > > %s\n",
> > > -				       memb->devnm);
> > > -			else
> > > -				force_remove(memb->devnm, subfd, &mmdi,
> > > -					     verbose);
> > > +	if (subfd < 0)
> > > +		return;
> > > +
> > > +	rv =3D Manage_subdevs(memb->devnm, subfd, devlist, verbose,
> > > +			    0, UOPT_UNDEFINED, 0);
> > > +	if (rv) {
> > > +		/*
> > > +		 * If the array is busy or no verbose info
> > > +		 * desired, nonthing else to do.
> > > +		 */
> > > +		if ((rv & 2) || verbose <=3D 0)
> > > +			goto close;
> > > +
> > > +		/* Otherwise if failed due to a broken array, warn */
> > > +		if (sysfs_init(&mmdi, -1, memb->devnm) =3D=3D 0 &&
> > > +		    sysfs_get_str(&mmdi, NULL, "array_state",
> > > +				  buf, sizeof(buf)) > 0 &&
> > > +		    strncmp(buf, "broken", 6) =3D=3D 0) {
> > > +			pr_err("Fail to remove %s from broken array.\n",
> > > +			       memb->devnm); =20
> >=20
> > The codes above and below are almost the same now, can we move them to a
> > function? =20
>=20
> There is a little difference on calling sysfs_init(), the second location
> doesn=E2=80=99t call sysfs_init(). It is possible to use a condition vari=
able to
> handle the difference, but that will be another extra complication and
> not worthy IMHO.
>=20

what about initializing the sysfs earlier and passing mdi to function? That
should resolve our problem.(Probably not a case anymore after dropping the
message).
>=20
> > >  		}
> > > -		close(subfd);
> > >  	}
> > > +close:
> > > +	close(subfd);
> > >  }
> > > =20
> > >  /*
> > > @@ -1760,11 +1742,22 @@ int IncrementalRemove(char *devname, char
> > > *id_path, int verbose) } else {
> > >  		rv |=3D Manage_subdevs(ent->devnm, mdfd, &devlist,
> > >  				    verbose, 0, UOPT_UNDEFINED, 0);
> > > -		if (rv & 2) {
> > > -		/* Failed due to EBUSY, try to stop the array.
> > > -		 * Give udisks a chance to unmount it first.
> > > -		 */
> > > -			rv =3D force_remove(ent->devnm, mdfd, &mdi,
> > > verbose);
> > > +		if (rv) { =20
> > I would prefer to reverse logic to make one indentation less (if that is
> > possible):
> > if (rv !=3D 0)
> >     goto end;
> > but it is fine anyway. =20
>=20
> Indeed I tends to remove all the warning messages, and do nothing else mo=
re
> if rv !=3D 0 from Manage_subdevs(). How do you think of this idea? Checki=
ng the
> array state indeed doesn't help too much.

LGTM. Incremental remove is designed to be system utility so the warning are
less important. User should use MISC --faulty and --remove.
>=20
> >  =20
> > > +			/*
> > > +			 * If the array is busy or no verbose info
> > > +			 * desired, nothing else to do.
> > > +			 */
> > > +			if ((rv & 2) || verbose <=3D 0)
> > > +				goto end;
> > > +
> > > +			/* Otherwise if failed due to a broken array,
> > > warn */
> > > +			if (sysfs_get_str(&mdi, NULL, "array_state",
> > > +					  buf, sizeof(buf)) > 0 &&
> > > +			    strncmp(buf, "broken", 6) =3D=3D 0) { =20
> >=20
> > Broken is defined in sysfs_array_states[], can we use it?
> > if (map_name(sysfs_array_states, buf) =3D=3D ARRAY_BROKEN)
> > I know that it could looks like a little overhead but compiler should do
> > the job here. =20
>=20
> Yes, I am aware of this. But the existed coding style in this file is the=
 hard
> coded strncmp(). So if we do want to print the warning for a broken array=
, it
> would be better to add the map_name() fixing in another patch. I mean, do=
 one
> thing in single patch.

Not a case if we are going to drop the message, correct? Feel free to handle
the state comparing across code in the future.
>=20
> > > +				pr_err("Fail to remove %s from broken
> > > array.\n",
> > > +				       ent->devnm); =20
> > Not exactly, The broken may be raised even if disk is removed. It is a =
case
> > for raid456 and raid1/10 with fail_last_dev=3D1. I would say just "%s i=
s in
> > broken state.\n"=20
> > Should be exclude arrays which are already broken (broken was set befor=
e we
> > called mdadm -If)? I don't see printing this message everytime as a
> > problem, but it is something you should consider.
> > =20
>=20
> Indeed, I still suggest to remove all the pr_err() stuffs, they cannot he=
lp
> too much, and introduce extra complication.

Ack.
>=20
> =20
> > And I forgot to say it eariler, could you consider adding test/s for bo=
th
> > IMSM and native? It is something that should be tested.
> > Sorry, scope is growing :( =20
>=20
> Sure, it's good idea, let's do it later.

Ok, thanks.

Mariusz
