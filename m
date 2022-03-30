Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BDA7C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 30 Mar 2022 18:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350227AbiC3SxZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 30 Mar 2022 14:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350519AbiC3Swn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 30 Mar 2022 14:52:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525863BFAA
        for <linux-raid@vger.kernel.org>; Wed, 30 Mar 2022 11:50:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF2B5B81D51
        for <linux-raid@vger.kernel.org>; Wed, 30 Mar 2022 18:50:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5993CC340F0
        for <linux-raid@vger.kernel.org>; Wed, 30 Mar 2022 18:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648666255;
        bh=1RizIn/xokB/1aZ5ppjNFN40VFqF7dqhe796Ubz9x18=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=c4jG+sxKpIpJPuIz4nM8cM6UAbGXqRCLGbux3T2K9kP2HaVDMYRXBSEkG6tRHuDO0
         8cfR1gmM29WtHI/cdkDO53PQHFA8XEiHNXw3i1os2L/RYW5rZuuZilGSo86OHLxWO9
         FQCPh0UNYo09CLhXQ8ySZt6//ry0O6+Et+XtGNqdFaVFb2j5ucEkP5xXCPEO1ZUkH2
         afiKVzL7wMEaOyWrTQr6oW64C3ZPmTN7w409qwbyoYdpGWui8vcZZoqeo0LZKFjlkJ
         3xpxi92uBf7hhuWzmNs/TPCQsNWlzkhblQGkDW0WK1N/2+HjJ8dStOU9rgSC33cDRA
         ATQOJV1I5syUg==
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-2e6650cde1bso228920737b3.12
        for <linux-raid@vger.kernel.org>; Wed, 30 Mar 2022 11:50:55 -0700 (PDT)
X-Gm-Message-State: AOAM531yPkW0xNKj0EXalIz89h2ahzZbNPEvbS3zZAPgvxPn8NSnJGmr
        n8GQx4k2GomCBhCzQHdav/b5vST9kG17lfiNE7s=
X-Google-Smtp-Source: ABdhPJxbQjC26EjkqEf2eDvFUXbogTGsFDGRHL4eSLJQmLBUmLt2bPqrM4GPJuDaAZyb9Mm+WZHlUCLMC8EYWvD2fq4=
X-Received: by 2002:a0d:d5c3:0:b0:2e5:cc05:1789 with SMTP id
 x186-20020a0dd5c3000000b002e5cc051789mr1109728ywd.472.1648666254393; Wed, 30
 Mar 2022 11:50:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220309064209.4169303-1-song@kernel.org> <9516f407-bb91-093b-739d-c32bda1b5d8d@kernel.dk>
 <CAPhsuW5zX96VaBMu-o=JUqDz2KLRBcNFM_gEsT=tHjeYqrngSQ@mail.gmail.com>
 <38f7aaf5-2043-b4f4-1fa5-52a7c883772b@kernel.dk> <CAPhsuW7zdYZqxaJ7SOWdnVOx-cASSoXS4OwtWVbms_jOHNh=Kw@mail.gmail.com>
 <2b437948-ba2a-c59c-1059-e937ea8636bd@kernel.dk> <84310ba2-a413-22f4-1349-59a09f4851a1@kernel.dk>
 <CAPhsuW492+zrVCyckgct_ju+5V_2grn4-s--TU2QVA7pkYtyzA@mail.gmail.com>
 <88ddb41a-75cb-df50-6679-6801e85dc196@nuclearwinter.com> <4a40d169-21c9-8292-7d0e-b68753265108@kernel.dk>
 <YkR0gvkIOONNYo/d@kroah.com> <46cb9609-ffb5-74aa-e4a1-598c86be9db9@kernel.dk> <CAAMCDefQQqwsLNmBjArTipLDnKzW2nQBW4MTHajrjKS4oi=JFg@mail.gmail.com>
