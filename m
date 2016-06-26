From: Phil Turmel <philip@turmel.org>
Subject: Re: Recommendations needed for RAID5 recovery
Date: Sun, 26 Jun 2016 18:18:04 -0400
Message-ID: <5770549C.4060301@turmel.org>
References: <B1389BE8-B7B5-4AB4-BE12-1636D4B91BB5@seas.upenn.edu>
 <CAOS+5GGxVOWw1nEfEgpVcLY0+tHPVV3d48BzyRATjpApgvSkxg@mail.gmail.com>
 <22381.43040.31844.544728@quad.stoffel.home>
 <576E6E68.9070209@youngman.org.uk> <576EB5FD.1000309@turmel.org>
 <5770452F.8000109@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5770452F.8000109@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Peter Gebhard <pgeb@seas.upenn.edu>
Cc: Linux-RAID <linux-raid@vger.kernel.org>, Another Sillyname <anothersname@googlemail.com>, John Stoffel <john@stoffel.org>
List-Id: linux-raid.ids

On 06/26/2016 05:12 PM, Wols Lists wrote:
> On 25/06/16 17:49, Phil Turmel wrote:

>> dd is totally useless for raid recovery in all cases.  ddrescue may =
be
>> of use in this case:
>=20
> And if dd gets a copy without errors, what's the difference between t=
hat
> and a ddrescue? Surely they're identical?
>=20
> That said, it struck me you're probably better off using ddrescue,
> because ddrescue could get that copy in one. So if you can get it in
> one, it doesn't matter which you use, so you should use ddrescue beca=
use
> it saves a wasted attempt with dd. (I've just read the ddrescue man
> page. Recommended reading ... :-)

dd will only copy a device that has no UREs.  If it has no UREs, it'll
work in the raid array even if there's no redundancy.  So duplicating
that device is pointless for pure recovery purposes.

If you already know you have one or more UREs on a device and no other
redundancy to reconstruct with, you go straight to ddrescue -- you know
that dd won't work, so why bother?  And in this case we know -- the
drive was kicked out of the array.  The OP hasn't provided any further
information, so we don't know if this is the typical timeout mismatch
calamity, or if there's more serious problems, but that doesn't change
the advice.

=46inally, if you know you have UREs *and* you still have redundancy
(raid6 or raid10,n3 degraded by one, f.e.), you want to keep the drive
with the UREs in place until replaced so MD can perform reconstruction
when it hits that spot.  Again, no role for dd.

Now, when the problem isn't just an array that needs to be reassembled
but rather a true reconstruction from unknown parameters, the duplicate
devices are needed because the experiments to discover the parameters
can be destructive.  In this case we need complete copies for the
experiments, whether UREs are present or not.  ddrescue again.  (Knowin=
g
there are UREs makes it important to use the original devices during
recreation after the experiments are done.)

I don't know *any* scenario where dd is useful for raid recovery.

> Hmm...
>=20
> Would it be an idea to get 4 by 3TB drives? That way he can do the
> backup straight on to a RAID6 array, and IF he gets a successful back=
up
> then the old drives are now redundant, for backups or whatever (3TB R=
eds
> or NASs are about =C2=A3100 each...)

Many hobbyists and small business people have limited budgets.  (Been
there!)  I try to avoid recommending expensive replacements unless the
situation clearly calls for it.  I specifically omitted any suggestion
of where to perform backups since it may make sense for the OP to just
copy important stuff onto an external USB device.

It's entirely possible that the OP is researching timeout mismatch and
patching up some green drives.  It's not ideal, but such an array can
operate with the work-arounds for years if it's regularly scrubbed.  An=
d
it's cheap, which sometimes matters.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
