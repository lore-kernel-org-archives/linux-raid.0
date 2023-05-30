Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34CFFC7EE23
	for <linux-raid@archiver.kernel.org>; Tue, 30 May 2023 13:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbjE3NKY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 30 May 2023 09:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbjE3NKW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 30 May 2023 09:10:22 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6EF5A1
        for <linux-raid@vger.kernel.org>; Tue, 30 May 2023 06:10:20 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7263B21AD0;
        Tue, 30 May 2023 13:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1685452219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uwbj3QcIhtq+VHzO7sPIX4soQZyQKrAOLOofWXyLW4w=;
        b=x7QctO+RQcQPu3bxuGr5CQGDQaqDV1HIx5UASvIadLjvfDCC7hZ553LgWMi1CUEz2xGJCp
        VAZO8hz6tvmfsrCB1le1YGGVe2ndM1Kwh49XdPCcBY+YBUYGArEtg/dBNZFYFfPTdcleGk
        fsRCegXVpIus3OeViy3nITHAYSpbRHo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1685452219;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uwbj3QcIhtq+VHzO7sPIX4soQZyQKrAOLOofWXyLW4w=;
        b=IbUi+eog0BULc6cTzEUnyIunyjqg97Nw0l4pGYEEU2FsKGrkB3OHyq5+U+DFX3pFHGTr/u
        0oDIpYqWZkNkbxDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6D19C13478;
        Tue, 30 May 2023 13:10:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id L1SzDrr1dWStNgAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 30 May 2023 13:10:18 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH v3] Incremental: remove obsoleted calls to udisks
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230530150515.00005980@linux.intel.com>
Date:   Tue, 30 May 2023 21:10:05 +0800
Cc:     linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>,
        Jes Sorensen <jes@trained-monkey.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FC875F52-6CAE-4BD4-BF9B-B55891330461@suse.de>
References: <20230529160754.26849-1-colyli@suse.de>
 <20230530081718.00003cb7@linux.intel.com>
 <c6jr4jmfkesjfxon7wsaxcw2qj52dvgrtjsxuuddoxhpftaly4@3vqllxix4otq>
 <20230530150515.00005980@linux.intel.com>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
X-Mailer: Apple Mail (2.3731.500.231)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2023=E5=B9=B45=E6=9C=8830=E6=97=A5 21:05=EF=BC=8CMariusz Tkaczyk =
<mariusz.tkaczyk@linux.intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Tue, 30 May 2023 18:59:46 +0800
> Coly Li <colyli@suse.de> wrote:
>=20
>> On Tue, May 30, 2023 at 08:17:18AM +0200, Mariusz Tkaczyk wrote:
>>> On Tue, 30 May 2023 00:07:54 +0800
>>> Coly Li <colyli@suse.de> wrote:
>>>=20
>>>> Utilility udisks is removed from udev upstream, calling this =
obsoleted
>>>> command in run_udisks() doesn't make any sense now.
>>>>=20
>>>> This patch removes the calls chain of udisks, which includes =
routines
>>>> run_udisk(), force_remove(), and 2 locations where force_remove() =
are
>>>> called. Considering force_remove() is removed with udisks util, it =
is
>>>> fair to remove Manage_stop() inside force_remove() as well.
>>>>=20
>>>> In the two modifications where calling force_remove() are removed,
>>>> the failure from Manage_subdevs() can be safely ignored, because,
>>>> 1) udisks doesn't exist, no need to check the return value to =
umount
>>>>   the file system by udisks and remove the component disk again.
>>>> 2) After the 'I' inremental remove, there is another 'r' hot remove
>>>>   following up. The first incremental remove is a best-try effort. =20=

>>> Hi Coly,
>>>=20
>>> I'm not sure what you meant here. I know that on "remove" event udev =
will
>>> call mdadm -If <devname>. And that is all I'm familiar with. I don't =
see
>>> another branch executed in code to handle "remove" event, no second =
attempt
>>> for clean up is made. Could you clarify? How is it executed?
>>> Perhaps, I understand it incorrectly as second action that is always
>>> executed automatically. I know that there is an action "--remove" =
which can
>>> be manually triggered. Is that what you meant?
>>>=20
>>=20
>> What I mentioned was only related to the source code.
>>=20
>> Before force_remove() is removed, it was called on 2 locations, one =
was from
>> remove_from_member_array(), another was from IncrementalRemove().
>>=20
>> But remove_from_member_array() was called from IncrementalRemove() =
too. The
>> code flow is,
>>=20
>> if (container) {
>> call remove_from_member_array()
>> } else {
>> call Manage_subdevs() with 'I' operation.
>> if (return 2)
>> call force_remove()
>> }
>>=20
>> call Manage_subdevs() with 'r' operation
>>=20
>> =46rom the above bogus code, the first call to Manage_subdevs() was =
an
>> Incremental remove, and the second call to Manage_subdevs() was a hot =
remove.
>> No matter it succeed or failed on the first call, the second call for =
hot
>> remove will always happen.
>>=20
>> Therefore, after removing force_remove(), it is unnecessary to check =
the
>> return value of the first call to IncrementalRemove(). Because always =
the
>> second call to Manage_subdevs() with 'r' operation will follow up.
>>=20
>> This was what I meant, it was only related to the code I modified.
>>=20
>=20
> Ok, now I get this. Thanks! It make sense now. And I know who made it =
this way:
> =
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=3Dcb8f5371=
352f6c16af5aab8a40861e13aa50fc2b
>=20
> This second independent Manage_subdevs call is needed for external =
metadata
> because at the end we need to remove the device from the container. It =
seems
> that I made a mistake here and doubled call for native (nobody have =
been
> noticed for years LOL). The goto end; should be independent from if =
(rv & 2).
>=20
> Feel free to clear this up. I think that else branch is not needed =
now.
> In incremental remove we should stay with 'I' disposition because in =
this mode
> kernel should not be blocked from setting broken state as it is with =
'f'
> disposition.
> =
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=3D461fae7e=
7809670d286cc19aac5bfa861c29f93a

OK, I will post another patch for the cleanup later. Now I submit this =
patch to Jes firstly.


>>=20
>> e > Therefore in this patch, where foorce_remove() is removed, the =
return
>>>> value of calling Manage_subdevs() is not checked too.
>>>>=20
>>>> Signed-off-by: Coly Li <colyli@suse.de>
>>>> Cc: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
>>>> Cc: Jes Sorensen <jes@trained-monkey.org>
>>>> ---
>>>> Changelog,
>>>> v3: remove the almost-useless warning message, and make the change
>>>>    more simplified.
>>>> v2: improve based on code review comments from Mariusz.
>>>> v1: initial version. =20
>>>=20
>>> For the code:
>>> Reviewed-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> =20
>>=20
>> Thanks.
>>=20
>> BTW, do you have any suggestion for the commit log? It seems current =
commit
>> message is not that clear, and I want to listen to your input :-)
>=20
> It is fine, I read that at the morning so it seems that my brain was =
not
> working yet. This is another example why I should not write mail =
before coffee
> :)

Thanks.

Coly Li

