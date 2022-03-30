Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16650C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 30 Mar 2022 14:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347211AbiC3Ou4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 30 Mar 2022 10:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347210AbiC3Ouz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 30 Mar 2022 10:50:55 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECEB1403B
        for <linux-raid@vger.kernel.org>; Wed, 30 Mar 2022 07:49:09 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id b16so25054338ioz.3
        for <linux-raid@vger.kernel.org>; Wed, 30 Mar 2022 07:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to;
        bh=+vwlaONMgiIUupinB4uXBHDBjckmvkI6uNOzfs5TMCc=;
        b=cybTWeaupyJubrZhdmH8y/PuRvzCrcwj384pcW/WegHd6YNOEYUhyBRM7AXcx+5o+G
         /3S4urZXa/aIk5u10GzgGAS3SlfGwLAZK2XW23zNEh9i8ZH0TLKBYqALGxkZUgdar3zZ
         ImKu09uQFJWZdgiF2nFYbjZdyp0UkCOKPI8ce0tpoi3z47NVWXVnUM6mHK21mJhi5wCM
         0Vp0/I1JgKM15qMjJGwmlaFc1sUMnFhJUChw02jGS6Rv7ynvVmTXZ458xJV5Nieam+s8
         RupP+pspYoX5UXzet11rJWwz2rbpioWuhtVv95XhalEXBXrU6PduLVQGQFZzuibx5uqb
         msNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=+vwlaONMgiIUupinB4uXBHDBjckmvkI6uNOzfs5TMCc=;
        b=O5RMrz1EfZaWVm9lamxli/m1cV++l5dC0EPmHauj5UslHkIpUYX4J9FGNaxptyl/JC
         CsYaDsZ8SRDzMIDxiiZOcH25ODrruNYRyxWABWt6GkDZxQpqCeEQzNk9vu1M+PFF7K0j
         dzddMDYl6GPTwnQJeve71UFPHLthHplB7GSWJQvRs2hYkPFfqqSggvTo3RP6dhICPCUZ
         NKMvh6ucR9kK/dTIAyW3GEOZjJfiCS+E+17HR9KC3pvuQqrosjUHcMOral6wFQ8ncT7W
         iba5Yp70ircpf//3Rzxrnpctv2GTJSwn+p3QuV23/dToDWBA15nh1TAY25Rpd7KtsBER
         YvvA==
X-Gm-Message-State: AOAM531cSIvLOTr1KLb2tBjIkKNg+AUHkCJ39Sutz85FU4qmWgQYy126
        9aS+j9Y4rSvV/BURK3eXfsTYa0T9ffG0C011
X-Google-Smtp-Source: ABdhPJwv6fdh13XZak3CfoO5tacwb7eKWWPY9h0FAiFreDP7OQh1ko1N8mBkxS59aaMcNSe/aeOajQ==
X-Received: by 2002:a05:6602:314c:b0:649:a265:72ee with SMTP id m12-20020a056602314c00b00649a26572eemr11316512ioy.100.1648651748987;
        Wed, 30 Mar 2022 07:49:08 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f2-20020a056e020b4200b002c805b9b4c4sm11219084ilu.16.2022.03.30.07.49.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 07:49:08 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------tfncYLs1lBxpmNAR5kE0vMWF"
Message-ID: <4a40d169-21c9-8292-7d0e-b68753265108@kernel.dk>
Date:   Wed, 30 Mar 2022 08:49:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] block: check more requests for multiple_queues in
 blk_attempt_plug_merge
Content-Language: en-US
To:     Larkin Lowrey <llowrey@nuclearwinter.com>,
        Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Wilson Jonathan <i400sjon@gmail.com>,
        Roger Heflin <rogerheflin@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20220309064209.4169303-1-song@kernel.org>
 <9516f407-bb91-093b-739d-c32bda1b5d8d@kernel.dk>
 <CAPhsuW5zX96VaBMu-o=JUqDz2KLRBcNFM_gEsT=tHjeYqrngSQ@mail.gmail.com>
 <38f7aaf5-2043-b4f4-1fa5-52a7c883772b@kernel.dk>
 <CAPhsuW7zdYZqxaJ7SOWdnVOx-cASSoXS4OwtWVbms_jOHNh=Kw@mail.gmail.com>
 <2b437948-ba2a-c59c-1059-e937ea8636bd@kernel.dk>
 <84310ba2-a413-22f4-1349-59a09f4851a1@kernel.dk>
 <CAPhsuW492+zrVCyckgct_ju+5V_2grn4-s--TU2QVA7pkYtyzA@mail.gmail.com>
 <88ddb41a-75cb-df50-6679-6801e85dc196@nuclearwinter.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <88ddb41a-75cb-df50-6679-6801e85dc196@nuclearwinter.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This is a multi-part message in MIME format.
