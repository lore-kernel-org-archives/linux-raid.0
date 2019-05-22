From: Song Liu <songliubraving@fb.com>
Subject: Fix bad backport to stable v3.16+
Date: Wed, 22 May 2019 16:30:33 +0000
Message-ID: <5F8253BF-1167-4A48-A3AC-E0728E1EE6CB@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <62B578430C9F4E4F908C9E2FD76DD80D@namprd15.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, Nigel Croxon <ncroxon@redhat.com>, "linux@thorsten-knabe.de" <linux@thorsten-knabe.de>
List-Id: linux-raid.ids

Hi,=20

As reported by Thorsten Knabe <linux@thorsten-knabe.de>.=20

commit 4f4fd7c5798b ("Don't jump to compute_result state from check_result =
state") =20
was back ported to v3.16+. However, this fix was wrong. =20

Please back port the following two commits to fix this issue.=20

commit a25d8c327bb4 ("Revert "Don't jump to compute_result state from check=
_result state"")
commit b2176a1dfb51 ("md/raid: raid5 preserve the writeback action after th=
e parity check")

Thanks,
Song=
