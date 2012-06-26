From: NeilBrown <neilb@suse.de>
Subject: Re: A disk failure during the initial resync after create, does not
 always suspend the resync to start the recovery
Date: Wed, 27 Jun 2012 08:57:18 +1000
Message-ID: <20120627085718.4d67b9b6@notabene.brown>
References: <0B3484EB4B5B284199C5204D116920FC047E8D@WAL-MBS04.global.avidww.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CEz5Y1+g24_w4NKD8MHhk7E"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0B3484EB4B5B284199C5204D116920FC047E8D@WAL-MBS04.global.avidww.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ralph Berrett <ralph.berrett@avid.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/CEz5Y1+g24_w4NKD8MHhk7E
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 26 Jun 2012 21:14:54 +0000 Ralph Berrett <ralph.berrett@avid.com>
wrote:

> A disk failure during the initial resync after create, does not always su=
spend the resync to start the recovery
> =A0
> Steps:
> 1. Create multiple Raid6 arrays (in my case 8 arrays, this is a large sto=
rage system)
> 2. Create 2 spares (with one spare in md1 and other in md5)
> 3. Set two different "spare-group" in /etc/mdamd/mdadm.conf so that md1-m=
d4 and md5-md8 each share one of the two spare.
> 4. While resync is still in progress, fail a disk in the arrays that do n=
ot have the spare (physically pulled).
> 5. The spare drive is moved from to the effected array via mdadm --monito=
r daemon that is running. But the "recovery" does not always started. Most =
of the time it waits for the "resync" to complete before starting the "reco=
very", but not always.
> =A0
> Which is the expected behavior, should it stop the resync to do the recov=
ery or not?  If not, since these are fairly large arrays, the "resync" coul=
d take a while before it even starts the "recovery" leaving the system in d=
egraded state.  From my experiments, the "resync" is not stopped more often=
 than it is stopped.
> =A0
> The only workaround I have found is to send "echo "ilde" > /sys/block/md2=
/md/sync_action" which will suspend the resync and then the recovery will s=
tart.  This is a intended as a embedded system so this is not an optimal wo=
rkaround.
> =A0
> emDebain 6.0.4
> Kernel:    2.6.32
> mdadm:   v3.1.4 - 31st August 2010
> =A0

I've never given a lot of thought to this scenario so the way that it works
is simply how the different bits fall together, not anything deliberate.

If a device failed in an array which did not currently have a spare attache=
d,
I would expect the resync to restart and when the spare gets moved over the
resync would continue and when it completes a recovery would start.

If a device failed in an array which already had a spare attached - I would
have to check the code to see what would happen but I can certainly imagine
that a recovery of that spare would start, and it may well resync the other
parity block at the same time.=20

It should  be deterministic though - I can't see much room for any random
element.

As the initial sync of RAID6 isn't really needed anyway, it is clear that it
should be interrupted and the recovery preformed instead.
However if a sync is happening after an unclean restart when a device fails,
it isn't clear to me what the preferred option is.
Allowing the sync to complete means your data will be protected from another
failure sooner.
Allowing the recovery to start immediately means that you will get all your
bandwidth to the array back sooner, and you'll be protected from double
failure sooner.

Maybe if the sync is less than half way, interrupt it. If more than half wa=
y,
abort it?

The way I would  'fix' this would be to modify mdadm to write 'idle' to
'sync_action' at an appropriate time (after moving the spare over).

NeilBrown

--Sig_/CEz5Y1+g24_w4NKD8MHhk7E
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+o+Tjnsnt1WYoG5AQIsshAAqovdKgCycwicr12XlJajTN4d6CV4aORA
ZDf0nTHX6O8BGGmr0/fQw1YfPtzY/HDbOMtjtoJWWJ+FUfQBJCXMQI5CDEZStwuV
DcBLXb74BHLtDD4YlCSpmmdECrVgg4TR5J2w7riPDhN1KqzlG9+UGdI3GiXxZJBy
Yjvx8XwC0tOKBE+1u8nK1hlQ6mNniXfvW3us3p/IdmaExQwIx87HeU60Ek7+gR+g
16aUHdHk6YqQ3iL1PflNh497Co5Lx367iXQDyfeeMLs2ifGAPnEpC84aq89K+TtF
zaINyvaAV8XkiVnX+B2WfDW3X5u0LDu0xkwp7NLa1afjVWfPRpoe1jODClDx4ViX
Z6VvlLx62lgYNkj51ctH5HVMdO/puFVFAF7WPk1PSWF9BMaRWtSSaUTueAq/V1l4
bHzYpzbf75c6QzLuqsHa4IuLYgckkoNzf+UNZ0mMu+71b9DZG3q/oka9DV1bQc7I
GnEhkihbQREKwixeOy2crHGTRtDG2dyb0MJjE0bR0Radf3nrMKJWtRzo342kVckU
KqkUw/sEH+BOgKbu/LPFPRw1KviFlxotIj9X7KCi8s/irPkEzhCz7ZrLTT2AqD3s
KZGXxZo7VX4FmKMlEfqtLxlxTaBhmBjdewxopj8rtjjxA3WjtElel/IU76TgTS8P
v+EiJP3pp4o=
=O5nP
-----END PGP SIGNATURE-----

--Sig_/CEz5Y1+g24_w4NKD8MHhk7E--
