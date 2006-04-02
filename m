From: gaetan.leurent@ens.fr (=?iso-8859-1?Q?Ga=EBtan?= LEURENT)
Subject: Raid 4/5 small writes
Date: Sun, 02 Apr 2006 17:37:22 +0200
Message-ID: <qlk3bgwt2dp.fsf@clipper.ens.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm considering building a Raid4[#] array for my desktop and I have a
question about small writes with Raid4/Raid5: when a small part of a
block is modified, we have two options:

- read the hole stripe, compute the new checksum and write the data and
  the checksum

- read only the part of the data that will be overwritten, and the
  corresponding part of the checksum.  Since the checksum is a simple
  XOR, we have:
     New Checksum =3D Old Checksum XOR Old Data XOR New Data
  and we can write the new data and the new checksum without reading
  more data.

Does the Linux kernel implements the second way?


[#] I'm not doing Raid5 because I have two 120Go drives and two 250Go
    drives.  I am thinking of making a Raid0 array out of the two small
    drives, and using that as the parity drive for the Raid4.  I believ=
e
    this should give better performance than Raid5.

Thanks,

--=20
Ga=EBtan LEURENT
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
