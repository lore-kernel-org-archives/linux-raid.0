Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F119C433E0
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jan 2021 22:37:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E69AB22227
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jan 2021 22:37:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731534AbhARWhl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jan 2021 17:37:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:37834 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731525AbhARWhj (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 18 Jan 2021 17:37:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 42009ADC4;
        Mon, 18 Jan 2021 22:36:57 +0000 (UTC)
From:   NeilBrown <neil@brown.name>
To:     Nathan Brown <nbrown.us@gmail.com>
Date:   Tue, 19 Jan 2021 09:36:51 +1100
Cc:     linux-raid@vger.kernel.org
Subject: Re: Self inflicted reshape catastrophe
In-Reply-To: <CAHikZs7EKe2H5OYdxd5dwZ8WCs8fdVp-5BWku0vQ5Bb-yCstCw@mail.gmail.com>
References: <CAHikZs7DaOj4QAw0VcbidmdrP11pWE-NTcxXDJS=KW9rf0TY7Q@mail.gmail.com>
 <87eeijjcgo.fsf@notabene.neil.brown.name>
 <CAHikZs7EKe2H5OYdxd5dwZ8WCs8fdVp-5BWku0vQ5Bb-yCstCw@mail.gmail.com>
Message-ID: <8735yxkh30.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Sun, Jan 17 2021, Nathan Brown wrote:

> It was this part of the original post
>
>> The raid didn't automatically assemble so I did
>> `mdadm --assemble` but really screwed up and put the 5 new disks in a
>> different array
>
> Basically, I did an `mdadm --assemble /dev/md1 <new disks for md0>`

That command wouldn't have the effect you describe (and is visible in
the --examine output - thanks).

Maybe you mean "--add" ???

> instead of `mdadm --assemble /dev/md0 <new disks for md0>`. Further
> complicated by the fact the md1 was missing a disk, so I let 1 of the
> 5 disks become a full member md1 since I didn't catch my error in time
> and enough recovery on md1 had occurred to wipe out any data transfer
> from the reshape on md0. The other 4 became hot spares. This wiped the
> super block on those 5 new disks, the super blocks no longer contain
> the correct information showing the original reshape attempt on md0.
>
> I have yet to dive into the code but it seems likely that I can
> manually reconstruct the appropriate super blocks for these 4 disks
> that still contain valid data as a result of the reshape with a worst
> case of ~1/5th data loss.

There will be fs-metadata loss as well as data loss, and that is the real
killer.

Yes the data is probably still on those "spare" devices.  Probably just
the md-metadata is lost.  The data that was on sdo1 is now lost, but
RAID6 protects you from losing one device, so that doesn't matter.

To reconstruct the correct metadata, the easiest approach is probably to
copy the superblock from the best drive in md0 and use a binary-editor
to change the 'Device Role' field to an appropriate number for each
different device.  Maybe your kernel logs will have enough info to
confirm which device was in each role.

One approach to copying the metadata is to use "mdadm --dump=/tmp/md0 /dev/md0"
which should create sparse files in /tmp/md0 with the metadata from each
device.
Then binary-edit those files, and rename them. Then use
   mdadm --restore=/tmp/md0 /dev/md0
to copy the metadata back.  Maybe.

Then use "mdadm --examine --super=1.2" to check that the superblock
looks OK and to find out what the "expected" checksum is.  Then edit the
superblock again to set the checksum.

Then try assembling the array with
   mdadm --assemble --freeze-reshape --readonly ....

which should minimize the damage that can be done if something isn't
right.
Then try "fsck -n" the filesystem to see if it looks OK.

Good luck

NeilBrown


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJEBAEBCAAuFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAmAGDYMQHG5laWxAYnJv
d24ubmFtZQAKCRA57J7dVmKBuVX0EACsZ/HeIWhOriFpDyJEyLUGg7mv0QqOeldh
Er7SXU85zD0ZOfdAyb5e7SQ6Z/WoEXZ7T1vW98zb0EFGhmZs408ZKzBG5q74xSG5
94jpNbtB2siZtfdu8Yxydn4BCtYe4p/kPA7REqhTX7so5C0TVpM5hg0tW/W8ruKh
cGXUAe0zMzo647G/etSYF1NyV0g9Lwdl7wdlZPBZHE52KXqr3JDguoZujaeGoDS3
3gzP6aMXi2ckGuloKyLPIBQ3oXDMdR1bCJguuSZuE9N1CYsREsp1oRa4rQCLtW6F
QeZWechEsjUpMDfRZdblMHf7U8U4aGwp2KYlqfY5Hc20Sn8puePBGe1zqRHQoUCv
LTnqr4dQ24m7Jzd82jQQ09FgwpPNQHIlCZ4ThFLwSNA3BWneJsHR/OUc648QUAab
FhvRA3BYLG19cSCL6ZdPZP2lxJ/OinVAztN2MQk8+lkda+cVvCCI6C9/bpoio32n
khdLEiz5bxrUFS7qh36I2tL/qKCXXIAXJJDR4TZlN7vTVQ1DYZpI4gxLdBN3do5n
oPgD9F+Tto5HKS3oX6E/Nj8HCuw3vfPutui77A4ZMj/SxdwfdaaNpn/wfjAOUZ0w
pNJIje9BMx6gth1E86NIt9uE7zMA7h7RWalLnZ09Ow0DwqLfeU6rTPBI8N1Oi4ds
TGJW7CbIgw==
=I6qH
-----END PGP SIGNATURE-----
--=-=-=--
