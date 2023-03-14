Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99E84C6FD1F
	for <linux-raid@archiver.kernel.org>; Tue, 14 Mar 2023 16:11:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCNQL2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Mar 2023 12:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjCNQLV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Mar 2023 12:11:21 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF894A2244
        for <linux-raid@vger.kernel.org>; Tue, 14 Mar 2023 09:11:08 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A0D0221B1D;
        Tue, 14 Mar 2023 16:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1678810267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t2XIIUTeL6x5/7tp0RbkIVeSDdLTffLJ6O3gZxoAMTI=;
        b=pmi2v54AFsKfaDJNE+oAGFZq5nr3bXKvixnNRs3ny3knuX0RPh3U0DVIXxs/VGAlk076TK
        XxoUimLMSD7a+9NCaTilciN5hNh5Y0Pht160DnKZojSDwLiRG+dG+uxHIJhcZ4gXxUDva5
        N6lq+sIIQUa6GjhXt4rUZdsTxT5jHak=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 47EE913A26;
        Tue, 14 Mar 2023 16:11:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id V3CXD5ucEGRvWwAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 14 Mar 2023 16:11:07 +0000
Message-ID: <04a4cc6aac10cd24d5bc0b3485d47f6ccb752eab.camel@suse.com>
Subject: Re: [QUESTION] How to fix the race of "mdadm --add" and "mdadm
 mdadm --incremental --export"
From:   Martin Wilck <mwilck@suse.com>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Li Xiao Keng <lixiaokeng@huawei.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>, Coly Li <colyli@suse.de>,
        linux-raid@vger.kernel.org, linfeilong <linfeilong@huawei.com>,
        louhongxiang@huawei.com,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        miaoguanqin <miaoguanqin@huawei.com>
Date:   Tue, 14 Mar 2023 17:11:06 +0100
In-Reply-To: <20230314165938.00003030@linux.intel.com>
References: <252cdcda-afcd-ce76-00cf-c138136e70ab@huawei.com>
         <c00c211a3126d7a30c662117d28f3a4a9c81f7dc.camel@suse.com>
         <20230314165938.00003030@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 2023-03-14 at 16:59 +0100, Mariusz Tkaczyk wrote:
> On Tue, 14 Mar 2023 16:04:23 +0100
> Martin Wilck <mwilck@suse.com> wrote:
>=20
> > On Tue, 2023-03-14 at 22:58 +0800, Li Xiao Keng wrote:
> > > Hi,
> > > =C2=A0=C2=A0 Here we meet a question. When we add a new disk to a rai=
d, it
> > > may
> > > return
> > > -EBUSY.
> > > =C2=A0=C2=A0 The main process of --add=EF=BC=88for example md0, sdf):
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1.dev_open(sdf)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2.add_to_super
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3.write_init_super
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4.fsync(fd)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 5.close(fd)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 6.ioctl(ADD_NEW_DISK).
> > > =C2=A0=C2=A0 However, there will be some udev(change of sdf) event af=
ter
> > > step5.
> > > Then
> > > "/usr/sbin/mdadm --incremental --export $devnode --offroot
> > > $env{DEVLINKS}"
> > > will be run, and the sdf will be added to md0. After that, step6
> > > will
> > > return
> > > -EBUSY.
> > > =C2=A0=C2=A0 It is a problem to user. First time adding disk does not
> > > return
> > > success
> > > but disk is actually added. And I have no good idea to deal with
> > > it.
> > > Please
> > > give some great advice.=C2=A0=20
> >=20
> > I haven't looked at the code in detail, but off the top of my head,
> > it
> > should help to execute step 5 after step 6. The close() in step 5
> > triggers the uevent via inotify; doing it after the ioctl should
> > avoid
> > the above problem.
> Hi,
> That will result in EBUSY in everytime. mdadm will always handle
> descriptor and kernel will refuse to add the drive.

Why would it cause EBUSY? Please elaborate. My suggestion would avoid
the race described by Li Xiao Keng. I only suggested to postpone the
close(), nothing else. The fsync() would still be done before the
ioctl, so the metadata should be safely on disk when the ioctl is run.

This is a recurring pattern. Tools that manipulate block devices must
be aware that close-after-write triggers an uevent, and should make
sure that they don't close() such files prematurely.

> >=20
> > Another obvious workaround in mdadm would be to check the state of
> > the
> > array in the EBUSY case and find out that the disk had already been
> > added.
> >=20
> > But again, this was just a high-level guess.
> >=20
> > Martin
> >=20
>=20
> Hmm... I'm not a native expert but why we cannot write metadata after
> adding
> drive to array? Why kernel can't handle that?
>=20
> Ideally, we should lock device and block udev- I know that there is
> flock
> based API to do that but I'm not sure if flock() won't cause the same
> problem.

That doesn't work reliably. At least not in general. The mechanmism is
disabled for for dm devices (e.g. multipath), for example. See
https://github.com/systemd/systemd/blob/a5c0ad9a9a2964079a19a1db42f79570a35=
82bee/src/udev/udevd.c#L483


> There is also something like "udev-md-raid-creating.rules". Maybe we
> can reuse
> it?
>=20

Unless I am mistaken, these rules are exactly those that cause the
issue we are discussing. Since these rules are also part of the mdadm
package, it might be possible to set some flag under /run that would
indicate to the rules that auto-assembly should be skipped. But that
might be racy, too.

Martin

> Thanks,
> Mariusz

