Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B1ADECAAD5
	for <linux-raid@archiver.kernel.org>; Mon, 29 Aug 2022 16:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbiH2QTd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 Aug 2022 12:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiH2QTc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 Aug 2022 12:19:32 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE5772FCF
        for <linux-raid@vger.kernel.org>; Mon, 29 Aug 2022 09:19:31 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 346401F88C;
        Mon, 29 Aug 2022 16:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661789970; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:  in-reply-to:in-reply-to;
        bh=KUZZqYDDLRrStg3IK9e1a9r9RdWC2T/s33IYP12UisE=;
        b=P8GChokKgCAM0wqNMS+wc94q4LDQWCW0CudPBWlqfTid1r/PWDQvZsMNKPdOeZ3kzhagN6
        RbBzBHymx/OCKSuyjhTUc+09FOef1LCBfM/BGWAkt1Oet1pnrQUuxCexGFbFZSEvwIx/Vp
        qbtxcIZOKUh7oUe8AYGPMfHjEc+ZILg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E3F361352A;
        Mon, 29 Aug 2022 16:19:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UPKbNhHnDGOaHAAAMHmgww
        (envelope-from <mkoutny@suse.com>); Mon, 29 Aug 2022 16:19:29 +0000
Date:   Mon, 29 Aug 2022 18:19:28 +0200
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        systemd-devel@lists.freedesktop.org
Cc:     NeilBrown <neilb@suse.de>, Coly Li <colyli@suse.de>,
        linux-raid@vger.kernel.org, Benjamin Brunner <bbrunner@suse.com>,
        Franck Bui <fbui@suse.de>,
        Jes Sorensen <jes@trained-monkey.org>, Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH] mdadm/systemd: remove KillMode=none from service file
Message-ID: <20220829161928.GA4273@blackbody.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <20220818140707.00007b43@linux.intel.com>
 <20220824145756.000048f8@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello.

On Wed, Aug 24, 2022 at 02:57:56PM +0200, Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:
> It will be great if you can really prove that the mechanism is working. Do you
> know any project which really uses this functionality?

My knee-jerk response would be open-iscsi daemon but I know that this
one in particular works without '@', so I can't answer your query.

(But generally, it would only protect against the "global" killing upon
initrd transitions, not the killing of a single unit. That's likely what
you run into first during shutdown.)

Let me cross-post (back [1]) to systemd-devel ML.

> We need to handle dirty clean transaction. On shutdown, when umount is
> requested them filesystem could flush in flight data, and them kernel is
> waiting for mdmon to acknowledge the change in metadata[2].

So, technically, you'd want to order the mdmon service wrt .mount unit.
But that's unfortunately not known when mdmon@ starts based on a udev rule.

Therefore, I suspect removal of KillMode=none would need some version
of [2] to accomodate such device-service orderings.

Michal


[1] In-Reply-To: https://lists.freedesktop.org/archives/systemd-devel/2022-August/048201.html
[1] In-Reply-To: https://lore.kernel.org/r/20220824145756.000048f8@linux.intel.com/
[2] https://github.com/Werkov/systemd/commit/bdaa49d34e78981f3535c42ec19ac0f314135c07

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCYwznDAAKCRAkDQmsBEOq
uQpPAQC1RZE+pnjLNjhFQoSDAEM0CduslMlnw3wQuUtVLLRckQD+Oc6d5/gYI8xG
y7Z37PgCsCN4Kx1igbBVI8OOeRUN7AM=
=XYF2
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
