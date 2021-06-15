Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07FCFC2B9F4
	for <linux-raid@archiver.kernel.org>; Tue, 15 Jun 2021 02:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D12086100B
	for <linux-raid@archiver.kernel.org>; Tue, 15 Jun 2021 02:29:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbhFOCbH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Jun 2021 22:31:07 -0400
Received: from sonic316-10.consmr.mail.gq1.yahoo.com ([98.137.69.34]:35334
        "EHLO sonic316-10.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229919AbhFOCbF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 14 Jun 2021 22:31:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=att.net; s=s1024; t=1623724141; bh=7GxDmwhdMrAKBxBqnNX04Ero4wU5rhNLjp24UHX6tTg=; h=Subject:To:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=zhPwQrQ1sGEJYPjhqPeiECNmi39UD59jAxpPW/qziABq5GLByfYuN1o0iM2vZhu+7Fx0hji7I/ptNj6FQwa6ZelrR4XlHbX0v731fJazlnBrJ6/F41Oa8AuB4jV0iEava08AoyMAcUDLBlD+xKXu1exJ27IqcvPd+ylRuq104g4=
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1623724141; bh=WjWKnogS4JEJaiHzpwJPeGUzy2dQUmLHvSJuFrqJ+J7=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=THj0oK3DDegCtkfhQ9YsEQtRBFVdVd9duNnW43RIA5MdR/79ekKvD0N4AxAaaG4B0c2L/CnPbELL7+a9wVy2mPOa0BhcR9xsZ33VFbIdMYTHvmWGX0QoXvhaP77pKr1rgMPxzurqqm+7CYErqOi0y8CJd6mJtUunUj98SNvoNMTos/hE6hnnHS+qYE/4cSeNhW//tlVO/sfh/SUMQ/GuWRyDfHnjE/Gn2LmMFkrjOZ2qDjzGZ0ed42lSw7uGTUDmfylBRunA1tCic/ZMu7Z/4REMIE6AstVethOH/V7OUeoU1CKEEhKFro5XsVLDle1YyRkovWVqmcOXuWzG5c2Zfw==
X-YMail-OSG: uSoKhpIVM1kuZT.nk2aeIW03pwDWT7yO4hmvV53GHvMBCYSqXM2y4oT5LKOxrEt
 li0WL0ATtaidzw8Mp5RSUdDnOabjc_4_g7Bf8c3tgZ.vigmalsLBZNo9.WgNTvYUB9Gdh9JtCFrh
 fAV38XWKe6GjSe.aXzEpMaQ7_wBqp_UpltYYgwQIdIdXavxPV.xQzNkV7lvaeQDMBLJRy8rYHTgG
 zoVIpsrKVAAchXcW50zNhqyN4hsPkS.lHp3Z4a64mSYuPBXyf1nEw9Vq.xKx_nPDd4PLZLy3CW7R
 H1Tbt8z7EDetugP3h_hhwC.L6erzMU_.lcGYALK2Gb4pC8PaYUhFxT6bbQfnR5j8SsKc3vuI9e45
 Xx8rn4EsmRzKM7qhJthCFUliyUIMWS8Ipql284j6lx68Mv6kqO1kYEGCNY.uvQy4be0IlG2InzTt
 TzYipAK98QAjT1GlhXqaCwo89wiwADBcjnQ562B8yEnrAhxmgE9viDsccd_NrVkV3udH.IVG_JCQ
 PwO5LFX88sDlV35QT.JK3hqO__F77NohTrYUJeNrFzYfBYjbz5eyhqQG65e2BdOEbxh.0B6DZM37
 RTl6sc_GUrnDBpWy29a.l.CWYNbX4JIQwdRQ4GPbhmbEX6qsCHC8EwRpcQNzlm9VuieJDa0JdxOH
 IPEb1sxKYYFZybvHpX.dDZu4BRQxUgCe6dlNvY569cI_hpA4oF7dKaaNvNbjlCGlW4gr7MBtBnQu
 bUxO84O2ZazgwLqNQ5eSrKj6oXaAjWduiD4wb.R1cr7rgj03G2qACJcPcBEOjo6CtkKu4qRpAf8T
 5xp.TK23SsLnGE4Njcagt4.C2xocJQLxNlbcbgswK5zaH0avRvohLvWT4IPm8nkigKM3pmcOQm8B
 heexyMK4IXwp4adRYlotCjQgy1wo9_0Wbf15huZ8nCHyD7fIX8yUerHi6DXP3Lf725LUC6RxB5cH
 six9QJ0esZzpSnTx6JDZTi2wEMk1j9791UrHT9daDo7J56fzGwbYPblDSr70lOEOGecv7IpN2L06
 YwqpYEOzmCF1nnqZ_kbKbt75CfgD_DVmaCnlHMg76k52A36WJc4v1O05ZYFUqPkUhITpd8XhGbiH
 N0kLZbsjqt5U9kSQCGeLYHjFuJayVQWGQCOK5SevlC6AFDnNit761Q50BAKCC52SK1nyq46Km.PZ
 ea7d6YGMeLYiLV5_KFJQLw7PxKoKRYC659VtW84092_R0wmDaVEcT_1Hjf1AumMtGTzuYXvdDP0P
 W12WxGxEtnyc28JKoY_Pe4mZN.A_WcI3I0wvaD4Wrkird54tsAK7CxJbr3lKglrJNeuc4SXhWM9B
 w991oGQC3BrHMWECrp_pquAlGjEFkbV6Q4GigFPrqyvdrD4Lmlcmdt7OB3KZMJmG24ZMjhzqKySy
 MZBlcFdauM_IJvxWHp.qPL90btuHuFkT63QD1QQlahqPQbrCEDZPscRYuEZsQ6TqiETqRcyp0Kvu
 TaWkpm.NEtdjeTMsUEKD_O3a1yh6nS7zrNRR03nenAFU6WmYuskn4WXG2qsKqciOxz6A1safAk8D
 x2GXvZOiyPJFVg8DuHO8tam8rVLxDB9EkS6dcRCNz4fQAZUIxRg_ZqrG_REcoHIwsNpkAMVBnAnT
 adOLJvyc.eMMh8IGklz47269qLgzDkdMpMeJkBC.ScKv5Ub2rkttSBr8XhreXSBhazXU6YfGQZE0
 6qXlQhZYuQJXxgYH.c9x4HaCfNO3dFd3Va4UFkAuIboz5zlTLHl62lhQfN4lxnPrWIJRVBOCPOgv
 d2JJHkwAs3wggmdWBcYYrWOrGc8YPwFGJkYW2dWNqmiwFTc6CHSn4cRLO_TC1BSR8IhXw6dGagFW
 Qi.3jPi.IpjCzytD_Gl_QUslP8PfwQmjOjsljHY3OLshNb8s0x_4opBjjRCaeG0GxvKpyw5qKYHR
 Uk41fCfB3QF0389Bji7FSv_uPuUqwRgCp5aO0JMjhPdYOWhnTny9YWiJgsCqRScrnR7TBuJhsvBo
 e2G1BkIrQhrUDeOjFRfo8n_RZAxbRduhIN4p2QTmd68w0rPLsU1VoIMyPx3n2AU9.0ecTeBkuFW2
 LpPSR4LXWtE51aQlU5_o0E7BAXymRJVgLGAHrgknfmiCX9YtxdaEHzjzXRrVGvmPhyec.gJAK_ZX
 72YJZko_opayjzsmNSLMPrkChNVHal7hYFZicELC7LxeNggIAwVsACfYzVW2wl1G7FCh.lCyfiz5
 kYEVlQ.DNXAR9usLBL18XqnLa2zD6SXS05QFoz31mLMxnDxU0.0a7XGL6C8utSp3uP4MXSAoylju
 1_2sXoPuTpdbZXJDLfeHtgEBrNFNOn1NWUUmnvZCRMgEEGtciYTZPn.wYjgl.WqSXv_JZMWznEKn
 AbkT81oV6LvyMg27_rgpGIuQ-
X-Sonic-MF: <lesrhorer@att.net>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.gq1.yahoo.com with HTTP; Tue, 15 Jun 2021 02:29:01 +0000
Received: by kubenode546.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 2a3195a317d85a6f81e72b7b0760453b;
          Tue, 15 Jun 2021 01:33:24 +0000 (UTC)
Subject: Re: Recover from crash in RAID6 due to hardware failure
To:     Linux RAID <linux-raid@vger.kernel.org>
References: <bd617822-79bd-ce40-f50e-21d482570324@gmail.com>
 <4745ddd9-291b-00c7-8678-cac14905c188@att.net>
 <ed21aa89-e6a1-651d-cc23-9f4c72cf63e0@gmail.com>
From:   Leslie Rhorer <lesrhorer@att.net>
Message-ID: <1c28967e-3dbc-e5ff-9536-b8de0cf9cd65@att.net>
Date:   Mon, 14 Jun 2021 20:33:20 -0500
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <ed21aa89-e6a1-651d-cc23-9f4c72cf63e0@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.18469 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

	There is a fair chance you can recover the data by recreating the array:

mdadm -S /dev/md2
mdadm -C -f -e 1.2 -n 6 -c 64K --level=6 -p left-symmetric /dev/md2 
/dev/sda3 /dev/sdb3 /dev/sdc3 /dev/sdd3 /dev/sde3

On 6/8/2021 6:39 AM, Carlos Maziero wrote:
> Em 07/06/2021 07:27, Leslie Rhorer escreveu:
>> On 6/6/2021 10:07 PM, Carlos Maziero wrote:
>>
>>> However, the disks where added as spares and the volume remained
>>> crashed. Now I'm afraid that such commands have erased metadata and made
>>> things worse... :-(
>>
>>      Yeah.  Did you at any time Examine the drives and save the output?
>>
>> mdadm -E /dev/sd[a-e]3
>>
>>      If so, you have a little bit better chance.
> 
> Yes, but I did it only after the failure. The output for all disks is
> attached to this message.
> 
> 
>>> Is there a way to reconstruct the array and to recover its data, at
>>> least partially?
>>
>>      Maybe.  Do you know eaxctly which physical disk was in which RAID
>> position?  It seems likely the grouping was the same for the corrupted
>> array as for the other arrays, given the drives are partitioned.
> 
> Yes, disk sda was in slot 1, and so on. I physically labelled all slots
> and disks.
> 
> 
>>
>>      First off, try:
>>
>> mdadm -E /dev/sde3 > /etc/mdadm/RAIDfix
>>
>>      This should give you the details of the RAID array.  From this,
>> you should be able to re-create the array.  I would heartily recommend
>> getting some new drives and copying the data to them before
>> proceeding.  I would get a 12T drive and copy all of the partitions to
>> it:
>>
>> mkfs /dev/sdf  (or mkfs /dev/sdf1)
>> mount /dev/sdf /mnt (or mount /dev/sdf1 /mnt)
>> ddrescue /dev/sda3 /mnt/drivea /tmp/tmpdrivea
>> ddrescue /dev/sdb3 /mnt/driveb /tmp/tmpdriveb
>> ddrescue /dev/sdc3 /mnt/drivec /tmp/tmpdrivec
>> ddrescue /dev/sdd3 /mnt/drived /tmp/tmpdrived
>> ddrescue /dev/sde3 /mnt/drivee /tmp/tmpdrivee
>>
>>      You could skimp by getting an 8T drive, and then if drive e
>> doesn't fit, you could create the array without it, and you will be
>> pretty safe.  It's not what I would do, but if you are strapped for
>> cash...
> 
> OK, I will try to have a secondary disk for that and another computer,
> since the NAS has only 5 bays and I would need one more for doing such
> operations.
> 
> 
>>> Contents of /proc/mdstat (after the commands above):
>>>
>>> Personalities : [raid1] [linear] [raid0] [raid10] [raid6] [raid5]
>>> [raid4]
>>> md2 : active raid6 sda3[0](S) sdb3[1](S) sdc3[2](S) sdd3[3](S) sde3[4]
>>>         8776632768 blocks super 1.2 level 6, 64k chunk, algorithm 2 [5/1]
>>> [____U]
>>>        md1 : active raid1 sda2[1] sdb2[2] sdc2[3] sdd2[0] sde2[4]
>>>         2097088 blocks [5/5] [UUUUU]
>>>        md0 : active raid1 sda1[1] sdb1[2] sdc1[3] sdd1[0] sde1[4]
>>>         2490176 blocks [5/5] [UUUUU]
>>
>>      There is something odd here.  You say the disks failed, but
>> clearly they are in decent shape.  The first and second partitions on
>> all drives appear to be good.  Did the system recover the RAID1 arrays?
> 
> Apparently the failure was not in the disks, but in the NAS hardware. I
> opened it one week ago for RAM upgrading (replaced the old 512M card by
> a 1GB one), and maybe the slot connecting the main board to the SATA
> board presented a connectivity problem (but the NAS OS said nothing
> about). Anyway, I had 5 disks in a RAID 6 array and the logs showed 3
> disks failing at the same time, which is quite unusual. This is the
> reason I believe the disks are physically ok.
> 
> Thanks for your attention!
> 
> Carlos
> 
> 
