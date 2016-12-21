From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [BUG] MD/RAID1 hung forever on freeze_array
Date: Wed, 21 Dec 2016 13:48:25 +0100
Message-ID: <CAMGffE=OVX-jp+-SY8A4pmJHyVAkVQVXSCa_3VgndFf4tYyG9w@mail.gmail.com>
References: <CAMGffE=1kp7gMhG+dFxTvhD6VkRuSfbuXbf9vYSWwGG+=vvhDA@mail.gmail.com>
 <87a8c20xpg.fsf@notabene.neil.brown.name> <CAMGffEkQ5puQEE0FVfLMV1of1OYOhLMhHdUTAy-YLYPkzBzjDg@mail.gmail.com>
 <87oa0gzuej.fsf@notabene.neil.brown.name> <CAMGffEm4BDhKJSiDt=2WmxrpRutg862at7JP221gMi6_SpPomQ@mail.gmail.com>
 <877f73zd5d.fsf@notabene.neil.brown.name> <CAMGffEnCesgUp4gBsPN2L9qg3WSxNXsCcYEPWH-BaeEEktaqcw@mail.gmail.com>
 <CAMGffE=KoVdoYRzkHdRMuCopjmUdcrP9-woFFr-4-VszGsSHRQ@mail.gmail.com>
 <CAMGffEnvn4YQ5ADFXrOm2vOeEwApo38V84wB7VF3D1eZihF-Zw@mail.gmail.com>
 <87fulpyj33.fsf@notabene.neil.brown.name> <CAMGffEkufeaDytaHxtLR02iiQifZDhcwkLdzMj3X8_yaitSoFQ@mail.gmail.com>
 <87oa07tu6q.fsf@notabene.neil.brown.name> <CAMGffEmEUg2Xrg-v_z+cMxzsH-Uk6bDCqTSA7vGoPw4f2dvu0A@mail.gmail.com>
 <871sx2thvt.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a1141c938e083cc05442a92da
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <871sx2thvt.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Nate Dailey <nate.dailey@stratus.com>
List-Id: linux-raid.ids

--001a1141c938e083cc05442a92da
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Thanks Neil,

On Tue, Dec 20, 2016 at 10:23 PM, NeilBrown <neilb@suse.com> wrote:
> On Tue, Dec 20 2016, Jinpu Wang wrote:
>
>> Hi Neil,
>>> This is the problem.  'hold' hasn't been initialised.
>>> We could either do:
>>>   bio_list_init(&hold);
>>>   bio_list_merge(&hold, &bio_list_on_stack);
>> I tried above variant first and it lead to panic in endio path:
>>
> ...
>>
>>     [exception RIP: bio_check_pages_dirty+65]
>
>
> I can't explain that at all.  Maybe if I saw the complete patch I would
> be able to see what went wrong (or maybe there is a separate cause).
I think I know the cause now, I did
+bio_list_init(&hold);
bio_list_merge(&hold, &bio_list_on_stack);
- bio_list_init(&bio_list_on_stack)
I didn't read your comment clear enough, just thought we maybe don't
need to reinit &bio_list_on_stack twice.
But your idea is same the copy before we can q->make_request_fn.

>
>>>
>>> You didn't find 'hold' to be necessary in your testing, but I think tha=
t
>>> is more complex arrangements it could make an important difference.
>>
>> Could you elaborate a bit more, from my understanding, in later code,
>> we pop all bio from bio_list_on_stack,
>> add it to either "lower" or "same" bio_list, so merge both will have
>> the whole list again, right?
>
> If there are several bios on bio_list_on_stack, and if processing the
> first one causes several calls to generic_make_request(), then we want
> all the bios passed to generic_make_request() to be handled *before* the
> remaining bios that were originally on bio_list_on_stack.  Of these new
> bios, we want to handle those for a lower level device first, and those
> for the same device after that.  Only when all of those have been
> completely submitted (together with any subordinate bios submitted to
> generic_make_request()) do we move on to the rest of bio_list_on_stack
> (which are at the same level as the first bio, or higher in the device
> stack).
>
> The usage of 'hold' would become important when you have multiple
> levels.  e.g. dm on md on scsi.  If the first bio send to dm is split,
> then the first half needs to be processed all the way down to all the
> scsi devices, before the second half of the split is handled.
>
> Hope that helps,
> NeilBrown
>
Thanks, it does help a lot, I attached the patch I'm still testing,
but so far so good.
Could you check if I got it right?

