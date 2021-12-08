Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A4CC433F5
	for <linux-raid@archiver.kernel.org>; Wed,  8 Dec 2021 21:27:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237520AbhLHVb2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Dec 2021 16:31:28 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:36680 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234766AbhLHVb1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Dec 2021 16:31:27 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 60E57212BA;
        Wed,  8 Dec 2021 21:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638998874; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r1Nn/3chndDCNPZZd7gK0CCQs8RibhkzxpJ50mKriRs=;
        b=XOwfZWBeOAuSWvl1xaAR33NqhkCyhlhIWX+qvHwL39Yya1WOIY9m8e/SIf7Deq9RnEpJy5
        zvfrauF/fJDy9qc/8o/95GQYBn1A+xQpDL40vAPmuK97BpA/wucxSwY0Se19hUa9xZ6gk7
        6knrj1UjdXi5nD3YsK4GM+G1WEThDE4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638998874;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r1Nn/3chndDCNPZZd7gK0CCQs8RibhkzxpJ50mKriRs=;
        b=YRY62lQSPs2gngH9N++1r5adyGiTvX1gHbmCpzZGGjFfW4kMc9XzlV9kkVTnMqhQDqrclB
        Mj56UKQ5wQ2d/2Bw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8697E13C45;
        Wed,  8 Dec 2021 21:27:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3zxbEVgjsWHIagAAMHmgww
        (envelope-from <neilb@suse.de>); Wed, 08 Dec 2021 21:27:52 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Franck Bui" <fbui@suse.de>
Cc:     "Benjamin Brunner" <bbrunner@suse.com>, "Coly Li" <colyli@suse.de>,
        linux-raid@vger.kernel.org,
        "mtkaczyk" <mariusz.tkaczyk@linux.intel.com>,
        "Jes Sorensen" <jsorensen@fb.com>
Subject: Re: [PATCH] mdadm/systemd: change KillMode from none to mixed in
 service files
In-reply-to: <4db89d7a-88c1-494f-359b-359e355d9b55@suse.de>
References: <20211201062245.6636-1-colyli@suse.de>,
 <20211201170843.00005f69@linux.intel.com>,
 <9ee380c8-e43b-8f58-c7d5-5bddb6f2e688@suse.de>,
 <73287b77-33aa-a9bd-7efa-5816e098f02f@suse.com>,
 <39d432ad-b451-082a-e52d-ffa32155529b@suse.de>,
 <163839547917.26075.6431438000167570600@noble.neil.brown.name>,
 <dabe438e-3eca-8ad4-553e-ba8555d126bd@suse.de>,
 <28a04276-d338-2db5-bb3d-49616e14206b@suse.com>,
 <4db89d7a-88c1-494f-359b-359e355d9b55@suse.de>
Date:   Thu, 09 Dec 2021 08:27:47 +1100
Message-id: <163899886765.32564.8176199508001680040@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 09 Dec 2021, Franck Bui wrote:
> Hi,
>=20
> On 12/7/21 1:34 PM, Benjamin Brunner wrote:
> >>>> Please correct me if I am wrong, I see the difference of the KillMode =
is,
> >>>> -- KillMode=3Dmixed stops the processes more gentally, it kill the main
> >>>> process with SIGTERM and the remaining processes with SIGKILL.
> >>>> -- KillMode=3Dcontrol-group kills all in-cgroup processes with SIGKILL,
> >>>> which I feel a bit cruel for the main process.
>=20
> I think there's a miss-understanding here.
>=20
> Regardless of whether "mixed" or "control-group" mode (or any other mode
> actually) is used, the process used to kill processes part of a service is
> always the same, only the list of the killed processes differs.
>=20
> The process is as follow:
>=20
>  1. send the signal specified by KillSignal=3D to the list of processes (if
>     any), TERM is the default
>  2. wait until either the target of process(es) exit or a timeout expires
>  3. if the timeout expires send the signal specified by FinalKillSignal=3D,
>     KILL is the default
>=20
> For "control-group", all remaining processes will receive the SIGTERM signa=
l (by
> default) and if there are still processes after a period f time, they will =
get
> the SIGKILL signal.
>=20
> For "mixed", only the main process will receive the SIGTERM signal, and if =
there
> are still processes after a period of time, all remaining processes (includ=
ing
> the main one) will receive the SIGKILL signal.
>=20
> >>> There is no point sending SIGTERM to a process which doesn't respond to
> >>> it.=C2=A0 mdmon is the only mdadm service which handles SIGTERM.=C2=A0 =
So it might
> >>> make sense to uise KillMode=3Dmixed for that.
> >>> For anything else, SIGKILL via KillMode=3Dcontrol-group is perfectly
> >>> acceptable.
>=20
> I don't know enough mdadm to suggest a mode but maybe the clarification abo=
ve
> will help you figuring this out.
>=20
> That said it sounds a bit strange that some processes don't respond to SIGT=
ERM.
> Is that done because some services need to run lately during the shutdown p=
rocess ?

When I wrote that they don't respond to SIGTERM, I meant that they don't
take any special action.  They don't ignore SIGTERM, so they will exit
when they are sent it.  i.e.  it doesn't matter whether they get SIGTERM
or SIGKILL - either way they will exit.

NeilBrown
