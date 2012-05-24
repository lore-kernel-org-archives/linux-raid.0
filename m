From: NeilBrown <neilb@suse.de>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Thu, 24 May 2012 12:10:20 +1000
Message-ID: <20120524121020.3349c402@notabene.brown>
References: <4FAAE8F1.8000600@pocock.com.au>
	<CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com>
	<4FABC7C6.4030107@turmel.org>
	<4FAC2FF2.5060305@hardwarefreak.com>
	<4FAC40BC.1060300@hesbynett.no>
	<CABYL=ToORULrdhBVQk0K8zQqFYkOomY-wgG7PpnJnzP9u7iBnA@mail.gmail.com>
	<4FACBB68.2080304@hesbynett.no>
	<4FACCAC8.4020206@pocock.com.au>
	<4FAD9283.7020809@hardwarefreak.com>
	<CAGqmV7oJg8vwKPJEYJhPANzaN-xxVW6Lw2gLTEKmMfG=pqCHuA@mail.gmail.com>
	<4FBA8EA9.40203@hardwarefreak.com>
	<20120522093404.3ffaae42@notabene.brown>
	<4FBB33D6.4010101@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ibdj0OiYejnOOwnfuWxAugs"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FBB33D6.4010101@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: CoolCold <coolthecold@gmail.com>, Daniel Pocock <daniel@pocock.com.au>, David Brown <david.brown@hesbynett.no>, Roberto Spadim <roberto@spadim.com.br>, Phil Turmel <philip@turmel.org>, Marcus Sorensen <shadowsor@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ibdj0OiYejnOOwnfuWxAugs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 22 May 2012 01:36:06 -0500 Stan Hoeppner <stan@hardwarefreak.com>
wrote:

> On 5/21/2012 6:34 PM, NeilBrown wrote:
> > On Mon, 21 May 2012 13:51:21 -0500 Stan Hoeppner <stan@hardwarefreak.co=
m>
> > wrote:
> >=20
> >> On 5/21/2012 10:20 AM, CoolCold wrote:
> >>> On Sat, May 12, 2012 at 2:28 AM, Stan Hoeppner <stan@hardwarefreak.co=
m> wrote:
> >>>> On 5/11/2012 3:16 AM, Daniel Pocock wrote:
> >>>>
> >>> [snip]
> >>>> That's the one scenario where I abhor using md raid, as I mentioned.=
  At
> >>>> least, a boot raid 1 pair.  Using layered md raid 1 + 0, or 1 + line=
ar
> >>>> is a great solution for many workloads.  Ask me why I say raid 1 + 0
> >>>> instead of raid 10.
> >>> So, I'm asking - why?
> >>
> >> Neil pointed out quite some time ago that the md RAID 1/5/6/10 code ru=
ns
> >> as a single kernel thread.  Thus when running heavy IO workloads across
> >> many rust disks or a few SSDs, the md thread becomes CPU bound, as it
> >> can only execute on a single core, just as with any other single threa=
d.
> >=20
> > This is not the complete truth.
>=20
> Yes, I should have stipulated only writes are limited to a single thread.
>=20
> > For RAID1 and RAID10, successful IO requests do not involved the kernel
> > thread, so the fact that there is only one should be irrelevant.
> > Failed requests are retried using the thread and it is also involved it
> > resync/recovery so those processes may be limited by the single thread.
> >=20
> > RAID5/6 does not use the thread for read requests on a non-degraded arr=
ay.
> > However all write requests go through the single thread so there could =
be
> > issues there.
>=20
> Thanks for clarifying this.  In your previous response to this issue
> (quoted and linked below) you included RAID 1/10 with RAID 5/6 WRT
> writes going through a single thread.
>=20
> > Have you  actually measured md/raid10 being slower than raid0 over raid=
1?
>=20
> I personally have not, as I don't have access to the storage hardware
> necessary to sink a sufficiently large write stream to peak a core with
> the md thread.
>=20
> > I have a vague memory from when this came up before that there was some=
 extra
> > issue that I was missing, but I cannot recall it just now....
>=20
> We're recalling the same thread, which was many months ago.  Here's your
> post:  http://marc.info/?l=3Dlinux-raid&m=3D132616899005148&w=3D2
>=20
> And here's the relevant section upon which I was basing my recent
> statements:
>=20
> "I think you must be misremembering.  Neither RAID0 or Linear have any
> threads involved.  They just redirect the request to the appropriate
> devices.  Multiple threads can submit multiple requests down through
> RAID0 and Linear concurrently.
>=20
> RAID1, RAID10, and RAID5/6 are different.  For reads they normally are
> have no contention with other requests, but for writes things do get
> single-threaded at some point."
>=20

That's right - I keep forgetting about the single-threading caused by needi=
ng
to sync with bitmap updates.

So reads a fully parallel.  Writes are - for now - serialised to a single
processor for handling.

Thanks,
NeilBrown

--Sig_/ibdj0OiYejnOOwnfuWxAugs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT72YjDnsnt1WYoG5AQJcxw//Te6RhH1bbu3emKz7SnMEbJdGCyjk1jtW
TVgjfyQaNVK0QRIYK3+v+FhV0STtdKbw8O7VE6a0oZnB1HVgttueHlVibHB/r2AS
vDckcr3FV7eX/W/t1OCAxsJZ+osdG6alCG+MwxvgH2VhmeW+10+nBGuzuP4HSBrD
Gz4PIunqVEsX9O7KFY9VQLtoWylusaaTfuimmW4Sl8I8075dFKZYk0+5KgVD+1tF
ezd98CsQtcM7cmKHrrOxTK3WLjgrxq9ZTyK2w/7IB+kRNP2l5DgrFz8k4wNe4+bf
0u1BLDeAn+w5k5OT4j7WvBJHBRfA20Lg2HajbRIWRRVnXMInVJNMXX3q8vekvppE
8S1/edyTU8gvte5Wvu2RDlFSdNyKS/QqoIDZH4BpdblfBFbE9u+GuRxsYzxaZcQ5
6rqXF6Y8dVR5mfrConRSCj0nl36TTvFI6iDxw8iApRwF31CD8LJAaT1TbyUcp3CA
wHMI/kZvAtfLxwx/ZfvSMzYi31oeWpNBlZVjOC0TiTkFI6+0kDg12PHkWqppvscp
EFbXOPkuOEh/fddiJybPidltvOSXc2AuUnzT5jbz2xe+kviJUTwK/URRfwPcHkio
ZOS8snj3WND6xlBCZFBOCrGjScFLDsDjiqk8cqHOTB6i90Zn/KYvbqtIkvjEYd24
CYV+gQXy2qM=
=M9dK
-----END PGP SIGNATURE-----

--Sig_/ibdj0OiYejnOOwnfuWxAugs--
