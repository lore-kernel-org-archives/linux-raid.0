Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C8FBC4332F
	for <linux-raid@archiver.kernel.org>; Mon, 19 Dec 2022 16:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbiLSQmf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 19 Dec 2022 11:42:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbiLSQme (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 19 Dec 2022 11:42:34 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09369642B
        for <linux-raid@vger.kernel.org>; Mon, 19 Dec 2022 08:42:33 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B70DF38270;
        Mon, 19 Dec 2022 16:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1671468151; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E3nTVPOLcCuHgY8Xn629oITb+sMk2voH/i4KERjerVg=;
        b=zr9VJ0vLiWHtWXEMmC0hvr42YDVpJFZ+g3STVCPuEQLWbcCAOcodT4Y/uJd2ldPUJlSlHu
        B+sJFvMRgIMOpKhYn1VftP6fIfaFPxFhhDVoYyE6CJpwBG5PYiSyt66B2c9mO6kVGIZSP0
        AQvi1F281/I/DuR5RLLB0LHP/JNmp7g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1671468151;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E3nTVPOLcCuHgY8Xn629oITb+sMk2voH/i4KERjerVg=;
        b=zrGrOX+NVZ/om8ylRT9Rx0tc7H/DRdl0NRmryq3uFR9hKlh9Xr95I6W2f5mS2ErWixz3tu
        dVonKbmc7Ba9UIAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EB1B913498;
        Mon, 19 Dec 2022 16:42:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id MKD2LXaUoGNSdAAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 19 Dec 2022 16:42:30 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH 2/2] Update mdadm Monitor manual.
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20221219095835.686-3-blazej.kucman@intel.com>
Date:   Tue, 20 Dec 2022 00:42:18 +0800
Cc:     linux-raid <linux-raid@vger.kernel.org>, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <39C85AD4-DB59-46C5-BA5C-B5D0AB1B88C9@suse.de>
References: <20221219095835.686-1-blazej.kucman@intel.com>
 <20221219095835.686-3-blazej.kucman@intel.com>
To:     Blazej Kucman <blazej.kucman@intel.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B412=E6=9C=8819=E6=97=A5 17:58=EF=BC=8CBlazej Kucman =
<blazej.kucman@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> - describe monitor work modes,
> - clarify the turning off condition,
> - describe the mdmonitor.service as a prefered management way.
>=20
> Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
> Change-Id: Id5a1d5e60b958954f48d3e0285dfeb0c6f54a9d4

Except for the Change-Id part, the patch itself is fine to me.

Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li



> ---
> mdadm.8.in | 71 ++++++++++++++++++++++++++++++++++++++----------------
> 1 file changed, 50 insertions(+), 21 deletions(-)
>=20
> diff --git a/mdadm.8.in b/mdadm.8.in
> index 70c79d1e..64f71ed1 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -2548,13 +2548,33 @@ Usage:
> .I options... devices...
>=20
> .PP
> -This usage causes
> +Monitor option can work in two modes:
> +.IP \(bu 4
> +system wide mode, follow all md devices based on
> +.B /proc/mdstat,
> +.IP \(bu 4
> +follow only specified MD devices in command line.
> +.PP
> +
> +.B \-\-scan -
> +indicates system wide mode. Option causes the
> +.I monitor
> +to track all md devices that appear in
> +.B /proc/mdstat.
> +If it is not set, then at least one
> +.B device
> +must be specified.
> +
> +Monitor usage causes
> .I mdadm
> to periodically poll a number of md arrays and to report on any events
> noticed.
> -.I mdadm
> -will never exit once it decides that there are arrays to be checked,
> -so it should normally be run in the background.
> +
> +In both modes,
> +.I monitor
> +will work as long as there is an active array with redundancy and it =
is defined to follow (for
> +.B \-\-scan
> +every array is followed).
>=20
> As well as reporting events,
> .I mdadm
> @@ -2565,15 +2585,6 @@ or
> .B domain
> and if the destination array has a failed drive but no spares.
>=20
> -If any devices are listed on the command line,
> -.I mdadm
> -will only monitor those devices, otherwise, all arrays listed in the
> -configuration file will be monitored.  Further, if
> -.B \-\-scan
> -is given, then any other md devices that appear in
> -.B /proc/mdstat
> -will also be monitored.
> -
> The result of monitoring the arrays is the generation of events.
> These events are passed to a separate program (if specified) and may
> be mailed to a given E-mail address.
> @@ -2586,16 +2597,34 @@ device if relevant (such as a component device =
that has failed).
>=20
> If
> .B \-\-scan
> -is given, then a program or an E-mail address must be specified on =
the
> -command line or in the config file.  If neither are available, then
> +is given, then a
> +.B program
> +or an
> +.B e-mail
> +address must be specified on the
> +command line or in the config file. If neither are available, then
> .I mdadm
> will not monitor anything.
> -Without
> -.B \-\-scan,
> -.I mdadm
> -will continue monitoring as long as something was found to monitor.  =
If
> -no program or email is given, then each event is reported to
> -.BR stdout .
> +For devices given directly in command line, without
> +.B program
> +or
> +.B email
> +specified, each event is reported to
> +.BR stdout.
> +
> +Note: For systems where
> +.If mdadm monitor
> +is configured via systemd,
> +.B mdmonitor(mdmonitor.service)
> +should be configured. The service is designed to be primary solution =
for array monitoring,
> +it is configured to work in system wide mode.
> +It is automatically started and stopped according to current state =
and types of MD arrays in system.
> +The service may require additional configuration, like
> +.B e-mail
> +or
> +.B delay.
> +That should be done in
> +.B mdadm.conf.
>=20
> The different events are:
>=20
> --=20
> 2.35.3
>=20