--------------tfncYLs1lBxpmNAR5kE0vMWF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/30/22 8:39 AM, Larkin Lowrey wrote:
> Thank you for investigating and resolving this issue. Your effort is
> very much appreciated.
> 
> I am interested in when this patch will end up in a release. Is it
> going to make it into a 5.17.x release or will it not come until 5.18?

The two patches are merged for 5.18, and I just checked and they apply
directly to 5.17 as well.

Greg, care to queue up the two attached patches for 5.17-stable?

-- 
Jens Axboe

--------------tfncYLs1lBxpmNAR5kE0vMWF
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-block-flush-plug-based-on-hardware-and-software-queu.patch"
Content-Disposition: attachment;
 filename*0="0002-block-flush-plug-based-on-hardware-and-software-queu.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSAyNmZlZDRhYzRlYWIwOWMyN2ZiYWUxODU5Njk2Y2MzOGYwNTM2NDA3IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IEZyaSwgMTEgTWFyIDIwMjIgMTA6MjQ6MTcgLTA3MDAKU3ViamVjdDogW1BBVENIIDIv
Ml0gYmxvY2s6IGZsdXNoIHBsdWcgYmFzZWQgb24gaGFyZHdhcmUgYW5kIHNvZnR3YXJlIHF1
ZXVlCiBvcmRlcgoKV2UgdXNlZCB0byBzb3J0IHRoZSBwbHVnIGxpc3QgaWYgd2UgaGFkIG11
bHRpcGxlIHF1ZXVlcyBiZWZvcmUgZGlzcGF0Y2hpbmcKcmVxdWVzdHMgdG8gdGhlIElPIHNj
aGVkdWxlci4gVGhpcyB1c3VhbGx5IGlzbid0IG5lZWRlZCwgYnV0IGZvciBjZXJ0YWluCndv
cmtsb2FkcyB0aGF0IGludGVybGVhdmUgcmVxdWVzdHMgdG8gZGlza3MsIGl0J3MgYSBsZXNz
IGVmZmljaWVudCB0bwpwcm9jZXNzIHRoZSBwbHVnIGxpc3Qgb25lLWJ5LW9uZSBpZiBldmVy
eXRoaW5nIGlzIGludGVybGVhdmVkLgoKRG9uJ3Qgc29ydCB0aGUgbGlzdCwgYnV0IHNraXAg
dGhyb3VnaCBpdCBhbmQgZmx1c2ggb3V0IGVudHJpZXMgdGhhdCBoYXZlCnRoZSBzYW1lIHRh
cmdldCBhdCB0aGUgc2FtZSB0aW1lLgoKRml4ZXM6IGRmODdlYjBmY2U4ZiAoImJsb2NrOiBn
ZXQgcmlkIG9mIHBsdWcgbGlzdCBzb3J0aW5nIikKUmVwb3J0ZWQtYW5kLXRlc3RlZC1ieTog
U29uZyBMaXUgPHNvbmdAa2VybmVsLm9yZz4KUmV2aWV3ZWQtYnk6IFNvbmcgTGl1IDxzb25n
bGl1YnJhdmluZ0BmYi5jb20+ClNpZ25lZC1vZmYtYnk6IEplbnMgQXhib2UgPGF4Ym9lQGtl
cm5lbC5kaz4KLS0tCiBibG9jay9ibGstbXEuYyB8IDU5ICsrKysrKysrKysrKysrKysrKysr
KysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMjggaW5z
ZXJ0aW9ucygrKSwgMzEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYmxvY2svYmxrLW1x
LmMgYi9ibG9jay9ibGstbXEuYwppbmRleCA4NjJkOTFjNjExMmUuLjIxM2JiNTk3OWJlZCAx
MDA2NDQKLS0tIGEvYmxvY2svYmxrLW1xLmMKKysrIGIvYmxvY2svYmxrLW1xLmMKQEAgLTI1
NzMsMTMgKzI1NzMsMzYgQEAgc3RhdGljIHZvaWQgX19ibGtfbXFfZmx1c2hfcGx1Z19saXN0
KHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxLAogCXEtPm1xX29wcy0+cXVldWVfcnFzKCZwbHVn
LT5tcV9saXN0KTsKIH0KIAorc3RhdGljIHZvaWQgYmxrX21xX2Rpc3BhdGNoX3BsdWdfbGlz
dChzdHJ1Y3QgYmxrX3BsdWcgKnBsdWcsIGJvb2wgZnJvbV9zY2hlZCkKK3sKKwlzdHJ1Y3Qg
YmxrX21xX2h3X2N0eCAqdGhpc19oY3R4ID0gTlVMTDsKKwlzdHJ1Y3QgYmxrX21xX2N0eCAq
dGhpc19jdHggPSBOVUxMOworCXN0cnVjdCByZXF1ZXN0ICpyZXF1ZXVlX2xpc3QgPSBOVUxM
OworCXVuc2lnbmVkIGludCBkZXB0aCA9IDA7CisJTElTVF9IRUFEKGxpc3QpOworCisJZG8g
eworCQlzdHJ1Y3QgcmVxdWVzdCAqcnEgPSBycV9saXN0X3BvcCgmcGx1Zy0+bXFfbGlzdCk7
CisKKwkJaWYgKCF0aGlzX2hjdHgpIHsKKwkJCXRoaXNfaGN0eCA9IHJxLT5tcV9oY3R4Owor
CQkJdGhpc19jdHggPSBycS0+bXFfY3R4OworCQl9IGVsc2UgaWYgKHRoaXNfaGN0eCAhPSBy
cS0+bXFfaGN0eCB8fCB0aGlzX2N0eCAhPSBycS0+bXFfY3R4KSB7CisJCQlycV9saXN0X2Fk
ZCgmcmVxdWV1ZV9saXN0LCBycSk7CisJCQljb250aW51ZTsKKwkJfQorCQlsaXN0X2FkZF90
YWlsKCZycS0+cXVldWVsaXN0LCAmbGlzdCk7CisJCWRlcHRoKys7CisJfSB3aGlsZSAoIXJx
X2xpc3RfZW1wdHkocGx1Zy0+bXFfbGlzdCkpOworCisJcGx1Zy0+bXFfbGlzdCA9IHJlcXVl
dWVfbGlzdDsKKwl0cmFjZV9ibG9ja191bnBsdWcodGhpc19oY3R4LT5xdWV1ZSwgZGVwdGgs
ICFmcm9tX3NjaGVkKTsKKwlibGtfbXFfc2NoZWRfaW5zZXJ0X3JlcXVlc3RzKHRoaXNfaGN0
eCwgdGhpc19jdHgsICZsaXN0LCBmcm9tX3NjaGVkKTsKK30KKwogdm9pZCBibGtfbXFfZmx1
c2hfcGx1Z19saXN0KHN0cnVjdCBibGtfcGx1ZyAqcGx1ZywgYm9vbCBmcm9tX3NjaGVkdWxl
KQogewotCXN0cnVjdCBibGtfbXFfaHdfY3R4ICp0aGlzX2hjdHg7Ci0Jc3RydWN0IGJsa19t
cV9jdHggKnRoaXNfY3R4OwogCXN0cnVjdCByZXF1ZXN0ICpycTsKLQl1bnNpZ25lZCBpbnQg
ZGVwdGg7Ci0JTElTVF9IRUFEKGxpc3QpOwogCiAJaWYgKHJxX2xpc3RfZW1wdHkocGx1Zy0+
bXFfbGlzdCkpCiAJCXJldHVybjsKQEAgLTI2MTUsMzUgKzI2MzgsOSBAQCB2b2lkIGJsa19t
cV9mbHVzaF9wbHVnX2xpc3Qoc3RydWN0IGJsa19wbHVnICpwbHVnLCBib29sIGZyb21fc2No
ZWR1bGUpCiAJCQlyZXR1cm47CiAJfQogCi0JdGhpc19oY3R4ID0gTlVMTDsKLQl0aGlzX2N0
eCA9IE5VTEw7Ci0JZGVwdGggPSAwOwogCWRvIHsKLQkJcnEgPSBycV9saXN0X3BvcCgmcGx1
Zy0+bXFfbGlzdCk7Ci0KLQkJaWYgKCF0aGlzX2hjdHgpIHsKLQkJCXRoaXNfaGN0eCA9IHJx
LT5tcV9oY3R4OwotCQkJdGhpc19jdHggPSBycS0+bXFfY3R4OwotCQl9IGVsc2UgaWYgKHRo
aXNfaGN0eCAhPSBycS0+bXFfaGN0eCB8fCB0aGlzX2N0eCAhPSBycS0+bXFfY3R4KSB7Ci0J
CQl0cmFjZV9ibG9ja191bnBsdWcodGhpc19oY3R4LT5xdWV1ZSwgZGVwdGgsCi0JCQkJCQkh
ZnJvbV9zY2hlZHVsZSk7Ci0JCQlibGtfbXFfc2NoZWRfaW5zZXJ0X3JlcXVlc3RzKHRoaXNf
aGN0eCwgdGhpc19jdHgsCi0JCQkJCQkmbGlzdCwgZnJvbV9zY2hlZHVsZSk7Ci0JCQlkZXB0
aCA9IDA7Ci0JCQl0aGlzX2hjdHggPSBycS0+bXFfaGN0eDsKLQkJCXRoaXNfY3R4ID0gcnEt
Pm1xX2N0eDsKLQotCQl9Ci0KLQkJbGlzdF9hZGQoJnJxLT5xdWV1ZWxpc3QsICZsaXN0KTsK
LQkJZGVwdGgrKzsKKwkJYmxrX21xX2Rpc3BhdGNoX3BsdWdfbGlzdChwbHVnLCBmcm9tX3Nj
aGVkdWxlKTsKIAl9IHdoaWxlICghcnFfbGlzdF9lbXB0eShwbHVnLT5tcV9saXN0KSk7Ci0K
LQlpZiAoIWxpc3RfZW1wdHkoJmxpc3QpKSB7Ci0JCXRyYWNlX2Jsb2NrX3VucGx1Zyh0aGlz
X2hjdHgtPnF1ZXVlLCBkZXB0aCwgIWZyb21fc2NoZWR1bGUpOwotCQlibGtfbXFfc2NoZWRf
aW5zZXJ0X3JlcXVlc3RzKHRoaXNfaGN0eCwgdGhpc19jdHgsICZsaXN0LAotCQkJCQkJZnJv
bV9zY2hlZHVsZSk7Ci0JfQogfQogCiB2b2lkIGJsa19tcV90cnlfaXNzdWVfbGlzdF9kaXJl
Y3RseShzdHJ1Y3QgYmxrX21xX2h3X2N0eCAqaGN0eCwKLS0gCjIuMzUuMQoK
--------------tfncYLs1lBxpmNAR5kE0vMWF
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-block-ensure-plug-merging-checks-the-correct-queue-a.patch"
Content-Disposition: attachment;
 filename*0="0001-block-ensure-plug-merging-checks-the-correct-queue-a.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSA1YjIwNTA3MThkMDk1Y2QzMjQyZDFmNDJhYWFlYTNhMmZlYzhlNmYwIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IEZyaSwgMTEgTWFyIDIwMjIgMTA6MjE6NDMgLTA3MDAKU3ViamVjdDogW1BBVENIIDEv
