From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Question about MD multipathing
Date: Thu, 4 Aug 2005 14:30:13 +0200
Message-ID: <20050804123013.GE11081@marowsky-bree.de>
References: <38295A62BCF9744C9C0D5AD9FB7747C8D796B4@XW2K3-FRAMBX-06.ads.dlh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <38295A62BCF9744C9C0D5AD9FB7747C8D796B4@XW2K3-FRAMBX-06.ads.dlh.de>
Sender: linux-raid-owner@vger.kernel.org
To: martin.lonkwitz.sp@lhsystems.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2005-08-03T14:14:56, martin.lonkwitz.sp@lhsystems.com wrote:

> Cause I have problems with active/passiv storage (storagetek D240) whil=
e
> Lun's jump to the passiv controller of the storage cause of traffic
> comes to this one :/
> Dones anyone can suggest another solution for active/passive storage
> that works with linux kernel 2.4 and 2.6 ?

You should use DM multipath. md multipath isn't going to perform well
for you in 2.4 (unless you're using the SLES8 kernel, which is hacked up
quite a bit).

With 2.6, Device-Mapper has been choosen for the multipath IO to be
implemented in.



Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"