In-Reply-To: <CAAMCDefQQqwsLNmBjArTipLDnKzW2nQBW4MTHajrjKS4oi=JFg@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 30 Mar 2022 11:50:42 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4XuW0Ejb5hL+vk7Vt=MTPgE3R2666bo1O2bJV7FoSZXw@mail.gmail.com>
Message-ID: <CAPhsuW4XuW0Ejb5hL+vk7Vt=MTPgE3R2666bo1O2bJV7FoSZXw@mail.gmail.com>
Subject: Re: [PATCH] block: check more requests for multiple_queues in blk_attempt_plug_merge
To:     Roger Heflin <rogerheflin@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larkin Lowrey <llowrey@nuclearwinter.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Wilson Jonathan <i400sjon@gmail.com>
Content-Type: multipart/mixed; boundary="00000000000072b07505db7406be"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

--00000000000072b07505db7406be
Content-Type: text/plain; charset="UTF-8"

On Wed, Mar 30, 2022 at 8:58 AM Roger Heflin <rogerheflin@gmail.com> wrote:
>
> If someone sends a patch that will apply for 5.16 I can patch and compile, and run normal IO and a few raid checks tests.
>
> On Wed, Mar 30, 2022 at 10:39 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 3/30/22 9:17 AM, Greg Kroah-Hartman wrote:
>> > On Wed, Mar 30, 2022 at 08:49:07AM -0600, Jens Axboe wrote:
>> >> On 3/30/22 8:39 AM, Larkin Lowrey wrote:
>> >>> Thank you for investigating and resolving this issue. Your effort is
>> >>> very much appreciated.
>> >>>
>> >>> I am interested in when this patch will end up in a release. Is it
>> >>> going to make it into a 5.17.x release or will it not come until 5.18?
>> >>
>> >> The two patches are merged for 5.18, and I just checked and they apply
>> >> directly to 5.17 as well.
>> >>
>> >> Greg, care to queue up the two attached patches for 5.17-stable?
>> >
>> > Now queued up, but shouldn't they also work for 5.16?  They don't apply
>> > there, but the Fixes: tag says it should.
>>
>> Yes, they should go to 5.16-stable as well. Song, do you have time to
>> port and test on 5.16?

I ported the two patches on top of 5.16.18 (attached). They look good in my
tests.

Thanks,
Song

--00000000000072b07505db7406be
Content-Type: application/octet-stream; 
	name="0001-block-ensure-plug-merging-checks-the-correct-queue-a.patch"
Content-Disposition: attachment; 
	filename="0001-block-ensure-plug-merging-checks-the-correct-queue-a.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l1dxa0jo0>
X-Attachment-Id: f_l1dxa0jo0

