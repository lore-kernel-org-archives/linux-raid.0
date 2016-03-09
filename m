From: Dan Russell <dpr@aol.com>
Subject: Re: Import/recover RAID6 created with SAS2108?
Date: Wed, 9 Mar 2016 15:53:30 -0500
Message-ID: <97E12B93-B712-4FD3-81BE-F60E57B8469B@aol.com>
References: <2832CD22-EADC-4BC6-A250-FE8919A92E0A@aol.com> <20160307215026.GA8042@EIS> <ECED3C91-8D12-469E-A9AB-1337292DA216@aol.com> <20160309192728.GA3581@EIS>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160309192728.GA3581@EIS>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mar 9, 2016, at 2:27 PM, Andreas Klauer <Andreas.Klauer@metamorpher.=
de> wrote:
>=20
> On Tue, Mar 08, 2016 at 10:20:17PM -0500, Dan Russell wrote:
>> The partially-rebuilt drive is sdk, the original =E2=80=9Cfailed=E2=80=
=9D drive is sdag
>=20
> Best to leave both out if one has outdated and the other only half=20
> the content=E2=80=A6

I generally agree, but in my case the filesystem wasn=E2=80=99t mounted=
 (commented out of fstab, movers dropped system, I booted system, RAID =
failed before I mounted the filesystem), so I=E2=80=99m OK with the ris=
k.

>=20
>> However fdisk and mdadm are reporting the array is 17.6TB in size, w=
hereas it should be 66TB (24 3TB HDDs RAID6).
>=20
> I reproduced your commands using tmpfs based loop devices and it give=
s me=20
> the same problem. The RAID size is only 16 TiB. It seems to be hittin=
g a=20
> limit somewhere.
>=20
> Your /dev/mapper/sdx are snapshot/overlays, I hope?

Yes.  I can=E2=80=99t recommend highly enough the overlay_setup approac=
h on the Wiki.

> DDF metadata seems to be located at the end of the device, so you cou=
ld try=20
> your luck with mdadm 1.0 metadata instead; that gives me a RAID of a =
size=20
> closer to home.

This got me closer, but the LVM2 label was missing.  When I=E2=80=99d p=
reviously assembled the RAID in the container, I noticed algorithm 10; =
whereas with this approach it was 2.  I switched it to 10 and my array =
is back.  fsck (xfs_repair -n, really) says the FS is clean and random =
poking at files seems to back that up.

I have a backup, of course, but doing a disk-to-disk verify/recovery is=
 going to be so much quicker.

Thank you so much for your help, Andreas and all the contributors to th=
e =E2=80=9CRAID_Recovery=E2=80=9D and =E2=80=9CRecovering_a_failed_soft=
ware_RAID=E2=80=9D Wiki pages.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
