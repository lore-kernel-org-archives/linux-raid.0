Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27407C433B4
	for <linux-raid@archiver.kernel.org>; Wed, 12 May 2021 23:21:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3D40613EB
	for <linux-raid@archiver.kernel.org>; Wed, 12 May 2021 23:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbhELXWJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 May 2021 19:22:09 -0400
Received: from mail.xmyslivec.cz ([83.167.247.77]:35838 "EHLO
        mail.xmyslivec.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349952AbhELWuE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 12 May 2021 18:50:04 -0400
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 May 2021 18:50:03 EDT
Received: from [172.23.0.68] (mh1-fw.logicworks.mh.etn.cz [82.113.58.199])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.xmyslivec.cz (Postfix) with ESMTPSA id BA2BB4022F;
        Thu, 13 May 2021 00:39:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=xmyslivec.cz;
        s=master; t=1620859171;
        bh=3Yf8cronTNezzMhKYBkkHKtKHHs3xOHqzA1zr54ZIFo=;
        h=To:Cc:References:From:Subject:Date:In-Reply-To:From;
        b=gk7gWIMVYf6LlaIZeOFtI1W1gbvk3yKrBtdwoTMKZo0k/vAy4QWJXIOOuUUSC65jn
         Ex8beXzW36FdO7Wg7gnDEdp/KsQead/7w470Wooo0yoaLhJHSVj9jdM7YxVk5AH5a8
         FXNXHp9MRSm0CCBObgKmxKHMDnbe5u0PBdk/eKpNNSI1M/mBSY14oDM5v/Q5R0OvmX
         6Nfu4N8f/p/hILPBczFEMHuFabrbWh9nByMoWRwkS8Ec/SnK6jI/PArSSOGBPDkPh7
         LLlAGa11VdOmIRUd1UmCDx3UxBQgIQCEvwBbJw1sC1Ejl145PqklFbli3j59fPUPPR
         82ff1AppgBWBQ==
To:     Song Liu <song@kernel.org>
Cc:     Manuel Riel <manu@snapdragon.cc>,
        Linux-RAID <linux-raid@vger.kernel.org>,
        Michal Moravec <michal.moravec@logicworks.cz>
References: <DAEB6C2F-3AE0-4EBE-8775-7C6292F8749A@snapdragon.cc>
 <CAPhsuW4=XoyQV_HNVnFnMWS2PvvU1+Rtbh9SJB-FQTO3haa3ig@mail.gmail.com>
 <27EE5CBC-B1B8-4463-87F5-2AE73F30941B@snapdragon.cc>
 <C990C60B-FB5A-4709-949B-6D86AF9FA6B1@snapdragon.cc>
 <CAPhsuW5urYTuOago=5sGiQ_7huQ6S+2rYkQ=n+_TwxQtxC3tWQ@mail.gmail.com>
From:   Vojtech Myslivec <vojtech@xmyslivec.cz>
Subject: Re: [PATCH] md: warn about using another MD array as write journal
Message-ID: <0016997f-7fbe-a346-e94a-b3dd6d5e04c0@xmyslivec.cz>
Date:   Thu, 13 May 2021 00:39:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <CAPhsuW5urYTuOago=5sGiQ_7huQ6S+2rYkQ=n+_TwxQtxC3tWQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------A9939921D67E7789AF073D0E"
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This is a multi-part message in MIME format.
--------------A9939921D67E7789AF073D0E
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

It has been two months since I last reported the state of the issue:

On 17. 03. 21 16:55, Vojtech Myslivec wrote:
 > Thanks a lot Manuel for your findings and information.
 >
 > I have moved journal from logical volume on RAID1 to a plain partition
 > on a SSD and I will monitor the state.

So, we run the MD level 6 array (/dev/md1) with journal device on
a plain partition of one of SSD disk (/dev/sdh5) now. See attached files
for more details.


Since then (March 17th), our discussed issue happened "only" three 
times. First occurrence was on April 21st, 5 weeks after moving the journal.

*I can confirm that the issue still persist, but it is definitely less
frequent.*



On 22. 03. 21 18:13, Song Liu wrote:
 > Thanks for the information. Quick question, does the kernel have the
 > following change?
 >
 > commit c9020e64cf33f2dd5b2a7295f2bfea787279218a Author: Song
 > Liu<songliubraving@fb.com> Date:   9 months ago
 >
 > ...

We run latest available kernel from "Debian backports" distribution
repository, that is Linux version 5.10 currently. I checked that we had
kernel 5.10 as well on March, when I moved the journal.

If I checked it well, this particular patch is part of kernel 5.9
already.



Maybe unrelated, but I noticed this log message just after our "unstuck"
script performed some random I/O operation (just as I described before 
in this e-mail thread):

     May 2 ... kernel: [2035647.004554] md: md1: data-check done.



I would provide more information if needed. Thanks for any new info.

Vojtech Myslivec

--------------A9939921D67E7789AF073D0E
Content-Type: text/plain; charset=UTF-8;
 name="lsblk.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="lsblk.txt"

TkFNRSAgICAgICAgICAgTUFKOk1JTiBSTSAgIFNJWkUgUk8gVFlQRSAgTU9VTlRQT0lOVApz
ZGEgICAgICAgICAgICAgIDg6MCAgICAwICAgNywzVCAgMCBkaXNrICAK4pSU4pSAbWQxICAg
ICAgICAgICAgOToxICAgIDAgIDI5LDFUICAwIHJhaWQ2IC9tbnQvZGF0YQpzZGIgICAgICAg
ICAgICAgIDg6MTYgICAwICAgNywzVCAgMCBkaXNrICAK4pSU4pSAbWQxICAgICAgICAgICAg
OToxICAgIDAgIDI5LDFUICAwIHJhaWQ2IC9tbnQvZGF0YQpzZGMgICAgICAgICAgICAgIDg6
MzIgICAwICAgNywzVCAgMCBkaXNrICAK4pSU4pSAbWQxICAgICAgICAgICAgOToxICAgIDAg
IDI5LDFUICAwIHJhaWQ2IC9tbnQvZGF0YQpzZGQgICAgICAgICAgICAgIDg6NDggICAwICAg
NywzVCAgMCBkaXNrICAK4pSU4pSAbWQxICAgICAgICAgICAgOToxICAgIDAgIDI5LDFUICAw
IHJhaWQ2IC9tbnQvZGF0YQpzZGUgICAgICAgICAgICAgIDg6NjQgICAwICAgNywzVCAgMCBk
aXNrICAK4pSU4pSAbWQxICAgICAgICAgICAgOToxICAgIDAgIDI5LDFUICAwIHJhaWQ2IC9t
bnQvZGF0YQpzZGYgICAgICAgICAgICAgIDg6ODAgICAwICAgNywzVCAgMCBkaXNrICAK4pSU
4pSAbWQxICAgICAgICAgICAgOToxICAgIDAgIDI5LDFUICAwIHJhaWQ2IC9tbnQvZGF0YQpz
ZGcgICAgICAgICAgICAgIDg6OTYgICAxIDIyMyw2RyAgMCBkaXNrICAK4pSc4pSAc2RnMSAg
ICAgICAgICAgODo5NyAgIDEgIDM3LDNHICAwIHBhcnQgIArilIIg4pSU4pSAbWQwICAgICAg
ICAgIDk6MCAgICAwICAzNywyRyAgMCByYWlkMSAK4pSCICAg4pSc4pSAdmcwLXN3YXAgMjUz
OjAgICAgMCAgIDMsN0cgIDAgbHZtICAgW1NXQVBdCuKUgiAgIOKUlOKUgHZnMC1yb290IDI1
MzoxICAgIDAgIDE0LDlHICAwIGx2bSAgIC8K4pSc4pSAc2RnMiAgICAgICAgICAgODo5OCAg
IDEgICAgIDFLICAwIHBhcnQgIArilJzilIBzZGc1ICAgICAgICAgICA4OjEwMSAgMSAgICAg
OEcgIDAgcGFydCAgCuKUlOKUgHNkZzYgICAgICAgICAgIDg6MTAyICAxIDE3OCwzRyAgMCBw
YXJ0ICAKc2RoICAgICAgICAgICAgICA4OjExMiAgMSAyMjMsNkcgIDAgZGlzayAgCuKUnOKU
gHNkaDEgICAgICAgICAgIDg6MTEzICAxICAzNywzRyAgMCBwYXJ0ICAK4pSCIOKUlOKUgG1k
MCAgICAgICAgICA5OjAgICAgMCAgMzcsMkcgIDAgcmFpZDEgCuKUgiAgIOKUnOKUgHZnMC1z
d2FwIDI1MzowICAgIDAgICAzLDdHICAwIGx2bSAgIFtTV0FQXQrilIIgICDilJTilIB2ZzAt
cm9vdCAyNTM6MSAgICAwICAxNCw5RyAgMCBsdm0gICAvCuKUnOKUgHNkaDIgICAgICAgICAg
IDg6MTE0ICAxICAgICAxSyAgMCBwYXJ0ICAK4pSc4pSAc2RoNSAgICAgICAgICAgODoxMTcg
IDEgICAgIDhHICAwIHBhcnQgIArilIIg4pSU4pSAbWQxICAgICAgICAgIDk6MSAgICAwICAy
OSwxVCAgMCByYWlkNiAvbW50L2RhdGEK4pSU4pSAc2RoNiAgICAgICAgICAgODoxMTggIDEg
MTc4LDNHICAwIHBhcnQgIAo=
--------------A9939921D67E7789AF073D0E
Content-Type: text/plain; charset=UTF-8;
 name="mdstat-detail-md0.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="mdstat-detail-md0.txt"

L2Rldi9tZDA6CiAgICAgICAgICAgVmVyc2lvbiA6IDEuMgogICAgIENyZWF0aW9uIFRpbWUg
OiBUdWUgSmFuICA4IDEzOjE2OjI2IDIwMTkKICAgICAgICBSYWlkIExldmVsIDogcmFpZDEK
ICAgICAgICBBcnJheSBTaXplIDogMzkwMjg3MzYgKDM3LjIyIEdpQiAzOS45NyBHQikKICAg
ICBVc2VkIERldiBTaXplIDogMzkwMjg3MzYgKDM3LjIyIEdpQiAzOS45NyBHQikKICAgICAg
UmFpZCBEZXZpY2VzIDogMgogICAgIFRvdGFsIERldmljZXMgOiAyCiAgICAgICBQZXJzaXN0
ZW5jZSA6IFN1cGVyYmxvY2sgaXMgcGVyc2lzdGVudAoKICAgICAgIFVwZGF0ZSBUaW1lIDog
VGh1IE1heSAxMyAwMDoxNzowNiAyMDIxCiAgICAgICAgICAgICBTdGF0ZSA6IGNsZWFuIAog
ICAgQWN0aXZlIERldmljZXMgOiAyCiAgIFdvcmtpbmcgRGV2aWNlcyA6IDIKICAgIEZhaWxl
ZCBEZXZpY2VzIDogMAogICAgIFNwYXJlIERldmljZXMgOiAwCgpDb25zaXN0ZW5jeSBQb2xp
Y3kgOiByZXN5bmMKCiAgICAgICAgICAgICAgTmFtZSA6IGJhY2t1cDE6MCAgKGxvY2FsIHRv
IGhvc3QgYmFja3VwMSkKICAgICAgICAgICAgICBVVUlEIDogZmUwNmFjNjc6OTY3YzYyZjc6
NWVmMWI2N2I6N2I5NTExMDQKICAgICAgICAgICAgRXZlbnRzIDogNjk3CgogICAgTnVtYmVy
ICAgTWFqb3IgICBNaW5vciAgIFJhaWREZXZpY2UgU3RhdGUKICAgICAgIDAgICAgICAgOCAg
ICAgICA5NyAgICAgICAgMCAgICAgIGFjdGl2ZSBzeW5jICAgL2Rldi9zZGcxCiAgICAgICAx
ICAgICAgIDggICAgICAxMTMgICAgICAgIDEgICAgICBhY3RpdmUgc3luYyAgIC9kZXYvc2Ro
MQoK
--------------A9939921D67E7789AF073D0E
Content-Type: text/plain; charset=UTF-8;
 name="mdstat-detail-md1.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="mdstat-detail-md1.txt"

L2Rldi9tZDE6CiAgICAgICAgICAgVmVyc2lvbiA6IDEuMgogICAgIENyZWF0aW9uIFRpbWUg
OiBXZWQgQXByICAzIDE3OjE2OjIwIDIwMTkKICAgICAgICBSYWlkIExldmVsIDogcmFpZDYK
ICAgICAgICBBcnJheSBTaXplIDogMzEyNTYxMDA4NjQgKDI5ODA4LjE0IEdpQiAzMjAwNi4y
NSBHQikKICAgICBVc2VkIERldiBTaXplIDogNzgxNDAyNTIxNiAoNzQ1Mi4wNCBHaUIgODAw
MS41NiBHQikKICAgICAgUmFpZCBEZXZpY2VzIDogNgogICAgIFRvdGFsIERldmljZXMgOiA3
CiAgICAgICBQZXJzaXN0ZW5jZSA6IFN1cGVyYmxvY2sgaXMgcGVyc2lzdGVudAoKICAgICAg
IFVwZGF0ZSBUaW1lIDogVGh1IE1heSAxMyAwMDoxNToyMiAyMDIxCiAgICAgICAgICAgICBT
dGF0ZSA6IGNsZWFuIAogICAgQWN0aXZlIERldmljZXMgOiA2CiAgIFdvcmtpbmcgRGV2aWNl
cyA6IDcKICAgIEZhaWxlZCBEZXZpY2VzIDogMAogICAgIFNwYXJlIERldmljZXMgOiAwCgog
ICAgICAgICAgICBMYXlvdXQgOiBsZWZ0LXN5bW1ldHJpYwogICAgICAgIENodW5rIFNpemUg
OiA1MTJLCgpDb25zaXN0ZW5jeSBQb2xpY3kgOiBqb3VybmFsCgogICAgICAgICAgICAgIE5h
bWUgOiBiYWNrdXAxOjEgIChsb2NhbCB0byBob3N0IGJhY2t1cDEpCiAgICAgICAgICAgICAg
VVVJRCA6IGZkNjFjYjIyOjMwYmZjNjE2OjY1MDY4MjlkOjkzMTlhZjk1CiAgICAgICAgICAg
IEV2ZW50cyA6IDI1ODg4MzYKCiAgICBOdW1iZXIgICBNYWpvciAgIE1pbm9yICAgUmFpZERl
dmljZSBTdGF0ZQogICAgICAgMSAgICAgICA4ICAgICAgIDE2ICAgICAgICAwICAgICAgYWN0
aXZlIHN5bmMgICAvZGV2L3NkYgogICAgICAgMiAgICAgICA4ICAgICAgICAwICAgICAgICAx
ICAgICAgYWN0aXZlIHN5bmMgICAvZGV2L3NkYQogICAgICAgMyAgICAgICA4ICAgICAgIDMy
ICAgICAgICAyICAgICAgYWN0aXZlIHN5bmMgICAvZGV2L3NkYwogICAgICAgNCAgICAgICA4
ICAgICAgIDQ4ICAgICAgICAzICAgICAgYWN0aXZlIHN5bmMgICAvZGV2L3NkZAogICAgICAg
NSAgICAgICA4ICAgICAgIDY0ICAgICAgICA0ICAgICAgYWN0aXZlIHN5bmMgICAvZGV2L3Nk
ZQogICAgICAgNiAgICAgICA4ICAgICAgIDgwICAgICAgICA1ICAgICAgYWN0aXZlIHN5bmMg
ICAvZGV2L3NkZgoKICAgICAgIDcgICAgICAgOCAgICAgIDExNyAgICAgICAgLSAgICAgIGpv
dXJuYWwgICAvZGV2L3NkaDUKCg==
--------------A9939921D67E7789AF073D0E--
