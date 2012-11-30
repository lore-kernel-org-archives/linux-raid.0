From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2 v3] wait: add wait_event_lock_irq() interface
Date: Fri, 30 Nov 2012 12:13:08 -0800
Message-ID: <20121130121308.54d66bfe.akpm@linux-foundation.org>
References: <1354272161-9173-1-git-send-email-lczerner@redhat.com>
	<20121130024842.5326d998.akpm@linux-foundation.org>
	<alpine.LFD.2.00.1211301233320.8688@dhcp-1-104.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1211301233320.8688@dhcp-1-104.brq.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, axboe@kernel.dk, jmoyer@redhat.com, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Fri, 30 Nov 2012 12:36:35 +0100 (CET)
Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com> wrote:

> On Fri, 30 Nov 2012, Andrew Morton wrote:
>=20
> > Date: Fri, 30 Nov 2012 02:48:42 -0800
> > From: Andrew Morton <akpm@linux-foundation.org>
> > To: Lukas Czerner <lczerner@redhat.com>
> > Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, axboe=
@kernel.dk,
> >     jmoyer@redhat.com, Neil Brown <neilb@suse.de>,
> >     David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu=
>,
> >     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Subject: Re: [PATCH 1/2 v3] wait: add wait_event_lock_irq() interfa=
ce
> >=20
> > On Fri, 30 Nov 2012 11:42:40 +0100 Lukas Czerner <lczerner@redhat.c=
om> wrote:
> >=20
> > > New wait_event{_interruptible}_lock_irq{_cmd} macros added. This =
commit
> > > moves the private wait_event_lock_irq() macro from MD to regular =
wait
> > > includes, introduces new macro wait_event_lock_irq_cmd() instead =
of using
> > > the old method with omitting cmd parameter which is ugly and make=
s a use
> > > of new macros in the MD. It also introduces the _interruptible_ v=
ariant.
> > >=20
> > > The use of new interface is when one have a special lock to prote=
ct data
> > > structures used in the condition, or one also needs to invoke "cm=
d"
> > > before putting it to sleep.
> > >=20
> > > All new macros are expected to be called with the lock taken. The=
 lock
> > > is released before sleep and is reacquired afterwards. We will le=
ave the
> > > macro with the lock held.
> > >=20
> > > Note to DM: IMO this should also fix theoretical race on waitqueu=
e while
> > > using simultaneously wait_event_lock_irq() and wait_event() becau=
se of
> > > lack of locking around current state setting and wait queue remov=
al.
> >=20
> > Does this fix the sparse warning which Fengguang just sent us?
>=20
> Which report from Fengguang do you have in mind ? I do not see any
> on linux-kernel today.
>=20
> /me going to see what spare reports
>=20

On Fri, 30 Nov 2012 16:30:24 +0800
kbuild test robot <fengguang.wu@intel.com> wrote:

> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next=
=2Egit akpm
> head:   cfb65dadcd079ad4547407a1584bc6b96bd48bb3
> commit: 2b29cdb6f98c86a1da4ec5335d6247392b7c6551 [35/476] wait: add w=
ait_event_lock_irq() interface
>=20
>=20
> sparse warnings:
>=20
> + drivers/block/drbd/drbd_int.h:2339:9: sparse: preprocessor token __=
wait_event_lock_irq redefined
> include/linux/wait.h:554:9: this was the original definition
> + drivers/block/drbd/drbd_int.h:2358:9: sparse: preprocessor token wa=
it_event_lock_irq redefined
> include/linux/wait.h:621:9: this was the original definition
> drivers/block/drbd/drbd_interval.h:12:63: sparse: dubious one-bit sig=
ned bitfield
> drivers/block/drbd/drbd_interval.h:13:22: sparse: dubious one-bit sig=
ned bitfield
> drivers/block/drbd/drbd_int.h:903:39: sparse: attribute 'require_cont=
ext': unknown attribute
> drivers/block/drbd/drbd_int.h:1123:69: sparse: attribute 'require_con=
text': unknown attribute
> drivers/block/drbd/drbd_int.h:1124:70: sparse: attribute 'require_con=
text': unknown attribute
> drivers/block/drbd/drbd_int.h:1125:59: sparse: attribute 'require_con=
text': unknown attribute
> drivers/block/drbd/drbd_int.h:1126:63: sparse: attribute 'require_con=
text': unknown attribute
> drivers/block/drbd/drbd_int.h:1127:60: sparse: attribute 'require_con=
text': unknown attribute
> drivers/block/drbd/drbd_int.h:1128:71: sparse: attribute 'require_con=
text': unknown attribute
> drivers/block/drbd/drbd_int.h:1129:65: sparse: attribute 'require_con=
text': unknown attribute
> drivers/block/drbd/drbd_int.h:1130:66: sparse: attribute 'require_con=
text': unknown attribute
> drivers/block/drbd/drbd_int.h:1335:74: sparse: attribute 'require_con=
text': unknown attribute
> drivers/block/drbd/drbd_int.h:1336:50: sparse: attribute 'require_con=
text': unknown attribute
> drivers/block/drbd/drbd_int.h:1338:51: sparse: attribute 'require_con=
text': unknown attribute
> drivers/block/drbd/drbd_int.h:1339:58: sparse: attribute 'require_con=
text': unknown attribute
> drivers/block/drbd/drbd_int.h:1340:54: sparse: attribute 'require_con=
text': unknown attribute
> drivers/block/drbd/drbd_int.h:1341:62: sparse: attribute 'require_con=
text': unknown attribute
> drivers/block/drbd/drbd_int.h:1435:92: sparse: attribute 'require_con=
text': unknown attribute
