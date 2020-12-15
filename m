Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2910C4361B
	for <linux-raid@archiver.kernel.org>; Tue, 15 Dec 2020 18:39:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 714332222F
	for <linux-raid@archiver.kernel.org>; Tue, 15 Dec 2020 18:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730739AbgLOSiy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Dec 2020 13:38:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728004AbgLOSiy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Dec 2020 13:38:54 -0500
X-Greylist: delayed 506 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Dec 2020 10:38:14 PST
Received: from mail1.84.tech (mail1.84.tech [IPv6:2001:bc8:321a:200:fa7:a55:d1e7:f00d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19BE0C06179C
        for <linux-raid@vger.kernel.org>; Tue, 15 Dec 2020 10:38:14 -0800 (PST)
Received: from localhost (localhost [IPv6:::1])
        by mail1.84.tech (Postfix) with ESMTP id 1314D50530D
        for <linux-raid@vger.kernel.org>; Tue, 15 Dec 2020 19:29:02 +0100 (CET)
Received: from mail1.84.tech ([IPv6:::1])
        by localhost (mail1.84.tech [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id 6_x1RFxDAMP9 for <linux-raid@vger.kernel.org>;
        Tue, 15 Dec 2020 19:29:01 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
        by mail1.84.tech (Postfix) with ESMTP id B599950533B
        for <linux-raid@vger.kernel.org>; Tue, 15 Dec 2020 19:29:01 +0100 (CET)
X-Virus-Scanned: amavisd-new at 84.tech
Received: from mail1.84.tech ([IPv6:::1])
        by localhost (mail1.84.tech [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id h2a9IDeSAkC6 for <linux-raid@vger.kernel.org>;
        Tue, 15 Dec 2020 19:29:01 +0100 (CET)
Received: from mail.seblu.net (mail.seblu.net [212.129.28.29])
        by mail1.84.tech (Postfix) with ESMTPS id A2FEE50530D
        for <linux-raid@vger.kernel.org>; Tue, 15 Dec 2020 19:29:01 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
        by mail.seblu.net (Postfix) with ESMTP id 7E9385383060
        for <linux-raid@vger.kernel.org>; Tue, 15 Dec 2020 19:29:01 +0100 (CET)
Received: from mail.seblu.net ([IPv6:::1])
        by localhost (mail.seblu.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id rbQchj2OPbkD for <linux-raid@vger.kernel.org>;
        Tue, 15 Dec 2020 19:29:00 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
        by mail.seblu.net (Postfix) with ESMTP id C900E5383781
        for <linux-raid@vger.kernel.org>; Tue, 15 Dec 2020 19:29:00 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.seblu.net C900E5383781
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seblu.net; s=pipa;
        t=1608056940; bh=SYJh7IVqju9uLlhH3RBOkUqaYN+YdYHKu2WVlIzXwSo=;
        h=Message-ID:From:To:Date:MIME-Version;
        b=IL/xgekuIBALSGOp8bc8noUDFOSO2fsgvwmAPzD3HRC/VPYgou87EnXTsbdial1jB
         826+4tsg20zYAxp+GFBYt6U9CbN4WtPMRbCb37GCQoQy9OgnUc1kSpl18YchS8GAtx
         rPJEuN4n8Rt+78j2AdVoHeQWFdi8sNqz0TsZrpWYH+1iB/LdyP85TfI6jax9FNeDFI
         7sl+cSld78rbmgn1vefjQwVo2Cc465YiFq56DxZwc4o877M8waUPa6HpJDrgUXH/Ya
         asXt8tA5W1oNyyfHjTy2Dn9+LlOFUOzNil3s1lwb0XygpNRWoDbJOQoCxrZ4cak7/u
         JU8XGNkQtwk6g==
X-Virus-Scanned: amavisd-new at seblu.net
Received: from mail.seblu.net ([IPv6:::1])
        by localhost (mail.seblu.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id Gcq7Vg4XW7Sb for <linux-raid@vger.kernel.org>;
        Tue, 15 Dec 2020 19:29:00 +0100 (CET)
Received: from [IPv6:2a01:e0a:1f8:6b42:be57:b00b:a2e:b19] (unknown [IPv6:2a01:e0a:1f8:6b42:be57:b00b:a2e:b19])
        by mail.seblu.net (Postfix) with ESMTPSA id B4F645383060
        for <linux-raid@vger.kernel.org>; Tue, 15 Dec 2020 19:29:00 +0100 (CET)
Message-ID: <89d2eb88e6a300631862718024e687fc3102a4e1.camel@seblu.net>
Subject: Array size dropped from 40TB to 7TB when upgrading to 5.10
From:   =?ISO-8859-1?Q?S=E9bastien?= Luttringer <seblu@seblu.net>
To:     linux-raid@vger.kernel.org
Date:   Tue, 15 Dec 2020 19:29:00 +0100
Content-Type: multipart/signed; micalg="pgp-sha384";
        protocol="application/pgp-signature"; boundary="=-3C9gkxVrNVR263DgiuQz"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


--=-3C9gkxVrNVR263DgiuQz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

After a clean reboot to the new kernel 5.10.0 my 40TB md raid5 array size
droped to 7TB.
The previous kernel was 5.9.5. Rebooting back to the 5.9.5 didn't fix the
issue.

# cat /proc/mdstat=20
Personalities : [raid6] [raid5] [raid4]=20
md0 : active raid5 sdf[9] sdd[10] sda[7] sdb[6] sdc[11] sde[8]
      6857871360 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/6]
[UUUUUU]
     =20
unused devices: <none>


journalctl -oshort-iso --no-hostname -b -6|grep md0
2020-12-04T02:30:47+0100 kernel: md/raid:md0: device sdf operational as rai=
d
disk 0
2020-12-04T02:30:47+0100 kernel: md/raid:md0: device sda operational as rai=
d
disk 5
2020-12-04T02:30:47+0100 kernel: md/raid:md0: device sdd operational as rai=
d
disk 4
2020-12-04T02:30:47+0100 kernel: md/raid:md0: device sde operational as rai=
d
disk 2
2020-12-04T02:30:47+0100 kernel: md/raid:md0: device sdc operational as rai=
d
disk 1
2020-12-04T02:30:47+0100 kernel: md/raid:md0: device sdb operational as rai=
d
disk 3
2020-12-04T02:30:47+0100 kernel: md/raid:md0: raid level 5 active with 6 ou=
t of
6 devices, algorithm 2
2020-12-04T02:30:47+0100 kernel: md0: detected capacity change from 0 to
40007809105920
2020-12-04T02:31:47+0100 kernel: EXT4-fs (md0): mounted filesystem with ord=
ered
data mode. Opts: (null)

# journalctl -oshort-iso --no-hostname -b -5|grep md0
2020-12-15T03:53:00+0100 kernel: md/raid:md0: device sdf operational as rai=
d
disk 0
2020-12-15T03:53:00+0100 kernel: md/raid:md0: device sda operational as rai=
d
disk 5
2020-12-15T03:53:00+0100 kernel: md/raid:md0: device sde operational as rai=
d
disk 2
2020-12-15T03:53:00+0100 kernel: md/raid:md0: device sdd operational as rai=
d
disk 4
2020-12-15T03:53:00+0100 kernel: md/raid:md0: device sdc operational as rai=
d
disk 1
2020-12-15T03:53:00+0100 kernel: md/raid:md0: device sdb operational as rai=
d
disk 3
2020-12-15T03:53:00+0100 kernel: md/raid:md0: raid level 5 active with 6 ou=
t of
6 devices, algorithm 2
2020-12-15T03:53:00+0100 kernel: md0: detected capacity change from 0 to
7022460272640
2020-12-15T03:54:20+0100 systemd-fsck[1009]: fsck.ext4: Invalid argument wh=
ile
trying to open /dev/md0

There is no log of hardware errors or unclean unmounting.

# mdadm -D /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Mon Jan 24 02:53:21 2011
        Raid Level : raid5
        Array Size : 6857871360 (6540.18 GiB 7022.46 GB)
     Used Dev Size : 1371574272 (1308.04 GiB 1404.49 GB)
      Raid Devices : 6
     Total Devices : 6
       Persistence : Superblock is persistent

       Update Time : Tue Dec 15 17:53:13 2020
             State : clean=20
    Active Devices : 6
   Working Devices : 6
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : resync

              Name : white:0  (local to host white)
              UUID : affd87df:da503e3b:52a8b97f:77b80c0c
            Events : 1791763

    Number   Major   Minor   RaidDevice State
       9       8       80        0      active sync   /dev/sdf
      11       8       32        1      active sync   /dev/sdc
       8       8       64        2      active sync   /dev/sde
       6       8       16        3      active sync   /dev/sdb
      10       8       48        4      active sync   /dev/sdd
       7       8        0        5      active sync   /dev/sda

The mdadm userspace as not been updated.
# mdadm -V
mdadm - v4.1 - 2018-10-01

An `mdadm --action check /dev/md0` was run without errors.

1) What's the best option to restore the size without loosing the data?
2) Is this issue can be related to the kernel upgrade or it's fortuitous?

Regards,

S=C3=A9bastien "Seblu" Luttringer

--=-3C9gkxVrNVR263DgiuQz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iHUEABYJAB0WIQSTtRpKFHmOS6hn0ULluymEcK1OQQUCX9kAbAAKCRDluymEcK1O
QYszAQCPvBrZpkQycHURigLuytjgxgTePePuTdgWbKK7ZsPKDQEA/DvVFNIap3iG
zXWp/htBTQmlXBSdvZrAurcschvKGAE=
=YzHH
-----END PGP SIGNATURE-----

--=-3C9gkxVrNVR263DgiuQz--

