From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: RE: [md-accel PATCH 00/19] md raid acceleration and the async_tx api
Date: Wed, 27 Jun 2007 10:09:30 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E520212C067@azsmsx413.amr.corp.intel.com>
References: <46829432.4050302@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7B8DD.ED8379C6"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <46829432.4050302@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de, akpm@linux-foundation.org, davem@davemloft.net, "Leech, Christopher" <christopher.leech@intel.com>, "Nelson, Shannon" <shannon.nelson@intel.com>, herbert@gondor.apana.org.au, jeff@garzik.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7B8DD.ED8379C6
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Dan, I hope you will release these as a patchset against 2.6.22 when
> it's out or 2.6.21. I find I have a lot more confidence in results,
good
> or bad, when comparing something I have run in production with just
one
> patchset added. There are enough other changes in an -rc to confuse
the
> issue, and I don't run them in production (at least not usually).
>=20
There has since been a some style cleanups and the raid5 refactor, but
you can go grab the 2.6.21-iop1 patch series from SourceForge if you
want to try these changes out.  Use the attached series file instead of
the one in the tarball. =20

You can also wait for 2.6.22-iop1, which should be the final version of
md-accel queued for the merge window.

https://sourceforge.net/project/downloading.php?group_id=3D115074&filenam=
e
=3Dpatches-2.6.21-iop1.tar.gz&47542009

> --
> bill davidsen <davidsen@tmr.com>
>   CTO TMR Associates, Inc
>   Doing interesting things with small computers since 1979

Thank you for testing,
Dan

------_=_NextPart_001_01C7B8DD.ED8379C6
Content-Type: application/octet-stream;
	name="series"
Content-Transfer-Encoding: base64
Content-Description: series
Content-Disposition: attachment;
	filename="series"

IyBUaGlzIHNlcmllcyBhcHBsaWVzIG9uIEdJVCBjb21taXQgZGU0NmMzMzc0NWY1ZTJhZDU5NGM3
MmYyY2Y1ZjQ5MDg2MWIxNmNlMQojZGV2X2RiZy1jaGVjay1hcmdzLnBhdGNoCiNtc2ktYXJjaC1o
YXMtbXNpLnBhdGNoCiNtc2ktZml4LXNtcC1jb21waWxhdGlvbi5wYXRjaAojaW9wMTN4eC1tc2kt
c3VwcG9ydC5wYXRjaAojaW9wLWZpeC1nZXR0aW1lb2Zmc2V0LnBhdGNoCiNpb3AxM3h4LWlvLWZp
eC5wYXRjaAojaW9wMTN4eC10cG1pLnBhdGNoCiNpb3AxM3h4LXRpbWUtYXV0b2RldGVjdC5wYXRj
aAojaW9wMTN4eC1pb3AzNDItdWFydC1lbmFibGUucGF0Y2gKI2lvcC13YXRjaGRvZy5wYXRjaAoj
aW9wM3h4LXBjaS1pbml0aWFsaXphdGlvbi5wYXRjaAojYXJtLWZpeC1oYW5kbGluZy1vZi1zdmMt
dW5kZWYtZXhjLnBhdGNoCiNpb3AxM3h4LXdvcmthcm91bmQtdWFydC1paXItZXJyYXRhLnBhdGNo
CiNhcm0tYWxsb3ctZG1hLW5vbmUucGF0Y2gKYWRkLWJhc2Utc3VwcG9ydC1mb3ItYXN5bmNfdHgu
cGF0Y2gKZG1hZW5naW5lLWNsaWVudC1jaGFubmVsLW1hbmFnZW1lbnQucGF0Y2gKYXJtLWFkZC1k
cml2ZXJzLWRtYS5wYXRjaAphZGQtdGhlLWFzeW5jX3R4LWFwaS5wYXRjaAptZC1hZGQtcmFpZDVf
cnVuX29wcy5wYXRjaAptZC1lbmFibGUtcmFpZDVfcnVuX29wcy5wYXRjaAptZC1tb3ZlLXdyaXRl
LW9wZXJhdGlvbnMtdG8tcmFpZDVfcnVuX29wcy5wYXRjaAptZC1tb3ZlLWNvbXB1dGUtb3BlcmF0
aW9ucy10by1yYWlkNV9ydW5fb3BzLnBhdGNoCm1kLW1vdmUtY2hlY2stb3BlcmF0aW9ucy10by1y
YWlkNV9ydW5fb3BzLnBhdGNoCm1kLXNhdGlzZnktcmVhZC1yZXF1ZXN0cy12aWEtcmFpZDVfcnVu
X29wcy5wYXRjaAptZC11c2UtYXN5bmNfdHgtZm9yLWV4cGFuc2lvbi5wYXRjaAptZC1tb3ZlLWlv
LXRvLXJhaWQ1X3J1bl9vcHMucGF0Y2gKbWQtcmVtb3ZlLWNvbXB1dGVfYmxvY2stYW5kLWNvbXB1
dGVfcGFyaXR5NS5wYXRjaAppb3AtYWRtYS1kZXZpY2UtZHJpdmVyLnBhdGNoCmlvcDEzeHgtYWRt
YS1zdXBwb3J0LnBhdGNoCmlvcDN4eC1hZG1hLXN1cHBvcnQucGF0Y2gKI2kyYy1tNDFzdDg1dy5w
YXRjaAojaW9wMTN4eC1pbXUucGF0Y2gKI2lvcDEzeHgtaW11LXNjc2kucGF0Y2gKI2lvcDEzeHgt
aW11LWRpcmVjdGVkLWNvcmUtcmVzZXQucGF0Y2gKI2lvcDEzeHgteHNjMy1vcHJvZmlsZS5wYXRj
aAojaW9wMTN4eC1wY2ktc3lzZnMtbW1hcC5wYXRjaAojaW9wMTN4eC1wbW9uLW9wcm9maWxlLnBh
dGNoCiNhcm0tdWRpdmRpMy5wYXRjaAojcGJpX2NvbXBhY3RfZmxhc2gucGF0Y2gKI2RtYS1jb3B5
LWNsZWFyLXBhZ2UucGF0Y2gKI3RyeS1kbWEtbWVtY3B5LnBhdGNoCiN0cnktZG1hLWNvcHktdG8t
dXNlci5wYXRjaAojdHJ5LWRtYS1jb3B5LWZyb20tdXNlci5wYXRjaAojdGVtcC1yZXZlcnQtbXNp
LXN1cHBvcnQtcmV2Ny5wYXRjaAojaXNjODEzeHgucGF0Y2gKI3YyLjYuMjEtaW9wMS5wYXRjaAo=

------_=_NextPart_001_01C7B8DD.ED8379C6--