RnJvbSA2YWI2NWJlYzg4OTdkMGI5Y2RiZTU3M2JmZjlmNzk3N2UxYTBmYmRmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRhdGU6IEZy
aSwgMTEgTWFyIDIwMjIgMTA6MjE6NDMgLTA3MDAKU3ViamVjdDogW1BBVENIIDEvMl0gYmxvY2s6
IGVuc3VyZSBwbHVnIG1lcmdpbmcgY2hlY2tzIHRoZSBjb3JyZWN0IHF1ZXVlIGF0CiBsZWFzdCBv
bmNlCgpTb25nIHJlcG9ydHMgdGhhdCBhIFJBSUQgcmVidWlsZCB3b3JrbG9hZCBydW5zIG11Y2gg
c2xvd2VyIHJlY2VudGx5LAphbmQgaXQgaXMgc2VlaW5nIGEgbG90IGxlc3MgbWVyZ2luZyB0aGFu
IGl0IGRpZCBwcmV2aW91c2x5LiBUaGUgcmVhc29uCmlzIHRoYXQgYSBwcmV2aW91cyBjb21taXQg
cmVkdWNlZCB0aGUgYW1vdW50IG9mIHdvcmsgd2UgZG8gZm9yIHBsdWcKbWVyZ2luZy4gUkFJRCBy
ZWJ1aWxkIGludGVybGVhdmVzIHJlcXVlc3RzIGJldHdlZW4gZGlza3MsIHNvIGEgbGFzdC1lbnRy
eQpjaGVjayBpbiBwbHVnIG1lcmdpbmcgYWx3YXlzIG1pc3NlcyBhIG1lcmdlIG9wcG9ydHVuaXR5
IHNpbmNlIHdlIGFsd2F5cwpmaW5kIGEgZGlmZmVyZW50IGRpc2sgdGhhbiB3aGF0IHdlIGFyZSBs
b29raW5nIGZvci4KCk1vZGlmeSB0aGUgbG9naWMgc3VjaCB0aGF0IGl0J3Mgc3RpbGwgYSBvbmUt
aGl0IGNhY2hlLCBidXQgZW5zdXJlIHRoYXQKd2UgY2hlY2sgZW5vdWdoIHRvIGZpbmQgdGhlIHJp
Z2h0IHRhcmdldCBiZWZvcmUgZ2l2aW5nIHVwLgoKRml4ZXM6IGQzOGE5YzA0YzBkNSAoImJsb2Nr
OiBvbmx5IGNoZWNrIHByZXZpb3VzIGVudHJ5IGZvciBwbHVnIG1lcmdlIGF0dGVtcHQiKQpSZXBv
cnRlZC1hbmQtdGVzdGVkLWJ5OiBTb25nIExpdSA8c29uZ0BrZXJuZWwub3JnPgpSZXZpZXdlZC1i
eTogU29uZyBMaXUgPHNvbmdsaXVicmF2aW5nQGZiLmNvbT4KU2lnbmVkLW9mZi1ieTogSmVucyBB
eGJvZSA8YXhib2VAa2VybmVsLmRrPgotLS0KIGJsb2NrL2Jsay1tZXJnZS5jIHwgMjMgKysrKysr
KysrKysrKy0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCspLCAxMCBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9ibG9jay9ibGstbWVyZ2UuYyBiL2Jsb2NrL2Jsay1t
ZXJnZS5jCmluZGV4IDg5M2MxYTYwYjcwMS4uOTcxN2Q3NDAzNTg3IDEwMDY0NAotLS0gYS9ibG9j
ay9ibGstbWVyZ2UuYworKysgYi9ibG9jay9ibGstbWVyZ2UuYwpAQCAtMTA5MywxOCArMTA5Mywy
MSBAQCBib29sIGJsa19hdHRlbXB0X3BsdWdfbWVyZ2Uoc3RydWN0IHJlcXVlc3RfcXVldWUgKnEs
IHN0cnVjdCBiaW8gKmJpbywKIAlpZiAoIXBsdWcgfHwgcnFfbGlzdF9lbXB0eShwbHVnLT5tcV9s
aXN0KSkKIAkJcmV0dXJuIGZhbHNlOwogCi0JLyogY2hlY2sgdGhlIHByZXZpb3VzbHkgYWRkZWQg
ZW50cnkgZm9yIGEgcXVpY2sgbWVyZ2UgYXR0ZW1wdCAqLwotCXJxID0gcnFfbGlzdF9wZWVrKCZw
bHVnLT5tcV9saXN0KTsKLQlpZiAocnEtPnEgPT0gcSkgeworCXJxX2xpc3RfZm9yX2VhY2goJnBs
dWctPm1xX2xpc3QsIHJxKSB7CisJCWlmIChycS0+cSA9PSBxKSB7CisJCQkqc2FtZV9xdWV1ZV9y
cSA9IHRydWU7CisJCQlpZiAoYmxrX2F0dGVtcHRfYmlvX21lcmdlKHEsIHJxLCBiaW8sIG5yX3Nl
Z3MsIGZhbHNlKSA9PQorCQkJICAgIEJJT19NRVJHRV9PSykKKwkJCQlyZXR1cm4gdHJ1ZTsKKwkJ
CWJyZWFrOworCQl9CisKIAkJLyoKLQkJICogT25seSBibGstbXEgbXVsdGlwbGUgaGFyZHdhcmUg
cXVldWVzIGNhc2UgY2hlY2tzIHRoZSBycSBpbgotCQkgKiB0aGUgc2FtZSBxdWV1ZSwgdGhlcmUg
c2hvdWxkIGJlIG9ubHkgb25lIHN1Y2ggcnEgaW4gYSBxdWV1ZQorCQkgKiBPbmx5IGtlZXAgaXRl
cmF0aW5nIHBsdWcgbGlzdCBmb3IgbWVyZ2VzIGlmIHdlIGhhdmUgbXVsdGlwbGUKKwkJICogcXVl
dWVzCiAJCSAqLwotCQkqc2FtZV9xdWV1ZV9ycSA9IHRydWU7Ci0KLQkJaWYgKGJsa19hdHRlbXB0
X2Jpb19tZXJnZShxLCBycSwgYmlvLCBucl9zZWdzLCBmYWxzZSkgPT0KLQkJCQlCSU9fTUVSR0Vf
T0spCi0JCQlyZXR1cm4gdHJ1ZTsKKwkJaWYgKCFwbHVnLT5tdWx0aXBsZV9xdWV1ZXMpCisJCQli
cmVhazsKIAl9CiAJcmV0dXJuIGZhbHNlOwogfQotLSAKMi4zMC4yCgo=
--00000000000072b07505db7406be
Content-Type: application/octet-stream; 
	name="0002-block-flush-plug-based-on-hardware-and-software-queu.patch"
