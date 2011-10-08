From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Re: BUG: spinlock lockup while performing FS operations and detected
 stalls on CPUs / tasks.
Date: Sat, 8 Oct 2011 09:36:42 -0400
Message-ID: <5617831734450003872@unknownmsgid>
References: <4E8FE4E5.9040606@russia.ru>
Mime-Version: 1.0 (iPhone Mail 8J2)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E8FE4E5.9040606@russia.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?0JLQsNC70LXRgNC40Lk=?= <paramonov@russia.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "duaneg@dghda.com" <duaneg@dghda.com>, Alexander Beregalov <a.beregalov@gmail.com>
List-Id: linux-raid.ids

As soon as smart says there are ANY problem, the disk IS going bad and
will have serious problem soon enough. Especially READ DMA errors
which mean it reallocate sectors. Consumer level disk try to hide
problems as hard as they can until the disk finally fail. Try ddrescue
from disk to /dev/null to check for speed, I guess it is slow.

Envoy=C3=A9 de mon appareil mobile.

J=C3=A9r=C3=B4me Poulin
Solutions G.A.

On 2011-10-08, at 01:52, =D0=92=D0=B0=D0=BB=D0=B5=D1=80=D0=B8=D0=B9 <pa=
ramonov@russia.ru> wrote:

> So, this IDE drive has non-critical SMART errors listed at end of mes=
sage by command smartctl --all /dev/sde. It is unclear how this might a=
ffect the command dd.
