From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/3] Create: Allow to create two volumes of different
 sizes within one container
Date: Tue, 20 Sep 2011 23:31:03 -0700
Message-ID: <CAA9_cmdkRFqUzj3rdOmNWhTBg=8Wk+LEoaPozawdjQvF0YGb7g@mail.gmail.com>
References: <20110919165220.9239.2939.stgit@gklab-128-192.igk.intel.com>
	<20110919165230.9239.4775.stgit@gklab-128-192.igk.intel.com>
	<20110921133123.05d03613@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf3005dc1c65127b04ad6db87a
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110921133123.05d03613@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Lukasz Orlowski <lukasz.orlowski@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--20cf3005dc1c65127b04ad6db87a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 20, 2011 at 8:31 PM, NeilBrown <neilb@suse.de> wrote:
> On Mon, 19 Sep 2011 18:52:31 +0200 Lukasz Orlowski
> <lukasz.orlowski@intel.com> wrote:
>
>> Allows to create RAID 5 volume on 3 disks and then RAID 1 volume on 2
>> disks withing the same container.
>>
>> Signed-off-by: Lukasz Orlowski <lukasz.orlowski@intel.com>
>> ---
>> =A0super-intel.c | =A0 =A06 ++++++
>> =A01 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/super-intel.c b/super-intel.c
>> index a78d723..616853b 100644
>> --- a/super-intel.c
>> +++ b/super-intel.c
>> @@ -5041,6 +5041,12 @@ static int validate_geometry_imsm_volume(struct s=
upertype *st, int level,
>> =A0 =A0 =A0 if (!super)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>>
>> + =A0 =A0 if (mpb->num_raid_devs > 0 && mpb->num_disks !=3D raiddisks) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, Name ": the option-rom require=
s all "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "member disks to be a member o=
f all volumes.\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> + =A0 =A0 }
>> +
>> =A0 =A0 =A0 if (!validate_geometry_imsm_orom(super, level, layout, raidd=
isks, chunk, verbose)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, Name ": RAID gemetry validat=
ion failed. "
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Cannot proceed with the act=
ion(s).\n");
>>
>
> This patch doesn't make sense.
>
> Firstly the description seems backwards. =A0The purpose of this patch see=
ms to
> disallow the creation of two volumes with different numbers of devices, b=
ut
> the description seems to say that it allows it. =A0But that is a small po=
int.
>
> ->num_disks is the number of devices in the container including spares. =
=A0This
> patch would allow the first array in a container to have fewer devices th=
an
> the container with the rest being spares. =A0However the second array wou=
ld have
> to have the same number of devices as the container - even if this is mor=
e
> than the first array.
>
> Presumably what you really want to do is:
> =A0if num_raid_devs > 0, then find the relevant imsm_map, and then check =
if
> =A0 =A0 map->num_members =3D=3D raiddisks
> =A0and fail if they are not equal.
>

Yeah, the changelog is backwards, and this breaks tests/08imsm-overlap
because it does not honor IMSM_NO_PLATFORM.  How about the attached?

Lukasz, please copy me on patch submissions.

Thanks,
Dan

--20cf3005dc1c65127b04ad6db87a
Content-Type: application/octet-stream; name="fix-member-disks.patch"
Content-Disposition: attachment; filename="fix-member-disks.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gstxomms1

aW1zbTogZml4IGFycmF5IG1lbWJlcnNoaXAgZW5mb3JjZW1lbnQKCkZyb206IERhbiBXaWxsaWFt
cyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPgoKQ29tbWl0IGU3Y2IwNmM4ICJDcmVhdGU6IEFs
bG93IHRvIGNyZWF0ZSB0d28gdm9sdW1lcyBvZiBkaWZmZXJlbnQgc2l6ZXMKd2l0aGluIG9uZSBj
b250YWluZXIiIGZpeGVkIGVuZm9yY2VtZW50IG9mIHRoZSAiYWxsIG1lbWJlciBkaXNrcyBtdXN0
IGJlCmEgbWVtYmVyIG9mIGFsbCBhcnJheXMiIGNvbnN0cmFpbnQgYnkgYWRkaW5nIHN1cHBvcnQg
Zm9yIHRoZSBjYXNlIHdoZXJlCmEgc21hbGxlciBhcnJheSBpcyBiZWluZyBjcmVhdGVkIGluIGEg
Y29udGFpbmVyIHdpdGggYSBsYXJnZXIgYXJyYXkuCgpIb3dldmVyLCBpdCBicm9rZSB0ZXN0cy8w
OGltc20tb3ZlcmxhcCwgYW5kIHRoZSB0ZXN0IHNob3VsZCBiZSBtb3ZlZApuZXh0IHRvIHRoZSBl
eGlzdGluZyBjb2RlIHRoYXQgcHJldmVudHMgbmV3IHNwYXJlcyBmcm9tIGJlaW5nIGFjdGl2YXRl
ZApwcmVtYXR1cmVseS4KCkNjOiBMdWthc3ogT3Jsb3dza2kgPGx1a2Fzei5vcmxvd3NraUBpbnRl
bC5jb20+ClNpZ25lZC1vZmYtYnk6IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwu
Y29tPgotLS0KIHN1cGVyLWludGVsLmMgfCAgIDExICsrKysrLS0tLS0tCiAxIGZpbGVzIGNoYW5n
ZWQsIDUgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9zdXBlci1p
bnRlbC5jIGIvc3VwZXItaW50ZWwuYwppbmRleCAwN2Q0N2I1Li45ODg1Yjk4IDEwMDY0NAotLS0g
YS9zdXBlci1pbnRlbC5jCisrKyBiL3N1cGVyLWludGVsLmMKQEAgLTUxMjIsMTIgKzUxMjIsNiBA
QCBzdGF0aWMgaW50IHZhbGlkYXRlX2dlb21ldHJ5X2ltc21fdm9sdW1lKHN0cnVjdCBzdXBlcnR5
cGUgKnN0LCBpbnQgbGV2ZWwsCiAJaWYgKCFzdXBlcikKIAkJcmV0dXJuIDA7CiAKLQlpZiAobXBi
LT5udW1fcmFpZF9kZXZzID4gMCAmJiBtcGItPm51bV9kaXNrcyAhPSByYWlkZGlza3MpIHsKLQkJ
ZnByaW50ZihzdGRlcnIsIE5hbWUgIjogdGhlIG9wdGlvbi1yb20gcmVxdWlyZXMgYWxsICIKLQkJ
CSJtZW1iZXIgZGlza3MgdG8gYmUgYSBtZW1iZXIgb2YgYWxsIHZvbHVtZXMuXG4iKTsKLQkJcmV0
dXJuIDA7Ci0JfQotCiAJaWYgKCF2YWxpZGF0ZV9nZW9tZXRyeV9pbXNtX29yb20oc3VwZXIsIGxl
dmVsLCBsYXlvdXQsIHJhaWRkaXNrcywgY2h1bmssIHZlcmJvc2UpKSB7CiAJCWZwcmludGYoc3Rk
ZXJyLCBOYW1lICI6IFJBSUQgZ2VtZXRyeSB2YWxpZGF0aW9uIGZhaWxlZC4gIgogCQkJIkNhbm5v
dCBwcm9jZWVkIHdpdGggdGhlIGFjdGlvbihzKS5cbiIpOwpAQCAtNTIwNiw2ICs1MjAwLDExIEBA
IHN0YXRpYyBpbnQgdmFsaWRhdGVfZ2VvbWV0cnlfaW1zbV92b2x1bWUoc3RydWN0IHN1cGVydHlw
ZSAqc3QsIGludCBsZXZlbCwKIAkJZnByaW50ZihzdGRlcnIsIE5hbWUgIjogVGhlIG9wdGlvbi1y
b20gcmVxdWlyZXMgYWxsIG1lbWJlciIKIAkJCSIgZGlza3MgdG8gYmUgYSBtZW1iZXIgb2YgYWxs
IHZvbHVtZXNcbiIpOwogCQlyZXR1cm4gMDsKKwl9IGVsc2UgaWYgKHN1cGVyLT5vcm9tICYmIG1w
Yi0+bnVtX3JhaWRfZGV2cyA+IDAgJiYKKwkJICAgbXBiLT5udW1fZGlza3MgIT0gcmFpZGRpc2tz
KSB7CisJCWZwcmludGYoc3RkZXJyLCBOYW1lICI6IFRoZSBvcHRpb24tcm9tIHJlcXVpcmVzIGFs
bCBtZW1iZXIiCisJCQkiIGRpc2tzIHRvIGJlIGEgbWVtYmVyIG9mIGFsbCB2b2x1bWVzXG4iKTsK
KwkJcmV0dXJuIDA7CiAJfQogCiAJLyogcmV0cmlldmUgdGhlIGxhcmdlc3QgZnJlZSBzcGFjZSBi
bG9jayAqLwo=
--20cf3005dc1c65127b04ad6db87a--
