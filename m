From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC]raid5: add an option to avoid copy data from bio to stripe
 cache
Date: Wed, 21 May 2014 17:01:12 +1000
Message-ID: <20140521170112.16ae2d11@notabene.brown>
References: <20140428065841.GA28726@kernel.org>
	<20140428101748.GA17026@infradead.org>
	<20140428204407.226c88e4@notabene.brown>
	<20140429020124.GA24123@kernel.org>
	<20140429170725.0b4687a8@notabene.brown>
	<20140429111358.GA10584@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/jbVPi7519VDdoZFq/BrZBv7"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140429111358.GA10584@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/jbVPi7519VDdoZFq/BrZBv7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 29 Apr 2014 19:13:58 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Tue, Apr 29, 2014 at 05:07:25PM +1000, NeilBrown wrote:
> > On Tue, 29 Apr 2014 10:01:24 +0800 Shaohua Li <shli@kernel.org> wrote:
> >=20
> > > On Mon, Apr 28, 2014 at 08:44:07PM +1000, NeilBrown wrote:
> > > > On Mon, 28 Apr 2014 03:17:48 -0700 Christoph Hellwig <hch@infradead=
.org>
> > > > wrote:
> > > >=20
> > > > > On Mon, Apr 28, 2014 at 02:58:41PM +0800, Shaohua Li wrote:
> > > > > >=20
> > > > > > The stripe cache has two goals:
> > > > > > 1. cache data, so next time if data can be found in stripe cach=
e, disk access
> > > > > > can be avoided.
> > > > >=20
> > > > > I think this is mostly a side effect.  We have a much larger and =
better
> > > > > tuned page cache to take care of this.
> > > > >=20
> > > > > > 2. stable data. data is copied from bio to stripe cache and cal=
culated parity.
> > > > > > data written to disk is from stripe cache, so if upper layer ch=
anges bio data,
> > > > > > data written to disk isn't impacted.
> > > > > >=20
> > > > > > In my environment, I can guarantee 2 will not happen.
> > > > >=20
> > > > > Why just in your environment?  Now that we got stable pages in th=
e page
> > > > > cache this should always be the case.
> > > >=20
> > > > Hmm... I hadn't realised that we were guaranteed stabled pages alwa=
ys (if
> > > > requested).  It seems that we are.
> > > >=20
> > > > >=20
> > > > > > Of course, this shouldn't be enabled by default, so I added an =
option to
> > > > > > control it.
> > > > >=20
> > > > > Unless careful benchmarking in various scenarious shows adverse e=
ffects
> > > > > this should be the default.  And if we can find adverse effects w=
e need
> > > > > to look into them.
> > > >=20
> > > > Certainly some benchmarking is needed.
> > > >=20
> > > > We should set
> > > >=20
> > > >  mddev->queue->backing_dev_info.capabilities |=3D BDI_CAP_STABLE_WR=
ITES
> > > >=20
> > > > if and only iff 'skip_copy' is set. Then test various cases just to=
 confirm
> > > > that it is generally an improvement.
> > >=20
> > > IIRC, we switched from 'force wait page writeback' to 'wait page writ=
eback if
> > > required' because of performance issues reported, so we shoudn't alwa=
ys enable
> > > BDI_CAP_STABLE_WRITES. Is it safe to set/clear BDI_CAP_STABLE_WRITES =
at
> > > runtime, if we use 'skip_copy' to control it? Ofcourse, we don't need=
 runtime
> > > changing the setting, but we need a mechanism to setup it before arra=
y runs.
> >=20
> > So for md/RAID5 the trade off is:
> >  - If we set BDI_CAP_STABLE_WRITES then processes might sometimes have =
to wait
> >    for the writeout to complete where otherwise they would not
> >  - If we don't then RAID5 *always* has to copy the page into the stripe=
 cache.
