From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Question about MD multipathing
Date: Thu, 4 Aug 2005 14:51:17 +0200
Message-ID: <20050804125117.GG11081@marowsky-bree.de>
References: <38295A62BCF9744C9C0D5AD9FB7747C8E87CBA@XW2K3-FRAMBX-06.ads.dlh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <38295A62BCF9744C9C0D5AD9FB7747C8E87CBA@XW2K3-FRAMBX-06.ads.dlh.de>
Sender: linux-raid-owner@vger.kernel.org
To: martin.lonkwitz.sp@lhsystems.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2005-08-04T14:46:28, martin.lonkwitz.sp@lhsystems.com wrote:

> Hello Lars,
>=20
> Thank you very much for your mail.
> Well, unfortunately I don't have a choice and musst use kernel 2.4 :-(
> But therefore we use mostly Suse :)

OK, md multipath works rather well in the latest SLES8 2.4 kernel
update.

Just don't set all paths to active, add the passive ones as spares, and
then you will have a true active/passive scenario.

> Any more options ? We tried the qlogic fail-over driver. But it looks l=
ike
> that this driver are unable to handle the way over 2 fabrics to a lun.

No idea, I don't use qlogic internal multipathing at all.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"

