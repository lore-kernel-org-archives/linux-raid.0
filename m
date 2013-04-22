From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] MD:  Do not increment resync_mismatches unless
 MD_RECOVERY_REQUESTED
Date: Tue, 23 Apr 2013 09:59:32 +1000
Message-ID: <20130423095932.5a9345b2@notabene.brown>
References: <1366402161.18514.1.camel@f16>
	<20130422103626.4cdcefae@notabene.brown>
	<2BD5F32D-4C11-4DA6-A38B-DFA030D78489@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7vjApuhSifgBuO0OBFNenrl"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2BD5F32D-4C11-4DA6-A38B-DFA030D78489@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/7vjApuhSifgBuO0OBFNenrl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Apr 2013 11:26:16 -0500 Brassow Jonathan <jbrassow@redhat.com>
wrote:

>=20
> On Apr 21, 2013, at 7:36 PM, NeilBrown wrote:
>=20
> > On Fri, 19 Apr 2013 15:09:21 -0500 Jonathan Brassow <jbrassow@redhat.co=
m>
> > wrote:
> >=20
> >> MD:  Do not increment resync_mismatches unless MD_RECOVERY_REQUESTED
> >>=20
> >> resync_mismatches is used to display the number of differences that
> >> have been found or repaired during a scrubbing operation.  It is not
> >> meant to count anything during resync or repair operations.  (How
> >> much sense does it make to find resync_mismatches populated after an
> >> initial synchronization of the array?  After cleaning-up an unclean
> >> shutdown?  After [re]integrating a device into an existing array?)
> >> The incrementing of the variable must be restricted to when the user
> >> initiates a scrubbing operation (i.e. "check" or "repair").
> >=20
> > How do you know what it is "meant" to do? :-)
>=20
> Yes, I suppose I did infer the meaning, but I don't think it's too much o=
f a stretch - especially given the commit message where 'resync_mismatches'=
 was introduced.
> commit 9d88883e68f404d5581bd391713ceef470ea53a9
> Author: NeilBrown <neilb@suse.de>
> Date:   Tue Nov 8 21:39:26 2005 -0800
>=20
>     [PATCH] md: teach raid5 the difference between 'check' and 'repair'.
>    =20
>     With this, raid5 can be asked to check parity without repairing it.  =
It also
>     keeps a count of the number of incorrect parity blocks found (mismatc=
hes) an
>     reports them through sysfs.
>    =20
>     Signed-off-by: Neil Brown <neilb@suse.de>
>     Cc: Greg KH <greg@kroah.com>
>     Signed-off-by: Andrew Morton <akpm@osdl.org>
>     Signed-off-by: Linus Torvalds <torvalds@osdl.org>
> Also, it seems that 'mismatches' is only ever talked about in reference t=
o scrubbing operations.  (Although it does say in 'man 4 md', "This  is  se=
t to zero when a scrub starts and is incremented whenever a sector is found=
 that is a mismatch.", which could imply that 'mismatches' might be non-zer=
o before a scrub operation starts.)  There is no indication anywhere that I=
 can find what it would mean to have a non-zero 'mismatches' absent a scrub=
 operation - perhaps we just assume "uninitialized".
>=20
> However, if it has come to mean something more since then or provides any=
 sort of useful information, then I can see your point.  I find the behavio=
r to be problematic.  A user creates an array and sometimes the value is no=
n-zero - that could be alarming, causing the user to think the array needs =
immediate "repair".
>=20
> Anyway, I suppose I am simply bloviating if your mind is made up.  I can =
make due with the idea below of recording the "last_sync_action".  I'm thin=
king of recording the MD_RECOVERY_* flags that would define the type of syn=
c_action - would you rather have a 'char *'?  If we kept the flags, I wonde=
r if we could also use that to define acceptable sync_action transitions...=
  We don't, for example, particularly want "resync" -> "idle" -> "check" ->=
 "idle" -> "resync" - especially if checkpoints are being made throughout.
>=20
> > While it might not be particularly useful, I see no point in hiding
> > information, and no desire to change what mismatch_cnt reports.
> >=20
> > It may well be useful to somehow report what the real meaning for
> > mismatch_cnt is.  i.e. to report what the last sync_action was.
> > Then any use-space tool that reported mismatch_cnt, could adjust accord=
ing to
> > whether the last operation was check/repair or resync/recovery/reshape.=
 etc.
> >=20
> > So if you were to provide a patch which adds "last_sync_action" or simi=
lar,
> > I'd certainly consider that.
>=20
>  brassow

"bloviating" : Talk at length, esp. in an inflated or empty way.

I learnt a new word today - thanks!

On reflection, not all RAID personalities count mismatches for resync.  RAI=
D1
doesn't (so your change to raid1.c was unnecessary).
So assuming that it means anything after a 'sync' is already invalid.

You are right that people get confused by it, but they get confused that it
is non-zero after a "repair" mostly, and we cannot "fix" that.

I think the really useful thing here is to record the cause of the
mismatch_cnt - why we even counted mismatches.  I'd probably record it as a
string but I don't think it matter much either way: whatever makes the code
simple is good.

And if we do record the action which generated mismatch_cnt, then having the
mismatch_cnt file appear empty when the action was not check or repair is
probably valid after all.

I don't think there is any extra need to enforce sync_action transitions.
If you write "idle" while a sync is needed, it will interrupt the sync then
immediately restart it again.
You could possible write "frozen" and then "check".  That might do something
odd, and possibly should  be fixed.
However the choice of next action doesn't depend on what has been done
previously, but on the current state of the array.  So there is no need to
record extra state, but there might be a need to validate some transitions,
particularly involving 'frozen'.

NeilBrown

--Sig_/7vjApuhSifgBuO0OBFNenrl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXXO5Dnsnt1WYoG5AQLQSxAAoIi7eKQgZZRbx6CvJyauR5PSFSAPN7Ba
vSn45DHpn0GXmwTGe/nWtQ7JMmd/55r22IjkoeqZ0ssTDTYnJP22MZHkeWVr8GCn
y4BRnu3cYNEDc2yzhYXHpL+eyWvDWBXQWDI3/RDC5ck1vK3Lmn39P6TXJYe/AeEc
U6eAeINlxzv+J9lTKoIq5gx9rbc6s52OVbiaEkE/KAavShggBpKoH64OMLlUX2Wx
0klNt1DLRqhl0s+BRtEa9fU7Gq98v2TtukdOcyOxnqtmmjyF5cxTY99q1EnmYlDv
xpcHa8h8X+O3Mi+2b7HGv0ePq+5AD9oroPPHLecDPu0xJ1BpaIMICJn9yNBRFNRL
RWjJaBwEo1/IRC/V/PaFnYBqirD7hFiswWnQtHcU6io4CFUETRcguWLw47Tuyxx8
kdPdkbk1fOsS0ZeTq4fMVaiBviMKJv8yUV6jd6bcPF0sEb1jL3HcXNf6r08JBME+
qjmvdlKlCEsdufzwn2hPRfI7ce4CsoRqj1IneUKp7LR6NseJafHwZeCwQGgQYN8e
u3T5Cg2feV/J4WzmOrzhIbx1Lj0QhNL5oo8wwsDROBTPPBbtNA3WpwQAit5wg4b0
pJTFUFkUZMhpewLYPSMjHNWfByPHk9OnuUqdb2YzrHisTnc1LBZsDa6fJr77kjyG
/A/0Y4BS2Pc=
=Lc/5
-----END PGP SIGNATURE-----

--Sig_/7vjApuhSifgBuO0OBFNenrl--
