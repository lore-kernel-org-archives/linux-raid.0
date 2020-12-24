Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89398C433DB
	for <linux-raid@archiver.kernel.org>; Thu, 24 Dec 2020 10:20:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EB2A221F2
	for <linux-raid@archiver.kernel.org>; Thu, 24 Dec 2020 10:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgLXKUV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 24 Dec 2020 05:20:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26278 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726839AbgLXKUU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 24 Dec 2020 05:20:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608805133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yeB6niYXa2OA9mrrL3D4yoNCSTaKFJOJV2ZNcVrGP7M=;
        b=IwXkUd3l7JJISMvbOzeT0gw6pVcfn1ETPv1FdSfyM/jHsSaus26ekczYKqQ5o4v8Rl5asp
        WNzDyL6oN0fXXn3Fcsc1WYYf+iewsiSLYbCJowX4SKleDn+Plc6XaWW9CSU1tx+SbEnyRi
        JHKRdy4iuW0+p11SeitPWlSboXqbcqs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-EGMKA78YOPGybCBbFKbQWg-1; Thu, 24 Dec 2020 05:18:48 -0500
X-MC-Unique: EGMKA78YOPGybCBbFKbQWg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DFBF4801AC0;
        Thu, 24 Dec 2020 10:18:46 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-28.pek2.redhat.com [10.72.8.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C67760BFA;
        Thu, 24 Dec 2020 10:18:42 +0000 (UTC)
Subject: Re: PROBLEM: Recent raid10 block discard patchset causes filesystem
 corruption on fstrim
To:     Song Liu <songliubraving@fb.com>,
        Matthew Ruffell <matthew.ruffell@canonical.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Song Liu <song@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Coly Li <colyli@suse.de>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        "khalid.elmously@canonical.com" <khalid.elmously@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
References: <dbd2761e-cd7d-d60a-f769-ecc8c6335814@canonical.com>
 <EA47EF7A-06D8-4B37-BED7-F04753D70DF5@fb.com>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <a85943ed-60d4-05ad-9f6d-d76324fa5538@redhat.com>
Date:   Thu, 24 Dec 2020 18:18:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <EA47EF7A-06D8-4B37-BED7-F04753D70DF5@fb.com>
Content-Type: multipart/mixed;
 boundary="------------C9881F6387E4A199DD38C2E2"
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This is a multi-part message in MIME format.
--------------C9881F6387E4A199DD38C2E2
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/09/2020 12:17 PM, Song Liu wrote:
> Hi Matthew,
>
>> On Dec 8, 2020, at 7:46 PM, Matthew Ruffell <matthew.ruffell@canonical.com> wrote:
>>
>> Hello,
>>
>> I recently backported the following patches into the Ubuntu stable kernels:
>>
>> md: add md_submit_discard_bio() for submitting discard bio
>> md/raid10: extend r10bio devs to raid disks
>> md/raid10: pull codes that wait for blocked dev into one function
>> md/raid10: improve raid10 discard request
>> md/raid10: improve discard request for far layout
>> dm raid: fix discard limits for raid1 and raid10
>> dm raid: remove unnecessary discard limits for raid10
> Thanks for the report!
>
> Hi Xiao,
>
> Could you please take a look at this and let me know soon? We need to fix
> this before 5.10 official release.
>
> Thanks,
> Song
>
Hi all

The root cause is found. Now we use a similar way with raid0 to handle 
discard request
for raid10. Because the discard region is very big, we can calculate the 
start/end address
for each disk. Then we can submit the discard request to each disk. But 
for raid10, it has
copies. For near layout, if the discard request doesn't align with chunk 
size, we calculate
a start_disk_offset. Now we only use start_disk_offset for the first 
disk, but it should be
used for the near copies disks too.

[  789.709501] discard bio start : 70968, size : 191176
[  789.709507] first stripe index 69, start disk index 0, start disk 
offset 70968
[  789.709509] last stripe index 256, end disk index 0, end disk offset 
262144
[  789.709511] disk 0, dev start : 70968, dev end : 262144
[  789.709515] disk 1, dev start : 70656, dev end : 262144

For example, in this test case, it has 2 near copies. The 
start_disk_offset for the first disk is 70968.
It should use the same offset address for second disk. But it uses the 
start address of this chunk.
It discard more region. The patch in the attachment can fix this 
problem. It split the region that
doesn't align with chunk size.

There is another problem. The stripe size should be calculated 
differently for near layout and far layout.

@Song, do you want me to use a separate patch for this fix, or fix this 
in the original patch?

Merry Christmas
Xiao


--------------C9881F6387E4A199DD38C2E2
Content-Type: text/plain; charset=UTF-8;
 name="fix-raid10-discard-patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="fix-raid10-discard-patch"

Y29tbWl0IDBkNzRhYzY2ZWQwZWM1YWY3MDI5NjU0NWUyNjA0NDcyM2ExNDY1N2MKQXV0aG9y
OiBYaWFvIE5pIDx4bmlAcmVkaGF0LmNvbT4KRGF0ZTogICBUaHUgRGVjIDI0IDE3OjU4OjQz
IDIwMjAgKzA4MDAKCiAgICBmaXgKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL3JhaWQxMC5j
IGIvZHJpdmVycy9tZC9yYWlkMTAuYwppbmRleCAzMTUzMTgzYjc3NzIuLjkyMTgyY2Y0MGQy
MiAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZC9yYWlkMTAuYworKysgYi9kcml2ZXJzL21kL3Jh
aWQxMC5jCkBAIC0xNjA0LDYgKzE2MDQsNyBAQCBzdGF0aWMgaW50IHJhaWQxMF9oYW5kbGVf
ZGlzY2FyZChzdHJ1Y3QgbWRkZXYgKm1kZGV2LCBzdHJ1Y3QgYmlvICpiaW8pCiAJc2VjdG9y
X3QgY2h1bms7CiAJdW5zaWduZWQgaW50IHN0cmlwZV9zaXplOwogCXNlY3Rvcl90IHNwbGl0
X3NpemU7CisJc2VjdG9yX3QgY2h1bmtfc2l6ZSA9IDEgPDwgZ2VvLT5jaHVua19zaGlmdDsK
IAogCXNlY3Rvcl90IGJpb19zdGFydCwgYmlvX2VuZDsKIAlzZWN0b3JfdCBmaXJzdF9zdHJp
cGVfaW5kZXgsIGxhc3Rfc3RyaXBlX2luZGV4OwpAQCAtMTYyNCw3ICsxNjI1LDggQEAgc3Rh
dGljIGludCByYWlkMTBfaGFuZGxlX2Rpc2NhcmQoc3RydWN0IG1kZGV2ICptZGRldiwgc3Ry
dWN0IGJpbyAqYmlvKQogCWlmICh0ZXN0X2JpdChNRF9SRUNPVkVSWV9SRVNIQVBFLCAmbWRk
ZXYtPnJlY292ZXJ5KSkKIAkJZ290byBvdXQ7CiAKLQlzdHJpcGVfc2l6ZSA9IGdlby0+cmFp
ZF9kaXNrcyA8PCBnZW8tPmNodW5rX3NoaWZ0OworCXN0cmlwZV9zaXplID0gZ2VvLT5uZWFy
X2NvcGllcyA/IGdlby0+bmVhcl9jb3BpZXMgPDwgZ2VvLT5jaHVua19zaGlmdDoKKwkJCQln
ZW8tPnJhaWRfZGlza3MgPDwgZ2VvLT5jaHVua19zaGlmdDsKIAliaW9fc3RhcnQgPSBiaW8t
PmJpX2l0ZXIuYmlfc2VjdG9yOwogCWJpb19lbmQgPSBiaW9fZW5kX3NlY3RvcihiaW8pOwog
CkBAIC0xNjM3LDYgKzE2MzksMTggQEAgc3RhdGljIGludCByYWlkMTBfaGFuZGxlX2Rpc2Nh
cmQoc3RydWN0IG1kZGV2ICptZGRldiwgc3RydWN0IGJpbyAqYmlvKQogCWlmIChiaW9fc2Vj
dG9ycyhiaW8pIDwgc3RyaXBlX3NpemUqMikKIAkJZ290byBvdXQ7CiAKKwkvKiBLZWVwIHRo
ZSBkaXNjYXJkIHN0YXJ0L2VuZCBhZGRyZXNzIGFsaWduZWQgd2l0aCBjaHVuayBzaXplICov
CisJaWYgKGJpb19zdGFydCAmIGdlby0+Y2h1bmtfbWFzaykgeworCQlzcGxpdF9zaXplID0g
KGNodW5rX3NpemUgLSAoYmlvX3N0YXJ0ICYgZ2VvLT5jaHVua19tYXNrKSk7CisJCWJpbyA9
IHJhaWQxMF9zcGxpdF9iaW8oY29uZiwgYmlvLCBzcGxpdF9zaXplLCBmYWxzZSk7CisJfQor
CWlmIChiaW9fZW5kICYgZ2VvLT5jaHVua19tYXNrKSB7CisJCXNwbGl0X3NpemUgPSBiaW9f
ZW5kICYgZ2VvLT5jaHVua19tYXNrOworCQliaW8gPSByYWlkMTBfc3BsaXRfYmlvKGNvbmYs
IGJpbywgc3BsaXRfc2l6ZSwgdHJ1ZSk7CisJfQorCWJpb19zdGFydCA9IGJpby0+YmlfaXRl
ci5iaV9zZWN0b3I7CisJYmlvX2VuZCA9IGJpb19lbmRfc2VjdG9yKGJpbyk7CisKIAkvKiBG
b3IgZmFyIGFuZCBmYXIgb2Zmc2V0IGxheW91dCwgaWYgYmlvIGlzIG5vdCBhbGlnbmVkIHdp
dGggc3RyaXBlIHNpemUsCiAJICogaXQgc3BsaXRzIHRoZSBwYXJ0IHRoYXQgaXMgbm90IGFs
aWduZWQgd2l0aCBzdHJpcCBzaXplLgogCSAqLwpAQCAtMTY2NCw4ICsxNjc4LDggQEAgc3Rh
dGljIGludCByYWlkMTBfaGFuZGxlX2Rpc2NhcmQoc3RydWN0IG1kZGV2ICptZGRldiwgc3Ry
dWN0IGJpbyAqYmlvKQogCXN0YXJ0X2Rpc2tfaW5kZXggPSBzZWN0b3JfZGl2KGZpcnN0X3N0
cmlwZV9pbmRleCwgZ2VvLT5yYWlkX2Rpc2tzKTsKIAlpZiAoZ2VvLT5mYXJfb2Zmc2V0KQog
CQlmaXJzdF9zdHJpcGVfaW5kZXggKj0gZ2VvLT5mYXJfY29waWVzOwotCXN0YXJ0X2Rpc2tf
b2Zmc2V0ID0gKGJpb19zdGFydCAmIGdlby0+Y2h1bmtfbWFzaykgKwotCQkJCShmaXJzdF9z
dHJpcGVfaW5kZXggPDwgZ2VvLT5jaHVua19zaGlmdCk7CisJLyogTm93IHRoZSBiaW8gaXMg
YWxpZ25lZCB3aXRoIGNodW5rIHNpemUgKi8KKwlzdGFydF9kaXNrX29mZnNldCA9IGZpcnN0
X3N0cmlwZV9pbmRleCA8PCBnZW8tPmNodW5rX3NoaWZ0OwogCiAJY2h1bmsgPSBiaW9fZW5k
ID4+IGdlby0+Y2h1bmtfc2hpZnQ7CiAJY2h1bmsgKj0gZ2VvLT5uZWFyX2NvcGllczsKQEAg
LTE2NzMsOCArMTY4Nyw3IEBAIHN0YXRpYyBpbnQgcmFpZDEwX2hhbmRsZV9kaXNjYXJkKHN0
cnVjdCBtZGRldiAqbWRkZXYsIHN0cnVjdCBiaW8gKmJpbykKIAllbmRfZGlza19pbmRleCA9
IHNlY3Rvcl9kaXYobGFzdF9zdHJpcGVfaW5kZXgsIGdlby0+cmFpZF9kaXNrcyk7CiAJaWYg
KGdlby0+ZmFyX29mZnNldCkKIAkJbGFzdF9zdHJpcGVfaW5kZXggKj0gZ2VvLT5mYXJfY29w
aWVzOwotCWVuZF9kaXNrX29mZnNldCA9IChiaW9fZW5kICYgZ2VvLT5jaHVua19tYXNrKSAr
Ci0JCQkJKGxhc3Rfc3RyaXBlX2luZGV4IDw8IGdlby0+Y2h1bmtfc2hpZnQpOworCWVuZF9k
aXNrX29mZnNldCA9IGxhc3Rfc3RyaXBlX2luZGV4IDw8IGdlby0+Y2h1bmtfc2hpZnQ7CiAK
IHJldHJ5X2Rpc2NhcmQ6CiAJcjEwX2JpbyA9IG1lbXBvb2xfYWxsb2MoJmNvbmYtPnIxMGJp
b19wb29sLCBHRlBfTk9JTyk7Cg==
--------------C9881F6387E4A199DD38C2E2--

