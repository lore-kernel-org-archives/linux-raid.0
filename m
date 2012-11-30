From: Lars Marowsky-Bree <lmb@suse.com>
Subject: Re: Raid 0+1
Date: Fri, 30 Nov 2012 16:29:54 +0100
Message-ID: <20121130152954.GR29064@suse.de>
References: <CAAo+KF=-XStwczZvxPh7jgLZzwEAD71XWWg0h5HBXekBO8-5vQ@mail.gmail.com>
 <50B8C26C.7000807@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <50B8C26C.7000807@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2012-11-30T15:27:56, Sebastian Riemer <sebastian.riemer@profitbricks=
=2Ecom> wrote:

> Yes, it is possible but it only makes sense if you want to mirror to
> another server as most people know that the alternative DRBD is too s=
low
> for serious storage requirements.
>=20
> Create the RAID-0 first, then take your RAID-0 device and e.g. an iSC=
SI
> device from another storage server with the same setup and create a
> RAID-1 over them. Then, you've got your stacked MD layers.
>=20
> With the flag write-mostly you can even tell the read balancing that =
the
> remote device is slower than the local one.

That is somewhat orthogonal to the original discussion, but in which
benchmarks is this approach faster than DRBD - aren't the bottlenecks
still the spindle and the network IO?



Regards,
    Lars

--=20
Architect Storage/HA
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imend=F6=
rffer, HRB 21284 (AG N=FCrnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wil=
de

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
