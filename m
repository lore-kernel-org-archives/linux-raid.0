Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DAB1C433B4
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 16:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C38B611AB
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 16:55:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346886AbhESQ4u (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 May 2021 12:56:50 -0400
Received: from sonic313-22.consmr.mail.gq1.yahoo.com ([98.137.65.85]:42825
        "EHLO sonic313-22.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241252AbhESQ4t (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 19 May 2021 12:56:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=att.net; s=s1024; t=1621443330; bh=6bk1BQZspr1VOO5HVJ6vkeOX/q4EOACV4kkuUFbqZNo=; h=Subject:To:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=LJdHOx4k3SpknULWoZrP5hWefn+2nwU5dDKvpokbqpNSMrxth68KPJ5s9A9ZAcC2OLCJsDeee+kezXAGbsS7RIHw+tUT3zdM/owQ5lNmsQKTpcaDv73xmb54GtQOPDu0hClR0VtTalxdLGxtgXjSVb7HSeGrgfppXcF8YWYlI1c=
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1621443330; bh=qARhmkbAsOUw1GuVeGziJMjHnetc2P2gqYBDOTAvNzn=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=NfjNGI5K69mbsWJJOYGgyd1iNMGLpYX3sofru9fQzlbNXFqQgWZmA+FltoM4XP+Iy2Hwvv3b6OsxD+r/1v8hWXQwpRTMgGUwij18zg9GT30bRdpdEuz7YZF4b+uKTL0ce+zhgq3zl5XS5O0zD2+adMwTfxiut3VMOw4imGgbeFrZjI9h/Nad1h98M1nG/FQmdpiLdGeC5Bf1mJW26eGZJur9I1GfF1MusYVQeRyNRGia6M2p2Lg6oWaGRCZoBwYoejjUnKMHRr+Oes7oNEKchkmlDSgs+lMuACN8fcOngcEb2oS+pWSmTFRYZ9c0f90yBAAq04hxKTVlk4oq4FXELA==
X-YMail-OSG: bQkgFgQVM1kT4yMC0TwTZ_yOiB._xL5LFUNvD8g0XQyDoPL0VZcLKm.0u8ShNwF
 7PcMjr1xT7ZuRe_EGL1oFYUpIt3CY6EinbuXhJg2RV_pcTd1vu5Cxh2MrSW9UwQ6rfspc2b5O7ZF
 R8UQPam8lZWfUgbVjSReyvVVpE9U0Kvar79DgxFrBxo9lFiDwoeDLdReH3ajW1PtO0KNYKBFvQbi
 eVsyI6fdq0NLWRcCTDtLQrXudJy3YUioKi0bqYRZ9x3.GGYU5pS2amUce82Om7Gqd3E0ciedRvkq
 3R8CGWJgei1ZBFmkdK_Tm6pFBkZ0xsqBE0KEd2m_9KhPaz0H9PQafQcX4zUdnYbWHnuqnG.hzJ_8
 bNZUKjLpKeYERiHVQRz9WIo3A1gufpNGzvfhGQhNMGkb_J1SYIELdHR.LCNK71uTJvMh0u0M2VXN
 oKsKbc3ZMrKB.FyEYZ9PeTlC33zaPdFTIGwTqN_3Rn.5zGUTe0tCRhex0CdgOmKgHmKQIRzffUzi
 TLv5vrSgiKIm1Rh0088n5HX9rJ_xp5lvPjV52S4gxYKwT3miXPns1Lqfyaz7m2YSazsAzoRjd4p3
 1HMtI8YhjqXf4bxfmcIXAF.UOE6hSvqZICr2zL5WqrWaxpSbRbkJs5EpqXwFi8mUETmSaE.ZSF0u
 VaO5ErVoahdBKPXVF5ixJ9ByUeyMG3i4YpkIVig_wT91PQbA_gGPUytNbYwk8wdj51o2jakSt6K1
 I.WN30z3WNrESsYOTvzMniIIoXzCg9Y51pWiuLfAnfIp5Oja927ZJimZHwyik3fBS87NvLq9pbHz
 p.dxZGPgEhloQMJgnqXGZP9Py2CVazFUA9H47y3ohbdrToc5wuPbEmJ1jzonzmis3K9WeggJnXz8
 HamQC7I0nTuq2aputMOPYSxP.FEN5sRYC2vSGLtjLzsb8JL.NV9IM.JIJHadcsnOEjjYmjlNk_YI
 Qoa8o.B8mjhmkvCD8AdH6XhuFtXAPjFzj23xnKkjV32mEDkhqFtezg6W3mxIGM4W04zgdy7BLy7Q
 OXAhOxBBVtZvB0vhufsyeGb_YbHnymmr3abo04LZYBZ5WceVN0Co.Df_ZZFdmEPnGgghsEQ4K_ZT
 KSrDc.wZe3SOoMhfi.WxwwQmhKG4XuJ8Y.oPHFgz_qsLYg.pHqiXmkx533KhMC0Ay2TkIyBbBrNf
 aN1hsCxb_wsuyaqV9jmQR0CcLicxST.WWtHQP2iV.jH3KQezJeWB0c_eRlOKin0u9Fff7Q5KKMRP
 LiOGQbr3V4uf_9.q.BHrdCR8Mbn9pVJfGf8QGKz6zmyYGfK02jrMru_apIhE6mUYLp46nXJr4vWY
 2jvbJ9Xc3ZkRFHqSeskCY8ZlnerxKe9VDmgC9tdK2drP.iGE518qFFIE9xDUKJB4RQwmQj_oSUtc
 UcPoiEKv4RbUlX0MH2J3whMXqH5gaiaRlHEpBtToWq7P0uMJme2j45UP.5mzayBFCaUtqdypGAog
 ZgcBadCOKoSz252zNIR86KYY6sNGaaq_OtOIU2frpKNRrQR0Qm9FViiehSElZ.16PXZ2J.HTiU7n
 tU9mllvqxzWUxubXBhA2UeNOzKQVthca1tE_WXI2R01HI95TdtCeIcB5qtT_PHiTbERQJktfg7tX
 1g4J4GO3qPLGqCBwLtXNU2CUX3R89p4y7UcijZt6GRVrA2S7BzqK_m_kFQ3gdGmtqtsQW5A1tBHU
 rqvwroDVrr5097WlDXRCl0hmaYrYRhCjDFlnyWYAHVXd3OV_DTwPjaFPDwg3Xbti49C0tHy4.gUz
 OJswHB1kl0rrjZTyW9od5thikAzB67Y5j41fgXTEMWe2RSESZvAt0qouZukVgPX3MTju62MjVsVs
 cW.phI8y..7.MtJpafi3jjDxQZyR.RvyYeBnp3ffh6UqYPfbUqoeE6PJncA68Tws8KxhyWPnPFdk
 WJf2JUXidXkTIohQpIiEKZDS7aLeB3F7997JwyRr5n1ev6E2Z4dn95mYiX3uUxm7T6Rxe6v.TELj
 HQCjBAt8FcKW8zkiCeBJgE.UJ4Zj.kos_DiDNbNHT32dE0BFpitiv5uLTj5ELk6AMKeZ1ju8Arp7
 JTFilPNDxG9hadAqXGV.BPILtP3E4y1fC9ItGeBsHUCnfa3XyUbT8zMTRHIDXMOLO89iSSh9eIbY
 ousXfQkverrNglXLhE6xUAYB5wzcKcuhTCEhFhwlZJvX5nYLeWKkLf._rn6iMk04zVZG.Qihu44h
 38.nn58Y_wiuZ5IWNnk0clLSPkhrPiq5kY3USu7agzZzUIoDYmmbyxRAcIhw_wSOVxTN1lGg6qiA
 HpkHCKY_apEPym_yqBgLw65f2FxgB.9ghmjAC3Lu47Dq.0w8UHutKtzFGxS9GN9B96hYxNErYJf7
 f_L2W.ZobNByVd.xQcA6Y_5moX8PQUmi7.FEqyC3.H7yDshmvEya7hi6DgYi1G3cEVA_ZOX_I1ig
 kvjQs6.w9MucnPocGMw--
X-Sonic-MF: <lesrhorer@att.net>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.gq1.yahoo.com with HTTP; Wed, 19 May 2021 16:55:30 +0000
Received: by kubenode548.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 08e2cb166f85a876b89294b40f744145;
          Wed, 19 May 2021 16:55:27 +0000 (UTC)
Subject: Re: My superblocks have gone missing, can't reassemble raid5
To:     Linux RAID <linux-raid@vger.kernel.org>
References: <CA+o1gzBcQF_JeiC7Nv_zEBmJU2ypwQ_+RkbcZOOt0qOK1MkQww@mail.gmail.com>
 <20210517112844.388d2270@natsu>
 <CAAMCDec=H=6ceP9bKjSnsQyvmZ0LqTAYzJTDmDQoBOHSJV+hDw@mail.gmail.com>
 <20210517181905.6f976f1a@natsu>
 <2e37cf64-1696-a5ca-f7db-83a1d098133d@turmel.org>
 <d21d0214-32e6-1213-b5a5-5b630223e346@thelounge.net>
 <09d03968-28e3-8c67-38c1-e3a8c577bd93@att.net>
 <e4258686-7673-9f5f-d333-fbbb95c066b1@turmel.org>
From:   Leslie Rhorer <lesrhorer@att.net>
Message-ID: <337ea246-99b0-2834-8b07-e12025d04b7d@att.net>
Date:   Wed, 19 May 2021 11:54:44 -0500
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <e4258686-7673-9f5f-d333-fbbb95c066b1@turmel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.18291 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo Apache-HttpAsyncClient/4.1.4 (Java/16)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/19/2021 8:41 AM, Phil Turmel wrote:
> On 5/19/21 9:20 AM, Leslie Rhorer wrote:
>>
>>
>> On 5/18/2021 1:31 PM, Reindl Harald wrote:
> 
> [trim/]
> 
>>> leave some margin and padding around the used space solves that 
>>> problem entirely and i still need to hear a single valid reason for 
>>> using unpartitioned drives in a RAID
>>
>>      I can give you about a dozen.  We will start with this:
>>
>> 1. Partitioning is not necessary.  Doing something that is not 
>> necessary is not usually worthwhile.
> 
> 1a: sure.  1b:  I can think of many things that aren't *necessary* but 
> are certainly worthwhile.  I can even throw a few out there, like 
> personal hygiene, healthy diets, exercise.  In this context, I would 
> list drive smart monitoring, weekly scrubs, and sysadmins with a clue.

	Every one of those things are not only necessary but absolutely 
essential.  The consequences of failing in those areas can be absolutely 
devastating.  What's more, I did not say, "...Never".  I very 
specifically said , "...Not usually".  There was a reason I did that.

>> 2. Partitioning offers no advantages.  Doing something unnecessary is 
>> questionable.  Doing something that has no purpose at all is downright 
>> foolish.
> 
> Who says it has no purpose.  Its purpose is to segment a device into 
> regions with associated metadata.

	Context, please.  If there is only one region with data then there is 
no reason for any association with or existence of any metadata.  A 
system containing only one segment needs no internal identification of 
any sort.  A universe requires no names or labels of any sort.

	A system consisting of multiple segments is a very different thing.  In 
any such system, partitioning or something similar is essential.  That 
is why my main servers all have partitioned OS arrays and 
non-partitioned data arrays.


>> 3. Partitioning introduces an additional layer of activity.  This 
>> makes it both more complex and more wasteful of resources.  And yes, 
>> before you bring it up, the additional complexity and resource 
>> infringement are quite small.  They are not zero, however, and they 
>> are in essence continuous.  Every little bit counts.
> 
> Hmm.  A sector offset and limit check, buried deep in the kernel's 
> common code.  I dare you to measure the incremental impact.

	You are assuming, there.  The kernel can most certainly be compiled 
without that code.  In fact, I have done so on embedded systems.  I 
could measure the impact, if it were an issue for me.  It isn't.  The 
simple fact is every bit of code takes time to run.  I don't need a 
quantitative measure to confirm that.  I also know the run time of the 
code is only a few msec for the first run and a few nanosec for 
subsequent runs, assuming the blocks are kept in cache somewhere.  That 
is indeed minimal.

>> 4. There is no guarantee the partitioning that works today will work 
>> tomorrow.  It should, of course, and it probably will, but why take a 
>> risk when there is absolutely no gain whatsoever?
> 
> You assert "no gain", but you provide no support for your assertion.

	That is because it is not possible to provide support for nothing.  One 
cannot prove non-existence.  If you have support for the notion there is 
some sort of gain, then by all means provide it.  Short of that, there 
is no evidence there is some gain to be had, and my statement stands. 
Believe me, my feelings are not going to be hurt by being proved wrong.

>> 5. It is additional work that ultimately yields no positive result 
>> whatsoever.  Admittedly, partitioning one disk is not a lot of work. 
>> Partitioning 50 disks is another matter.  Partitioning 500 disks...
> 
> You assert "no positive result whatsoever".  Sounds like #4.  With 
> similar lack of support.  Fluffing up your list, much?

	No, it is the cost side of the argument, which is not the same as the 
consequential side.  They are the two sides of the cost / benefit 
analysis.  In #4, I assert the benefit is negligible, perhaps even zero. 
  You haven't bothered to refute this, by the way.  In this point, I 
highlight the fact there is some cost to the practice.  Again, you have 
not refuted this.  An ad hominem reference to some alleged procedural 
failure on my part does not support your position.  Note I would be 
happy for you to do so, but don't think criticizing my abilities, 
whether accurate or not, in no way supports your position.

>> 6. Partitioning has an intent.  That intent is of no relevance 
>> whatsoever on a device whose content is singular in scope.  Are you 
>> suggesting we should also partition tapes?  Ralph Waldo Emerson had 
>> something important to say about repeatedly doing things simply 
>> because they have been done before and elsewhere.
> 
> No relevance?  Metadata can be rather useful when operating systems 
> encounter what looks like an empty disk.

	I am afraid you are going to have to be more specific for me to concede 
this point.  I am having trouble coming up with a good example.

> Metadata that says "not 
> empty!"  Especially valuable when metadata is *recognized* by all 
> operating systems.  You know, like, a *standard*.

	Please name one such case.  I cannot think of even a single protocol or 
standard that is universally recognized.  Some are close, but then only 
those that are very, very old.

> While MDraid places 
> metadata on the devices it uses, only Linux *recognizes* it.

	The logical extension of this is no system, anywhere, should ever use 
RAID of any flavor.  Nor indeed, any file system.  Nor, for that matter, 
any file system.  Indeed, we should never use any hard drive, and 
definitely not any tape drives.

>> 7. There is no downside to forfeiting the partition table.  Not 
>> needing to do something is an extremely good reason for not doing it.  
>> This is of course a corollary to point #1.
> 
> Just more fluff.

	"Just" more ad hominem.  Going down a short side path for a moment, the 
term "just" is almost always an illegitimate attempt to belittle and 
avoid an idea with the intent of being dismissive to an opponent in a 
debate.  All it really does is highlight the speaker's inability to 
properly support the speaker's side of the debate.  I would request you 
please stop "justiing" and instead provide some real support for your 
argument.  It doesn't greatly matter to me who wins this argument, but 
having to reply to unsupported rhetoric wastes my time.

> Microsoft and a number of NAS products are known to corrupt drives with 
> no partition table.

	Which is a pretty good argument to avoid those products, if true. 
Actually, I can't speak to any particular NAS (most of which are Linux 
based, and so quite unlikely to behave in such a manner), but while MS 
was accused of such activity in the past.  It was not true up to and 
including Windows 7.  I don't know about Windows 10, but I doubt it. 
Notwithstanding, I still avoid Windows whenever possible.  I certainly 
avoid doing anything merely to accommodate Windows.

> I vaguely recall hardware raid doing it, too. 
> That's a damn good reason to add a tiny (measurable?) amount of overhead.

	No, it's a damn good reason to completely avoid any such products, for 
reasons far deeper than just mucking around with partition tables. 
Mucking around the system without the express intent and direction of 
the system supervisor is not acceptable under any circumstances.  It's 
also a damn good reason why the supervisor needs to know what they are 
doing.

> And dude, making a single partition on a disk can be /scripted/.  Might 
> want to learn about that, if the pain of the driving fdisk/gdisk 
> occasionally is too much for your delicate fingers.

	It's not too much.  It's just unnecessary.  So is typing <scriptname> 
when it is not necessary.  The fact it can be scripted is irrelevant. 
You are free to do whatever you like.  I am not going to try to stop 
you.  You asked for reasons why one may chose not to partition RAID 
members.  I gave you some.  Accept them or reject them.  I don't really 
care.  Show me where my statements were factually incorrect.  I am 
always happy to learn of my mistakes.

	By the way, I don't partition non-RAID drives, either, unless they 
require multiple segments.  Not all of the media have any file systems, 
either.
