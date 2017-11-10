From: Jun-Kai Teoh <kai.teoh@gmail.com>
Subject: Re: RAID5 up, but one drive removed, one says spare building, what
 now?
Date: Fri, 10 Nov 2017 11:22:46 -0800
Message-ID: <66C593A3-D4BD-4B80-AF7D-B1693F8271CA@gmail.com>
References: <CAA4aoFaEwv=EPcotAbjzkgXWoOFwxo2XAoMzN1Zfb62k4Fngxw@mail.gmail.com>
 <5A058E25.1020608@youngman.org.uk>
 <34b72bc9-9a72-3143-bd1e-d00f90493d04@turmel.org>
 <CAK2H+ec6DxBE_Mxq9skOa3XNGMc2BW8Q4+ieoA13uG+UhE4nZg@mail.gmail.com>
 <CAA4aoFbOnCtj_+qbfuzz7qS6xrt5HB9XJK-E+h0_eEu=vLdftg@mail.gmail.com>
 <3fa05723-8275-8840-7fbc-397801fa17de@turmel.org>
 <0B536D2C-1919-4704-94D3-6EB733B73E9D@gmail.com>
 <8822270a-a88b-fe9a-daae-22df155f5062@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8822270a-a88b-fe9a-daae-22df155f5062@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Mark Knecht <markknecht@gmail.com>, Wols Lists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> On Nov 10, 2017, at 11:04 AM, Phil Turmel <philip@turmel.org> wrote:
>=20
> On 11/10/2017 01:15 PM, Jun-Kai Teoh wrote:
>=20
>> I'm backing up as much as I can, but I don't think I'll be able to=20
>> back up everything. I can back up very little of the data, so I'm=20
>> trying to prioritize carefully right now.
>=20
> Ah, ok.  Well, after you get the important stuff backed up, you can
> add more devices as spares and try to let MD continue its grow and
> rebuild operations.  It might end up completing.

Again, pardon me if I sound super ignorant, I just want to do all of =
this right.

Do I just plug in another blank 4TB, and run "mdadm -A /dev/md126 =
/dev/sd[newdrive]" into it?

Or leave it as it is, and just ask it to continue growing with "mdadm -A =
-R", and *then* add a blank drive into the raid but don't ask it to =
grow?

> But don't add any more complete devices to the array -- use a =
partition
> that starts at 1MB and covers the rest of the device (default for most
> partition tools nowadays).

Where can I read about how to do this properly? I tried googling it but =
I'm pretty lost. Or what tool I should use etc.

> I recommend that when/if your array is stable again, you add one more
> spare (with partition) and then use mdadm's --replace operation to =
move
> complete-device members to the new member.  When each is done, take =
the
> newly freed device and partition it and do the next.  When you have no
> more complete-device members and have the last freed device =
partitioned,
> consider converting to raid6 with that spare.

I think I understand what you mean here, but it sounds like I need to =
figure out the top two parts first and that'll take me awhile.

I'll probably have questions again, later, haha.

I really appreciate all the support and patience from this list.

Y'all lifesavers.=20=
