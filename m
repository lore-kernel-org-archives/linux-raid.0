Return-Path: <SRS0=MG8V=CC=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A432C433DF
	for <linux-raid@archiver.kernel.org>; Mon, 24 Aug 2020 17:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7F432075B
	for <linux-raid@archiver.kernel.org>; Mon, 24 Aug 2020 17:24:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=aim.com header.i=@aim.com header.b="kz9H2YHB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgHXRXT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Aug 2020 13:23:19 -0400
Received: from sonic306-21.consmr.mail.ne1.yahoo.com ([66.163.189.83]:37455
        "EHLO sonic306-21.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726874AbgHXRXQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 24 Aug 2020 13:23:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aim.com; s=a2048; t=1598289794; bh=mgQ1egAYS4+MbH5j1z5bf6ZILGc98/+XEVA47jQHb2U=; h=To:From:Subject:Date:References:From:Subject; b=kz9H2YHBUZSC+hpndfkSk3KrnjL9JgZC97kTXSBpuyduN8Pcaf54cU5BTwg8EdCTiECSj1QMiXqccPsJkVDm6L0nn0s3gTy+UibtBcRP65WMTKCSgj3CFpuJQ9rkeTjWqAaY7xkSgPHgdek5UBLWjclfxRdPg9rQVJf/yMa1Jkr6U0gaMDxT8iq4jDzT/LStr6PWR6kDJx9BxzFAowEqFetXugQmMsYJoo5TRNKN6vol7MgzyNgEVNbOM4d1in0JVCZWfKZdL1djO1bYEQsp3ZNQ9Ui1B/KHh8S6vzGvXitbrgq6j9MNd9/Igt8NLXFxb4weVA50ehX4RASc/RmpqA==
X-YMail-OSG: 7fkY12MVM1mjp0ylt.MoGNgRyNY3II6r0td4DkCrQkbmR.jyRzF6bY0aK6RsA63
 wyqn4ixX_OBhh2kx9LsqBCXy4K0TzoGrswOd_7ma37IZeUqLUU84LBMThVI85DqovajsBzfm3oo8
 m19CdcjWUwec19k6.3O3EG84z.mke.k.Uag5Qs7i4WGnQEfd4cv216mAxT78xtBHihGY_27ngImd
 MKEKrBGGKhnw.86HFka0YFScHbHttL2yLtsJOdNYMP6QsbHmFSXlZLdmhTV_CMcdjqcHaEHfSaSv
 T35a3tXHDygAV.NHtioUi.Yo2jwTCk6YDNaRp4mjVEboiN6jhWvsSxDc4tOW68T7jLLeqsmNkvul
 67h5NfJ4adk3XG5Ri3LDfaxtYIr_9ySpyaEwBBzSyK9v7x4JoqfIIfq7P5X1D02tJRydVXt_joR7
 CwOgoi3vZcyfwCzdomW_4OQnPXPrxl5Yni0S7MZq.gjVe0dEm0r9JdJX4vpYmJ6obCG_lsmNcb6L
 77jIOMUjHF6d_8sEHdeMXRfcY1q5i.fTgBI4p3pch0Mj64niwII_m0CtOjc8TZbT9TvCVGqkol1L
 6THZ_q719EvJWw9CVHPBqomsMtcfIm0z01rTovw36wJjAfhPOB9ZiDrCyI7ac3YElrZULzPPGSji
 ga02srsUdK28x9sLSbKaV9qqi4oVBDsHzo.kvr9mhkQx9uZod_fjJTXo4xJvEvxpY._5I8tEHOzD
 3RW.3BwU92JMg4WjLzO3zzFx5GvNcqgjJaTyxvsl8CbJ7ncXnCzjJumjp.xGqpuro6iuY2pYo7xg
 s00OQfwsjEe4wJg_YSJNCt3eXvZanYmEsey.Ce0rmvhxWYfdR7GOlZX8eFFKXftA68U1JWjdjjyO
 LEndkbaKe1f_4ARswujIo9lar2UL1WJYG14bnYjY_lGNDjt1rPmedT9.ZkHZCDNUGk1CjDI6MniR
 zXTKbbEib5pT24d5cBs58w5YmPsYvJgYRVk_XeskL.wy3OxuMKNSxQqLuJZo6xqfCz3JFHLomh3Q
 7tYzitTLcg7ShPPpV6VIQNdQ4sutuuWTyZdRMJ187TXVzB7Y6uiHz7MigFFtgEtZW3LA53LaUqQH
 RZ0wIeq3Nzqvpt4QMeL_pmDHv02k_cJgUuC2eTTcULq5TjY8PytrAeOQLuj6Qy2MD2M1uba0Rq0D
 agCibHBZeCT1UZTkr9DPy4_b22YudkgHibaJRS9Ye.FNby1zHs6AWOtv3evKHjh5Jz7f5IPKNYFX
 E1bULxKQoAgIKKQJpOOxBfb.o8vHhM4ksYlAmT5YdM0.nBBpYOSopUxBIHE82m3KJLQydo7PkoPP
 xoc8JKCWPL3Uv6wqx01CpCQ900tIdZyDsSxMNcj1UowvCrTnzY7l2DLTl16JbqEKGWeh0SUV071w
 y4Tf8F8XsRNWPk57vmGFRiv37dINT9VoUfIOE_uASHOIcfQEnyjwKfzUGxoPpaM5ZEeYc3c1pks0
 xdDVcXbyfyEYXY298tmRk5KU6g67kduT8OyWHaFc74m8odx7qiWg-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Mon, 24 Aug 2020 17:23:14 +0000
Received: by smtp417.mail.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID db38c973224496f154988d0560b262a9;
          Mon, 24 Aug 2020 17:23:12 +0000 (UTC)
To:     linux-raid@vger.kernel.org
From:   Brian Allen Vanderburg II <brianvanderburg2@aim.com>
Subject: Linux raid-like idea
Autocrypt: addr=brianvanderburg2@aim.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <1cf0d18c-2f63-6bca-9884-9544b0e7c54e@aim.com>
Date:   Mon, 24 Aug 2020 13:23:11 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
References: <1cf0d18c-2f63-6bca-9884-9544b0e7c54e.ref@aim.com>
X-Mailer: WebService/1.1.16455 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol Apache-HttpAsyncClient/4.1.4 (Java/11.0.7)
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I'm not a systems developer so can't even begin such an idea myself, but
I have a small idea about a RAID solution that may be beneficial, and
then again, maybe not.

It seems that RAID is sometimes advised against especially for larger
disks due to issues with rebuild times.=C2=A0 If during a rebuild, anothe=
r
disk fails, it could mean the loss of the entire array of data,
depending on how many parity disks exist.=C2=A0 Of course RAID is not in
itself an alternative to a backup of critical data, but to minimize the
chance of total data loss of an array, other solutions (UnRAID/etc)
exist.=C2=A0 One I've used a little bit is mergerfs/SnapRAID.=C2=A0 Merge=
rfs take
two complete file systems and presents it as a single file system, and
can distribute the files across, with the advantage that a lost data
drive does not lose the entire array since each disk is its own complete
filesystem.=C2=A0 Only the files on the lost disk would be missing.=C2=A0=
 SnapRAID
can then be ran periodically to create parity data to restore from if a
data disk is lost.

This got me to thinking, why can't we do something like this at the
driver level, with real-time parity protection? In SnapRAID, the parity
must be manually built via the command, and a lost disk means that disk
is down until a restore command is manually ran. In a real RAID array,
the parity would be calculated in real time, and a block from a missing
disk can still be read based on the parity information and other disks.
It's just that, since the disks are combined into one logical disk, a
completely lost data disk with no available parity essentially loses all
data in the array.

So the idea is, for a RAID system maybe something like mdadm, but to
present each data disk as its own block device.=C2=A0 /dev/sda1 may be
presented as /dev/fr0 (fr =3D fakeRAID), /dev/sdb1 as /def/fr1, and so on=
,
with /dev/sdd1 and /dev/sde1 as parity disks.=C2=A0 A read/write from
/dev/fr0 would always map to /dev/sda1 plus a small fixed-size header
for the associations. This fixed-size header would also allow, if the
drive was removed and inserted into a different system, a loopback mount
with offset to access the contents.

The scope of the idea stops there, just providing parity protection to
the data disks while presenting each data disk as its own block device.
If desired, multiple sets could be created, each with their own data and
parity disks.=C2=A0 And it should support adding new data and parity disk=
s,
removing, etc. Ideally, the data disks could be of different sizes, as
long as the parity disks were the largest.

On top of this, the user then uses the exposed block devices as they see
fit.=C2=A0 If the data disks are related, they could use something like
mergerfs on top of the mount points of the files systems in
/dev/fr0,1,2,etc. If the disks are not related then /dev/fr0,1,2,etc
could be used independently.=C2=A0 They could be partitioned and have mor=
e
than one file system on them.=C2=A0 Perhaps in theory a RAID array could =
be
built on top of them, but this defeats the purpose of each data disk
containing it's own complete file system, and would then have the issue
that a lost data disk would loose the entire data.


Just an idea I wanted to put out there to see if there were any
merit/interest in it.


Thanks,


Brian Allen Vanderburg II