Content-Disposition: attachment; 
	filename="0002-block-flush-plug-based-on-hardware-and-software-queu.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l1dxa72x1>
X-Attachment-Id: f_l1dxa72x1

RnJvbSBkODRkZTE5NzFkNWE1MTJiN2JjMzZkOGRmMTY5NjYwZThjZTdkZDYzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRhdGU6IEZy
aSwgMTEgTWFyIDIwMjIgMTA6MjQ6MTcgLTA3MDAKU3ViamVjdDogW1BBVENIIDIvMl0gYmxvY2s6
IGZsdXNoIHBsdWcgYmFzZWQgb24gaGFyZHdhcmUgYW5kIHNvZnR3YXJlIHF1ZXVlCiBvcmRlcgoK
V2UgdXNlZCB0byBzb3J0IHRoZSBwbHVnIGxpc3QgaWYgd2UgaGFkIG11bHRpcGxlIHF1ZXVlcyBi
ZWZvcmUgZGlzcGF0Y2hpbmcKcmVxdWVzdHMgdG8gdGhlIElPIHNjaGVkdWxlci4gVGhpcyB1c3Vh
bGx5IGlzbid0IG5lZWRlZCwgYnV0IGZvciBjZXJ0YWluCndvcmtsb2FkcyB0aGF0IGludGVybGVh
dmUgcmVxdWVzdHMgdG8gZGlza3MsIGl0J3MgYSBsZXNzIGVmZmljaWVudCB0bwpwcm9jZXNzIHRo
ZSBwbHVnIGxpc3Qgb25lLWJ5LW9uZSBpZiBldmVyeXRoaW5nIGlzIGludGVybGVhdmVkLgoKRG9u
J3Qgc29ydCB0aGUgbGlzdCwgYnV0IHNraXAgdGhyb3VnaCBpdCBhbmQgZmx1c2ggb3V0IGVudHJp
ZXMgdGhhdCBoYXZlCnRoZSBzYW1lIHRhcmdldCBhdCB0aGUgc2FtZSB0aW1lLgoKRml4ZXM6IGRm
ODdlYjBmY2U4ZiAoImJsb2NrOiBnZXQgcmlkIG9mIHBsdWcgbGlzdCBzb3J0aW5nIikKUmVwb3J0
ZWQtYW5kLXRlc3RlZC1ieTogU29uZyBMaXUgPHNvbmdAa2VybmVsLm9yZz4KUmV2aWV3ZWQtYnk6
IFNvbmcgTGl1IDxzb25nbGl1YnJhdmluZ0BmYi5jb20+ClNpZ25lZC1vZmYtYnk6IEplbnMgQXhi
b2UgPGF4Ym9lQGtlcm5lbC5kaz4KLS0tCiBibG9jay9ibGstbXEuYyB8IDYwICsrKysrKysrKysr
KysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwg
MjcgaW5zZXJ0aW9ucygrKSwgMzMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYmxvY2svYmxr
LW1xLmMgYi9ibG9jay9ibGstbXEuYwppbmRleCA4ODc0YTYzYWU5NTIuLjhlZjg4YWExZWZiZSAx
MDA2NDQKLS0tIGEvYmxvY2svYmxrLW1xLmMKKysrIGIvYmxvY2svYmxrLW1xLmMKQEAgLTIyNDQs
MTMgKzIyNDQsMzUgQEAgc3RhdGljIHZvaWQgYmxrX21xX3BsdWdfaXNzdWVfZGlyZWN0KHN0cnVj
dCBibGtfcGx1ZyAqcGx1ZywgYm9vbCBmcm9tX3NjaGVkdWxlKQogCQlibGtfbXFfY29tbWl0X3Jx
cyhoY3R4LCAmcXVldWVkLCBmcm9tX3NjaGVkdWxlKTsKIH0KIAotdm9pZCBibGtfbXFfZmx1c2hf
cGx1Z19saXN0KHN0cnVjdCBibGtfcGx1ZyAqcGx1ZywgYm9vbCBmcm9tX3NjaGVkdWxlKQorc3Rh
dGljIHZvaWQgYmxrX21xX2Rpc3BhdGNoX3BsdWdfbGlzdChzdHJ1Y3QgYmxrX3BsdWcgKnBsdWcs
IGJvb2wgZnJvbV9zY2hlZCkKIHsKLQlzdHJ1Y3QgYmxrX21xX2h3X2N0eCAqdGhpc19oY3R4Owot
CXN0cnVjdCBibGtfbXFfY3R4ICp0aGlzX2N0eDsKLQl1bnNpZ25lZCBpbnQgZGVwdGg7CisJc3Ry
dWN0IGJsa19tcV9od19jdHggKnRoaXNfaGN0eCA9IE5VTEw7CisJc3RydWN0IGJsa19tcV9jdHgg
KnRoaXNfY3R4ID0gTlVMTDsKKwlzdHJ1Y3QgcmVxdWVzdCAqcmVxdWV1ZV9saXN0ID0gTlVMTDsK
Kwl1bnNpZ25lZCBpbnQgZGVwdGggPSAwOwogCUxJU1RfSEVBRChsaXN0KTsKIAorCWRvIHsKKwkJ
c3RydWN0IHJlcXVlc3QgKnJxID0gcnFfbGlzdF9wb3AoJnBsdWctPm1xX2xpc3QpOworCisJCWlm
ICghdGhpc19oY3R4KSB7CisJCQl0aGlzX2hjdHggPSBycS0+bXFfaGN0eDsKKwkJCXRoaXNfY3R4
ID0gcnEtPm1xX2N0eDsKKwkJfSBlbHNlIGlmICh0aGlzX2hjdHggIT0gcnEtPm1xX2hjdHggfHwg
dGhpc19jdHggIT0gcnEtPm1xX2N0eCkgeworCQkJcnFfbGlzdF9hZGQoJnJlcXVldWVfbGlzdCwg
cnEpOworCQkJY29udGludWU7CisJCX0KKwkJbGlzdF9hZGRfdGFpbCgmcnEtPnF1ZXVlbGlzdCwg
Jmxpc3QpOworCQlkZXB0aCsrOworCX0gd2hpbGUgKCFycV9saXN0X2VtcHR5KHBsdWctPm1xX2xp
c3QpKTsKKworCXBsdWctPm1xX2xpc3QgPSByZXF1ZXVlX2xpc3Q7CisJdHJhY2VfYmxvY2tfdW5w
bHVnKHRoaXNfaGN0eC0+cXVldWUsIGRlcHRoLCAhZnJvbV9zY2hlZCk7CisJYmxrX21xX3NjaGVk
X2luc2VydF9yZXF1ZXN0cyh0aGlzX2hjdHgsIHRoaXNfY3R4LCAmbGlzdCwgZnJvbV9zY2hlZCk7
Cit9CisKK3ZvaWQgYmxrX21xX2ZsdXNoX3BsdWdfbGlzdChzdHJ1Y3QgYmxrX3BsdWcgKnBsdWcs
IGJvb2wgZnJvbV9zY2hlZHVsZSkKK3sKIAlpZiAocnFfbGlzdF9lbXB0eShwbHVnLT5tcV9saXN0
KSkKIAkJcmV0dXJuOwogCXBsdWctPnJxX2NvdW50ID0gMDsKQEAgLTIyNjEsMzcgKzIyODMsOSBA
QCB2b2lkIGJsa19tcV9mbHVzaF9wbHVnX2xpc3Qoc3RydWN0IGJsa19wbHVnICpwbHVnLCBib29s
IGZyb21fc2NoZWR1bGUpCiAJCQlyZXR1cm47CiAJfQogCi0JdGhpc19oY3R4ID0gTlVMTDsKLQl0
aGlzX2N0eCA9IE5VTEw7Ci0JZGVwdGggPSAwOwogCWRvIHsKLQkJc3RydWN0IHJlcXVlc3QgKnJx
OwotCi0JCXJxID0gcnFfbGlzdF9wb3AoJnBsdWctPm1xX2xpc3QpOwotCi0JCWlmICghdGhpc19o
Y3R4KSB7Ci0JCQl0aGlzX2hjdHggPSBycS0+bXFfaGN0eDsKLQkJCXRoaXNfY3R4ID0gcnEtPm1x
X2N0eDsKLQkJfSBlbHNlIGlmICh0aGlzX2hjdHggIT0gcnEtPm1xX2hjdHggfHwgdGhpc19jdHgg
IT0gcnEtPm1xX2N0eCkgewotCQkJdHJhY2VfYmxvY2tfdW5wbHVnKHRoaXNfaGN0eC0+cXVldWUs
IGRlcHRoLAotCQkJCQkJIWZyb21fc2NoZWR1bGUpOwotCQkJYmxrX21xX3NjaGVkX2luc2VydF9y
ZXF1ZXN0cyh0aGlzX2hjdHgsIHRoaXNfY3R4LAotCQkJCQkJJmxpc3QsIGZyb21fc2NoZWR1bGUp
OwotCQkJZGVwdGggPSAwOwotCQkJdGhpc19oY3R4ID0gcnEtPm1xX2hjdHg7Ci0JCQl0aGlzX2N0
eCA9IHJxLT5tcV9jdHg7Ci0KLQkJfQotCi0JCWxpc3RfYWRkKCZycS0+cXVldWVsaXN0LCAmbGlz
dCk7Ci0JCWRlcHRoKys7CisJCWJsa19tcV9kaXNwYXRjaF9wbHVnX2xpc3QocGx1ZywgZnJvbV9z
Y2hlZHVsZSk7CiAJfSB3aGlsZSAoIXJxX2xpc3RfZW1wdHkocGx1Zy0+bXFfbGlzdCkpOwotCi0J
aWYgKCFsaXN0X2VtcHR5KCZsaXN0KSkgewotCQl0cmFjZV9ibG9ja191bnBsdWcodGhpc19oY3R4
LT5xdWV1ZSwgZGVwdGgsICFmcm9tX3NjaGVkdWxlKTsKLQkJYmxrX21xX3NjaGVkX2luc2VydF9y
ZXF1ZXN0cyh0aGlzX2hjdHgsIHRoaXNfY3R4LCAmbGlzdCwKLQkJCQkJCWZyb21fc2NoZWR1bGUp
OwotCX0KIH0KIAogc3RhdGljIHZvaWQgYmxrX21xX2Jpb190b19yZXF1ZXN0KHN0cnVjdCByZXF1
ZXN0ICpycSwgc3RydWN0IGJpbyAqYmlvLAotLSAKMi4zMC4yCgo=
--00000000000072b07505db7406be--
