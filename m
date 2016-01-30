From: Phil Turmel <philip@turmel.org>
Subject: Re: Reshape stuck immediately, backup file all nulls
Date: Sat, 30 Jan 2016 12:09:55 -0500
Message-ID: <56ACEE63.6070108@turmel.org>
References: <CABRqA0i7bAB3Xca1a29u2JYOF2UaE_w1sY73se3menp+ExWWKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABRqA0i7bAB3Xca1a29u2JYOF2UaE_w1sY73se3menp+ExWWKA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Bj=c3=b6rn_Augustsson?= <oggust@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Bj=C3=B6rn,

On 01/30/2016 07:21 AM, Bj=C3=B6rn Augustsson wrote:

> The question is, what kind of state am in now?=20

The kernel is waiting for mdmon (mdadm as a background task) to step
through the stripes.  mdmon died and the kernel will wait forever.

> And how should I recover?
> Will just adding a policy to allow access to that file, and then
> mdadm --grow --continue /dev/md127
> fix it?=20

Probably.  Others have fixed this by disabling selinux for the reshape.
 Don't forget to specify --backup-file again on the command line.  (I
don't use selinux myself, so I can't be more specific.)

In the future, consider not using a backup file at all -- mdadm
generally leaves enough dead space on devices to avoid the need.

> Is the broken backup file going to be a problem?

Shouldn't be. Report back if it is.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