Cheers,
--=20
Jinpu Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang@profitbricks.com
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss

--001a1141c938e083cc05442a92da
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-block-fix-deadlock-between-freeze_array-and-wait_bar.patch"
Content-Disposition: attachment;
	filename="0001-block-fix-deadlock-between-freeze_array-and-wait_bar.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_iwyxnemg1

RnJvbSA5NTAwZDVlOWE3Y2NkMWY0Mzk3ZjkyN2ZmZGM4ZDM3ODk1NWQ0NzdjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYWNrIFdhbmcgPGppbnB1LndhbmdAcHJvZml0YnJpY2tzLmNv
bT4KRGF0ZTogV2VkLCAxNCBEZWMgMjAxNiAxNjo1NTo1MiArMDEwMApTdWJqZWN0OiBbUEFUQ0hd
IGJsb2NrOiBmaXggZGVhZGxvY2sgYmV0d2VlbiBmcmVlemVfYXJyYXkoKSBhbmQgd2FpdF9iYXJy
aWVyKCkKCldoZW4gd2UgY2FsbCB3YWl0X2JhcnJpZXIsIHdlIG1pZ2h0IGhhdmUgc29tZSBiaW9z
IHdhaXRpbmcKaW4gY3VycmVudC0+YmlvX2xpc3QsIHdoaWNoIHByZXZlbnRzIHRoZSBhcnJheV9m
cmVlemUgY2FsbCB0bwpjb21wbGV0ZS4gVGhvc2UgY2FuIG9ubHkgYmUgaW50ZXJuYWwgUkVBRHMs
IHdoaWNoIGhhdmUgYWxyZWFkeQpwYXNzZWQgdGhlIHdhaXRfYmFycmllciBjYWxsICh0aHVzIGlu
Y3JlbWVudGluZyBucl9wZW5kaW5nKSwgYnV0CnN0aWxsIHdlcmUgbm90IHN1Ym1pdHRlZCB0byB0
aGUgbG93ZXIgbGV2ZWwsIGR1ZSB0byBnZW5lcmljX21ha2VfcmVxdWVzdApsb2dpYyB0byBhdm9p
ZCByZWN1cnNpdmUgY2FsbHMuIEluIHN1Y2ggY2FzZSwgd2UgaGF2ZSBhIGRlYWRsb2NrOgotIGFy
cmF5X2Zyb3plbiBpcyBhbHJlYWR5IHNldCB0byAxLCBzbyB3YWl0X2JhcnJpZXIgdW5jb25kaXRp
b25hbGx5IHdhaXRzLCBzbwotIGludGVybmFsIFJFQUQgYmlvcyB3aWxsIG5vdCBiZSBzdWJtaXR0
ZWQsIHRodXMgZnJlZXplX2FycmF5IHdpbGwKbmV2ZXIgY29tcGxldGVzLgoKVG8gZml4IHRoaXMs
IG1vZGlmeSBnZW5lcmljX21ha2VfcmVxdWVzdCB0byBhbHdheXMgc29ydCBiaW9fbGlzdF9vbl9z
dGFjawpmaXJzdCB3aXRoIGxvd2VzdCBsZXZlbCwgdGhlbiBoaWdoZXIsIHVudGlsIHNhbWUgbGV2
ZWwuCgpTdWdnZXN0ZWQtYnk6IE5laWwgQnJvd24gPG5laWwuYnJvd24uc3VzZS5jb20+ClNpZ25l
ZC1vZmYtYnk6IEphY2sgV2FuZyA8amlucHUud2FuZ0Bwcm9maXRicmlja3MuY29tPgotLS0KIGJs
b2NrL2Jsay1jb3JlLmMgfCAyMCArKysrKysrKysrKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQs
IDIwIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9ibG9jay9ibGstY29yZS5jIGIvYmxvY2sv
YmxrLWNvcmUuYwppbmRleCBlOGQxNWQ4Li41YTYzOTBhIDEwMDY0NAotLS0gYS9ibG9jay9ibGst
Y29yZS5jCisrKyBiL2Jsb2NrL2Jsay1jb3JlLmMKQEAgLTIwNjQsMTAgKzIwNjQsMzAgQEAgYmxr
X3FjX3QgZ2VuZXJpY19tYWtlX3JlcXVlc3Qoc3RydWN0IGJpbyAqYmlvKQogCQlzdHJ1Y3QgcmVx
dWVzdF9xdWV1ZSAqcSA9IGJkZXZfZ2V0X3F1ZXVlKGJpby0+YmlfYmRldik7CiAKIAkJaWYgKGxp
a2VseShibGtfcXVldWVfZW50ZXIocSwgX19HRlBfRElSRUNUX1JFQ0xBSU0pID09IDApKSB7CisJ
CQlzdHJ1Y3QgYmlvX2xpc3QgbG93ZXIsIHNhbWUsIGhvbGQ7CisKKwkJCS8qIENyZWF0ZSBhIGZy
ZXNoIGJpb19saXN0IGZvciBhbGwgc3Vib3JkaW5hdGUgcmVxdWVzdHMgKi8KKwkJCWJpb19saXN0
X2luaXQoJmhvbGQpOworCQkJYmlvX2xpc3RfbWVyZ2UoJmhvbGQsICZiaW9fbGlzdF9vbl9zdGFj
ayk7CisJCQliaW9fbGlzdF9pbml0KCZiaW9fbGlzdF9vbl9zdGFjayk7CiAKIAkJCXJldCA9IHEt
Pm1ha2VfcmVxdWVzdF9mbihxLCBiaW8pOwogCiAJCQlibGtfcXVldWVfZXhpdChxKTsKKwkJCS8q
IHNvcnQgbmV3IGJpb3MgaW50byB0aG9zZSBmb3IgYSBsb3dlciBsZXZlbAorCQkJICogYW5kIHRo
b3NlIGZvciB0aGUgc2FtZSBsZXZlbAorCQkJICovCisJCQliaW9fbGlzdF9pbml0KCZsb3dlcik7
CisJCQliaW9fbGlzdF9pbml0KCZzYW1lKTsKKwkJCXdoaWxlICgoYmlvID0gYmlvX2xpc3RfcG9w
KCZiaW9fbGlzdF9vbl9zdGFjaykpICE9IE5VTEwpCisJCQkJaWYgKHEgPT0gYmRldl9nZXRfcXVl
dWUoYmlvLT5iaV9iZGV2KSkKKwkJCQkJYmlvX2xpc3RfYWRkKCZzYW1lLCBiaW8pOworCQkJCWVs
c2UKKwkJCQkJYmlvX2xpc3RfYWRkKCZsb3dlciwgYmlvKTsKKwkJCS8qIG5vdyBhc3NlbWJsZSBz
byB3ZSBoYW5kbGUgdGhlIGxvd2VzdCBsZXZlbCBmaXJzdCAqLworCQkJYmlvX2xpc3RfbWVyZ2Uo
JmJpb19saXN0X29uX3N0YWNrLCAmbG93ZXIpOworCQkJYmlvX2xpc3RfbWVyZ2UoJmJpb19saXN0
X29uX3N0YWNrLCAmc2FtZSk7CisJCQliaW9fbGlzdF9tZXJnZSgmYmlvX2xpc3Rfb25fc3RhY2ss
ICZob2xkKTsKIAogCQkJYmlvID0gYmlvX2xpc3RfcG9wKGN1cnJlbnQtPmJpb19saXN0KTsKIAkJ
fSBlbHNlIHsKLS0gCjIuNy40Cgo=
--001a1141c938e083cc05442a92da--
