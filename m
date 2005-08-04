From: <martin.lonkwitz.sp@lhsystems.com>
Subject: RE: Question about MD multipathing
Date: Thu, 4 Aug 2005 14:46:28 +0200
Message-ID: <38295A62BCF9744C9C0D5AD9FB7747C8E87CBA@XW2K3-FRAMBX-06.ads.dlh.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: lmb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Lars,

Thank you very much for your mail.
Well, unfortunately I don't have a choice and musst use kernel 2.4 :-(
But therefore we use mostly Suse :)
Any more options ? We tried the qlogic fail-over driver. But it looks lik=
e
that this driver are unable to handle the way over 2 fabrics to a lun.

Regards,
          Martin Lonkwitz


-----Original Message-----
From: Lars Marowsky-Bree [mailto:lmb@suse.de]=20
Sent: Donnerstag, 4. August 2005 14:30
To: LONKWITZ, MARTIN; linux-raid@vger.kernel.org
Subject: Re: Question about MD multipathing

On 2005-08-03T14:14:56, martin.lonkwitz.sp@lhsystems.com wrote:

> Cause I have problems with active/passiv storage (storagetek D240)=20
> while Lun's jump to the passiv controller of the storage cause of=20
> traffic comes to this one :/ Dones anyone can suggest another solution=20
> for active/passive storage that works with linux kernel 2.4 and 2.6 ?

You should use DM multipath. md multipath isn't going to perform well for=
 you in 2.4 (unless you're using the SLES8 kernel, which is hacked up qui=
te a bit).

With 2.6, Device-Mapper has been choosen for the multipath IO to be imple=
mented in.



Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"

