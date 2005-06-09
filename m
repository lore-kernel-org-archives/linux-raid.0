From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: trouble with software raid-1 on dm-multipath-devices
Date: Thu, 9 Jun 2005 16:42:42 +0200
Message-ID: <20050609144242.GT25717@marowsky-bree.de>
References: <42A817B6.70709@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <42A817B6.70709@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Sven Hessenmueller <Sven.Hessenmueller@gmx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2005-06-09T12:19:34, Sven Hessenmueller <Sven.Hessenmueller@gmx.de> =
wrote:

> mdadm -C -l mirror -n 2 /dev/md0 /dev/mapper/sym1_dev388=20
> /dev/mapper/sym2_dev388
>=20
> results in:
>=20
> Jun  8 02:24:09 s01kr606 kernel: md: could not lock dm-7.
> Jun  8 02:24:09 s01kr606 kernel: md: error, md_import_device() return=
ed -16
>=20
> is there any other possibility or any clue to get it working??

This should work, I test that frequently.

Are the /dev/dm-xx mounted/accessed by anything else?

(And, because of a bug, I'm hoping you're running SLES9 SP1 with a
kernel updated to post-SP1, because that one was broken with DM/md
stacking due to an oversight... But then, you'd have seen an oops
already ;-)

SP2 will bring much improved DM multipath, too.

Actually, in the future you may want to annoy the Novell / SUSE support
organization with questions about SLES9 kernels, because they are fairl=
y
different from mainline ;-)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
