From: "Orlowski, Lukasz" <lukasz.orlowski@intel.com>
Subject: FW: mdadm r/w operations without TEMP_FAILURE_RETRY()
Date: Tue, 18 Oct 2011 10:28:48 +0100
Message-ID: <2AC2FDB9F3686F48962B2B65E2040CCC3D155FAB@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: "NeilBrown (neilb@suse.de)" <neilb@suse.de>
List-Id: linux-raid.ids

Hi,

I was going through mdadm code and got to realize that r/w operations a=
re invoked without TEMP_FAILURE_RETRY() macro, which protects from unex=
pected operation termination, case SIGINT is thrown. According to my kn=
owledge its POSIX best-practice to call the r/w operations within that =
macro, lest some sporadic unexpected behaviors occur.

Any particular reason for not using it?

Pozdrawiam / Regards,
=A3ukasz Or=B3owski

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku,=20
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego,=20
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
