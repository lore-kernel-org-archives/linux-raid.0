From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 00/24] Clustered MD RAID1
Date: Wed, 11 Feb 2015 15:17:09 +1100
Message-ID: <20150211151709.510005d2@notabene.brown>
References: <20141218161456.GA29504@shrek.lan>
	<20150206133952.173f1975@notabene.brown>
	<54DA392F.1050506@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/K/HPqCi_5SiXu_4kthdN1ot"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54DA392F.1050506@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/K/HPqCi_5SiXu_4kthdN1ot
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Feb 2015 11:00:31 -0600 Goldwyn Rodrigues <rgoldwyn@suse.de> wro=
te:

> Hi Neil,
>=20
> >
> >
> > hi Goldwyn,
> >   thanks for these - and sorry for the long delay.   Lots of leave over
> >   southern summer, and the lots of email etc to deal with.
> >
> > This patch set is very close and I am tempted to just apply it and then
> > fix things up with subsequent patches.  In order to allow that, could y=
ou
> > please:
> >    - rebase against current upstream
> >    - fix the checkpatch.pl errors and warnings.
> >      The "WARNING: line over 80 characters" are often a judgement call
> >      so I'm not particularly worried about those.  Most, if not all, of
> >      the others should be followed just to have consistent layout.
>=20
> Done.

ERROR: code indent should use tabs where possible

  when you use spaces, they show up in red for me!!
Ditto for
WARNING: please, no space before tabs

WARNING: quoted string split across lines
   It really is best to fix those, even though it makes the line long.
   When grepping to find out where a message comes from, it is very annoying
   if the grep fails because the line was split.

WARNING: Missing a blank line after declarations
   Worth fixing I think.

WARNING: printk() should include KERN_ facility level
   Definitely should be fixed, maybe make it pr_warn()??

>=20
> >
> > Then I'll queue them up for 3.21, providing I don't find anything that =
would
> > hurt non-cluster usage ....
> >   On that topic: why initialise rv to -EINVAL in "metadata_update sends
> >   message...".  That looks wrong.
>=20
> Yes, this is fixed.
>=20
> >
> > I noticed that a number of times a patch will revert something that a
> > previous patch added.  It would be much nicer to fold these changes bac=
k into
> > the original patch.  Often this is just extra blank lines, but occasion=
ally
> > variable names are changed (md -> mddev).  It should be given the final=
 name
> > when introduced.  Every chunk in every patch should be directly relevan=
t to
> > that patch.
>=20
> I have cross-checked this and I did not find anything with respect to=20
> variable names. I did some cleanup with respect to the code though.
>=20
> There is one instance where I have used a variable: cluster_setup_done=20
> and then removed it. I think this is required to understand the patch=20
> and a smooth transition to subsequent patches. However, if you want me=20
> to aggressively remove that part, I should be able to do that.

No, "cluster_setup_done" makes sense. It is scaffolding that you later need
to remove.

I'm probably letting me OCD tendencies get carried away, but these some of
the things that I noticed:


 "Introduce md_cluster_info" moves 'bast' to a new location in
 dlm_lock_resource for no apparent reason.
 Also 'leave()' has a parameter which is changed from 'md' to 'mddev',
 as does 'join'.

 "Add node recovery callbacks" adds a comment to the 'nodes' field of 'stru=
ct
 mddev'.  Why not add the comment when the field is added?
 Oh, and it mis-spells "unmber".


 In "Gather on-going resync information of other nodes" you have:

 static struct md_cluster_operations cluster_ops =3D {
        .join   =3D join,
        .leave  =3D leave,
-       .slot_number =3D slot_number
+       .slot_number =3D slot_number,
+       .resync_info_update =3D resync_info_update
 };


It is really best to put a comma at the end of each entry, even the last.
Then the patch would have been:

 static struct md_cluster_operations cluster_ops =3D {
        .join   =3D join,
        .leave  =3D leave,
        .slot_number =3D slot_number,
+       .resync_info_update =3D resync_info_update,
 };

which is much nicer to read.  You finally get this right in
  "Suspend writes in RAID1 if within range" :-)

>=20
> >
> > Some other issues, that could possibly be fixed up afterwards:
> >
> >   - Is a clustername 64 bytes or 63 bytes?  I would have thought 64,
> >     but the use of strlcpy make is 63 plus a nul.  Is that really what =
is
> >     wanted?
>=20
> Yes, it is 64 bytes. I haven't fixed this as yet.
>=20
> >
> >   - Based on https://lkml.org/lkml/2012/10/23/580 it might be good to a=
dd
> >     "default n" to Kconfig, and possible add a WARN() if anyone tries t=
o use
> >     the code.
>=20
> Done. Added pr_warn while loading the module.
>=20
> >
> >   - I'm a bit concerned about the behaviour on node failure.
> >     When a node fails, two things must happen w.r.t the bits in that no=
de's
> >     bitmap.
> >     1/ The corresponding regions of the array need to be resynced.  You=
 do have
