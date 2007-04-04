From: Tim Dijkstra <newsuser@famdijkstra.org>
Subject: Re: s2disk and raid
Date: Wed, 4 Apr 2007 20:53:52 +0200
Message-ID: <20070404205352.11b3d9e8@commensaal.drs.p>
References: <20070403175521.70e6c876@commensaal.drs.p>
	<17939.13752.164747.486393@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0213678793=="
Return-path: <suspend-devel-bounces@lists.sourceforge.net>
In-Reply-To: <17939.13752.164747.486393@notabene.brown>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/suspend-devel>,
	<mailto:suspend-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=suspend-devel>
List-Post: <mailto:suspend-devel@lists.sourceforge.net>
List-Help: <mailto:suspend-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/suspend-devel>,
	<mailto:suspend-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: suspend-devel-bounces@lists.sourceforge.net
Errors-To: suspend-devel-bounces@lists.sourceforge.net
To: Neil Brown <neilb@suse.de>, suspend-devel List <suspend-devel@lists.sourceforge.net>, linux-raid@vger.kernel.org, 415441@bugs.debian.org
List-Id: linux-raid.ids

--===============0213678793==
Content-Type: multipart/signed; boundary="Sig_6.SdzguDkLC/Zopnxkvg198";
	protocol="application/pgp-signature"; micalg=PGP-SHA1

--Sig_6.SdzguDkLC/Zopnxkvg198
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 4 Apr 2007 15:20:56 +1000
Neil Brown <neilb@suse.de> wrote:

> On Tuesday April 3, newsuser@famdijkstra.org wrote:
> > Hi,
> >=20
> > I've got a bugreport [0] from a user trying to use raid and uswsusp. He=
's
> > using initramfs-tools available in debian. I'll describe the problem
> > and my analysis, maybe you can comment on what you think. A warning: I =
only
> > have a casual understanding of raid, never looked at any code related t=
o it.
> >=20
> > This is a setup where root maybe on raid, but swap isn't. Swap on raid
> > will be very difficult to support, I think.
>=20
> Nah... shouldn't be a problem.... well, maybe raid5.

OK, that is nice to hear.

> >=20
> > When s2disk is started, nothing special is done to the array. It may be
> > in an unclean state (just like filesystems). Image is written to disk.
> >=20
> > After the power cycle the kernel boots, devices are discovered, among
> > which the ones holding raid. Then we try to find the device that holds
> > swap in case of resume and / in case of a normal boot.
> >=20
> > Now comes a crucial point. The script that finds the raid array, finds
> > the array in an unclean state and starts syncing.
>=20
> Uhm, so you are finding the device for the root filesystem before you
> have decided which case it will be (resume or normal boot).  Can that
> be delayed until after the decision.  It's probably not important but
> it seems neater.
> Or do you need the root device even when resuming (I guess if swap is
> in a file on the root filesystem....)

It is not that we need the root filesystem for resume. It is more how
the initramfs is currently setup. To be as general as possible, all
partitions are discoverd, of which one will contain the image.

> The trick is to use the 'start_ro' module parameter.
>   echo 1 > /sys/module/md_mod/parameters/start_ro
>=20
> Then md will start arrays assuming read-only.  No resync will be
> started, no superblock will be written.  They stay this way until the
> first write at which point they become normal read-write and any
> required resync starts.
>=20
> So you can start arrays 'readonly', and resume off a raid1 without any
> risk of the the resync starting when it shouldn't.
>=20
> It is probably best to 'echo 0 > ....' once you have committed to a
> normal boot, but it isn't really critical.

This is very good to know. I think we can work out something with the
debian-maintainer based on this.

> >=20
> > The debian-maintainer of mdadm thinks that the suspend process should
> > have left the array in a clean state, but this is IMHO impossible.
>=20
> It probably would be best if suspend left the process in a clean
> state.  It shouldn't be too hard, but it needs to be done in the
> kernel.
> However it isn't critical to all of this working well.
>=20
> I mentioned above that if swap in on raid5 it might be awkward.  This
> is because raid5 caches some data that is on disk.  If you snapshot
> the raid5 memory, then resume raid5 so it can write to disk, when you
> come back from suspend you could have old data in the cache.  It
> should be possible to fix this, but it is currently a potential
> problem that might be worth warning people against.

OK, if we can support suspend and raid and even with swap on raid0 or
raid1, I'm happy.

Thanks for the input.

grts Tim

--Sig_6.SdzguDkLC/Zopnxkvg198
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGE/RHlR+JLH/tVJsRAhXHAJ4vZCUjCH2vHVIzPDYnGYdzzL9ZYQCfWYtM
BxB0zUiy4Mx1OawNUiGZM08=
=kqw8
-----END PGP SIGNATURE-----

--Sig_6.SdzguDkLC/Zopnxkvg198--


--===============0213678793==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys-and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
--===============0213678793==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Suspend-devel mailing list
Suspend-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/suspend-devel

--===============0213678793==--
