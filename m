From: Song Liu <song@kernel.org>
Subject: Re: Assemblin journaled array fails
Date: Mon, 6 Jul 2020 15:08:56 -0700
Message-ID: <CAPhsuW4Y-23m7JexbnUCO3pq6+yTNrMrN6v-od+FFzZU8PgCdA@mail.gmail.com>
References: <f8c61278-1758-66cd-cf25-8a118cb12f58@yandex.pl>
 <0cf6454d-a8b5-4bee-5389-94b23c077050@yandex.pl> <CAPhsuW51u6KWLvUntMXPU7stu7oSA+d-yT6zf7G0zCETzLWwiA@mail.gmail.com>
 <49efa0d2-b44c-ec85-5e44-fb93a15001e7@yandex.pl> <4df42e3d-ad2b-dfc2-3961-49ada4ea7eaf@yandex.pl>
 <CAPhsuW5kk0G9PSfEADc8+rn=QT2z4ogjuV98qWsH_s_WBic-5w@mail.gmail.com>
 <71f58507-314e-4a1d-dd50-41a60d76521b@yandex.pl> <CAPhsuW59Q7mU9WH36RHs9kb-TMk7FmrQL+JCApupf_TZtpWynA@mail.gmail.com>
 <4a03e900-61a8-f150-9be8-739e88ba8ce6@yandex.pl> <CAPhsuW4BZE-DeESsq-coNx5_KZrfHjP=d9YOjOPqPji5kQBXjg@mail.gmail.com>
 <a772ede5-1d6f-e7cd-e949-a5d81d0fdbd1@yandex.pl> <CAPhsuW5hwAMTy8ozpsT+n5F3M7NzKqBdheFZvnouZEv8hEqAxQ@mail.gmail.com>
 <4b426e56-f971-67cf-81c0-63e035bf492a@yandex.pl> <CAPhsuW6fvgRCz7X7nnCEof4+yy2fTsxShNCuqTkMC0JQpj6gKw@mail.gmail.com>
 <57247f5e-ec38-fb8c-9684-abbe699945fb@yandex.pl> <CAPhsuW4hnpsbhQWWNKqgnw4nhp4Ho+gFbPU2fGjoMOcM8y7L+Q@mail.gmail.com>
 <15a3dd66-39a9-894d-3e72-d231cf36758e@yandex.pl> <4577498e-4124-ac6f-9d76-1f039fa1ba80@yandex.pl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="000000000000a22b2305a9cd1f8f"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4577498e-4124-ac6f-9d76-1f039fa1ba80@yandex.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <msoltyspl@yandex.pl>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--000000000000a22b2305a9cd1f8f
Content-Type: text/plain; charset="UTF-8"

On Mon, Jul 6, 2020 at 1:07 AM Michal Soltys <msoltyspl@yandex.pl> wrote:
>
> On 20/06/25 18:11, Michal Soltys wrote:
> > On 6/24/20 1:13 AM, Song Liu wrote:
> >> On Tue, Jun 23, 2020 at 6:17 AM Michal Soltys <msoltyspl@yandex.pl>
> >> wrote:
> >>
> >> Hmm.. this is weird, as I think I marked every instance of set_bit
> >> MD_SB_CHANGE_PENDING.
> >> Would you mind confirm those are to the other array with something like:
> >>
> >> diff --git i/drivers/md/md.c w/drivers/md/md.c
> >> index dbbc8a50e2ed2..e91acfdcec032 100644
> >> --- i/drivers/md/md.c
> >> +++ w/drivers/md/md.c
> >> @@ -8480,7 +8480,7 @@ bool md_write_start(struct mddev *mddev, struct
> >> bio *bi)
> >>                          mddev->in_sync = 0;
> >>                          set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
> >>                          set_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
> >> -                       pr_info("%s set MD_SB_CHANGE_PENDING\n",
> >> __func__);
> >> +                       pr_info("%s: md: %s set
> >> MD_SB_CHANGE_PENDING\n", __func__, mdname(mddev));
> >>                          md_wakeup_thread(mddev->thread);
> >>                          did_change = 1;
> >>                  }
> >>
> >> Thanks,
> >> Song
> >>
> >
> > dmesg attached
> > - md127 - journal
> > - md126 - the other raid
> > - md125 - the problematic one
>
> So, what kind of next step after this ?

Sorry for the delay. I read the log again, and found the following
line caused this issue:

[ +16.088243] r5l_write_super_and_discard_space set MD_SB_CHANGE_PENDING

The attached patch should workaround this issue. Could you please give it a try?

Thanks,
song

--000000000000a22b2305a9cd1f8f
Content-Type: application/octet-stream;
	name="0001-md-raid5-cache-clear-MD_SB_CHANGE_PENDING-before-flu.patch"
