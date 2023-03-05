Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FC97C6FA8E
	for <linux-raid@archiver.kernel.org>; Sun,  5 Mar 2023 22:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjCEWLB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 5 Mar 2023 17:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjCEWLA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 5 Mar 2023 17:11:00 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D2F15CBA
        for <linux-raid@vger.kernel.org>; Sun,  5 Mar 2023 14:10:58 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A23E322660;
        Sun,  5 Mar 2023 22:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678054257; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L+mzJK4M0h6G1Nyk2eoY3DZjZjOVxvb89az4FZl+Xqs=;
        b=BCTXrz1ndLt5wPySXrZZwAj0gV/dhNZdezaJFQQ68mJ9e9fQL1DuTdUlrU2+4+GLoqxVAP
        LZwn8NqFk4wWHzoJCb6GWNE/j8V++dTUxSU9uTl8mrIXRqhq9LIfWV/X7se2qOjitTj7B6
        9mx7OicCHbgF/gcd+IfG20Owe72wfNw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678054257;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L+mzJK4M0h6G1Nyk2eoY3DZjZjOVxvb89az4FZl+Xqs=;
        b=ZGzFYhdqQ972ZfXCmk06V7vHOaniCuc5DWjMdXIflu8vFN2Um6wEOTfYtXKamWK0GsNR3t
        j8l+kKWbrbZJgDAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CECBB1339E;
        Sun,  5 Mar 2023 22:10:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3V+mIG8TBWRTEgAAMHmgww
        (envelope-from <neilb@suse.de>); Sun, 05 Mar 2023 22:10:55 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Mariusz Tkaczyk" <mariusz.tkaczyk@linux.intel.com>
Cc:     "Jes Sorensen" <jes@trained-monkey.org>,
        linux-raid@vger.kernel.org, "Martin Wilck" <martin.wilck@suse.com>,
        "Mariusz Tkaczyk" <mariusz.tkaczyk@intel.com>
Subject: Re: [PATCH 6/6] mdmon improvements for switchroot
In-reply-to: <20230301145007.00001f62@linux.intel.com>
References: <167745586347.16565.4353184078424535907.stgit@noble.brown>,
 <167745678753.16565.5052083348539533042.stgit@noble.brown>,
 <20230301145007.00001f62@linux.intel.com>
