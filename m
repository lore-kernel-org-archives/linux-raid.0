From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: strange partition table and slow speeds
Date: Mon, 17 Dec 2012 21:47:13 +0100 (CET)
Message-ID: <28361073.8.1355777233170.JavaMail.root@zimbra>
References: <CA+Z7oPgx6DgEbpJ6OEoMFTDbUPhq_b4UXp8SW-dPiVNYw17bjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+Z7oPgx6DgEbpJ6OEoMFTDbUPhq_b4UXp8SW-dPiVNYw17bjA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex Pientka <alex.pientka@gmail.com>
Cc: linux-raid@vger.kernel.org, Phil Turmel <philip@turmel.org>
List-Id: linux-raid.ids

why would you want to use partitions for such a RAID in the first place=
?

----- Opprinnelig melding -----
> That brings up the question: Any reason to get the partition table
> fixed up? Is this just a cosmetic issue?
> Alex
>=20
>=20
> On Mon, Dec 17, 2012 at 12:41 PM, Phil Turmel <philip@turmel.org>
> wrote:
> > [Top-posting repaired. Please don't.]
> >
> > On 12/17/2012 12:26 PM, Alex Pientka wrote:
> >> On Mon, Dec 17, 2012 at 12:18 PM, Phil Turmel <philip@turmel.org>
> >> wrote:
> >>> Hi Alex,
> >>>
> >>> On 12/17/2012 09:17 AM, Alex Pientka wrote:
> >>>
> >>> [trim /]
> >>>>
> >>>> /dev/md0:
> >>>>         Version : 1.1
> >>>
> >>>                    ^^^^^
> >>> You've deliberately chosen a metadata version that places the
> >>> superblock
> >>> at sector 0 of the given device. If that is a whole disk, it
> >>> overwrites
> >>> the partition table. The default metadata is v1.2 (which places
> >>> the
> >>> superblock at offset 4k) for this very reason.
> >
> >> I assume upgrading to v1.2 is not possible. The only other way
> >> would
> >> be to fail every raw device (one-by-one) and then create the fd
> >> partition on it, correct?
> >
> > You could put the array back on partitions if you like. I'd make a
> > complete backup, zero the superblocks, and use --create
> > --assume-clean
> > to switch to v1.2 in place (with due care to maintain the device
> > order
> > and data offsets).
> >
> > (Save the output of "mdadm -E /dev/sdXX" for each member device
> > before
> > you start.)
> >
> > However, that fdisk can't understand the partition table shouldn't
> > be
> > hurting anything, so I wouldn't make it a priority.
> >
> > BTW, partition type 'fd' is deprecated along with v0.90 metadata, a=
s
> > it
> > only impacts kernel non-initramfs autoassembly, and that only works
> > with
> > DOS partition tables and v0.90 metadata.
> >
> > Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

--=20
Vennlige hilsener / Best regards

roy
--
Roy Sigurd Karlsbakk
(+47) 98013356
roy@karlsbakk.net
http://blogg.karlsbakk.net/
GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
--
I all pedagogikk er det essensielt at pensum presenteres intelligibelt.=
 Det er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5=
 eksessiv anvendelse av idiomer med xenotyp etymologi. I de fleste tilf=
eller eksisterer adekvate og relevante synonymer p=C3=A5 norsk.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