Ml0gYmxvY2s6IGVuc3VyZSBwbHVnIG1lcmdpbmcgY2hlY2tzIHRoZSBjb3JyZWN0IHF1ZXVl
IGF0CiBsZWFzdCBvbmNlCgpTb25nIHJlcG9ydHMgdGhhdCBhIFJBSUQgcmVidWlsZCB3b3Jr
bG9hZCBydW5zIG11Y2ggc2xvd2VyIHJlY2VudGx5LAphbmQgaXQgaXMgc2VlaW5nIGEgbG90
IGxlc3MgbWVyZ2luZyB0aGFuIGl0IGRpZCBwcmV2aW91c2x5LiBUaGUgcmVhc29uCmlzIHRo
YXQgYSBwcmV2aW91cyBjb21taXQgcmVkdWNlZCB0aGUgYW1vdW50IG9mIHdvcmsgd2UgZG8g
Zm9yIHBsdWcKbWVyZ2luZy4gUkFJRCByZWJ1aWxkIGludGVybGVhdmVzIHJlcXVlc3RzIGJl
dHdlZW4gZGlza3MsIHNvIGEgbGFzdC1lbnRyeQpjaGVjayBpbiBwbHVnIG1lcmdpbmcgYWx3
YXlzIG1pc3NlcyBhIG1lcmdlIG9wcG9ydHVuaXR5IHNpbmNlIHdlIGFsd2F5cwpmaW5kIGEg
ZGlmZmVyZW50IGRpc2sgdGhhbiB3aGF0IHdlIGFyZSBsb29raW5nIGZvci4KCk1vZGlmeSB0
aGUgbG9naWMgc3VjaCB0aGF0IGl0J3Mgc3RpbGwgYSBvbmUtaGl0IGNhY2hlLCBidXQgZW5z
dXJlIHRoYXQKd2UgY2hlY2sgZW5vdWdoIHRvIGZpbmQgdGhlIHJpZ2h0IHRhcmdldCBiZWZv
cmUgZ2l2aW5nIHVwLgoKRml4ZXM6IGQzOGE5YzA0YzBkNSAoImJsb2NrOiBvbmx5IGNoZWNr
IHByZXZpb3VzIGVudHJ5IGZvciBwbHVnIG1lcmdlIGF0dGVtcHQiKQpSZXBvcnRlZC1hbmQt
dGVzdGVkLWJ5OiBTb25nIExpdSA8c29uZ0BrZXJuZWwub3JnPgpSZXZpZXdlZC1ieTogU29u
ZyBMaXUgPHNvbmdsaXVicmF2aW5nQGZiLmNvbT4KU2lnbmVkLW9mZi1ieTogSmVucyBBeGJv
ZSA8YXhib2VAa2VybmVsLmRrPgotLS0KIGJsb2NrL2Jsay1tZXJnZS5jIHwgMjAgKysrKysr
KysrKysrKystLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCA2IGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Jsb2NrL2Jsay1tZXJnZS5jIGIvYmxvY2svYmxr
LW1lcmdlLmMKaW5kZXggZjUyNTU5OTFiNzczLi44ZDgxNzdmNzFlYmQgMTAwNjQ0Ci0tLSBh
L2Jsb2NrL2Jsay1tZXJnZS5jCisrKyBiL2Jsb2NrL2Jsay1tZXJnZS5jCkBAIC0xMDg3LDEy
ICsxMDg3LDIwIEBAIGJvb2wgYmxrX2F0dGVtcHRfcGx1Z19tZXJnZShzdHJ1Y3QgcmVxdWVz
dF9xdWV1ZSAqcSwgc3RydWN0IGJpbyAqYmlvLAogCWlmICghcGx1ZyB8fCBycV9saXN0X2Vt
cHR5KHBsdWctPm1xX2xpc3QpKQogCQlyZXR1cm4gZmFsc2U7CiAKLQkvKiBjaGVjayB0aGUg
cHJldmlvdXNseSBhZGRlZCBlbnRyeSBmb3IgYSBxdWljayBtZXJnZSBhdHRlbXB0ICovCi0J
cnEgPSBycV9saXN0X3BlZWsoJnBsdWctPm1xX2xpc3QpOwotCWlmIChycS0+cSA9PSBxKSB7
Ci0JCWlmIChibGtfYXR0ZW1wdF9iaW9fbWVyZ2UocSwgcnEsIGJpbywgbnJfc2VncywgZmFs
c2UpID09Ci0JCQkJQklPX01FUkdFX09LKQotCQkJcmV0dXJuIHRydWU7CisJcnFfbGlzdF9m
b3JfZWFjaCgmcGx1Zy0+bXFfbGlzdCwgcnEpIHsKKwkJaWYgKHJxLT5xID09IHEpIHsKKwkJ
CWlmIChibGtfYXR0ZW1wdF9iaW9fbWVyZ2UocSwgcnEsIGJpbywgbnJfc2VncywgZmFsc2Up
ID09CisJCQkgICAgQklPX01FUkdFX09LKQorCQkJCXJldHVybiB0cnVlOworCQkJYnJlYWs7
CisJCX0KKworCQkvKgorCQkgKiBPbmx5IGtlZXAgaXRlcmF0aW5nIHBsdWcgbGlzdCBmb3Ig
bWVyZ2VzIGlmIHdlIGhhdmUgbXVsdGlwbGUKKwkJICogcXVldWVzCisJCSAqLworCQlpZiAo
IXBsdWctPm11bHRpcGxlX3F1ZXVlcykKKwkJCWJyZWFrOwogCX0KIAlyZXR1cm4gZmFsc2U7
CiB9Ci0tIAoyLjM1LjEKCg==

--------------tfncYLs1lBxpmNAR5kE0vMWF--
