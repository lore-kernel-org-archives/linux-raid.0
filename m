Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F094FC77B75
	for <linux-raid@archiver.kernel.org>; Tue,  9 May 2023 02:10:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjEICKn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 May 2023 22:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjEICKm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 8 May 2023 22:10:42 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D3E2695
        for <linux-raid@vger.kernel.org>; Mon,  8 May 2023 19:10:36 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QFhT44hXcz4f3vdd
        for <linux-raid@vger.kernel.org>; Tue,  9 May 2023 10:10:32 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgD3X7OYq1lkLd45JA--.8001S3;
        Tue, 09 May 2023 10:10:33 +0800 (CST)
Subject: Re: Raid5 to raid6 grow interrupted, mdadm hangs on assemble command
To:     Jove <jovetoo@gmail.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Wol <antlists@youngman.org.uk>, linux-raid@vger.kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>, songliubraving@meta.com,
        Logan Gunthorpe <logang@deltatee.com>
References: <CAFig2csUV2QiomUhj_t3dPOgV300dbQ6XtM9ygKPdXJFSH__Nw@mail.gmail.com>
 <63d92097-5299-2ae8-9697-768c52678578@huaweicloud.com>
 <CAFig2ct4BJZ0A9BKuXn8RM71+KrUzB8vKGQY0fSjNZiNenQZBg@mail.gmail.com>
 <c71c8381-f26e-f7de-c6f5-3c4411f08b15@huaweicloud.com>
 <d159161d-a5eb-8790-49c4-b7013e66ba65@youngman.org.uk>
 <6f391690-992f-1196-3109-6d422b3522f7@huaweicloud.com>
 <CAFig2ct+ZbHYEho7p9eubaz-kozGR+GkSJ1tVL+LGaciUBixyw@mail.gmail.com>
 <bc698b03-446b-a42e-cf0c-5c1b3cb62559@huaweicloud.com>
 <CAFig2csN8qSEafSehM5oN-kO3FsK=6+vvyEeiYcbvqRkmoiN7Q@mail.gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <5862fb1d-33e0-acb1-d740-dd6fda27eaf4@huaweicloud.com>
Date:   Tue, 9 May 2023 10:10:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAFig2csN8qSEafSehM5oN-kO3FsK=6+vvyEeiYcbvqRkmoiN7Q@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------3C03CE93E2CB3FCE527696B3"
X-CM-TRANSID: gCh0CgD3X7OYq1lkLd45JA--.8001S3
X-Coremail-Antispam: 1UD129KBjvdXoW7Gr4rtr43urWfGw4rZFy7Jrb_yoWkKwbE9r
        1YvrnrGw1DWanF9r1rWFZ5tryxK3yDXryUJ34DKwsrXryrJF43WF4kGrn8u3Z2g34kKr9x
        Jr10v3y8A3sIvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbhAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487M2AExVA0xI801c8C04v7Mc02F40EFcxC0VAK
        zVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx
        8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwAC
        Y4xI67k04243AVC20s07Mxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I
        8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AK
        xVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcV
        AFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8I
        cIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI
        0_Jr0_Gr1l6VACY4xI67k04243AbIYCTnIWIevJa73UjIFyTuYvjfUO9NVDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This is a multi-part message in MIME format.
--------------3C03CE93E2CB3FCE527696B3
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi, Jove

在 2023/05/06 21:07, Jove 写道:
> Hi Kuai,
> 
> Just to confirm, the array seems fine after the reshape. Copying files now.
> 
> Would it be best if I scrap this array and create a new one or is this
> array safe to use in the long term? It had to use the --invalid-backup
> flag to get it to reshape, so there might be corruption before that
> resume point?
> 
> I have to do a reshape anyway, to 5 raid devices.
> 
>> In the meantime, I'll try to fix this deadlock, hope you don't mind a
>> reported-by tag.
> 
> I would not, thank you.
> 
> I still have the backup images of the drive in reshape. If you wish I
> can test any fix you create.

Here is the first verion of the fixed patch, I fail the io that is
waiting for reshape while reshape can't make progress. I tested in my
VM and it works as I expected. Can you give it a try to see if mdadm
can still assemble?

Thanks,
Kuai
> 
>> I have no idea why systemd-udevd is accessing the array.
> 
> My guess is it is accessing this array is because it checks it for the
> lvm layout so it can automatically create the /dev/mapper entries.
> With systemd-udevd disabled, these entries to not automatically
> appear.
> 
> And thank you again for getting me my data back.
> 
> Best regards,
> 
>     Johan
> .
> 

