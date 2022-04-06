Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A399BC43217
	for <linux-raid@archiver.kernel.org>; Wed,  6 Apr 2022 21:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237076AbiDFVkh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 6 Apr 2022 17:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237944AbiDFVit (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 6 Apr 2022 17:38:49 -0400
Received: from zimbra.karlsbakk.net (zimbra.karlsbakk.net [IPv6:2a0a:51c0:0:1f:4ca5::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DE323FF12
        for <linux-raid@vger.kernel.org>; Wed,  6 Apr 2022 14:02:53 -0700 (PDT)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 58E5E3C1DD5;
        Wed,  6 Apr 2022 23:02:52 +0200 (CEST)
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id 1OvCoPZU9SqD; Wed,  6 Apr 2022 23:02:50 +0200 (CEST)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 9E16D3C1DD6;
        Wed,  6 Apr 2022 23:02:50 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra.karlsbakk.net 9E16D3C1DD6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karlsbakk.net;
        s=1DC131FE-D37A-11E7-BD32-3AD4DFE620DF; t=1649278970;
        bh=UBsYV8TLTUucCcOZ4I7r1pAtNe3iyiNOllsN9FTRDR0=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=V+lcHyEuv79hIJS5SIwPJirGsPqUUfD0TTs3nn6APM9FX+pqis2Yx+EoMNZX71N4y
         Hao9h3PZVlQRx/i3OzZ1ngd/9oVSA36OmF08j/TxO8jtjBBL63kjoBtXGvym3inEdU
         py6rhvG3dVAXWp9fd2n6604/V91CFHQT9oLOqtptrPyYxb2YbHssgKJn1gPhcIizI4
         0fBB6v5GZ8fHCjNh54FVG/fhM1S+mx+NniSZqhJRG6SmxruWXiDSCB2xaj7lXYdvLv
         9X0lV/HM/oBmL80v6asLZqBCjPZugMy8AfSLqwGCwQI6/BROhjWTkEJOM2jmHitZsf
         D9fBTC9EFaPIA==
X-Virus-Scanned: amavisd-new at zimbra.karlsbakk.net
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id XxI3lr1q2tTD; Wed,  6 Apr 2022 23:02:50 +0200 (CEST)
Received: from zimbra.karlsbakk.net (localhost.localdomain [127.0.0.1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 112843C1DD5;
        Wed,  6 Apr 2022 23:02:49 +0200 (CEST)
Date:   Wed, 6 Apr 2022 23:02:49 +0200 (CEST)
From:   Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To:     Jorge Nunes <jorgebnunes@gmail.com>
Cc:     Wols Lists <antlists@youngman.org.uk>,
        Linux Raid <linux-raid@vger.kernel.org>
Message-ID: <1425811685.4785411.1649278969214.JavaMail.zimbra@karlsbakk.net>
In-Reply-To: <CANDfL1YiDuLXpdh7tzEepFhoir9r3r+CmQypQ4Ywhq5EN0WPjw@mail.gmail.com>
References: <CANDfL1au6kdEkR3bmLAHTdGV-Rb==8Jy1ZnwNFjvjNq7drC1XA@mail.gmail.com> <987997234.3307867.1649118543055.JavaMail.zimbra@karlsbakk.net> <336816279.3605676.1649150230084.JavaMail.zimbra@karlsbakk.net> <CANDfL1YiKq9aeUsrmdZyLb5Fy98Tifjcr_zZJY6a+LxyqKYKkA@mail.gmail.com> <b9f58b50-3f79-4a81-2f47-0f23a6958e10@youngman.org.uk> <CANDfL1YiDuLXpdh7tzEepFhoir9r3r+CmQypQ4Ywhq5EN0WPjw@mail.gmail.com>
Subject: Re: RAID 1 to RAID 5 failure
MIME-Version: 1.0
Content-Type: multipart/mixed; 
        boundary="----=_Part_4785409_1482856626.1649278969171"
X-Originating-IP: [2001:700:700:403::8:10d2]
X-Mailer: Zimbra 8.8.10_GA_3801 (ZimbraWebClient - FF98 (Mac)/8.8.10_GA_3786)
Thread-Topic: RAID 1 to RAID 5 failure
Thread-Index: c2pqr2o8mJkoUkufmudx4hF2rwahxA==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

------=_Part_4785409_1482856626.1649278969171
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

I made a log of my testing - perhaps this'll help

Vennlig hilsen

roy
--=20
Roy Sigurd Karlsbakk
(+47) 98013356
http://blogg.karlsbakk.net/
GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
--
Hi=C3=B0 g=C3=B3=C3=B0a skaltu =C3=AD stein h=C3=B6ggva, hi=C3=B0 illa =C3=
=AD snj=C3=B3 rita.

----- Original Message -----
> From: "Jorge Nunes" <jorgebnunes@gmail.com>
> To: "Wols Lists" <antlists@youngman.org.uk>
> Cc: "Roy Sigurd Karlsbakk" <roy@karlsbakk.net>, "Linux Raid" <linux-raid@=
vger.kernel.org>
> Sent: Wednesday, 6 April, 2022 22:46:10
> Subject: Re: RAID 1 to RAID 5 failure

> Hi again!
>=20
> Roy: Thank you for your input. This recovery of the misaligned data
> takes a lot of time but I'm keeping this task till the end of the
> array.
>=20
> Wol: Then I'll try this but someone has to guide me to do this shrink
> and try to get the initial array alignment.
>=20
> Thank you both!
> Best,
> Jorge
>=20
> Wols Lists <antlists@youngman.org.uk> escreveu no dia quarta,
> 6/04/2022 =C3=A0(s) 20:57:
>>
>> On 05/04/2022 11:50, Jorge Nunes wrote:
>> > Hi roy.
>> >
>> > Thank you for your time.
>> >
>> > Now, I'm doing a photorec on /dev/sda and /dev/sdd and I get better
>> > results on (some) of the data recovered if I do it on top of /dev/md0.
>> > I don't care anymore about recovering the filesystem, I just want to
>> > maximize the quality of data recovered with photorec.
>>
>> Once you've recovered everything you can, if no-one else has chimed in,
>> do try shrinking it back to a 2-disk raid-5. It SHOULD restore your
>> original filesystem. You've then just got to find out where it starts -
>> what filesystem was it?
>>
>> If it's an ext4 there's probably a signature which will tell you where
>> it starts. Then somebody should be able to tell you how to mount it and
>> back it up properly ...
>>
>> I'm sure there will be clues to other file systems, ask on your distro
>> list for more information - the more people who see a request for help,
>> the more likely you are to get some.
>>
>> Cheers,
> > Wol

------=_Part_4785409_1482856626.1649278969171
Content-Type: application/x-genesis-rom; name=major-fsckup.md
Content-Disposition: attachment; filename=major-fsckup.md
Content-Transfer-Encoding: base64

IyBTbWFsbCBmc2NrdXAgdGVzdCBieSBbUm95IFNpZ3VyZCBLYXJsc2Jha2tdKG1haWx0bzpyb3lA
a2FybHNiYWtrLm5ldCkKClRlc3QgcGVyZm9ybWVkIGluIGEgVk0gb24gS1ZNL2xpYnZpcnQKCkRy
aXZlcyB0byB1c2UgZm9yIHRlc3QKCnNkciA4RwpzZHMgOEcKc2R0IDhHCnNkdSA4RwoKYGBgCnJv
b3RAcmFpZHRlc3Q6fiMgZmRpc2sgL2Rldi9zZHIKYGBgCkNyZWF0ZSBhIHNpbmdsZSBwYXJ0aXRp
b24gb24gdGhlIGRyaXZlIC0gc2FtZSB3aXRoIHNkcwoKQ2hlY2sgbGF5b3V0CmBgYApyb290QHJh
aWR0ZXN0On4jIGxzYmxrIC9kZXYvc2RbcnNdCk5BTUUgICBNQUo6TUlOIFJNIFNJWkUgUk8gVFlQ
RSBNT1VOVFBPSU5UCnNkciAgICAgNjU6MTYgICAwICAgOEcgIDAgZGlzawrilJTilIBzZHIxICA2
NToxNyAgIDAgICA4RyAgMCBwYXJ0CnNkcyAgICAgNjU6MzIgICAwICAgOEcgIDAgZGlzawrilJTi
lIBzZHMxICA2NTozMyAgIDAgICA4RyAgMCBwYXJ0CmBgYAoKQ3JlYXRlIGluaXRpYWwgUkFJRApg
YGAKcm9vdEByYWlkdGVzdDp+IyBtZGFkbSAtLWNyZWF0ZSAvZGV2L21kMyAtLWxldmVsPTEgLS1y
YWlkLWRldmljZXM9MiAvZGV2L3NkW3JzXTEKYGBgCgpJbml0aWFsIFJBSUQgY3JlYXRlZCB3aXRo
IHN1cGVyYmxvY2sgMS4yCgpNYWtlIGV4dDQgZnMgb24gaXQgYW5kIG1vdW50IGl0CmBgYAojIG1r
ZnMgLXQgZXh0NCAvZGV2L21kMwpta2UyZnMgMS40Ni4yICgyOC1GZWItMjAyMSkKRGlzY2FyZGlu
ZyBkZXZpY2UgYmxvY2tzOiBkb25lCkNyZWF0aW5nIGZpbGVzeXN0ZW0gd2l0aCAyMDk1NjE2IDRr
IGJsb2NrcyBhbmQgNTI0Mjg4IGlub2RlcwpGaWxlc3lzdGVtIFVVSUQ6IGRjMmNhYjIzLTdlNGUt
NDBlYy1iZWEwLWIyYzljOGM0ZTE0OQpTdXBlcmJsb2NrIGJhY2t1cHMgc3RvcmVkIG9uIGJsb2Nr
czoKCTMyNzY4LCA5ODMwNCwgMTYzODQwLCAyMjkzNzYsIDI5NDkxMiwgODE5MjAwLCA4ODQ3MzYs
IDE2MDU2MzIKCkFsbG9jYXRpbmcgZ3JvdXAgdGFibGVzOiBkb25lCldyaXRpbmcgaW5vZGUgdGFi
bGVzOiBkb25lCkNyZWF0aW5nIGpvdXJuYWwgKDE2Mzg0IGJsb2Nrcyk6IGRvbmUKV3JpdGluZyBz
dXBlcmJsb2NrcyBhbmQgZmlsZXN5c3RlbSBhY2NvdW50aW5nIGluZm9ybWF0aW9uOiBkb25lCnJv
b3RAcmFpZHRlc3Q6fiMgbWtkaXIgL2ZzY2t1cHRlc3QKcm9vdEByYWlkdGVzdDp+IyBtb3VudCAv
ZGV2L21kMyAvZnNja3VwdGVzdApyb290QHJhaWR0ZXN0On4jIGRmIC1oIC9mc2NrdXB0ZXN0LwpG
aWxlc3lzdGVtICAgICAgU2l6ZSAgVXNlZCBBdmFpbCBVc2UlIE1vdW50ZWQgb24KL2Rldi9tZDMg
ICAgICAgIDcuOEcgICAyNEsgIDcuNEcgICAxJSAvZnNja3VwdGVzdApgYGAKCkkgZ3JhYmJlZCBk
ZWJpYW4tbGl2ZS0xMS4zLjAtYW1kNjQte2Npbm5hbW9uLGdub21lLHN0YW5kYXJkfS5pc28gZnJv
bSB0aGUgbmVhcmVzdCBkZWJpYW4gbWlycm9yCnNvIG5vdyBvbmx5IDFHQiBsZWZ0LgoKIyMgRnNj
a3VwIHRpbWUhCiMjIyBVbW91bnQgYW5kIHN0b3AgdGhlIHJhaWQKYGBgCnJvb3RAcmFpZHRlc3Q6
fiMgdW1vdW50IC9mc2NrdXB0ZXN0CnJvb3RAcmFpZHRlc3Q6fiMgdW1vdW50IC1mIC9kZXYvbWQz
CnVtb3VudDogL2Rldi9tZDM6IG5vdCBtb3VudGVkLgpyb290QHJhaWR0ZXN0On4jIG1kYWRtIC0t
c3RvcCAvZGV2L21kMwptZGFkbTogc3RvcHBlZCAvZGV2L21kMwpgYGAKIyMjIENyZWF0ZSBhIG5l
dyBSQUlELTUgb24gdG9wIG9mIHRoZSBvbGQgUkFJRC0xCmBgYApyb290QHJhaWR0ZXN0On4jIG1k
YWRtIC0tY3JlYXRlIC9kZXYvbWQzIC1hIHllcyAtbCA1IC1uIDIgL2Rldi9zZHIgL2Rldi9zZHMK
bWRhZG06IHBhcnRpdGlvbiB0YWJsZSBleGlzdHMgb24gL2Rldi9zZHIKbWRhZG06IHBhcnRpdGlv
biB0YWJsZSBleGlzdHMgb24gL2Rldi9zZHIgYnV0IHdpbGwgYmUgbG9zdCBvcgogICAgICAgbWVh
bmluZ2xlc3MgYWZ0ZXIgY3JlYXRpbmcgYXJyYXkKbWRhZG06IHBhcnRpdGlvbiB0YWJsZSBleGlz
dHMgb24gL2Rldi9zZHMKbWRhZG06IHBhcnRpdGlvbiB0YWJsZSBleGlzdHMgb24gL2Rldi9zZHMg
YnV0IHdpbGwgYmUgbG9zdCBvcgogICAgICAgbWVhbmluZ2xlc3MgYWZ0ZXIgY3JlYXRpbmcgYXJy
YXkKQ29udGludWUgY3JlYXRpbmcgYXJyYXk/IHkKbWRhZG06IERlZmF1bHRpbmcgdG8gdmVyc2lv
biAxLjIgbWV0YWRhdGEKbWRhZG06IGFycmF5IC9kZXYvbWQzIHN0YXJ0ZWQuCnJvb3RAcmFpZHRl
c3Q6fiMgbWRhZG0gLS1hZGQgL2Rldi9tZDMgL2Rldi9zZFt0dV0KbWRhZG06IGFkZGVkIC9kZXYv
c2R0Cm1kYWRtOiBhZGRlZCAvZGV2L3NkdQpgYGAKIyMjIEFuZCBncm93IGl0CmBgYApyb290QHJh
aWR0ZXN0On4jIG1kYWRtIC0tZ3JvdyAvZGV2L21kMyAtLXJhaWQtZGlzaz00CmBgYApXYWl0IHRp
bGwgaXQncyBkb25lIHN5bmNpbmcgYW5kIHJhbiBmc2NrIC9kZXYvbWQzIC0gc2FtZSBhcyB5b3Ug
Z290OgpgYGAKcm9vdEByYWlkdGVzdDp+IyBmc2NrIC9kZXYvbWQzCmZzY2sgZnJvbSB1dGlsLWxp
bnV4IDIuMzYuMQplMmZzY2sgMS40Ni4yICgyOC1GZWItMjAyMSkKZXh0MmZzX29wZW4yOiBCYWQg
bWFnaWMgbnVtYmVyIGluIHN1cGVyLWJsb2NrCmZzY2suZXh0MjogU3VwZXJibG9jayBpbnZhbGlk
LCB0cnlpbmcgYmFja3VwIGJsb2Nrcy4uLgpmc2NrLmV4dDI6IEJhZCBtYWdpYyBudW1iZXIgaW4g
c3VwZXItYmxvY2sgd2hpbGUgdHJ5aW5nIHRvIG9wZW4gL2Rldi9tZDMKClRoZSBzdXBlcmJsb2Nr
IGNvdWxkIG5vdCBiZSByZWFkIG9yIGRvZXMgbm90IGRlc2NyaWJlIGEgdmFsaWQgZXh0Mi9leHQz
L2V4dDQKZmlsZXN5c3RlbS4gIElmIHRoZSBkZXZpY2UgaXMgdmFsaWQgYW5kIGl0IHJlYWxseSBj
b250YWlucyBhbiBleHQyL2V4dDMvZXh0NApmaWxlc3lzdGVtIChhbmQgbm90IHN3YXAgb3IgdWZz
IG9yIHNvbWV0aGluZyBlbHNlKSwgdGhlbiB0aGUgc3VwZXJibG9jawppcyBjb3JydXB0LCBhbmQg
eW91IG1pZ2h0IHRyeSBydW5uaW5nIGUyZnNjayB3aXRoIGFuIGFsdGVybmF0ZSBzdXBlcmJsb2Nr
OgogICAgZTJmc2NrIC1iIDgxOTMgPGRldmljZT4KIG9yCiAgICBlMmZzY2sgLWIgMzI3NjggPGRl
dmljZT4KYGBgCgojIyBBbiBhdHRlbXB0IHRvIGZpeCB0aGlzCgpGaXJzdCBjaGVjayB0aGUgY3Vy
cmVudCBzaXplIG9mIHRoZSBhcnJheQoKYGBgCnJvb3RAcmFpZHRlc3Q6fiMgY2F0IC9wcm9jL21k
c3RhdAptZDMgOiBhY3RpdmUgcmFpZDUgc2R1WzRdIHNkdFszXSBzZHNbMl0gc2RyWzBdCiAgICAg
IDI1MTM4MTc2IGJsb2NrcyBzdXBlciAxLjIgbGV2ZWwgNSwgNTEyayBjaHVuaywgYWxnb3JpdGht
IDIgWzQvNF0gW1VVVVVdCnJvb3RAcmFpZHRlc3Q6fiMgbWRhZG0gLS1kZXRhaWwgL2Rldi9tZDMg
fCBncmVwIC1lICJBcnJheSBTaXplIiAtZSAiRGV2IFNpemUiCiAgICAgICAgQXJyYXkgU2l6ZSA6
IDI1MTM4MTc2ICgyMy45NyBHaUIgMjUuNzQgR0IpCiAgICAgVXNlZCBEZXYgU2l6ZSA6IDgzNzkz
OTIgKDcuOTkgR2lCIDguNTggR0IpCmBgYAoKV2UgaGF2ZW4ndCBncm93biB0aGUgYXJyYXkgeWV0
LCBzbyBwZXJoYXBzIG5vIGRhdGEgaXMgbG9zdD8KClNocmluayB0aGUgYXJyYXkgc2l6ZSB0byB3
aGF0J3MgaW4gdXNlCgpgYGAKcm9vdEByYWlkdGVzdDp+IyBtZGFkbSAtLWdyb3cgL2Rldi9tZDMg
LS1hcnJheS1zaXplIDgzNzkzOTIKYGBgClJlZHVjZSB0aGUgYXJyYXkgYnkgcmVtb3ZpbmcgdGhl
IG5ldyBkcml2ZXMsIHNkdSBhbmQgc2R0CgpgYGAKcm9vdEByYWlkdGVzdDp+IyBtZGFkbSAtLWdy
b3cgLS1yYWlkLWRldmljZXM9MiAvZGV2L21kMyAtLWJhY2t1cC1maWxlIC9iYWNrdXAvbWQzLmJh
Y2t1cAptZGFkbTogTmVlZCB0byBiYWNrdXAgMTUzNksgb2YgY3JpdGljYWwgc2VjdGlvbi4uCmBg
YAoKQ2hlY2sgcGFydGl0aW9uIHRhYmxlcwpgYGAKcm9vdEByYWlkdGVzdDp+IyBsc2JsayAvZGV2
L3NkW3JzXQpOQU1FICAgTUFKOk1JTiBSTSBTSVpFIFJPIFRZUEUgTU9VTlRQT0lOVApzZHIgICAg
IDY1OjE2ICAgMCAgIDhHICAwIGRpc2sK4pSU4pSAc2RyMSAgNjU6MTcgICAwICAgOEcgIDAgcGFy
dApzZHMgICAgIDY1OjMyICAgMCAgIDhHICAwIGRpc2sK4pSU4pSAc2RzMSAgNjU6MzMgICAwICAg
OEcgIDAgcGFydApgYGAKCkxvb2tzIGdvb2QgLSBhdHRlbXB0IHRvIHJlY3JlYXRlIHRoZSBvbGQg
cmFpZDEKCmBgYAptZGFkbSAtLWNyZWF0ZSAvZGV2L21kMyAtLWxldmVsPTEgLS1hc3N1bWUtY2xl
YW4gLS1yYWlkLWRldmljZXM9MiAvZGV2L3NkW3JzXTEgCm1kYWRtOiAvZGV2L3NkcjEgYXBwZWFy
cyB0byBiZSBwYXJ0IG9mIGEgcmFpZCBhcnJheToKICAgICAgIGxldmVsPXJhaWQxIGRldmljZXM9
MiBjdGltZT1UdWUgQXByICA1IDEwOjM3OjAxIDIwMjIKbWRhZG06IE5vdGU6IHRoaXMgYXJyYXkg
aGFzIG1ldGFkYXRhIGF0IHRoZSBzdGFydCBhbmQKICAgIG1heSBub3QgYmUgc3VpdGFibGUgYXMg
YSBib290IGRldmljZS4gIElmIHlvdSBwbGFuIHRvCiAgICBzdG9yZSAnL2Jvb3QnIG9uIHRoaXMg
ZGV2aWNlIHBsZWFzZSBlbnN1cmUgdGhhdAogICAgeW91ciBib290LWxvYWRlciB1bmRlcnN0YW5k
cyBtZC92MS54IG1ldGFkYXRhLCBvciB1c2UKICAgIC0tbWV0YWRhdGE9MC45MAptZGFkbTogL2Rl
di9zZHMxIGFwcGVhcnMgdG8gYmUgcGFydCBvZiBhIHJhaWQgYXJyYXk6CiAgICAgICBsZXZlbD1y
YWlkMSBkZXZpY2VzPTIgY3RpbWU9VHVlIEFwciAgNSAxMDozNzowMSAyMDIyCkNvbnRpbnVlIGNy
ZWF0aW5nIGFycmF5PyB5Cm1kYWRtOiBEZWZhdWx0aW5nIHRvIHZlcnNpb24gMS4yIG1ldGFkYXRh
Cm1kYWRtOiBhcnJheSAvZGV2L21kMyBzdGFydGVkLgpgYGAKCkNoZWNrIHdoYXQncyBvbiAvZGV2
L21kMwoKYGBgCnJvb3RAcmFpZHRlc3Q6fiMgZmlsZSAtcyAvZGV2L21kMwovZGV2L21kMzogTGlu
dXggcmV2IDEuMCBleHQ0IGZpbGVzeXN0ZW0gZGF0YSwgVVVJRD02NWViNTAwNy02MTg4LTRiMDAt
YWUyYS1jYzg0ZWMzNzE1NjYgKGV4dGVudHMpICg2NGJpdCkgKGxhcmdlIGZpbGVzKSAoaHVnZSBm
aWxlcykKYGBgCgpBdHRlbXQgdG8gbW91bnQgaXQKCmBgYApyb290QHJhaWR0ZXN0On4jIG1vdW50
IC9kZXYvbWQzIC9mc2NrdXB0ZXN0Lwptb3VudDogL2ZzY2t1cHRlc3Q6IHdyb25nIGZzIHR5cGUs
IGJhZCBvcHRpb24sIGJhZCBzdXBlcmJsb2NrIG9uIC9kZXYvbWQzLCBtaXNzaW5nIGNvZGVwYWdl
IG9yIGhlbHBlciBwcm9ncmFtLCBvciBvdGhlciBlcnJvci4KYGBgCgpmc2NrCgpgYGAKcm9vdEBy
YWlkdGVzdDp+IyBmc2NrIC15IC9kZXYvbWQzCmZzY2sgZnJvbSB1dGlsLWxpbnV4IDIuMzYuMQpl
MmZzY2sgMS40Ni4yICgyOC1GZWItMjAyMSkKU3VwZXJibG9jayBoYXMgYW4gaW52YWxpZCBqb3Vy
bmFsIChpbm9kZSA4KS4KQ2xlYXI/IHllcwoKKioqIGpvdXJuYWwgaGFzIGJlZW4gZGVsZXRlZCAq
KioKClJlc2l6ZSBpbm9kZSBub3QgdmFsaWQuICBSZWNyZWF0ZT8geWVzCgpQYXNzIDE6IENoZWNr
aW5nIGlub2RlcywgYmxvY2tzLCBhbmQgc2l6ZXMKUm9vdCBpbm9kZSBpcyBub3QgYSBkaXJlY3Rv
cnkuICBDbGVhcj8geWVzCihsb3RzIG9mIG1vcmUgZXJyb3JzKQpgYGAKCk1vdW50IGl0IGFuZCBj
aGVjayBjb250ZW50cwoKYGBgCnJvb3RAcmFpZHRlc3Q6fiMgbW91bnQgL2Rldi9tZDMgL2ZzY2t1
cHRlc3QvCnJvb3RAcmFpZHRlc3Q6fiMgbHMgL2ZzY2t1cHRlc3QvCmxvc3QrZm91bmQvCnJvb3RA
cmFpZHRlc3Q6fiMgZmluZCAvZnNja3VwdGVzdC8KL2ZzY2t1cHRlc3QvCi9mc2NrdXB0ZXN0L2xv
c3QrZm91bmQKcm9vdEByYWlkdGVzdDp+IwpgYGAKCgo=
------=_Part_4785409_1482856626.1649278969171--
