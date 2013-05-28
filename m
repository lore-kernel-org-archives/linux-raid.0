From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: mdadm vs zfs for home server?
Date: Tue, 28 May 2013 10:00:50 -0500
Message-ID: <20130528150050.GA1357@septictank.raw-sewage.fake>
References: <20130527180912.GA6068@septictank.raw-sewage.fake>
 <5156525.31.1369681328163.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5156525.31.1369681328163.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, May 27, 2013 at 09:02:08PM +0200, Roy Sigurd Karlsbakk wrote:
> Short answer: ZFS will guarantee the data is free of errors, but
> MD will give you the flexibility of moving between RAID levels and
> adding drives to existing RAIDs. I have been working with ZFS with
> some 400TB of storage, and I considered using it for my home
> server, but chose MD because of the flexibility in there. ZFS
> requires you to plan your setup. It allows you to add VDEVs, but
> data isn't balanced over the VDEVs. That will required block
> pointer rewrite, something that's been talked about for at least
> four years, but yet hasn't surfaced.


In the raid-10 case, does Linux MD automatically "reblance" the
data?  I could be wrong, but my understanding is that it will let
you grow the array, but in the same way that ZFS would (for raid10
anyway): the extra space is there, but not striped across the
original disks.

If that's true, then it somewhat "evens the score" for me, as I'm
leaning towards raid-10.




> just my 2c
>=20
> roy
>=20
> ----- Opprinnelig melding -----
> > Anyone out there have a home (or maybe small office) file server
> > that where they thought about native Linux software RAID (mdadm)
> > versus ZFS on Linux?
> >=20
> > I currently have a raid6 array built from five low power (5400 rpm)
> > 3TB drives. I put an ext4 filesystem right on top of the md device
> > (no lvm). This array used to be comprised of 2TB drives; I've been
> > slowly replacing drives with 3TB versions as they went on sale.
> >=20
> > I run a weekly check on the array ("raid-check" script on CentOS,
> > which is basically a fancy wrapper for "echo check >>
> > /sys/block/mdX/md/sync_action"). I shouldn't be surprised, but I've
> > noticed that this check now takes substantially longer (than it did
> > with the 2TB drives).
> >=20
> > I got to thinking about the chances of data loss. First off: I do
> > have backups. But I want to take every "reasonable" precaution
> > against having to use the backups. Initially I started thinking
> > about zfs's raid-z3 (basically, triple-parity raid, the next logica=
l
> > step in the raid5, raid6 progression). But then I decided that,
> > based on the check speed of my current raid6, maybe I want to get
> > away from parity-based raid all together.
> >=20
> > Now I've got another 3TB drive on the way (rounding out the total t=
o
> > six) and am leaning towards RAID-10. I don't need the performance,
> > but it should be more performant than raid6. And I assume (though I
> > could be very wrong) that the weekly "check" action ought to be muc=
h
> > faster than it is with raid6. Is this correct?
> >=20
> > But after all that zfs reading, I'm wondering if that might not be
> > the way to go. I don't know how necessary it is, but I like the
> > idea of having the in-filesystem checksums to prevent "silent" data
> > corruption.
> >=20
> > I went through a zfs tutorial, building a little raid10 pool out of
> > files (just to play with). Seems pretty straightforward. But I'm
> > still much more familiar with mdadm (not an expert by any means, bu=
t
> > quite comfortable with typical uses). So, does my lack of
> > experience with zfs offset it's data integrity checks? And
> > furthermore, zfs on linux has only recently been marked stable.
> > Although there is plenty of anecdotal comments that it's been stabl=
e
> > much longer (the zfs on linux guys are just ultra-conservative).
> > Still, doesn't mdadm have the considerable edge in terms of
> > "longtime stability"?
> >=20
> > As I said initially, I'm in the thinking-it-through stage, just
> > looking to maybe get a discussion going as to why I should go one
> > way or the other.
> >=20
> > Thanks,
> > Matt
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d"
> > in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at http://vger.kernel.org/majordomo-info.html
>=20
> --=20
> Vennlige hilsener / Best regards
>=20
> roy
> --
> Roy Sigurd Karlsbakk
> (+47) 98013356
> roy@karlsbakk.net
> http://blogg.karlsbakk.net/
> GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
> --
> I all pedagogikk er det essensielt at pensum presenteres intelligibel=
t. Det er et element=E6rt imperativ for alle pedagoger =E5 unng=E5 ekse=
ssiv anvendelse av idiomer med xenotyp etymologi. I de fleste tilfeller=
 eksisterer adekvate og relevante synonymer p=E5 norsk.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
