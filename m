From: Jun-Kai Teoh <kai.teoh@gmail.com>
Subject: Re: RAID5 up, but one drive removed, one says spare building, what
 now?
Date: Fri, 10 Nov 2017 10:15:02 -0800
Message-ID: <0B536D2C-1919-4704-94D3-6EB733B73E9D@gmail.com>
References: <CAA4aoFaEwv=EPcotAbjzkgXWoOFwxo2XAoMzN1Zfb62k4Fngxw@mail.gmail.com>
 <5A058E25.1020608@youngman.org.uk>
 <34b72bc9-9a72-3143-bd1e-d00f90493d04@turmel.org>
 <CAK2H+ec6DxBE_Mxq9skOa3XNGMc2BW8Q4+ieoA13uG+UhE4nZg@mail.gmail.com>
 <CAA4aoFbOnCtj_+qbfuzz7qS6xrt5HB9XJK-E+h0_eEu=vLdftg@mail.gmail.com>
 <3fa05723-8275-8840-7fbc-397801fa17de@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3fa05723-8275-8840-7fbc-397801fa17de@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Mark Knecht <markknecht@gmail.com>, Wols Lists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> On Nov 10, 2017, at 10:01 AM, Phil Turmel <philip@turmel.org> wrote:
>=20
> Hi Jun-Kai,
>=20
> {Convention on kernel.org is to trim replies and avoid top-posting.}
>=20
> On 11/10/2017 12:25 PM, Jun-Kai Teoh wrote:
>> I was reshaping/growing my array when it died. Computer came back up
>> but array wouldn't assemble.
>>=20
>> I looked around and saw some commands on how to assemble without the
>> one drive that looked like it was kicked off sometime ago that I did
>> not realize (I used --assemble --force --verbose)
>>=20
>> I kept getting the error that there were 6 drives, 1 rebuilding, and
>> not enough to get the array up. I unplugged the one drive that had =
the
>> incorrect superblock and ran "mdadm -A -R".
>>=20
>> It ran and looked like it was resuming reshaping but it got really
>> slow - like 7 years slow.
>>=20
>> I killed the process, rebooted the machine, and it just auto
>> reassembled the array and automounted it on boot.
>>=20
>> Am in the process of backup right now.
>>=20
>> And yes, the drive/array is mounted.
>=20
> Ok.  I reviewed the other thread.  Consider creating a new array from
> scratch after you complete your backups, using consistent partitioning
> across all devices.  I would put LVM on top and leave part of it
> unallocated (for emergencies), but that's just my preference.
>=20
> Phil


My apologies all! I did not know this.

I'm backing up as much as I can, but I don't think I'll be able to back =
up everything. I can back up very little of the data, so I'm trying to =
prioritize carefully right now.

All devices are just 4TB drives, I didn't partition them separately for =
the array - or am I misunderstanding what you mean? <-- This is really =
common, all of you are far more knowledgeable than I am and I only =
understand some of the terms sometimes.