> >=20
> > It isn't at all clear to me which is best.  It is very possible that co=
pying
> > costs a lot.  But then waiting for read-modify-write cycles can be a re=
al
> > cost too....
> >=20
> > I think it is perfectly safe to change BDI_CAP_STABLE_WRITES while the =
array
> > is suspended. So
> >   mddev_suspend(mddev);
> >   change BDI_CAP_STABLE_WRITES
> >   mddev_resume(mddev);
> >=20
> > should be safe.
>=20
> sounds good.
> =20
> > >=20
> > > As of performance, the 'skip_copy' is very helpful (> 30% boost) for =
my raid5
> > > array (with 6 fast PCIe SSD) for 1M request size workload. Nothing ch=
anged for
> > > 4k randwrite workload.
> >=20
> > It would be really good to see comparison for sequential and random loa=
ds on
> > various filesytems with both rotating and SSD devices, in RAID5 and RAI=
D6,
> > with various numbers of devices.
> > :-)
> >=20
> > If you'd like to update your patch to adjust BDI_CAP_STABLE_WRITES when
> > skip_copy is changed, I'll apply it so that people can test it.
>=20
> Here it is.

I've removed this patch for now.  It causes a nasty crash when running the
07changelevels test in the mdadm test suite.

First we get

 kernel: [ 8282.822194] WARNING: CPU: 0 PID: 16377 at /home/git/md/drivers/=
md/raid5.c:1404 raid_run

which is

+		BUG_ON(sh->dev[i].page !=3D sh->dev[i].orig_page);
which I changed to WARN_ON,

then
kernel: [ 8284.116364] BUG: sleeping function called from invalid context a=
t /home/git/md/kernel/locking/rwsem.c:20
kernel: [ 8284.116369] in_atomic(): 1, irqs_disabled(): 0, pid: 16377, name=
: md0_raid5
kernel: [ 8284.116372] INFO: lockdep is turned off.
kernel: [ 8284.116379] Preemption disabled at:[<ffffffff81a63de4>] handle_s=
tripe_expansion+0x134/0x1e0
kernel: [ 8284.116380]=20
kernel: [ 8284.116385] CPU: 0 PID: 16377 Comm: md0_raid5 Tainted: G      D =
W     3.15.0-rc5+ #855
kernel: [ 8284.116388] Hardware name: HP ProLiant ML310 G3, BIOS W02 04/17/=
2006
kernel: [ 8284.116400]  ffff8800d25641d0 ffff8800b7403888 ffffffff81c62893 =
0000000000000000
kernel: [ 8284.116409]  ffff8800b74038b0 ffffffff810c4dea ffff88014091d410 =
ffff88014091d470
kernel: [ 8284.116415]  ffff8800d25641d0 ffff8800b74038d8 ffffffff81c716e5 =
ffff8800d25641d0
kernel: [ 8284.116416] Call Trace:
kernel: [ 8284.116422]  [<ffffffff81c62893>] dump_stack+0x4e/0x7a
kernel: [ 8284.116429]  [<ffffffff810c4dea>] __might_sleep+0x15a/0x250
kernel: [ 8284.116436]  [<ffffffff81c716e5>] down_read+0x25/0xa0
kernel: [ 8284.116445]  [<ffffffff810a6dcf>] exit_signals+0x1f/0x120
kernel: [ 8284.116453]  [<ffffffff81093d35>] do_exit+0xb5/0xc70
kernel: [ 8284.116462]  [<ffffffff810f7bcd>] ? kmsg_dump+0x1ad/0x220
kernel: [ 8284.116465]  [<ffffffff810f7a40>] ? kmsg_dump+0x20/0x220
kernel: [ 8284.116473]  [<ffffffff81055515>] oops_end+0x85/0xc0
kernel: [ 8284.116480]  [<ffffffff81055686>] die+0x46/0x70
kernel: [ 8284.116487]  [<ffffffff8105250a>] do_general_protection+0xca/0x1=
50
kernel: [ 8284.116494]  [<ffffffff81c739d2>] general_protection+0x22/0x30
kernel: [ 8284.116501]  [<ffffffff8166a0a9>] ? memcpy+0x29/0x110
kernel: [ 8284.116508]  [<ffffffff81638275>] ? async_memcpy+0xc5/0x160
kernel: [ 8284.116516]  [<ffffffff81a63de4>] handle_stripe_expansion+0x134/=
0x1e0
kernel: [ 8284.116522]  [<ffffffff81a6496e>] handle_stripe+0xade/0x23e0

