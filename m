From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [BUG] Raid5 trouble
Date: Wed, 17 Oct 2007 08:40:44 -0700
Message-ID: <e9c3a7c20710170840u2ed8d6a9x26523eec6700ad11@mail.gmail.com>
References: <4714BB92.7040701@systella.fr> <47161CE3.80909@systella.fr>
	 <e9c3a7c20710170758p4046ca44labe370e94bca6e93@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_519_10489630.1192635644393"
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20710170758p4046ca44labe370e94bca6e93@mail.gmail.com>
Sender: sparclinux-owner@vger.kernel.org
To: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
Cc: linux-raid@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-raid.ids

------=_Part_519_10489630.1192635644393
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 10/17/07, Dan Williams <dan.j.williams@intel.com> wrote:
> On 10/17/07, BERTRAND Jo=EBl <joel.bertrand@systella.fr> wrote:
> > BERTRAND Jo=EBl wrote:
> > >     Hello,
> > >
> > >     I run 2.6.23 linux kernel on two T1000 (sparc64) servers. Each
> > > server has a partitionable raid5 array (/dev/md/d0) and I have to
> > > synchronize both raid5 volumes by raid1. Thus, I have tried to build =
a
> > > raid1 volume between /dev/md/d0p1 and /dev/sdi1 (exported by iscsi fr=
om
> > > the second server) and I obtain a BUG :
> > >
> > > Root gershwin:[/usr/scripts] > mdadm -C /dev/md7 -l1 -n2 /dev/md/d0p1
> > > /dev/sdi1
> > > ...
> >
> >         Hello,
> >
> >         I have fixed iscsi-target, and I have tested it. It works now w=
ithout
> > any trouble. Patches were posted on iscsi-target mailing list. When I
> > use iSCSI to access to foreign raid5 volume, it works fine. I can forma=
t
> > foreign volume, copy large files on it... But when I tried to create a
> > new raid1 volume with a local raid5 volume and a foreign raid5 volume, =
I
> > receive my well known Oops. You can find my dmesg after Oops :
> >
>
> Can you send your .config and your bootup dmesg?
>

I found a problem which may lead to the operations count dropping
below zero.  If ops_complete_biofill() gets preempted in between the
following calls:

raid5.c:554> clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
raid5.c:555> clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);

...then get_stripe_work() can recount/re-acknowledge STRIPE_OP_BIOFILL
causing the assertion.  In fact, the 'pending' bit should always be
cleared first, but the other cases are protected by
spin_lock(&sh->lock).  Patch attached.

--
Dan

------=_Part_519_10489630.1192635644393
Content-Type: application/octet-stream; name=fix-biofill-clear.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f7w0e85f
Content-Disposition: attachment; filename=fix-biofill-clear.patch

cmFpZDU6IGZpeCBjbGVhcmluZyBvZiBiaW9maWxsIG9wZXJhdGlvbnMKCkZyb206IERhbiBXaWxs
aWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPgoKb3BzX2NvbXBsZXRlX2Jpb2ZpbGwoKSBy
dW5zIG91dHNpZGUgb2Ygc3Bpbl9sb2NrKCZzaC0+bG9jaykgYW5kIGNsZWFycwonYWNrJyBiZWZv
cmUgaXQgY2xlYXJzICdwZW5kaW5nJy4gIElmIGdldF9zdHJpcGVfd29yaygpIHJ1bnMgaW4gYmV0
d2VlbiB0aGUKY2xlYXJpbmcgb2YgJ2FjaycgYW5kICdwZW5kaW5nJyBpdCB3aWxsIHJlY291bnQg
dGhlIHJlY2VudGx5IGNvbXBsZXRlZApvcGVyYXRpb24gYW5kIGNhdXNlIHNoLT5vcHMuY291bnQg
dG8gYmUgbGVzcyB0aGFuIHplcm8uCgpTaWduZWQtb2ZmLWJ5OiBEYW4gV2lsbGlhbXMgPGRhbi5q
LndpbGxpYW1zQGludGVsLmNvbT4KLS0tCgogZHJpdmVycy9tZC9yYWlkNS5jIHwgICAgMiArLQog
MSBmaWxlcyBjaGFuZ2VkLCAxIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9tZC9yYWlkNS5jIGIvZHJpdmVycy9tZC9yYWlkNS5jCmluZGV4IGY5NmRl
YTkuLjgyMmY0ZDUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWQvcmFpZDUuYworKysgYi9kcml2ZXJz
L21kL3JhaWQ1LmMKQEAgLTU1MSw4ICs1NTEsOCBAQCBzdGF0aWMgdm9pZCBvcHNfY29tcGxldGVf
YmlvZmlsbCh2b2lkICpzdHJpcGVfaGVhZF9yZWYpCiAJCQl9CiAJCX0KIAl9Ci0JY2xlYXJfYml0
KFNUUklQRV9PUF9CSU9GSUxMLCAmc2gtPm9wcy5hY2spOwogCWNsZWFyX2JpdChTVFJJUEVfT1Bf
QklPRklMTCwgJnNoLT5vcHMucGVuZGluZyk7CisJY2xlYXJfYml0KFNUUklQRV9PUF9CSU9GSUxM
LCAmc2gtPm9wcy5hY2spOwogCiAJcmV0dXJuX2lvKHJldHVybl9iaSk7CiAK
------=_Part_519_10489630.1192635644393--
