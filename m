From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: writing zeros to bad sector results in persistent read error
Date: Wed, 08 Oct 2014 13:51:33 -0400
Message-ID: <543579A5.6020504@ubuntu.com>
References: <B7EA34DA-1064-45B1-B0C0-B7C423C7EB47@colorremedies.com> <20140607075140.277c0880@natsu> <0E76B97E-96DF-43A3-B8EC-4867964BF8E9@colorremedies.com> <20140609193723.79F1B3809B0@gemini.denx.de> <19559C36-08B4-4C2F-ABC3-9DE79BE37B54@colorremedies.com> <53970ACE.6080001@turmel.org> <6C47950B-13E8-479C-BC3B-C21C379A95FB@colorremedies.com> <yq18uof9sxz.fsf@sermon.lab.mkp.net> <CAAMCDef3tO4Ah_3gYJ_6Y0Kh_mPn+z=E5voHFYr-z7_Leuf48Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAMCDef3tO4Ah_3gYJ_6Y0Kh_mPn+z=E5voHFYr-z7_Leuf48Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Chris Murphy <lists@colorremedies.com>, Phil Turmel <philip@turmel.org>, Wolfgang Denk <wd@denx.de>, Roman Mamedov <rm@romanrm.net>, "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 6/29/2014 8:51 PM, Roger Heflin wrote:
> All of this is probably the reason that this command exists:
> 
> hdparm --write-sector <sectornum>
> 
> I believe it directly sends the scsi/ata layer commands.

You end up with the same results as using dd ( with oflag=direct ), it
is just a matter of the path it takes to get there.

With dd, it calls write() to pass the data to the block layer, which
hands it to the scsi layer, which translates it into a scsi
WRITE_10/16 command, which hands it to libata which translates it into
an ata taskfile to be handed to the drive.

With hdparm --write-sector, it builds the ata taskfile, uses the SG_IO
ioctl to hand it to the block layer, which hands it down through the
scsi and libata layers which see that it needs no translation and it
goes to the drive unmodified.

The resulting taskfile the drive actually sees should be the same.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUNXmlAAoJEI5FoCIzSKrwMYwIAJj1c0pBxdOcCQAk4i26802S
/lbPHhY5Xu7wR5KbZSXeEazE/vgTT7mDgjWHoe6Vl9e+Ci90KJxSFgQXNNwcYtuK
V+UFrTyqiKAzfk8VbRj0kwxk1JuXRQesDlwCGUsBkjSO26pdhUVfxwP8I3JcOBQW
uKRmh8PE48iq7kDWQdtxve6IPnAj/VY8AubwRAaVAvZ3xsEUBlf7UAkvA4n3WvWN
mfO1VVWwv4zyZ6bEBoWfjj6//5C0R+q2TrnBDFD9pN/wY4TdAx0gtufiUWx0v5WG
NNzJ9tm5z2rNo/HNi4w1gHm0JLDhSky21sNX7KyY8/1tFjqa3KQT7iQ6vxk4UJM=
=Xv01
-----END PGP SIGNATURE-----