> >        code to do this.
> >     2/ Other nodes must avoid read-balancing on those regions until the
> >        resync has completed.
> >
> >     You do have code for this second bit, but it looks wrong.  It avoids
> >     read-balancing if ->area_resyncing().  That isn't sufficient.
> >     The "area_resyncing" is always (I assume) a relatively small region=
 of
> >     the array which will be completely resynced quite quickly.  It must=
 be
> >     because writes are blocked to this area.  However the region in whi=
ch
> >     we must disable re-balancing can be much larger.  It covers *all* b=
its
> >     that are set in any unsynced bitmap.  So it isn't just the area tha=
t is
> >     currently being synced, but all areas that will be synced.
>=20
> What are unsynced bitmaps? Are they bitmaps which are associated with an=
=20
> active node or dirty bitmaps with dead nodes? If it is the former, I=20
> agree this is not enough. If it is latter, all nodes maintain a linked=20
> list of all the nodes which are currently performing resync (probably=20
> because of multiple nodes died simultaneously). One node performs the=20
> recovery (aka bitmap resync) of exactly one "dead" node at a time.=20
> area_resyncing goes through all the nodes which are performing resync.

The later - bitmaps associated with a dead node.
Bitmaps associated with an active node contain transient information, and t=
he
filesystem will ensure that it never reads from somewhere that someone else
might be writing (or if it does, it will know that the data cannot be
trusted).

I looked at the code again, and discovered that I had the problem backwards.
But there is still a problem.

when any node is resyncing, your code blocks writes for the entire span of =
the
array from where-ever the resync is up to, to the end of the device.
So a write to a location near the end of the  device will hang until all
resyncs finish.  This could be a much longer time than you would like writes
to hang for.

I think that the resyncing host should only report that it is resyncing a
relatively small range of the array, maybe 100Meg.  Maybe 1G.
Then that would only block access to that small part of the array, which
should clear in just a few seconds at most.

This information on the range being synced is not enough to limit
read-balancing.
I imagined that *every* node would read the bitmap for a failed node, and
would use that information to limit read-balancing.  There are some
complexities in this though.


So the current code isn't "wrong" exactly, but it think it could cause sever
delays in some (unusual) circumstances.




>=20
> >
> >   - I think md_reload_sb() might be too simple.  It probably should che=
ck that
> >     nothing serious has changed.  The "mddev->raid_disks =3D 0" look su=
spicious.
> >     I'll have to think about this a bit more.
>=20
> Yes, I get that feeling as well. However, I am not sure how to perform=20
> an exact comparison to understand what has changed. Perhaps it needs a=20
> new flag?

Probably.  I haven't thought much about it.

>=20
> >
> > That's all I can see for now.  I'll have another look once I have it al=
l in my tree.
> >
>=20
> I have put all the changes in my git:
> https://github.com/goldwynr/linux
> The branch cluster-md is against the latest upstream. I also performed a=
=20
> small sanity test to check everything is working properly.
>=20
> Let me know if you would want me to repost the entire patchset to the=20
> mailing list.
>=20
>=20

I don't think there is any need for that.
I won't pull it in just yet - to give you a chance to resolve the last of t=
he
checkpatch problems.
Then I'll double check that there is no risk to non-cluster users and try to
get it into -next after 3.20-rc2 is out.

Thanks,
NeilBrown

--Sig_/K/HPqCi_5SiXu_4kthdN1ot
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVNrXxTnsnt1WYoG5AQJ2dw//QVcX8KAhUftY9O7kIwKjCCSIpsOhWcoA
FXR5AOOlMJpLieA94MvtrLQ6mmoujrB2bpmrrTM6L6rj7kVgyOPEEriAhe+VWWHw
m9QIpMP1nVTXsvSkdYiVxXixp/q/ZHcmXF4l6pb50OHrJZwHAj+k2fPL6XVAyTXk
L6gsawpNNifJjCzCMnH128aPbF/M/GomkjGSmeSqAKZx7H1/pz8mlG3Lt37nY5Lu
2f+BG6/CXygrLP3ptenczk7yYiWV8WdNLLUNmIhw8aonYvDBhXCJLbgXBnWvFcH1
iye6/RQBScoq041f21nh0lOnMjNmZ9dm4KoMG3JGfroV1sLMuVuCjsDIxY213ltV
LWKzyOYnY0ge1no+iZ4+780CrqylJXAx4ifKiYuhp35L6Aab4dovHnqKjWtLVzpf
4ryeDxvRodPZElApQd1wMt8Npe2NxrO0IoVy9Zrm5RObpU9Mfm+oaYeZJosJ/qgo
H55DXx6jB58pszT8+a2yH60sKXuIrM/nTvbXwpd9u618mIOAOjg0HeKqrtI5yaFu
Dabch6pYC1KMbWV9YbMt7bEz6PPN1zfTKFVC3cU8iW6uvyOIGKpA48jwXc+YWv29
yKb5Ci0ZTof8f+3OJ32tK4mywmATxKw+LfJJpQ0U5iTnUnEkzLFqVk83z7kniffs
hFR/lWOP9Fo=
=6oFh
-----END PGP SIGNATURE-----

--Sig_/K/HPqCi_5SiXu_4kthdN1ot--
