From: Chris Murphy <lists@colorremedies.com>
Subject: Re: GPT Table broken on a Raid1
Date: Sun, 23 Sep 2012 12:53:07 -0600
Message-ID: <D14F019C-39C6-4C60-88EF-A7565FA93D6F@colorremedies.com>
References: <4961154.0TR9MeFlIq@techz> <2627519.Y2VdWh5VBI@techz> <1BDFB79A-E375-47F2-8EDF-8F51D8774651@colorremedies.com> <1361158.MkTZ6QR6cp@techz> <E9C051A7-65EB-48F5-8D3B-1C374F271E0C@colorremedies.com> <3EC7177F-9973-4D2E-988B-7020298E1727@colorremedies.com> <505DD9E2.7090908@anonymous.org.uk> <F7E53090-1143-4811-86B9-E71923B98AA2@colorremedies.com> <505E368A.4020200@anonymous.org.uk> <6FBE5434-A133-43C0-8296-58978301D32B@colorremedies.com> <505EF9F3.7000908@anonymous.org.uk> <142B3AEB-45FE-4A6E-A03F-BEAA9599C2DC@colorremedies.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <142B3AEB-45FE-4A6E-A03F-BEAA9599C2DC@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 23, 2012, at 11:44 AM, Chris Murphy wrote:
>=20
> If IMSM only applies an offset to the end of the disk, such that it m=
erely changes the last usable LBA and therefore there is a 1:1 correlat=
ion between array LBA's and physical disk LBA's, the kernel would find =
the alternate GPT header. Yet it isn't, so still something isn't right.

1.
IMSM metadata starts at LBA -32 from the end of the physical disk after=
 issuing this command:
mdadm -C /dev/md/imsm /dev/sd[bc] -n 2 -e imsm

At this point nothing else is on the disk, per hexdump.

2.
A small amount of additional data is added in those reserve 32 sectors =
at the end of the physical disk after issuing this command:
mdadm -C /dev/md/vol0 /dev/md/imsm -n 2 -l 1

3.
gdisk sees /dev/sdb as having 16777216 sectors.
gdisk sees /dev/md/vol0 has having 16769024 sectors.


4.
Upon creating a GPT on /dev/md/vol0, identical structures at identical =
byte offsets are created on /dev/sd[bc] and /dev/md/vol0.

The primary GPT header says the alternate header is at 0xffdfff.
The alternate GPT header is at 0xffdfff., or sector 16769023, right whe=
re it should be.

Regardless of whether the kernel sees the disk as Intel RAID or a bare =
disk, it finds the alternate GPT header, and doesn't complain about any=
thing.


Conclusions:
A. There is a 1:1 correlation between physical disk LBA and array LBA (=
at least for RAID 1), there is merely an offset at the end of the disk =
for IMSM metadata.

B. G=FCnther's disks had GPTs made on the physical disk devices themsel=
ves, prior to the creation of IMSM metadata. When IMSM metadata was cre=
ated, the alternate GPT header and table data were squished because it =
was in the wrong location.

C. The fact G=FCnther's "mdadm -E" command on the physical disks reveal=
s both are in a dirty state, indicates to me the array is not assembled=
, and is not presently mirroring. So I think he's actually not booted f=
rom or using the array at all, at least not from within linux.


Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
