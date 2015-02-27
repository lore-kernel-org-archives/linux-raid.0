From: Sushma Gurram <Sushma.Gurram@sandisk.com>
Subject: raid0: "clean" state on drive failure/removal
Date: Fri, 27 Feb 2015 20:54:32 +0000
Message-ID: <B9FF37F8E2D7894A9493A5314D0816FC242755A9@SACMBXIP01.sdcorp.global.sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

A basic question on raid0 behavior.

When a drive fails/removed in a raid0 array, =93mdadm =96detail=94 repo=
rts the array
state as clean instead of failed.

It appears that the drive is whacked out of the array, but that array s=
lot
continues to show =93active sync=94 state.

I/O to the failed drive errors out. However, it appears that I/O to oth=
er drives
in the raid0 array would succeed. How would the user know about the arr=
ay state
and potential data loss? Should the array information be cached, drive
failure/removals be monitored and checked against the cached informatio=
n?

Could anyone please explain the reason for this behavior of not reporti=
ng a
raid0 array as failed?

Thanks,
Sushma

________________________________

PLEASE NOTE: The information contained in this electronic mail message =
is intended only for the use of the designated recipient(s) named above=
=2E If the reader of this message is not the intended recipient, you ar=
e hereby notified that you have received this message in error and that=
 any review, dissemination, distribution, or copying of this message is=
 strictly prohibited. If you have received this communication in error,=
 please notify the sender by telephone or e-mail (as shown above) immed=
iately and destroy any and all copies of this message in your possessio=
n (whether hard copies or electronically stored copies).

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