Content-Disposition: attachment;
	filename="0001-md-raid5-cache-clear-MD_SB_CHANGE_PENDING-before-flu.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kcb21tqn0>
X-Attachment-Id: f_kcb21tqn0

RnJvbSBjZTMxMDcyOGVhNWU4NDIwZTlmNjJmMTFlMzk2OWMyMTAwYWY3YzgxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTb25nIExpdSA8c29uZ2xpdWJyYXZpbmdAZmIuY29tPgpEYXRl
OiBNb24sIDYgSnVsIDIwMjAgMTQ6NTc6MzIgLTA3MDAKU3ViamVjdDogW1BBVENIXSBtZC9yYWlk
NS1jYWNoZTogY2xlYXIgTURfU0JfQ0hBTkdFX1BFTkRJTkcgYmVmb3JlIGZsdXNoaW5nCiBkYXRh
IG9ubHkgc3RyaXBlcwoKU2lnbmVkLW9mZi1ieTogU29uZyBMaXUgPHNvbmdsaXVicmF2aW5nQGZi
LmNvbT4KLS0tCiBkcml2ZXJzL21kL3JhaWQ1LWNhY2hlLmMgfCA3ICsrKysrKysKIDEgZmlsZSBj
aGFuZ2VkLCA3IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL3JhaWQ1LWNh
Y2hlLmMgYi9kcml2ZXJzL21kL3JhaWQ1LWNhY2hlLmMKaW5kZXggOWI2ZGE3NTlkY2EyNS4uMGJl
YTIxZDgxNjk3ZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZC9yYWlkNS1jYWNoZS5jCisrKyBiL2Ry
aXZlcnMvbWQvcmFpZDUtY2FjaGUuYwpAQCAtMjQzMCwxMCArMjQzMCwxNSBAQCBzdGF0aWMgdm9p
ZCByNWNfcmVjb3ZlcnlfZmx1c2hfZGF0YV9vbmx5X3N0cmlwZXMoc3RydWN0IHI1bF9sb2cgKmxv
ZywKIAlzdHJ1Y3QgbWRkZXYgKm1kZGV2ID0gbG9nLT5yZGV2LT5tZGRldjsKIAlzdHJ1Y3QgcjVj
b25mICpjb25mID0gbWRkZXYtPnByaXZhdGU7CiAJc3RydWN0IHN0cmlwZV9oZWFkICpzaCwgKm5l
eHQ7CisJYm9vbCBjbGVhcmVkX3BlbmRpbmcgPSBmYWxzZTsKIAogCWlmIChjdHgtPmRhdGFfb25s
eV9zdHJpcGVzID09IDApCiAJCXJldHVybjsKIAorCWlmICh0ZXN0X2JpdChNRF9TQl9DSEFOR0Vf
UEVORElORywgJm1kZGV2LT5zYl9mbGFncykpIHsKKwkJY2xlYXJlZF9wZW5kaW5nID0gdHJ1ZTsK
KwkJY2xlYXJfYml0KE1EX1NCX0NIQU5HRV9QRU5ESU5HLCAmbWRkZXYtPnNiX2ZsYWdzKTsKKwl9
CiAJbG9nLT5yNWNfam91cm5hbF9tb2RlID0gUjVDX0pPVVJOQUxfTU9ERV9XUklURV9CQUNLOwog
CiAJbGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKHNoLCBuZXh0LCAmY3R4LT5jYWNoZWRfbGlzdCwg
bHJ1KSB7CkBAIC0yNDQ4LDYgKzI0NTMsOCBAQCBzdGF0aWMgdm9pZCByNWNfcmVjb3ZlcnlfZmx1
c2hfZGF0YV9vbmx5X3N0cmlwZXMoc3RydWN0IHI1bF9sb2cgKmxvZywKIAkJICAgYXRvbWljX3Jl
YWQoJmNvbmYtPmFjdGl2ZV9zdHJpcGVzKSA9PSAwKTsKIAogCWxvZy0+cjVjX2pvdXJuYWxfbW9k
ZSA9IFI1Q19KT1VSTkFMX01PREVfV1JJVEVfVEhST1VHSDsKKwlpZiAoY2xlYXJlZF9wZW5kaW5n
KQorCQlzZXRfYml0KE1EX1NCX0NIQU5HRV9QRU5ESU5HLCAmbWRkZXYtPnNiX2ZsYWdzKTsKIH0K
IAogc3RhdGljIGludCByNWxfcmVjb3ZlcnlfbG9nKHN0cnVjdCByNWxfbG9nICpsb2cpCi0tIAoy
LjI0LjEKCg==
--000000000000a22b2305a9cd1f8f--