I've haven't looked at why this might be.

And re the other patch you send, I meant to also say to please use
__test_and_clear_bit().  This version is sufficient when the variable is on=
ly
used by one thread, and it is slightly more efficient.

NeilBrown


>=20
>=20
> Subject: raid5: add an option to avoid copy data from bio to stripe cache
>=20
> The stripe cache has two goals:
> 1. cache data, so next time if data can be found in stripe cache, disk ac=
cess
> can be avoided.
> 2. stable data. data is copied from bio to stripe cache and calculated pa=
rity.
> data written to disk is from stripe cache, so if upper layer changes bio =
data,
> data written to disk isn't impacted.
>=20
> In my environment, I can guarantee 2 will not happen. And BDI_CAP_STABLE_=
WRITES
> can guarantee 2 too. For 1, it's not common too. block plug mechanism will
> dispatch a bunch of sequentail small requests together. And since I'm usi=
ng
> SSD, I'm using small chunk size. It's rare case stripe cache is really us=
eful.
>=20
> So I'd like to avoid the copy from bio to stripe cache and it's very help=
ful
> for performance. In my 1M randwrite tests, avoid the copy can increase the
> performance more than 30%.
>=20
> Of course, this shouldn't be enabled by default. It's reported enabling
> BDI_CAP_STABLE_WRITES can harm some workloads before, so I added an optio=
n to
> control it.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid5.c |  104 ++++++++++++++++++++++++++++++++++++++++++++++=
-------
>  drivers/md/raid5.h |    4 +-
>  2 files changed, 94 insertions(+), 14 deletions(-)
>=20


--Sig_/jbVPi7519VDdoZFq/BrZBv7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU3xPODnsnt1WYoG5AQKDYRAAr7WJxhD2rtkdgIX445PeH3CRN7u7LGl9
x2AUMhEh9eH0bAIBXMod4KmVtNlaiecHx5EcWS7P3YzEjj6bUR8qd/JW7mHaKoxN
h1c5UtVCpEjMv5O+BHbWcnir+dcnNecg+AZPAL9WFpGrR+CozlvUe21rn1B8HWod
lZnwSxbUE07yQowIXly/J4iszTnZZrlo54Rn5qFKuJ+6kJyRuRihjkzvX42NIYC/
lxRWXzBwkRKQxiroeLN7mXPiu7bewlqzlOLDoZVmPznrK0RibGQ9sV44GDUA2I5Y
c755dR2Y/q8TCE8dsGzajW+LTX5Ya+hs85gSfiViplxkR4Xq582d2d21qhNFyfqE
+e9AHXeh5QrqQl0Hni/xssCsOC1/SOhiSVA5PqndQ6sBcwhBNcgG+BiA26Ujy0iN
3ID8lJ9hG+SNG/0U1z6s1UKf8aSkJypuZMgXriDvBsvgtheo2+uw4L9E7OhNqxp6
w+329M7XRGiqfuk42CoWZhMUE5KYaWE3uaXi6PzRgEU7JxIi7vJ/quxLikI8Km4t
g8ziCKilTuVQTt/GiFXypdGwzy+cemFsHb87g2yAiEwwRqDJyXuKhf+M++snBSCZ
Were3O3bEfCWaM1CThAvm3u5C19AWjmbweE0oHhYjbgtcrBV5DClrbK4pUbQEr7/
dLOz6r/iv78=
=QP0k
-----END PGP SIGNATURE-----

--Sig_/jbVPi7519VDdoZFq/BrZBv7--
