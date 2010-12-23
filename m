From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: RE: Autorebuild, new dynamic udev rules for hot-plugs
Date: Thu, 23 Dec 2010 15:44:26 +0000
Message-ID: <66C59AD0932712458090B447266D638C010C367419@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FAF@irsmsx504.ger.corp.intel.com>
	<20101117212242.5ad7b210@notabene.brown>
	<A9DE54D0CD747C4CB06DCE5B6FA2246F010BE8FD35@irsmsx504.ger.corp.intel.com>
	<66C59AD0932712458090B447266D638C0109E0E1E7@irsmsx504.ger.corp.intel.com>
	<20101122160201.24ad85f8@notabene.brown>
	<66C59AD0932712458090B447266D638C0109E6AE6C@irsmsx504.ger.corp.intel.com>
	<4CEB06BD.9090407@intel.com> <20101123121725.09378dc8@notabene.brown>
 <66C59AD0932712458090B447266D638C0109EB8C71@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_66C59AD0932712458090B447266D638C010C367419irsmsx504gerc_"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66C59AD0932712458090B447266D638C0109EB8C71@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--_002_66C59AD0932712458090B447266D638C010C367419irsmsx504gerc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Hawrylewicz Czarnowski, Przemyslaw
> Sent: Tuesday, November 23, 2010 6:02 PM
> To: Neil Brown
> Cc: linux-raid@vger.kernel.org; Neubauer, Wojciech; Ciechanowski, Ed;
> Labun, Marcin; Czarnowska, Anna; Williams, Dan J
> Subject: RE: Autorebuild, new dynamic udev rules for hot-plugs
>=20
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > owner@vger.kernel.org] On Behalf Of Neil Brown
> > Sent: Tuesday, November 23, 2010 2:17 AM
> > To: Williams, Dan J
> > Cc: Hawrylewicz Czarnowski, Przemyslaw; linux-raid@vger.kernel.org;
> > Neubauer, Wojciech; Ciechanowski, Ed; Labun, Marcin; Czarnowska, Anna
> > Subject: Re: Autorebuild, new dynamic udev rules for hot-plugs
> >
> > On Mon, 22 Nov 2010 16:11:41 -0800
> > Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > > On 11/22/2010 3:50 PM, Hawrylewicz Czarnowski, Przemyslaw wrote:
> > > >> Four comments.
> > > >>
> > > >> 1/ I wouldn't write a file in /lib/udev/rules.d/
> > > >>    I think it should be written to "/dev/.udev/rules.d/"
> > > >>    which is referred to as the "temporary rules directory"
> > > >>    in the udev documentation.
> > > > I am not sure if it is what we are looking for. Temporary means the=
y
> > disappear after reboot. It is OK as cold-plug does not need support for
> > bare disks (or maybe I am wrong?). But in such case, one who wants to u=
se
> > autorebuild should invoke mdadm --activate-domains for example in
> > /etc/init.d/local.boot or somewhere else. Second idea here is to use
> > ActivateDomain() when one starts monitor with autorebuild enabled. Whic=
h
> > one? I would prefer to leave it as it was written initially (considerin=
g
> > comment #4). Then, if one removes policies from config, invoking --
> > activate-domains should reset/remove rules (but see #3)
> > >
> > > The intent was always to have this be something reinitialized at boot=
.
> > > Putting these in the temporary rule directory also precludes them fro=
m
> > > being added to the initramfs where they are not needed / potentially
> > > confusing.
> > >
> > > The other intent was to only match the pci paths for the controllers =
we
> > > cared about.  That does not appear to be a part of this patch.
> >
> > Can you define "we cared about".  Don't we care about everything listed
> in
> > mdadm.conf??
> >
> >
> > >
> > > >
> > > >>
> > > >> 2/ I would be good to process the type=3Ddisk or type=3Dpart part =
of the
> > > >>     policy into the rules file as well.
> > > > OK
> > > >
> > > >>
> > > >> 3/ I'm not very comfortable with hard-coding the name of the
> > > >>     file to be created in the rules.d directory.  Maybe usage coul=
d
> be
> > > >>        --activate-domains=3D63-md-whatever
> > > > Good idea, but only if we store our rules in /dev/.udev/rules.d.
> > Otherwise it would be difficult to maintain all generated rules and
> remove
> > the old ones... I would leave default if not given by user, but one can
> > pass any file name.
> > >
> > > The issue is that this namespace belongs to the distro and since they
> > > need to modify initscripts to turn this feature on might as well dump
> > > the entirety of the naming responsibility to the user.
> > >
> > > >> 4/ I don't think it is good to have an incomplete file in rules.d
> that
> > udev
> > > >>     might accidentally read.  We should create the file with a nam=
e
> > with a
> > > >>     leading '.' (assuming udev ignores those, I haven't checked) a=
nd
> > then
> > > >>     rename it after it has been completely written.
> > > > You're right. In theory, such partial udev rules are excluded when
> udev
> > can't interpret them properly. I have looked into udev's sources and
> found
> > that it looks for "*.rules" files. All other file extensions are ignore=
d.
> > Files with leading dots are also omitted. I would prefer to
> > create<name>.temp file and then rename it into<name>.rules.
> > >
> > > There must be an existing convention for this sort of the thing, if s=
o
> > > let's not invent another one.
> I haven't found anything similar. Just mountall, but it writes single lin=
e
> in one "shot"... Both options with extension or with leading dot will wor=
k.
>=20
> >
> > We could avoid both these issues by just writing the new rules file to
> > stdout.
> > When when the init script gets it wrong, it isn't our fault :-)
> I like that idea at this stage. Later on we might develop better solution
> (see below)
>=20
> >
> > But I don't really like that.  At least there should be a simple and
> > uniform
> > way to propagate any mdadm.conf changes into udev.
> >
> > Maybe the name of the rules file should be given in mdadm.conf, and e.g=
.
> >   mdadm --check-config
> > would report any syntax errors, report any inconsistencies with current
> > arrays, and update the udev file if necessary..
> >
> > Maybe leave that for 3.2.1, and just support '--activate-
> domains=3Dfilename'
> > for now.
> Let me extend this thought a little. As I mentioned above I like the idea
> of writing rule to stdout. Or if somebody wants to pass a file name, just
> write the file in current directory - similar to the way one creates
> mdadm.conf with mdadm --examine (but with small improvement:).
Replying to my last post I would like to present new patch based on the abo=
ve scheme.
I also want to raise the discussion again, as this thread is dead for a whi=
le...

Please comment.

> But the general problem is to find "simple and uniform way". Something
> distro-independent. Rules should be prepared once, right after config fil=
e
> is finished. Fire and forget:)
> We need to handle hot/cold-plug events for action=3Dspare, and hot-plug
> events for actions=3Dspare-same-slot. Considering we use temporary udev r=
ules
> directory they need to be regenerated each reboot, putting attention at t=
he
> moment when we have to do it so we handle all cases. What options then?
>=20
> As a last resort, maybe just a note in man pages with possibilities,
> leaving implementation to user/admin?
>=20
> >
> > ???
> >
> > NeilBrown
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--_002_66C59AD0932712458090B447266D638C010C367419irsmsx504gerc_
Content-Type: application/octet-stream;
	name="0001-Dynamic-hot-plug-udev-rules-for-policies.patch"
Content-Description: 0001-Dynamic-hot-plug-udev-rules-for-policies.patch
Content-Disposition: attachment;
	filename="0001-Dynamic-hot-plug-udev-rules-for-policies.patch"; size=8176;
	creation-date="Thu, 23 Dec 2010 15:37:31 GMT";
	modification-date="Thu, 23 Dec 2010 15:37:20 GMT"
Content-Transfer-Encoding: base64

RnJvbSBjMGFlY2Q0ZGQ5NjY5MWU4YmZhNmYyZGMxODcyNjFlYzhiYjJjNWEyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBQcnplbXlzbGF3IEN6YXJub3dza2kgPHByemVteXNsYXcuaGF3
cnlsZXdpY3ouY3phcm5vd3NraUBpbnRlbC5jb20+CkRhdGU6IFRodSwgMjMgRGVjIDIwMTAgMTY6
MzU6MDEgKzAxMDAKU3ViamVjdDogW1BBVENIXSBEeW5hbWljIGhvdC1wbHVnIHVkZXYgcnVsZXMg
Zm9yIHBvbGljaWVzCkNjOiBsaW51eC1yYWlkQHZnZXIua2VybmVsLm9yZywgV2lsbGlhbXMsIERh
biBKIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+LCBDaWVjaGFub3dza2ksIEVkIDxlZC5jaWVj
aGFub3dza2lAaW50ZWwuY29tPgoKV2hlbiBpbnRyb2R1Y2luZyBwb2xpY2llcywgbmV3IGhvdC1w
bHVnIHJ1bGVzIHdlcmUgYWRkZWQgdG8gc3VwcG9ydApiYXJlIGRpc2tzLiBNZGFkbSB3YXMgc3Rh
cnRlZCBmb3IgZWFjaCBob3QgcGx1Z2dlZCBibG9jayBkZXZpY2UKdG8gZGV0ZXJtaW5lIGlmIGl0
IGNvdWxkIGJlIHVzZWQgYXMgc3BhcmUgb3IgYXMgYSByZXBsYWNlbWVudCBtZW1iZXIgZm9yCmRl
Z3JhZGVkIGFycmF5LgpUaGlzIHBhdGNoIGludHJvZHVjZXMgbGltaXRhdGlvbiBvZiByYW5nZSBv
ZiBkZXZpY2VzIHRoYXQgYXJlIGhhbmRsZWQKYnkgbWRhZG0uCkl0IGxpbWl0cyB0aGVtIHRvIHRo
ZSBvbmVzIHNwZWNpZmllZCBpbiBkb21haW5zIGFzc29jaWF0ZWQgd2l0aAp0aGUgYWN0aW9uczog
c3BhcmUtc2FtZS1wb3J0LCBzcGFyZSBhbmQgc3BhcmUtZm9yY2UuCkluIG9yZGVyIHRvIGVuYWJs
ZSBob3QtcGx1ZyBmb3IgYmFyZSBkaXNrcyBvbmUgbXVzdCB1cGRhdGUgdWRldiBydWxlcwp3aXRo
IGNvbW1hbmQKCgltZGFkbSAtLWFjdGl2YXRlLWRvbWFpbnNbPWZpbGVuYW1lXQoKQWJvdmUgY29t
bWFuZCB3cml0ZXMgdWRldiBydWxlIGNvbmZpZ3VyYXRpb24gdG8gc3Rkb3V0LiBJZiAnZmlsZW5h
bWUnCmlzIGdpdmVuIG91dHB1dCBpcyB3cml0dGVuIHRvIHRoZSBmaWxlIHByb3ZpZGVkIGFzIHBh
cmFtZXRlci4gSXQgaXMgdXAKdG8gc3lzdGVtIGFkbWluaXN0cmF0b3Igd2hhdCBzaG91bGQgYmUg
ZG9uZSBsYXRlci4gVG8gbWFrZSBzdWNoIHJ1bGUKcGVybWFuZW50IChpLmUuIHJlbWFpbiBhZnRl
ciByZWJvb3QpIHJ1bGUgc2hvdWxkIGJlIHdyaXRlbiB0bwovbGliL3VkZXYvcnVsZXMuZCBkaXJl
Y3RvcnkuIE90aGVyIGNhc2VzIHdpbGwganVzdCBuZWVkIHRvIHdyaXRlIGl0IHRvCi9kZXYvLnVk
ZXYvcnVsZXMuZCBkaXJlY3Rvcnkgd2hlcmUgdGVtcG9yYXJ5IHJ1bGVzIGxpZXMuIE9uZSBzaG91
bGQgYmUKYXdhcmUgb2YgdGhlIG1lYW5pbmcgb2YgbmFtZXMvcHJpb3JpdGllcyBvZiB0aGUgdWRl
diBydWxlcy4KCkFmdGVyIG1kYWRtLmNvbmYgaXMgY2hhbmdlZCBvbmUgaXMgb2JsaWdlZCB0byBy
ZS1ydW4KIm1kYWRtIC0tYWN0aXZhdGUtZG9tYWlucyIgY29tbWFuZCBpbiBvcmRlciB0byBicmlu
ZyB0aGUgc3lzdGVtCmNvbmZpZ3VyYXRpb24gdXAgdG8gZGF0ZS4KQWxsIGhvdC1wbHVnZ2VkIGRp
c2tzIGNvbnRhaW5pbmcgbWV0YWRhdGEgYXJlIHN0aWxsIGhhbmRsZWQgYnkgZXhpc3RpbmcKcnVs
ZXMuCgpOb3RlOiB0aGlzIHBhdGNoIGlzIGp1c3QgYSBwcm9wb3NpdGlvbiB0byBtaW5pbWl6ZSBv
dmVyaGVhZCBvZiB1c2luZyBtZGFkbQpmb3IgZWFjaCBwbHVnZ2VkIGJsb2NrIGRldmljZS4KClNp
Z25lZC1vZmYtYnk6IFByemVteXNsYXcgQ3phcm5vd3NraSA8cHJ6ZW15c2xhdy5oYXdyeWxld2lj
ei5jemFybm93c2tpQGludGVsLmNvbT4KLS0tCiBSZWFkTWUuYyB8ICAgIDEgKwogbWRhZG0uYyAg
fCAgIDE4ICsrKysrKysrCiBtZGFkbS5oICB8ICAgIDIgKwogcG9saWN5LmMgfCAgMTQxICsrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
CiA0IGZpbGVzIGNoYW5nZWQsIDE2MiBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlm
ZiAtLWdpdCBhL1JlYWRNZS5jIGIvUmVhZE1lLmMKaW5kZXggNTcxNDg0OS4uY2Y0MWZhNSAxMDA2
NDQKLS0tIGEvUmVhZE1lLmMKKysrIGIvUmVhZE1lLmMKQEAgLTExMCw2ICsxMTAsNyBAQCBzdHJ1
Y3Qgb3B0aW9uIGxvbmdfb3B0aW9uc1tdID0gewogICAgIHsiZGV0YWlsLXBsYXRmb3JtIiwgMCwg
MCwgRGV0YWlsUGxhdGZvcm19LAogICAgIHsia2lsbC1zdWJhcnJheSIsIDEsIDAsIEtpbGxTdWJh
cnJheX0sCiAgICAgeyJ1cGRhdGUtc3ViYXJyYXkiLCAxLCAwLCBVcGRhdGVTdWJhcnJheX0sCisg
ICAgeyJhY3RpdmF0ZS1kb21haW5zIiwgMiwgMCwgQWN0aXZhdGVEb21haW5zfSwKIAogICAgIC8q
IHN5bm9ueW1zICovCiAgICAgeyJtb25pdG9yIiwgICAwLCAwLCAnRid9LApkaWZmIC0tZ2l0IGEv
bWRhZG0uYyBiL21kYWRtLmMKaW5kZXggMmZmZTk0Zi4uZjMwMjFjYyAxMDA2NDQKLS0tIGEvbWRh
ZG0uYworKysgYi9tZGFkbS5jCkBAIC0xMDYsNiArMTA2LDcgQEAgaW50IG1haW4oaW50IGFyZ2Ms
IGNoYXIgKmFyZ3ZbXSkKIAlpbnQgYXV0b191cGRhdGVfaG9tZSA9IDA7CiAJY2hhciAqc3ViYXJy
YXkgPSBOVUxMOwogCWNoYXIgKnJlbW92ZV9wYXRoID0gTlVMTDsKKwljaGFyICp1ZGV2X2ZpbGVu
YW1lID0gTlVMTDsKIAogCWludCBwcmludF9oZWxwID0gMDsKIAlGSUxFICpvdXRmOwpAQCAtMjM0
LDYgKzIzNSw3IEBAIGludCBtYWluKGludCBhcmdjLCBjaGFyICphcmd2W10pCiAJCQkJfQogCQkJ
CXN1YmFycmF5ID0gb3B0YXJnOwogCQkJfQorCQljYXNlIEFjdGl2YXRlRG9tYWluczoKIAkJY2Fz
ZSAnSyc6IGlmICghbW9kZSkgbmV3bW9kZSA9IE1JU0M7IGJyZWFrOwogCQljYXNlIE5vU2hhcmlu
ZzogbmV3bW9kZSA9IE1PTklUT1I7IGJyZWFrOwogCQl9CkBAIC05MjksNiArOTMxLDIwIEBAIGlu
dCBtYWluKGludCBhcmdjLCBjaGFyICphcmd2W10pCiAJCQl9CiAJCQlkZXZtb2RlID0gb3B0Owog
CQkJY29udGludWU7CisJCWNhc2UgTyhNSVNDLCBBY3RpdmF0ZURvbWFpbnMpOgorCQkJaWYgKGRl
dm1vZGUgJiYgZGV2bW9kZSAhPSBvcHQpIHsKKwkJCQlmcHJpbnRmKHN0ZGVyciwgTmFtZSAiOiAt
LUFjdGl2YXRlRG9tYWlucyBtdXN0IgorCQkJCQkJICAgICAiIGJlIHRoZSBvbmx5IG9wdGlvbi5c
biIpOworCQkJfSBlbHNlIHsKKwkJCQlpZiAodWRldl9maWxlbmFtZSkKKwkJCQlmcHJpbnRmKHN0
ZGVyciwgTmFtZSAiOiBvbmx5IHNwZWNpZnkgb25lIHVkZXYgIgorCQkJCQkJICAgICAicnVsZSBm
aWxlbmFtZS4gJXMgaWdub3JlZC5cbiIsCisJCQkJCW9wdGFyZyk7CisJCQkJZWxzZQorCQkJCQl1
ZGV2X2ZpbGVuYW1lID0gb3B0YXJnOworCQkJfQorCQkJZGV2bW9kZSA9IG9wdDsKKwkJCWNvbnRp
bnVlOwogCQljYXNlIE8oTUlTQywndCcpOgogCQkJdGVzdCA9IDE7CiAJCQljb250aW51ZTsKQEAg
LTE0OTMsNiArMTUwOSw4IEBAIGludCBtYWluKGludCBhcmdjLCBjaGFyICphcmd2W10pCiAJCQkJ
CQlmcmVlX21kc3RhdChtcyk7CiAJCQkJCX0gd2hpbGUgKCFsYXN0ICYmIGVycik7CiAJCQkJCWlm
IChlcnIpIHJ2IHw9IDE7CisJCQkJfSBlbHNlIGlmIChkZXZtb2RlID09IEFjdGl2YXRlRG9tYWlu
cykgeworCQkJCQlydiA9IEFjdGl2YXRlX0RvbWFpbnModWRldl9maWxlbmFtZSk7CiAJCQkJfSBl
bHNlIHsKIAkJCQkJZnByaW50ZihzdGRlcnIsIE5hbWUgIjogTm8gZGV2aWNlcyBnaXZlbi5cbiIp
OwogCQkJCQlleGl0KDIpOwpkaWZmIC0tZ2l0IGEvbWRhZG0uaCBiL21kYWRtLmgKaW5kZXggMzYx
MjRkZS4uMTI0MjAxNSAxMDA2NDQKLS0tIGEvbWRhZG0uaAorKysgYi9tZGFkbS5oCkBAIC0zMTEs
NiArMzExLDcgQEAgZW51bSBzcGVjaWFsX29wdGlvbnMgewogCUJpdG1hcCwKIAlSZWJ1aWxkTWFw
T3B0LAogCUludmFsaWRCYWNrdXAsCisJQWN0aXZhdGVEb21haW5zCiB9OwogCiAvKiBzdHJ1Y3R1
cmVzIHJlYWQgZnJvbSBjb25maWcgZmlsZSAqLwpAQCAtMTAzMSw2ICsxMDMyLDcgQEAgZXh0ZXJu
IGludCBDcmVhdGVCaXRtYXAoY2hhciAqZmlsZW5hbWUsIGludCBmb3JjZSwgY2hhciB1dWlkWzE2
XSwKIAkJCXVuc2lnbmVkIGxvbmcgbG9uZyBhcnJheV9zaXplLAogCQkJaW50IG1ham9yKTsKIGV4
dGVybiBpbnQgRXhhbWluZUJpdG1hcChjaGFyICpmaWxlbmFtZSwgaW50IGJyaWVmLCBzdHJ1Y3Qg
c3VwZXJ0eXBlICpzdCk7CitleHRlcm4gaW50IEFjdGl2YXRlX0RvbWFpbnMoY2hhciAqcnVsZV9u
YW1lKTsKIGV4dGVybiBpbnQgYml0bWFwX3VwZGF0ZV91dWlkKGludCBmZCwgaW50ICp1dWlkLCBp
bnQgc3dhcCk7CiBleHRlcm4gdW5zaWduZWQgbG9uZyBiaXRtYXBfc2VjdG9ycyhzdHJ1Y3QgYml0
bWFwX3N1cGVyX3MgKmJzYik7CiAKZGlmZiAtLWdpdCBhL3BvbGljeS5jIGIvcG9saWN5LmMKaW5k
ZXggYmE5NzZkYi4uODFkM2U3MCAxMDA2NDQKLS0tIGEvcG9saWN5LmMKKysrIGIvcG9saWN5LmMK
QEAgLTc2NCwzICs3NjQsMTQ0IEBAIGludCBwb2xpY3lfY2hlY2tfcGF0aChzdHJ1Y3QgbWRpbmZv
ICpkaXNrLCBzdHJ1Y3QgbWFwX2VudCAqYXJyYXkpCiAJZmNsb3NlKGYpOwogCXJldHVybiBydiA9
PSA1OwogfQorCisvKiBpbnZvY2F0aW9uIG9mIHVkZXYgcnVsZSBmaWxlICovCitjaGFyIHVkZXZf
dGVtcGxhdGVfc3RhcnRbXSA9CisiIyBkbyBub3QgZWRpdCB0aGlzIGZpbGUsIGl0IHdpbGwgYmUg
b3ZlcndyaXR0ZW4gb24gdXBkYXRlXG4iCisiXG4iCisiU1VCU1lTVEVNIT1cImJsb2NrXCIsIEdP
VE89XCJtZF9hdXRvcmVidWlsZF9lbmRcIlxuIgorIlxuIgorIkVOVntJRF9GU19UWVBFfT09XCJs
aW51eF9yYWlkX21lbWJlclwiLCBHT1RPPVwibWRfYXV0b3JlYnVpbGRfZW5kXCJcbiIKKyJFTlZ7
SURfRlNfVFlQRX09PVwiaXN3X3JhaWRfbWVtYmVyXCIsIEdPVE89XCJtZF9hdXRvcmVidWlsZF9l
bmRcIlxuIgorIlxuIjsKKworLyogZW5kaW5nIG9mIHVkZXYgcnVsZSBmaWxlICovCitjaGFyIHVk
ZXZfdGVtcGxhdGVfZW5kW10gPQorIlxuIgorIkxBQkVMPVwibWRfYXV0b3JlYnVpbGRfZW5kXCJc
biIKKyJcbiI7CisKKy8qIGZpbmQgcnVsZSBuYW1lZCBydWxlX3R5cGUgYW5kIHJldHVybiBpdHMg
dmFsdWUgKi8KK2NoYXIgKmZpbmRfcnVsZShzdHJ1Y3QgcnVsZSAqcnVsZSwgY2hhciAqcnVsZV90
eXBlKQoreworCXdoaWxlIChydWxlKSB7CisJCWlmIChydWxlLT5uYW1lID09IHJ1bGVfdHlwZSkK
KwkJCXJldHVybiBydWxlLT52YWx1ZTsKKworCQlydWxlID0gcnVsZS0+bmV4dDsKKwl9CisJcmV0
dXJuIE5VTEw7Cit9CisKKyNkZWZpbmUgVURFVl9SVUxFX0ZPUk1BVCBcCisiQUNUSU9OPT1cImFk
ZFwiLCBLRVJORUwhPVwibWQqXCIgRU5We0lEX1BBVEh9PT1cIiVzXCIgIiBcCisiUlVOKz1cIi9z
YmluL21kYWRtIC0taW5jcmVtZW50YWwgJGVudntERVZOQU1FfVwiLCAiIFwKKyJHT1RPPVwibWRf
YXV0b3JlYnVpbGRfZW5kXCJcbiIgXAorCisvKiBXcml0ZSBydWxlIGluIHRoZSBydWxlIGZpbGUu
IFVzZSBmb3JtYXQgZnJvbSBVREVWX1JVTEVfRk9STUFUICovCitpbnQgd3JpdGVfcnVsZShzdHJ1
Y3QgcnVsZSAqcnVsZSwgaW50IGZkKQoreworCWNoYXIgbGluZVsxMDI0XTsKKwljaGFyICpyID0g
ZmluZF9ydWxlKHJ1bGUsIHJ1bGVfcGF0aCk7CisJaWYgKCFyKQorCQlyZXR1cm4gLTE7CisKKwlz
bnByaW50ZihsaW5lLCBzaXplb2YobGluZSkgLSAxLCBVREVWX1JVTEVfRk9STUFULCByKTsKKwly
ZXR1cm4gd3JpdGUoZmQsIGxpbmUsIHN0cmxlbihsaW5lKSk7Cit9CisKKy8qIEdlbmVyYXRlIHNp
bmdsZSBlbnRyeSBpbiB1ZGV2IHJ1bGUgYmFzaW5nIG9uIFBPTElDWSBsaW5lIGZvdW5kIGluIGNv
bmZpZworICogZmlsZS4gVGFrZSBvbmx5IHRob3NlIHdpdGggcGF0aHMsIG9ubHkgZmlyc3Qgb2Nj
dXJyZW5jZSBpZiBwYXRocyBhcmUgZXF1YWwKKyAqIGFuZCBpZiBhY3Rpb25zIHN1cHBvcnRzIGhh
bmRsaW5nIG9mIHNwYXJlcyAoPj1hY3Rfc3BhcmVfc2FtZV9zbG90KQorICovCitpbnQgZ2VuZXJh
dGVfZW50cmllcyhpbnQgZmQpCit7CisJc3RydWN0IHBvbF9ydWxlICpsb29wLCAqZHVwOworCWNo
YXIgKmxvb3BfdmFsdWUsICpkdXBfdmFsdWU7CisJaW50IGR1cGxpY2F0ZTsKKwlpbnQgd3JpdHRl
biA9IDA7CisKKwlmb3IgKGxvb3AgPSBjb25maWdfcnVsZXM7IGxvb3A7IGxvb3AgPSBsb29wLT5u
ZXh0KSB7CisJCWlmIChsb29wLT50eXBlICE9IHJ1bGVfcG9saWN5ICYmIGxvb3AtPnR5cGUgIT0g
cnVsZV9wYXJ0KQorCQkJY29udGludWU7CisJCWR1cGxpY2F0ZSA9IDA7CisKKwkJLyogb25seSBw
b2xpY2llcyB3aXRoIHBhdGhzIGFuZCB3aXRoIGFjdGlvbnMgc3VwcG9ydGluZworCQkgKiBiYXJl
IGRpc2tzIGFyZSBjb25zaWRlcmVkICovCisJCWxvb3BfdmFsdWUgPSBmaW5kX3J1bGUobG9vcC0+
cnVsZSwgcG9sX2FjdCk7CisJCWlmICghbG9vcF92YWx1ZSB8fCBtYXBfYWN0KGxvb3BfdmFsdWUp
IDwgYWN0X3NwYXJlX3NhbWVfc2xvdCkKKwkJCWNvbnRpbnVlOworCQlsb29wX3ZhbHVlID0gZmlu
ZF9ydWxlKGxvb3AtPnJ1bGUsIHJ1bGVfcGF0aCk7CisJCWlmICghbG9vcF92YWx1ZSkKKwkJCWNv
bnRpbnVlOworCQlmb3IgKGR1cCA9IGNvbmZpZ19ydWxlczsgZHVwICE9IGxvb3A7IGR1cCA9IGR1
cC0+bmV4dCkgeworCQkJaWYgKGR1cC0+dHlwZSAhPSBydWxlX3BvbGljeSAmJiBsb29wLT50eXBl
ICE9IHJ1bGVfcGFydCkKKwkJCQljb250aW51ZTsKKwkJCWR1cF92YWx1ZSA9IGZpbmRfcnVsZShk
dXAtPnJ1bGUsIHBvbF9hY3QpOworCQkJaWYgKCFkdXBfdmFsdWUgfHwgbWFwX2FjdChkdXBfdmFs
dWUpIDwgYWN0X3NwYXJlX3NhbWVfc2xvdCkKKwkJCQljb250aW51ZTsKKwkJCWR1cF92YWx1ZSA9
IGZpbmRfcnVsZShkdXAtPnJ1bGUsIHJ1bGVfcGF0aCk7CisJCQlpZiAoIWR1cF92YWx1ZSkKKwkJ
CQljb250aW51ZTsKKwkJCWlmIChzdHJjbXAobG9vcF92YWx1ZSwgZHVwX3ZhbHVlKSA9PSAwKSB7
CisJCQkJZHVwbGljYXRlID0gMTsKKwkJCQlicmVhazsKKwkJCX0KKwkJfQorCisJCS8qIG5vdCBh
IGR1cCBvciBmaXJzdCBvY2N1cnJlbmNlICovCisJCWlmICghZHVwbGljYXRlKSB7CisJCQlpZiAo
d3JpdGVfcnVsZShsb29wLT5ydWxlLCBmZCkgPT0gLTEpCisJCQkJcmV0dXJuIDA7CisJCQl3cml0
dGVuKys7CisJCX0KKwl9CisJcmV0dXJuIHdyaXR0ZW47Cit9CisKKy8qIEFjdGl2YXRlX0RvbWFp
bnMgcm91dGluZSBjcmVhdGVzIGR5bmFtaWMgdWRldiBydWxlcyB1c2VkIHRvIGhhbmRsZQorICog
aG90LXBsdWcgZXZlbnRzIGZvciBiYXJlIGRldmljZXMgKGFuZCBtYWtpbmcgdGhlbSBzcGFyZXMp
CisgKi8KK2ludCBBY3RpdmF0ZV9Eb21haW5zKGNoYXIgKnJ1bGVfbmFtZSkKK3sKKwlpbnQgZmQg
PSAwOworCWludCBydjsKKwljaGFyIHVkZXZfcnVsZV9maWxlW1BBVEhfTUFYXTsKKworCWlmIChy
dWxlX25hbWUpCisJCWZkID0gY3JlYXQodWRldl9ydWxlX2ZpbGUsCisJCQkgICBTX0lSVVNSIHwg
U19JV1VTUiB8IFNfSVJHUlAgfCBTX0lST1RIKTsKKwllbHNlCisJCWZkID0gZHVwKGZpbGVubyhz
dGRvdXQpKTsKKwlpZiAoZmQgPT0gLTEpCisJCXJldHVybiAxOworCisJLyogd3JpdGUgc3RhdGlj
IGludm9jYXRpb24gKi8KKwlpZiAod3JpdGUoZmQsIHVkZXZfdGVtcGxhdGVfc3RhcnQsCisJCXNp
emVvZih1ZGV2X3RlbXBsYXRlX3N0YXJ0KSAtIDEpID09IC0xKSB7CisJCWNsb3NlKGZkKTsKKwkJ
aWYgKHJ1bGVfbmFtZSkKKwkJCXVubGluayh1ZGV2X3J1bGVfZmlsZSk7CisJCXJldHVybiAxOwor
CX0KKworCS8qIGl0ZXJhdGUsIGlmIG5vbmUgY3JlYXRlZCBvciBlcnJvciBvY2N1cnJlZCwgcmVt
b3ZlIGZpbGUgKi8KKwlydiA9IGdlbmVyYXRlX2VudHJpZXMoZmQpOworCWlmIChydiA8PSAwKSB7
CisJCWNsb3NlKGZkKTsKKwkJaWYgKHJ1bGVfbmFtZSkKKwkJCXVubGluayh1ZGV2X3J1bGVfZmls
ZSk7CisJCXJldHVybiBydiA9PSAtMSA/IC0xIDogMDsKKwl9CisKKwkvKiB3cml0ZSBlbmRpbmcg
Ki8KKwlpZiAod3JpdGUoZmQsIHVkZXZfdGVtcGxhdGVfZW5kLCBzaXplb2YodWRldl90ZW1wbGF0
ZV9lbmQpIC0gMSkgPT0gLTEpIHsKKwkJY2xvc2UoZmQpOworCQlpZiAocnVsZV9uYW1lKQorCQkJ
dW5saW5rKHVkZXZfcnVsZV9maWxlKTsKKwkJcmV0dXJuIDE7CisJfQorCisJY2xvc2UoZmQpOwor
CXJldHVybiAwOworfQotLSAKMS43LjEKCg==

--_002_66C59AD0932712458090B447266D638C010C367419irsmsx504gerc_--
