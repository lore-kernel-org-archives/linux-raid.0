From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: 3T drives and RAID
Date: Fri, 29 Oct 2010 22:36:27 -0500
Message-ID: <2F.34.13137.FB29BCC4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

	WD has finally released a 3T drive employing 4K sectors and Advanced
=46ormatting.  I have some questions about Linux / RAID compatibility. =
 The
compatibility chart says using the drive with Linux requires employing =
the
included HBA.  Is the HBA really required if the system will
not be booting from the drive? =A0Why?  What is the minimum kernel vers=
ion
required? =A0I am wanting to use these on a RAID6 array with no drive
partitioning underneath the array (raw disks) using md / mdadm. =A0I'm
using a pair of PM based eSATA RAID enclosures to house the drives, so
if I need to replace my adapters, the replacements will need to have
eSATA ports (at least 4 per card) compatible with PM enclosures, which =
the
included HBAs do not have.  I'm not sure if the little Sil3124 adapters=
 I
currently have will fill the bill.  Performance is not a big issue.

	In addition, I am going to need to add capacity to my existing
arrays well before I have the money to replace them completely with 3T
drives.  I'm going to need six 3T drives per array to completely replac=
e the
1T and 1.5T drives currently in use.  In the mean time, I could upgrade=
 the
existing arrays with 1T and 1.5T drives, but that money would be more o=
r
less wasted when the drives are replaced in a few months.  I would much
rather buy a couple of 3T drives and move them over to the new array wh=
en it
gets built.  Will there be an issue with attempting to add a 4K sector =
drive
to a RAID6 array built out of 512 byte sectors?

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