--------------3C03CE93E2CB3FCE527696B3
Content-Type: text/plain; charset=UTF-8;
 name="0001-md-fix-raid456-deadlock.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="0001-md-fix-raid456-deadlock.patch"

RnJvbSAxNTllYTdjOGQ1OTE4ODJkZmJiZGYzMDkzOGMxYzFkNWJjOWQ0OTMxIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBZdSBLdWFpIDx5dWt1YWkzQGh1YXdlaS5jb20+CkRh
dGU6IFR1ZSwgOSBNYXkgMjAyMyAwOToyODozNiArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIG1k
OiBmaXggcmFpZDQ1NiBkZWFkbG9jawoKU2lnbmVkLW9mZi1ieTogWXUgS3VhaSA8eXVrdWFp
M0BodWF3ZWkuY29tPgotLS0KIGRyaXZlcnMvbWQvbWQuYyAgICB8IDIwICsrKystLS0tLS0t
LS0tLS0tLS0tCiBkcml2ZXJzL21kL21kLmggICAgfCAxOCArKysrKysrKysrKysrKysrKysK
IGRyaXZlcnMvbWQvcmFpZDUuYyB8IDMyICsrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KystCiAzIGZpbGVzIGNoYW5nZWQsIDUzIGluc2VydGlvbnMoKyksIDE3IGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvbWQuYyBiL2RyaXZlcnMvbWQvbWQuYwppbmRl
eCA4ZTM0NGI0YjM0NDQuLjQ2MjUyOWU0N2YxOSAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZC9t
ZC5jCisrKyBiL2RyaXZlcnMvbWQvbWQuYwpAQCAtOTMsMTggKzkzLDYgQEAgc3RhdGljIGlu
dCByZW1vdmVfYW5kX2FkZF9zcGFyZXMoc3RydWN0IG1kZGV2ICptZGRldiwKIAkJCQkgc3Ry
dWN0IG1kX3JkZXYgKnRoaXMpOwogc3RhdGljIHZvaWQgbWRkZXZfZGV0YWNoKHN0cnVjdCBt
ZGRldiAqbWRkZXYpOwogCi1lbnVtIG1kX3JvX3N0YXRlIHsKLQlNRF9SRFdSLAotCU1EX1JE
T05MWSwKLQlNRF9BVVRPX1JFQUQsCi0JTURfTUFYX1NUQVRFCi19OwotCi1zdGF0aWMgYm9v
bCBtZF9pc19yZHdyKHN0cnVjdCBtZGRldiAqbWRkZXYpCi17Ci0JcmV0dXJuIChtZGRldi0+
cm8gPT0gTURfUkRXUik7Ci19Ci0KIC8qCiAgKiBEZWZhdWx0IG51bWJlciBvZiByZWFkIGNv
cnJlY3Rpb25zIHdlJ2xsIGF0dGVtcHQgb24gYW4gcmRldgogICogYmVmb3JlIGVqZWN0aW5n
IGl0IGZyb20gdGhlIGFycmF5LiBXZSBkaXZpZGUgdGhlIHJlYWQgZXJyb3IKQEAgLTM2MCwx
MCArMzQ4LDYgQEAgRVhQT1JUX1NZTUJPTF9HUEwobWRfbmV3X2V2ZW50KTsKIHN0YXRpYyBM
SVNUX0hFQUQoYWxsX21kZGV2cyk7CiBzdGF0aWMgREVGSU5FX1NQSU5MT0NLKGFsbF9tZGRl
dnNfbG9jayk7CiAKLXN0YXRpYyBib29sIGlzX21kX3N1c3BlbmRlZChzdHJ1Y3QgbWRkZXYg
Km1kZGV2KQotewotCXJldHVybiBwZXJjcHVfcmVmX2lzX2R5aW5nKCZtZGRldi0+YWN0aXZl
X2lvKTsKLX0KIC8qIFJhdGhlciB0aGFuIGNhbGxpbmcgZGlyZWN0bHkgaW50byB0aGUgcGVy
c29uYWxpdHkgbWFrZV9yZXF1ZXN0IGZ1bmN0aW9uLAogICogSU8gcmVxdWVzdHMgY29tZSBo
ZXJlIGZpcnN0IHNvIHRoYXQgd2UgY2FuIGNoZWNrIGlmIHRoZSBkZXZpY2UgaXMKICAqIGJl
aW5nIHN1c3BlbmRlZCBwZW5kaW5nIGEgcmVjb25maWd1cmF0aW9uLgpAQCAtNDY0LDYgKzQ0
OCwxMCBAQCB2b2lkIG1kZGV2X3N1c3BlbmQoc3RydWN0IG1kZGV2ICptZGRldikKIAl3YWtl
X3VwKCZtZGRldi0+c2Jfd2FpdCk7CiAJc2V0X2JpdChNRF9BTExPV19TQl9VUERBVEUsICZt
ZGRldi0+ZmxhZ3MpOwogCXBlcmNwdV9yZWZfa2lsbCgmbWRkZXYtPmFjdGl2ZV9pbyk7CisK
KwlpZiAobWRkZXYtPnBlcnMtPnByZXBhcmVfc3VzcGVuZCkKKwkJbWRkZXYtPnBlcnMtPnBy
ZXBhcmVfc3VzcGVuZChtZGRldik7CisKIAl3YWl0X2V2ZW50KG1kZGV2LT5zYl93YWl0LCBw
ZXJjcHVfcmVmX2lzX3plcm8oJm1kZGV2LT5hY3RpdmVfaW8pKTsKIAltZGRldi0+cGVycy0+
cXVpZXNjZShtZGRldiwgMSk7CiAJY2xlYXJfYml0X3VubG9jayhNRF9BTExPV19TQl9VUERB
VEUsICZtZGRldi0+ZmxhZ3MpOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9tZC5oIGIvZHJp
dmVycy9tZC9tZC5oCmluZGV4IGZkOGYyNjBlZDVmOC4uMjkyYjk2YTE1ODkwIDEwMDY0NAot
LS0gYS9kcml2ZXJzL21kL21kLmgKKysrIGIvZHJpdmVycy9tZC9tZC5oCkBAIC01MzYsNiAr
NTM2LDIzIEBAIHN0cnVjdCBtZGRldiB7CiAJYm9vbAlzZXJpYWxpemVfcG9saWN5OjE7CiB9
OwogCitlbnVtIG1kX3JvX3N0YXRlIHsKKwlNRF9SRFdSLAorCU1EX1JET05MWSwKKwlNRF9B
VVRPX1JFQUQsCisJTURfTUFYX1NUQVRFCit9OworCitzdGF0aWMgaW5saW5lIGJvb2wgbWRf
aXNfcmR3cihzdHJ1Y3QgbWRkZXYgKm1kZGV2KQoreworCXJldHVybiAobWRkZXYtPnJvID09
IE1EX1JEV1IpOworfQorCitzdGF0aWMgaW5saW5lIGJvb2wgaXNfbWRfc3VzcGVuZGVkKHN0
cnVjdCBtZGRldiAqbWRkZXYpCit7CisJcmV0dXJuIHBlcmNwdV9yZWZfaXNfZHlpbmcoJm1k
ZGV2LT5hY3RpdmVfaW8pOworfQorCiBlbnVtIHJlY292ZXJ5X2ZsYWdzIHsKIAkvKgogCSAq
IElmIG5laXRoZXIgU1lOQyBvciBSRVNIQVBFIGFyZSBzZXQsIHRoZW4gaXQgaXMgYSByZWNv
dmVyeS4KQEAgLTYxNCw2ICs2MzEsNyBAQCBzdHJ1Y3QgbWRfcGVyc29uYWxpdHkKIAlpbnQg
KCpzdGFydF9yZXNoYXBlKSAoc3RydWN0IG1kZGV2ICptZGRldik7CiAJdm9pZCAoKmZpbmlz
aF9yZXNoYXBlKSAoc3RydWN0IG1kZGV2ICptZGRldik7CiAJdm9pZCAoKnVwZGF0ZV9yZXNo
YXBlX3BvcykgKHN0cnVjdCBtZGRldiAqbWRkZXYpOworCXZvaWQgKCpwcmVwYXJlX3N1c3Bl
bmQpIChzdHJ1Y3QgbWRkZXYgKm1kZGV2KTsKIAkvKiBxdWllc2NlIHN1c3BlbmRzIG9yIHJl
c3VtZXMgaW50ZXJuYWwgcHJvY2Vzc2luZy4KIAkgKiAxIC0gc3RvcCBuZXcgYWN0aW9ucyBh
bmQgd2FpdCBmb3IgYWN0aW9uIGlvIHRvIGNvbXBsZXRlCiAJICogMCAtIHJldHVybiB0byBu
b3JtYWwgYmVoYXZpb3VyCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL3JhaWQ1LmMgYi9kcml2
ZXJzL21kL3JhaWQ1LmMKaW5kZXggODEyYTEyZTNlNDFhLi41YTI0OTM1YzExM2QgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvbWQvcmFpZDUuYworKysgYi9kcml2ZXJzL21kL3JhaWQ1LmMKQEAg
LTc2MSw2ICs3NjEsNyBAQCBlbnVtIHN0cmlwZV9yZXN1bHQgewogCVNUUklQRV9SRVRSWSwK
IAlTVFJJUEVfU0NIRURVTEVfQU5EX1JFVFJZLAogCVNUUklQRV9GQUlMLAorCVNUUklQRV9G
QUlMX0FORF9SRVRSWSwKIH07CiAKIHN0cnVjdCBzdHJpcGVfcmVxdWVzdF9jdHggewpAQCAt
NTk5Nyw3ICs1OTk4LDggQEAgc3RhdGljIGVudW0gc3RyaXBlX3Jlc3VsdCBtYWtlX3N0cmlw
ZV9yZXF1ZXN0KHN0cnVjdCBtZGRldiAqbWRkZXYsCiAJCQlpZiAoYWhlYWRfb2ZfcmVzaGFw
ZShtZGRldiwgbG9naWNhbF9zZWN0b3IsCiAJCQkJCSAgICAgY29uZi0+cmVzaGFwZV9zYWZl
KSkgewogCQkJCXNwaW5fdW5sb2NrX2lycSgmY29uZi0+ZGV2aWNlX2xvY2spOwotCQkJCXJl
dHVybiBTVFJJUEVfU0NIRURVTEVfQU5EX1JFVFJZOworCQkJCXJldCA9IFNUUklQRV9TQ0hF
RFVMRV9BTkRfUkVUUlk7CisJCQkJZ290byBvdXQ7CiAJCQl9CiAJCX0KIAkJc3Bpbl91bmxv
Y2tfaXJxKCZjb25mLT5kZXZpY2VfbG9jayk7CkBAIC02MDc2LDYgKzYwNzgsMTggQEAgc3Rh
dGljIGVudW0gc3RyaXBlX3Jlc3VsdCBtYWtlX3N0cmlwZV9yZXF1ZXN0KHN0cnVjdCBtZGRl
diAqbWRkZXYsCiAKIG91dF9yZWxlYXNlOgogCXJhaWQ1X3JlbGVhc2Vfc3RyaXBlKHNoKTsK
K291dDoKKwkvKgorCSAqIFRoZXJlIGlzIG5vIHBvaW50IHRvIHdhaXQgZm9yIHJlc2hhcGUg
YmVjYXVzZSByZXNoYXBlIGNhbid0IG1ha2UKKwkgKiBwcm9ncmVzcyBpZiB0aGUgYXJyYXkg
aXMgc3VzcGVuZGVkIG9yIGlzIG5vdCByZWFkIHdyaXRlLgorCSAqLworCWlmIChyZXQgPT0g
U1RSSVBFX1NDSEVEVUxFX0FORF9SRVRSWSAmJgorCSAgICAoaXNfbWRfc3VzcGVuZGVkKG1k
ZGV2KSB8fCAhbWRfaXNfcmR3cihtZGRldikpKSB7CisJCWJpLT5iaV9zdGF0dXMgPSBCTEtf
U1RTX0lPRVJSOworCQlyZXQgPSBTVFJJUEVfRkFJTDsKKwkJcHJfZXJyKCJtZC9yYWlkNDU2
OiVzOiBhcnJheSBpcyBzdXNwZW5kZWQgb3Igbm90IHJlYWQgd3JpdGUsIGlvIGFjY3Jvc3Mg
cmVzaGFwZSBwb3NpdGlvbiBmYWlsZWQsIHBsZWFzZSB0cnkgYWdhaW4gYWZ0ZXIgcmVzaGFw
ZS5cbiIsCisJCSAgICAgICBtZG5hbWUobWRkZXYpKTsKKwl9CiAJcmV0dXJuIHJldDsKIH0K
IApAQCAtODY1NCw2ICs4NjY4LDE5IEBAIHN0YXRpYyB2b2lkIHJhaWQ1X2ZpbmlzaF9yZXNo
YXBlKHN0cnVjdCBtZGRldiAqbWRkZXYpCiAJfQogfQogCitzdGF0aWMgdm9pZCByYWlkNV9w
cmVwYXJlX3N1c3BlbmQoc3RydWN0IG1kZGV2ICptZGRldikKK3sKKwlzdHJ1Y3QgcjVjb25m
ICpjb25mID0gbWRkZXYtPnByaXZhdGU7CisKKwkvKgorCSAqIEJlZm9yZSB3YWl0aW5nIGZv
ciBhY3RpdmVfaW8gdG8gYmUgZG9uZSwgZmFpbCBhbGwgdGhlIGlvIHRoYXQgaXMKKwkgKiB3
YWl0aW5nIGZvciByZXNoYXBlIGJlY2F1c2UgdGhleSBjYW4gbmV2ZXIgYmUgZG9uZSBhZnRl
ciBzdXNwZW5kLgorCSAqCisJICogUGVyaGFwcyBpdCdzIGJldHRlciB0byBsZXQgdGhvc2Ug
aW8gd2FpdCBmb3IgcmVzdW1lIHRoYW4gZmFpbGluZy4KKwkgKi8KKwl3YWtlX3VwKCZjb25m
LT53YWl0X2Zvcl9vdmVybGFwKTsKK30KKwogc3RhdGljIHZvaWQgcmFpZDVfcXVpZXNjZShz
dHJ1Y3QgbWRkZXYgKm1kZGV2LCBpbnQgcXVpZXNjZSkKIHsKIAlzdHJ1Y3QgcjVjb25mICpj
b25mID0gbWRkZXYtPnByaXZhdGU7CkBAIC05MDIwLDYgKzkwNDcsNyBAQCBzdGF0aWMgc3Ry
dWN0IG1kX3BlcnNvbmFsaXR5IHJhaWQ2X3BlcnNvbmFsaXR5ID0KIAkuY2hlY2tfcmVzaGFw
ZQk9IHJhaWQ2X2NoZWNrX3Jlc2hhcGUsCiAJLnN0YXJ0X3Jlc2hhcGUgID0gcmFpZDVfc3Rh
cnRfcmVzaGFwZSwKIAkuZmluaXNoX3Jlc2hhcGUgPSByYWlkNV9maW5pc2hfcmVzaGFwZSwK
KwkucHJlcGFyZV9zdXNwZW5kID0gcmFpZDVfcHJlcGFyZV9zdXNwZW5kLAogCS5xdWllc2Nl
CT0gcmFpZDVfcXVpZXNjZSwKIAkudGFrZW92ZXIJPSByYWlkNl90YWtlb3ZlciwKIAkuY2hh
bmdlX2NvbnNpc3RlbmN5X3BvbGljeSA9IHJhaWQ1X2NoYW5nZV9jb25zaXN0ZW5jeV9wb2xp
Y3ksCkBAIC05MDQ0LDYgKzkwNzIsNyBAQCBzdGF0aWMgc3RydWN0IG1kX3BlcnNvbmFsaXR5
IHJhaWQ1X3BlcnNvbmFsaXR5ID0KIAkuY2hlY2tfcmVzaGFwZQk9IHJhaWQ1X2NoZWNrX3Jl
c2hhcGUsCiAJLnN0YXJ0X3Jlc2hhcGUgID0gcmFpZDVfc3RhcnRfcmVzaGFwZSwKIAkuZmlu
aXNoX3Jlc2hhcGUgPSByYWlkNV9maW5pc2hfcmVzaGFwZSwKKwkucHJlcGFyZV9zdXNwZW5k
ID0gcmFpZDVfcHJlcGFyZV9zdXNwZW5kLAogCS5xdWllc2NlCT0gcmFpZDVfcXVpZXNjZSwK
IAkudGFrZW92ZXIJPSByYWlkNV90YWtlb3ZlciwKIAkuY2hhbmdlX2NvbnNpc3RlbmN5X3Bv
bGljeSA9IHJhaWQ1X2NoYW5nZV9jb25zaXN0ZW5jeV9wb2xpY3ksCkBAIC05MDY5LDYgKzkw
OTgsNyBAQCBzdGF0aWMgc3RydWN0IG1kX3BlcnNvbmFsaXR5IHJhaWQ0X3BlcnNvbmFsaXR5
ID0KIAkuY2hlY2tfcmVzaGFwZQk9IHJhaWQ1X2NoZWNrX3Jlc2hhcGUsCiAJLnN0YXJ0X3Jl
c2hhcGUgID0gcmFpZDVfc3RhcnRfcmVzaGFwZSwKIAkuZmluaXNoX3Jlc2hhcGUgPSByYWlk
NV9maW5pc2hfcmVzaGFwZSwKKwkucHJlcGFyZV9zdXNwZW5kID0gcmFpZDVfcHJlcGFyZV9z
dXNwZW5kLAogCS5xdWllc2NlCT0gcmFpZDVfcXVpZXNjZSwKIAkudGFrZW92ZXIJPSByYWlk
NF90YWtlb3ZlciwKIAkuY2hhbmdlX2NvbnNpc3RlbmN5X3BvbGljeSA9IHJhaWQ1X2NoYW5n
ZV9jb25zaXN0ZW5jeV9wb2xpY3ksCi0tIAoyLjM5LjIKCg==
--------------3C03CE93E2CB3FCE527696B3--

