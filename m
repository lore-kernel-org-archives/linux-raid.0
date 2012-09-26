From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] fix: imsm: mdmon should reread component_size on wakeup
Date: Wed, 26 Sep 2012 10:59:12 +1000
Message-ID: <20120926105912.268605b7@notabene.brown>
References: <20120917083755.26592.53269.stgit@gklab-128-085.igk.intel.com>
	<20120920113057.70de3a65@notabene.brown>
	<D9FFE20C522965449E182ACE73889AEB1900CD88@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/539qN.WF5mHTtQnuSTcCCBr"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D9FFE20C522965449E182ACE73889AEB1900CD88@IRSMSX102.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Patelczyk, Maciej" <maciej.patelczyk@intel.com>
List-Id: linux-raid.ids

--Sig_/539qN.WF5mHTtQnuSTcCCBr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Sep 2012 09:08:45 +0000 "Dorau, Lukasz" <lukasz.dorau@intel.com>
wrote:

> On Thursday, September 20, 2012 3:31 AM NeilBrown <neilb@suse.de> wrote:
> > On Mon, 17 Sep 2012 10:37:55 +0200 Lukasz Dorau
> > <lukasz.dorau@intel.com> wrote:
> >=20
> > > Mdmon has not read component_size (in read_and_act()) on wakeup so
> > far.
> > > In case of size's expansion component_size has been changed but
> > > mdmon has not updated it. As a result the metadata was incorrect
> > > during the size's expansion. It has contained no information
> > > that resync was in progress (there has been no checkpoint too).
> > > The metadata has been as if resync has already been finished
> > > but it has not.
> > >
> > > Updating of component_size has been added to read_and_act().
> > > Now mdmon uses the correct value of component_size and the correct
> > > metadata (containing information about resync and checkpoint) is writ=
ten.
> >=20
> > Thanks, but I don't think I like this approach.
> >=20
> > In my mind, the 'monitor' thread should only be monitoring things that =
it has
> > to respond to quickly - before another write can complete.
> > A size change does not need to be so immediate.
> > So I would rather that mdadm updates component_size but not array_size,
> > and
> > then 'ping's the manager.   The manager thread then checks and notices =
that
> > the component size has changed, asks the monitor to update the metadata,
> > then
> > sets the array_size to match.
> >=20
> > Possibly mdadm shouldn't just 'ping' the monitor, but should send the
> > metadata update ... not sure which is best.
> >=20
> > Does that make sense to you?
> >=20
>=20
> Maybe the description of the patch was a bit misleading and I suppose=20
> that you have misunderstood me.
> mdadm changes (updates) "component_size", not mdmon. The only thing
> this patch adds is that mdmon rereads the value of "component_size" on wa=
keup
> in case it has been changed by mdadm in meantime. So far mdmon has read
> "component_size" only once on startup. It was wrong, because if "componen=
t_size"=20
> has been changed by mdadm (in case of size's expansion), mdmon was using =
wrong,=20
> old value of "component_size". This patch corrects that.
> Is it OK for you?

That is exactly what I understood you to mean.  But I don't agree with it.

It isn't the job of the monitor thread to notice geometry changes.  That is
the job of the manager thread, possibly being told by mdadm via the socket.
The manager should explicitly tell the the monitor to perform a metadata
update when the size changes.
The monitor doesn't monitor chunksize or level or any other part of th
geometry of the array, and it shouldn't monitor component_size either.

NeilBrown


--Sig_/539qN.WF5mHTtQnuSTcCCBr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGJTYDnsnt1WYoG5AQLKiw/8CEpyN+B8eTBZmLD9A47KqjjBIQiR4PZj
rlXy+RASzYvJimi05f19ce0FjdeN0/H7VLsgnX/+oJMPB0BOJDBxmpFs+MxOZd2S
7V0JWcbEtSXWxxqoYZlM6YG7PR+WtXs/PHee1JrvZ7XMkZY+0aJ10cAGeyvcEg7e
XjABxbhtNhA8JK1hZUN2Aul3aUXY+S3QBAmPyl7e5xXphd6CRTfd0embS15N3wS8
/twXNmmfmi0WDdGqxWv0HWOGmMoCdts2ArWJhbabdaDIvVW3RntI59dI8rLS2QS5
qsti+7kbhFADkO8E4RRfbAQGkfyhFnCetO44saR1DpF1s+0qcuzI4PpJJUA4WkU7
ybV44A6PfmZ0C6S6LPFHvB58qL2Ba8kyX93vLsZduP+OKOC7wqDdvSfJYnsQXZkL
RRN60MIH6Q/v74NDfBwI5Mz3xORFwrSUlDcRY3bvQ8c4mdmhWEyyd2qqOoCcpzbR
Kl+PbHgh70V0FzBlOSeqSnldZMzlIU/4KH5zJpgA3SIqq+pUE0A+7EdCf0M6whwz
QguvahgONLP9uiIdHfV/hxjJVV48Ec3s9NbmYk2FgT4jCB2W6sLlTw5uS4hlA+PX
CBemgs4k9cesrUl9YtF9d75B1cA4h1FsPY33tUL8oTEt5hXWwE+p3HJv8Ekgd5ui
nuOXzgwPj18=
=vKbF
-----END PGP SIGNATURE-----

--Sig_/539qN.WF5mHTtQnuSTcCCBr--