Date:   Mon, 06 Mar 2023 09:10:52 +1100
Message-id: <167805425265.8008.9491232789224466676@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 02 Mar 2023, Mariusz Tkaczyk wrote:
> Hi Neil,
> We found typo. We fixed that to test the change.
> Other comments are less important.
>=20
> On Mon, 27 Feb 2023 11:13:07 +1100
> NeilBrown <neilb@suse.de> wrote:
>=20
> > We need a new mdmon@mdfoo instance to run in the root filesystem after
> > switch root, as /sys and /dev are removed from the initrd.
> >=20
> > systemd will not start a new unit with the same name running while the
> > old unit is still active, and we want the two mdmon processes to overlap
> > in time to avoid any risk of deadlock which a write is attempted with no
> > mdmon running.
> >=20
> > So we need a different unit name in the initrd than in the root.  Apart
> > from the name, everything else should be the same.
> >=20
> > This is easily achieved using a different instance name as the
> > mdmon@.service unit file already supports multiple instances (for
> > different arrays).
> >=20
> > So start "mdmon@mdfoo.service" from root, but
> > "mdmon@initrd-mdfoo.service" from the initrd.  udev can tell which
> > circumstance is the case by looking for /etc/initrd-release.
> > continue_from_systemd() is enhanced so that the "initrd-" prefix can be
> > requested.
> >=20
> > Teach mdmon that a container name like "initrd/foo" should be treated
> > just like "foo".  Note that systemd passes the instance name
> > "initrd-foo" as "initrd/foo".
> >=20
> > We don't need a similar machanism at shutdown because dracut runs
> > "mdmon --takeover --all" when appropriate.
> >=20
> > Signed-off-by: NeilBrown <neilb@suse.de>
>=20
> > diff --git a/mdmon.c b/mdmon.c
> > index 6d37b17c3f53..25abdd71fb1e 100644
> > --- a/mdmon.c
> > +++ b/mdmon.c
> > @@ -368,7 +368,11 @@ int main(int argc, char *argv[])
> >  	}
> > =20
> >  	if (!all && argv[optind]) {
> > -		container_name =3D get_md_name(argv[optind]);
> > +		static const char prefix[] =3D "initrd/";
> > +		container_name =3D argv[optind];
> > +		if (strncmp(container_name, prefix, sizeof(prefix)-1) =3D=3D 0)
> > +			container_name +=3D sizeof(prefix)-1;
> > +		container_name =3D get_md_name(container_name);
>=20
> "sizeof(prefix)-1" there should be spaces before and after operator.
>=20
> You are defining similar literals in 2 places:
> prefix[] =3D "initrd/"
> *prefix =3D in_initrd() ? "initrd-", "";
>=20
> When I see something like this, I need to ask why it is not globally defined
> because in the future we would need to define it for the firth and fourth t=
ime.
> I see the difference in last sign ('/' and '-'). We can omit that.
> I would like propose something like:
>=20
> in mdadm.h:
> #DEFINE MDMON_PREFIX "initrd"

To my mind this is "premature optimisation".  I think it makes the core
harder to read.  If it makes the code easier to maintain then it might
be worth the cost.  I don't think it does.
>=20
> in mdmon, do not check last sign. whatever it is, we don't really care, just
> skip it. All we need to know is that it not belongs to container name.
> Hope it works correctly:
> 	if (strncmp(container_name, MDMON_PREFIX, sizeof(prefix) - 1) =3D=3D 0)
> 		container_name +=3D sizeof(MDMON_PREFIX);
> =09
> And later in start_mdmon include '-' in snprintf:
> 		 "%s@%s%s.service", service_name, MDMON_PREFIX"-" ?: "",
>=20
> I think that we don't need to pass whole char* value, we can use bool, the =
one
> possibility is "initrd" now. If that would be changed, we can use enum and =
maps
> interface:
> https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/maps.c

Passing bools makes the calling code hard to read.  "What does that
"true" or "false" mean??".  Sometimes it really is best, but I think
passing the string "initrd" makes more sense to the reader than passing "true=
".

Passing enums is better than simple bools - and has the benefit of
spelling out the meaning of NULL.  These still feel a bit clumsy to me
so I would only use them when there is a clear benefit.

>=20
> This is lesson learned by code study, we needed to put big effort to correct
> similar case with reshapes because pointers become overkill through
> years:
> https://lore.kernel.org/linux-raid/20230102083524.28893-1-mateusz.kusiak@in=
tel.com/
>=20
> It my my personal view so you are free to make decision. I will accept it b=
ut
> please note that mdadm is full of same literals (just find /dev/md or /dev/=
md/)
> so that is why I'm especially sensitive in that cases.
>=20
> > --git a/util.c b/util.c index 6b44662db7cd..1d433d1826b5 100644 --- a/uti=
l.c
> > +++ b/util.c @@ -1906,6 +1906,7 @@ int start_mdmon(char *devnm)
> >  	int len;
> >  	pid_t pid;
> >  	int status;
> > +	char *prefix =3D in_initrd() ? "initrd-", "";
>=20
> The most important thing:
> typo, should be in_initrd() ? "initrd-": "";

Certainly - thanks for catching that!

Jes - should I resent the whole series, or just this patch, or will you
edit before applying?

Thanks,
NeilBrown

>=20
> >  	char pathbuf[1024];
> >  	char *paths[4] =3D {
> >  		pathbuf,
> > @@ -1916,7 +1917,7 @@ int start_mdmon(char *devnm)
> > =20
> >  	if (check_env("MDADM_NO_MDMON"))
> >  		return 0;
> > -	if (continue_via_systemd(devnm, MDMON_SERVICE))
> > +	if (continue_via_systemd(devnm, MDMON_SERVICE, prefix))
> >  		return 0;
> > =20
> >  	/* That failed, try running mdmon directly */
> > @@ -2187,7 +2188,7 @@ void manage_fork_fds(int close_all)
> >   *	1- if systemd service has been started
> >   *	0- otherwise
> >   */
> > -int continue_via_systemd(char *devnm, char *service_name)
> > +int continue_via_systemd(char *devnm, char *service_name, char *prefix)
> >  {
> >  	int pid, status;
> >  	char pathbuf[1024];
> > @@ -2199,7 +2200,7 @@ int continue_via_systemd(char *devnm, char
> > *service_name) case  0:
> >  		manage_fork_fds(1);
> >  		snprintf(pathbuf, sizeof(pathbuf),
> > -			 "%s@%s.service", service_name, devnm);
> > +			 "%s@%s%s.service", service_name, prefix ?: "",
> > devnm); status =3D execl("/usr/bin/systemctl", "systemctl", "restart",
> >  			       pathbuf, NULL);
> >  		status =3D execl("/bin/systemctl", "systemctl", "restart",
> >=20
> >=20
>=20
> Thanks,
> Mariusz
>=20

