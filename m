Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EACD1C433E0
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jan 2021 00:50:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB5B220758
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jan 2021 00:50:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729202AbhARAu3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 17 Jan 2021 19:50:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:45294 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729056AbhARAu3 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 17 Jan 2021 19:50:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BEC10ACAD;
        Mon, 18 Jan 2021 00:49:47 +0000 (UTC)
From:   NeilBrown <neil@brown.name>
To:     Nathan Brown <nbrown.us@gmail.com>, linux-raid@vger.kernel.org
Date:   Mon, 18 Jan 2021 11:49:43 +1100
Subject: Re: Self inflicted reshape catastrophe
In-Reply-To: <CAHikZs7DaOj4QAw0VcbidmdrP11pWE-NTcxXDJS=KW9rf0TY7Q@mail.gmail.com>
References: <CAHikZs7DaOj4QAw0VcbidmdrP11pWE-NTcxXDJS=KW9rf0TY7Q@mail.gmail.com>
Message-ID: <87eeijjcgo.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Thu, Jan 14 2021, Nathan Brown wrote:

> Scenario:
>
> I had a 4 by 10TB raid 5 array and was adding 5 more disks and
> reshaping it to a raid6. This was working just fine until I got a
> little too aggressive with perf tuning and caused `mdadm` to
> completely hang. I froze the rebuild and rebooted the server to wipe
> away my tuning mess. The raid didn't automatically assemble so I did
> `mdadm --assemble` but really screwed up and put the 5 new disks in a
> different array. Not sure why the superblock on those disks didn't
> stop `mdadm` from putting them into service but the end result was the
> superblock on those 5 new drives got wiped. That array was missing a

What does this mean "the superblock on those 5 new drives got wiped"?
How do you think that happened.
Can you please report the current super blocks (mdadm --examine) anyway
please.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJEBAEBCAAuFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAmAE2ycQHG5laWxAYnJv
d24ubmFtZQAKCRA57J7dVmKBucKjEACehWS5TdN9m1zr6Qnknh3sjl2bJSdm1NIK
BRhWbaPKl/cfQkUdWtPC2QlBaJh/7cpaKfH57bn9nnQdEtSRtQIKk6N0WyAo3b+1
szTKgzoz8LTVqsCjLkvaPAB09JlIJ2p1UcIBHvrM66dXDS4uPQ4pXVVNcEG9KkNG
6y5vy96VXqzM1yvpCxQS469WmzCmmRFyF/3ngdC/fHIC8nU/29WB4BXrHGtSywTL
iJTQnh7i1lbwCprl6FwocxLn+kvDbP/ezYMSCFk2Dd11x+Imn75mPbSbhPopUL4z
l+Rbdea9wrCc41Hg9zcjVPts7WfZy05TPBAGaSuzQCmS0xUtBlCPt5H6+vwNvUDt
Lz4ubPNysUXmVSiDHSwDgEAq/iFiGWA1JekO468CQOaCsd3gY2p59yFZGo1EBOLF
nRvEiQvnMIwCrjg6+Oz7fntx6CVeIDIi9J6wyIe1e5632VQyedqSPlKCJatpurxI
WWRuAERRnvyA40dRSXAZw4cwDtFKSz1f+6y4HEIRdjQQUU9Ylwb343iRPJhi59aw
kqUljxoItSiFSgISZEuyOrRwgMLeKYoUy9XJsqNKKghLQ1ugxiq5iSUDo8Imfdog
QDUnM51Q4U2pybrrJTB722a+f7fOqg+13La+7W88J3WK9hikIsgUT/Q4vCP2PDdW
tn3pYQI/7g==
=JDwP
-----END PGP SIGNATURE-----
--=-=-=--
