Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE10C433EF
	for <linux-raid@archiver.kernel.org>; Thu,  9 Jun 2022 00:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbiFIA0S (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Jun 2022 20:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiFIA0Q (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Jun 2022 20:26:16 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97654F9F2
        for <linux-raid@vger.kernel.org>; Wed,  8 Jun 2022 17:26:14 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 6782F3200910;
        Wed,  8 Jun 2022 20:26:11 -0400 (EDT)
Received: from imap49 ([10.202.2.99])
  by compute4.internal (MEProxy); Wed, 08 Jun 2022 20:26:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=braithwaite.dev;
         h=cc:cc:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1654734370; x=1654820770; bh=OW
        KIFsSNWkUsdkU8qE0lN3vMediE+yL43r/2GgMky+E=; b=tB5HCeC+buL+hPCPPp
        2+jLbx0gLZ/ItuCv3ZPLTAYwLEUaibj68TBY4i75xuNOdAmotCcRp3bqGTBAvV9+
        telg2V3FF2CJVcLO5yPnua3doR5XV2BmMXUVfgvV12sl3Sdx1ZYzJAgYbix+OzBR
        4e2MGZ8GHSt6Xa8X2qt7Z0cAKNe9DRjpVwQVwBFeM8tX5lADClHH+TQUIC88KKB4
        KfbSDdKEkqSsMRY8NUtJVfKgpkWT3Tq3itEhMaCI8rE9uOD+X0SPmS/J8hJQpH6V
        6es8s37nP+fBCJdQd9Hl2Sgd5Ba0Yo0CXkUPS1zQPCo8EVnMuDdDM1t6i97NwahJ
        7FIQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1654734370; x=1654820770; bh=OWKIFsSNWkUsdkU8qE0lN3vMediE
        +yL43r/2GgMky+E=; b=lmBJQbLZ2UwTU0v6NV+stpaxY0SdzP6GtdtII/S3Y6/a
        leh+RTGiaVYf4Pj54zGhG1ycIO2dDSVRnX2RwhIu+yn9wecbEZe/sJRokSNEM6F3
        +LSYjJQ98BEraibkza8IHeR7o5/GJoX1pV0jtTimsjuu7l4/A5OEwnfqeURp2s6u
        hhJ/chGUS6CKdXhwQotM2cppVME7SMQAQXYAyraDmkSKHZUlSoQ4x2UmSzuvRcKX
        j9SmJWlYrqvWkg+BKDpcfwhJuC+h3iOJYpJzf1CB0LHheOk3/AH+02nQk46zT0Sg
        tF5aBt+MAo31y/6gOGSCWHDPzA+fwnz3Lu/QCyRqdA==
X-ME-Sender: <xms:Ij6hYnNGRYGqjc7ClXnfAvHuV3Wp3DPDmBLlCt4C7yQIE1DhvBJwhQ>
    <xme:Ij6hYh9txDtp_v96tNJk-5tevbOzQOl6tr3wJY5YhrQOpUuHFhdUV4QKLURjn_KR4
    zvJpeV_Bmov7Q53nGk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedruddtkedgfeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefofgggkfgjfhffhffvvefutgesth
    dtredtreertdenucfhrhhomhepfdetlhgrnhcuuehrrghithhhfigrihhtvgdfuceorghl
    rghnsegsrhgrihhthhifrghithgvrdguvghvqeenucggtffrrghtthgvrhhnpefhteelie
    efkefgveejhfehkedtjeejveefteegfeejteekfeejffdutdejgeefgeenucffohhmrghi
    nhepshhmrghrthhmohhnthhoohhlshdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgrnhessghrrghithhhfigrihhtvgdruggv
    vh
X-ME-Proxy: <xmx:Ij6hYmSooF6zMCFn9826E1BDORZIhsjmJCmb7MWxW5JOSI6TSnG-Bg>
    <xmx:Ij6hYrv2xNpJlT10Z2JEC67Ate-UEb-9PQs5eqKMr4PT2JZ5Uk3cSg>
    <xmx:Ij6hYvfTMPZsQiv6D_U9rN8mLCF5Tf2rtSz1NsyeMBlkWA0E6viRRg>
    <xmx:Ij6hYtqEVyryFMnQUuWTWPdmyS7-H-SMMCCawDxr2xgMT-I-miYA-Q>
Feedback-ID: i1a914699:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id C5C6515A0080; Wed,  8 Jun 2022 20:26:10 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-692-gb287c361f5-fm-20220603.003-gb287c361
Mime-Version: 1.0
Message-Id: <b80c6d10-760e-40a2-b9ca-86aabf3267d0@www.fastmail.com>
In-Reply-To: <CAPpdf5-wEfpHnteLAG-EHD-we+b+0=KB7RcD=U9dw6K-_3f48w@mail.gmail.com>
References: <0fa973c1-2961-4f8f-99fa-b427a5c694fd@www.fastmail.com>
 <CAPpdf5-wEfpHnteLAG-EHD-we+b+0=KB7RcD=U9dw6K-_3f48w@mail.gmail.com>
Date:   Wed, 08 Jun 2022 17:25:48 -0700
From:   "Alan Braithwaite" <alan@braithwaite.dev>
To:     o1bigtenor <o1bigtenor@gmail.com>
Cc:     Linux-RAID <linux-raid@vger.kernel.org>
Subject: Re: MD Array Unexpected Kernel Hang
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Appreciated.  Only reason I didn't include it initially is because it's a giant wall of text (which the other debugging info was anyway, so I should have just been proactive).

Anyway, it can now be found below, annotated with the failing drives first.

Thanks,
- Alan



First 2 (sdg, sdh) are the "bad" drives which cause the md hangs when added to the array.  sdh looks particularly healthy to my reading of the output, but was still causing the issues. 


[root@ceres tmp]# sudo smartctl -x /dev/sdg
smartctl 7.3 2022-02-28 r5338 [x86_64-linux-5.17.9-arch1-1] (local build)
Copyright (C) 2002-22, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Vendor:               HGST
Product:              HUS724020ALS640
Revision:             A1C4
Compliance:           SPC-4
User Capacity:        2,000,398,934,016 bytes [2.00 TB]
Logical block size:   512 bytes
LU is resource provisioned, LBPRZ=0
Rotation Rate:        7200 rpm
Form Factor:          3.5 inches
Logical Unit id:      0x5000cca06d287590
Serial number:        P5GR7TBV
Device type:          disk
Transport protocol:   SAS (SPL-4)
Local Time is:        Wed Jun  8 17:22:20 2022 PDT
SMART support is:     Available - device has SMART capability.
SMART support is:     Enabled
Temperature Warning:  Enabled
Read Cache is:        Enabled
Writeback Cache is:   Disabled

=== START OF READ SMART DATA SECTION ===
SMART Health Status: OK

Current Drive Temperature:     42 C
Drive Trip Temperature:        85 C

Manufactured in week 21 of year 2015
Specified cycle count over device lifetime:  50000
Accumulated start-stop cycles:  32
Specified load-unload count over device lifetime:  600000
Accumulated load-unload cycles:  1530
Elements in grown defect list: 0

Vendor (Seagate Cache) information
  Blocks sent to initiator = 12276642395193344

Error counter log:
           Errors Corrected by           Total   Correction     Gigabytes    Total
               ECC          rereads/    errors   algorithm      processed    uncorrected
           fast | delayed   rewrites  corrected  invocations   [10^9 bytes]  errors
read:     110826       19         0    110845    1515087     460659.950           0
write:         0        0         0         0     972273      44976.018           0
verify:        0        0         0         0      58029          0.000           0

Non-medium error count:        0

SMART Self-test log
Num  Test              Status                 segment  LifeTime  LBA_first_err [SK ASC ASQ]
     Description                              number   (hours)
# 1  Background short  Completed                   -   39609                 - [-   -    -]

Long (extended) Self-test duration: 22236 seconds [6.2 hours]

Background scan results log
  Status: waiting until BMS interval timer expires
    Accumulated power on time, hours:minutes 39704:24 [2382264 minutes]
    Number of background scans performed: 62,  scan progress: 0.00%
    Number of background medium scans performed: 62


Protocol Specific port log page for SAS SSP
relative target port id = 1
  generation code = 1
  number of phys = 1
  phy identifier = 0
    attached device type: no device attached
    attached reason: unknown
    reason: power on
    negotiated logical link rate: phy enabled; unknown
    attached initiator port: ssp=0 stp=0 smp=0
    attached target port: ssp=0 stp=0 smp=0
    SAS address = 0x5000cca06d287591
    attached SAS address = 0x0
    attached phy identifier = 0
    Invalid DWORD count = 0
    Running disparity error count = 0
    Loss of DWORD synchronization count = 0
    Phy reset problem count = 0
relative target port id = 2
  generation code = 1
  number of phys = 1
  phy identifier = 1
    attached device type: expander device
    attached reason: SMP phy control function
    reason: unknown
    negotiated logical link rate: phy enabled; 6 Gbps
    attached initiator port: ssp=0 stp=0 smp=0
    attached target port: ssp=0 stp=0 smp=1
    SAS address = 0x5000cca06d287592
    attached SAS address = 0x50030480003954bf
    attached phy identifier = 14
    Invalid DWORD count = 10
    Running disparity error count = 10
    Loss of DWORD synchronization count = 2
    Phy reset problem count = 0

[root@ceres tmp]# sudo smartctl -x /dev/sdh
smartctl 7.3 2022-02-28 r5338 [x86_64-linux-5.17.9-arch1-1] (local build)
Copyright (C) 2002-22, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Vendor:               HGST
Product:              HUS724020ALS640
Revision:             A2C0
Compliance:           SPC-4
User Capacity:        2,000,398,934,016 bytes [2.00 TB]
Logical block size:   512 bytes
LU is fully provisioned
Rotation Rate:        7200 rpm
Form Factor:          3.5 inches
Logical Unit id:      0x5000cca06d3da1bc
Serial number:        P5H2WSDV
Device type:          disk
Transport protocol:   SAS (SPL-4)
Local Time is:        Wed Jun  8 17:22:25 2022 PDT
SMART support is:     Available - device has SMART capability.
SMART support is:     Enabled
Temperature Warning:  Enabled
Read Cache is:        Enabled
Writeback Cache is:   Enabled

=== START OF READ SMART DATA SECTION ===
SMART Health Status: OK

Current Drive Temperature:     41 C
Drive Trip Temperature:        85 C

Manufactured in week 28 of year 2015
Specified cycle count over device lifetime:  50000
Accumulated start-stop cycles:  23
Specified load-unload count over device lifetime:  600000
Accumulated load-unload cycles:  1512
Elements in grown defect list: 0

Vendor (Seagate Cache) information
  Blocks sent to initiator = 386113231388672

Error counter log:
           Errors Corrected by           Total   Correction     Gigabytes    Total
               ECC          rereads/    errors   algorithm      processed    uncorrected
           fast | delayed   rewrites  corrected  invocations   [10^9 bytes]  errors
read:        525        2         0       527        222       4203.269           0
write:         0        0         0         0       4103      13423.670           0
verify:        0        0         0         0      11426          0.000           0

Non-medium error count:        1

SMART Self-test log
Num  Test              Status                 segment  LifeTime  LBA_first_err [SK ASC ASQ]
     Description                              number   (hours)
# 1  Background short  Completed                   -   39221                 - [-   -    -]
# 2  Background short  Completed                   -   34658                 - [-   -    -]
# 3  Background short  Completed                   -   32405                 - [-   -    -]
# 4  Background short  Completed                   -   32380                 - [-   -    -]
# 5  Background short  Completed                   -   32357                 - [-   -    -]
# 6  Background short  Completed                   -   32332                 - [-   -    -]
# 7  Background short  Completed                   -   32308                 - [-   -    -]
# 8  Background short  Completed                   -   32285                 - [-   -    -]
# 9  Background short  Completed                   -   32260                 - [-   -    -]
#10  Background short  Completed                   -   32237                 - [-   -    -]
#11  Background short  Completed                   -   32213                 - [-   -    -]
#12  Background short  Completed                   -   32189                 - [-   -    -]
#13  Background short  Completed                   -   32165                 - [-   -    -]
#14  Background short  Completed                   -   32141                 - [-   -    -]
#15  Background short  Completed                   -   32117                 - [-   -    -]
#16  Background short  Completed                   -   32093                 - [-   -    -]
#17  Background short  Completed                   -   32068                 - [-   -    -]
#18  Background short  Completed                   -   32045                 - [-   -    -]
#19  Background short  Completed                   -   32020                 - [-   -    -]
#20  Background short  Completed                   -   31997                 - [-   -    -]

Long (extended) Self-test duration: 22650 seconds [6.3 hours]

Background scan results log
  Status: waiting until BMS interval timer expires
    Accumulated power on time, hours:minutes 39315:59 [2358959 minutes]
    Number of background scans performed: 243,  scan progress: 0.00%
    Number of background medium scans performed: 243


Protocol Specific port log page for SAS SSP
relative target port id = 1
  generation code = 1
  number of phys = 1
  phy identifier = 0
    attached device type: no device attached
    attached reason: unknown
    reason: power on
    negotiated logical link rate: phy enabled; unknown
    attached initiator port: ssp=0 stp=0 smp=0
    attached target port: ssp=0 stp=0 smp=0
    SAS address = 0x5000cca06d3da1bd
    attached SAS address = 0x0
    attached phy identifier = 0
    Invalid DWORD count = 0
    Running disparity error count = 0
    Loss of DWORD synchronization count = 0
    Phy reset problem count = 0
relative target port id = 2
  generation code = 1
  number of phys = 1
  phy identifier = 1
    attached device type: expander device
    attached reason: SMP phy control function
    reason: unknown
    negotiated logical link rate: phy enabled; 6 Gbps
    attached initiator port: ssp=0 stp=0 smp=0
    attached target port: ssp=0 stp=0 smp=1
    SAS address = 0x5000cca06d3da1be
    attached SAS address = 0x50030480003954bf
    attached phy identifier = 15
    Invalid DWORD count = 18
    Running disparity error count = 16
    Loss of DWORD synchronization count = 3
    Phy reset problem count = 0



# --- Good Drives Start Here ---

[root@ceres tmp]# sudo smartctl -x /dev/sdc
smartctl 7.3 2022-02-28 r5338 [x86_64-linux-5.17.9-arch1-1] (local build)
Copyright (C) 2002-22, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Vendor:               HGST
Product:              HUS724020ALS640
Revision:             A1C4
Compliance:           SPC-4
User Capacity:        2,000,398,934,016 bytes [2.00 TB]
Logical block size:   512 bytes
LU is resource provisioned, LBPRZ=0
Rotation Rate:        7200 rpm
Form Factor:          3.5 inches
Logical Unit id:      0x5000cca06d2927fc
Serial number:        P5GRMNRV
Device type:          disk
Transport protocol:   SAS (SPL-4)
Local Time is:        Wed Jun  8 17:22:31 2022 PDT
SMART support is:     Available - device has SMART capability.
SMART support is:     Enabled
Temperature Warning:  Enabled
Read Cache is:        Enabled
Writeback Cache is:   Disabled

=== START OF READ SMART DATA SECTION ===
SMART Health Status: OK

Current Drive Temperature:     44 C
Drive Trip Temperature:        85 C

Manufactured in week 21 of year 2015
Specified cycle count over device lifetime:  50000
Accumulated start-stop cycles:  33
Specified load-unload count over device lifetime:  600000
Accumulated load-unload cycles:  2019
Elements in grown defect list: 0

Vendor (Seagate Cache) information
  Blocks sent to initiator = 12460064392609792

Error counter log:
           Errors Corrected by           Total   Correction     Gigabytes    Total
               ECC          rereads/    errors   algorithm      processed    uncorrected
           fast | delayed   rewrites  corrected  invocations   [10^9 bytes]  errors
read:     125617        4         0    125621    1511670     470203.046           0
write:         0        0         0         0     311583      46916.011           0
verify:        0        0         0         0       1226          0.000           0

Non-medium error count:        0

SMART Self-test log
Num  Test              Status                 segment  LifeTime  LBA_first_err [SK ASC ASQ]
     Description                              number   (hours)
# 1  Background short  Completed                   -   39776                 - [-   -    -]
# 2  Background short  Completed                   -   39480                 - [-   -    -]

Long (extended) Self-test duration: 22236 seconds [6.2 hours]

Background scan results log
  Status: waiting until BMS interval timer expires
    Accumulated power on time, hours:minutes 39871:02 [2392262 minutes]
    Number of background scans performed: 65,  scan progress: 0.00%
    Number of background medium scans performed: 65


Protocol Specific port log page for SAS SSP
relative target port id = 1
  generation code = 1
  number of phys = 1
  phy identifier = 0
    attached device type: no device attached
    attached reason: unknown
    reason: power on
    negotiated logical link rate: phy enabled; unknown
    attached initiator port: ssp=0 stp=0 smp=0
    attached target port: ssp=0 stp=0 smp=0
    SAS address = 0x5000cca06d2927fd
    attached SAS address = 0x0
    attached phy identifier = 0
    Invalid DWORD count = 0
    Running disparity error count = 0
    Loss of DWORD synchronization count = 0
    Phy reset problem count = 0
relative target port id = 2
  generation code = 1
  number of phys = 1
  phy identifier = 1
    attached device type: expander device
    attached reason: SMP phy control function
    reason: unknown
    negotiated logical link rate: phy enabled; 6 Gbps
    attached initiator port: ssp=0 stp=0 smp=0
    attached target port: ssp=0 stp=0 smp=1
    SAS address = 0x5000cca06d2927fe
    attached SAS address = 0x50030480003954bf
    attached phy identifier = 9
    Invalid DWORD count = 11
    Running disparity error count = 10
    Loss of DWORD synchronization count = 2
    Phy reset problem count = 0

[root@ceres tmp]# sudo smartctl -x /dev/sdd
smartctl 7.3 2022-02-28 r5338 [x86_64-linux-5.17.9-arch1-1] (local build)
Copyright (C) 2002-22, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Vendor:               HGST
Product:              HUS724020ALS640
Revision:             A1C4
Compliance:           SPC-4
User Capacity:        2,000,398,934,016 bytes [2.00 TB]
Logical block size:   512 bytes
LU is resource provisioned, LBPRZ=0
Rotation Rate:        7200 rpm
Form Factor:          3.5 inches
Logical Unit id:      0x5000cca06d2924f0
Serial number:        P5GRMGEV
Device type:          disk
Transport protocol:   SAS (SPL-4)
Local Time is:        Wed Jun  8 17:22:32 2022 PDT
SMART support is:     Available - device has SMART capability.
SMART support is:     Enabled
Temperature Warning:  Enabled
Read Cache is:        Enabled
Writeback Cache is:   Disabled

=== START OF READ SMART DATA SECTION ===
SMART Health Status: OK

Current Drive Temperature:     44 C
Drive Trip Temperature:        85 C

Manufactured in week 21 of year 2015
Specified cycle count over device lifetime:  50000
Accumulated start-stop cycles:  33
Specified load-unload count over device lifetime:  600000
Accumulated load-unload cycles:  2031
Elements in grown defect list: 0

Vendor (Seagate Cache) information
  Blocks sent to initiator = 12182041999179776

Error counter log:
           Errors Corrected by           Total   Correction     Gigabytes    Total
               ECC          rereads/    errors   algorithm      processed    uncorrected
           fast | delayed   rewrites  corrected  invocations   [10^9 bytes]  errors
read:     284059        0         0    284059    1507556     472213.429           0
write:         0        0         0         0     378639      45073.915           0
verify:        0        0         0         0        319          0.000           0

Non-medium error count:        0

SMART Self-test log
Num  Test              Status                 segment  LifeTime  LBA_first_err [SK ASC ASQ]
     Description                              number   (hours)
# 1  Background short  Completed                   -   39775                 - [-   -    -]
# 2  Background short  Completed                   -   39479                 - [-   -    -]

Long (extended) Self-test duration: 22236 seconds [6.2 hours]

Background scan results log
  Status: waiting until BMS interval timer expires
    Accumulated power on time, hours:minutes 39870:03 [2392203 minutes]
    Number of background scans performed: 63,  scan progress: 0.00%
    Number of background medium scans performed: 63


Protocol Specific port log page for SAS SSP
relative target port id = 1
  generation code = 1
  number of phys = 1
  phy identifier = 0
    attached device type: no device attached
    attached reason: unknown
    reason: power on
    negotiated logical link rate: phy enabled; unknown
    attached initiator port: ssp=0 stp=0 smp=0
    attached target port: ssp=0 stp=0 smp=0
    SAS address = 0x5000cca06d2924f1
    attached SAS address = 0x0
    attached phy identifier = 0
    Invalid DWORD count = 0
    Running disparity error count = 0
    Loss of DWORD synchronization count = 0
    Phy reset problem count = 0
relative target port id = 2
  generation code = 1
  number of phys = 1
  phy identifier = 1
    attached device type: expander device
    attached reason: SMP phy control function
    reason: unknown
    negotiated logical link rate: phy enabled; 6 Gbps
    attached initiator port: ssp=0 stp=0 smp=0
    attached target port: ssp=0 stp=0 smp=1
    SAS address = 0x5000cca06d2924f2
    attached SAS address = 0x50030480003954bf
    attached phy identifier = 10
    Invalid DWORD count = 10
    Running disparity error count = 10
    Loss of DWORD synchronization count = 2
    Phy reset problem count = 0

[root@ceres tmp]# sudo smartctl -x /dev/sde
smartctl 7.3 2022-02-28 r5338 [x86_64-linux-5.17.9-arch1-1] (local build)
Copyright (C) 2002-22, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Vendor:               HGST
Product:              HUS724020ALS640
Revision:             A1C4
Compliance:           SPC-4
User Capacity:        2,000,398,934,016 bytes [2.00 TB]
Logical block size:   512 bytes
LU is resource provisioned, LBPRZ=0
Rotation Rate:        7200 rpm
Form Factor:          3.5 inches
Logical Unit id:      0x5000cca06d283b08
Serial number:        P5GR3WJV
Device type:          disk
Transport protocol:   SAS (SPL-4)
Local Time is:        Wed Jun  8 17:22:34 2022 PDT
SMART support is:     Available - device has SMART capability.
SMART support is:     Enabled
Temperature Warning:  Enabled
Read Cache is:        Enabled
Writeback Cache is:   Disabled

=== START OF READ SMART DATA SECTION ===
SMART Health Status: OK

Current Drive Temperature:     41 C
Drive Trip Temperature:        85 C

Manufactured in week 21 of year 2015
Specified cycle count over device lifetime:  50000
Accumulated start-stop cycles:  33
Specified load-unload count over device lifetime:  600000
Accumulated load-unload cycles:  2024
Elements in grown defect list: 0

Vendor (Seagate Cache) information
  Blocks sent to initiator = 12291100328853504

Error counter log:
           Errors Corrected by           Total   Correction     Gigabytes    Total
               ECC          rereads/    errors   algorithm      processed    uncorrected
           fast | delayed   rewrites  corrected  invocations   [10^9 bytes]  errors
read:      72338        1         0     72339    1454480     468885.996           0
write:         0        0         0         0     283314      44839.275           0
verify:        0        0         0         0        754          0.000           0

Non-medium error count:        0

SMART Self-test log
Num  Test              Status                 segment  LifeTime  LBA_first_err [SK ASC ASQ]
     Description                              number   (hours)
# 1  Background short  Completed                   -   39775                 - [-   -    -]
# 2  Background short  Completed                   -   39479                 - [-   -    -]

Long (extended) Self-test duration: 22236 seconds [6.2 hours]

Background scan results log
  Status: waiting until BMS interval timer expires
    Accumulated power on time, hours:minutes 39870:31 [2392231 minutes]
    Number of background scans performed: 62,  scan progress: 0.00%
    Number of background medium scans performed: 62


Protocol Specific port log page for SAS SSP
relative target port id = 1
  generation code = 1
  number of phys = 1
  phy identifier = 0
    attached device type: no device attached
    attached reason: unknown
    reason: power on
    negotiated logical link rate: phy enabled; unknown
    attached initiator port: ssp=0 stp=0 smp=0
    attached target port: ssp=0 stp=0 smp=0
    SAS address = 0x5000cca06d283b09
    attached SAS address = 0x0
    attached phy identifier = 0
    Invalid DWORD count = 0
    Running disparity error count = 0
    Loss of DWORD synchronization count = 0
    Phy reset problem count = 0
relative target port id = 2
  generation code = 1
  number of phys = 1
  phy identifier = 1
    attached device type: expander device
    attached reason: SMP phy control function
    reason: unknown
    negotiated logical link rate: phy enabled; 6 Gbps
    attached initiator port: ssp=0 stp=0 smp=0
    attached target port: ssp=0 stp=0 smp=1
    SAS address = 0x5000cca06d283b0a
    attached SAS address = 0x50030480003954bf
    attached phy identifier = 11
    Invalid DWORD count = 9
    Running disparity error count = 9
    Loss of DWORD synchronization count = 2
    Phy reset problem count = 0

[root@ceres tmp]# sudo smartctl -x /dev/sdf
smartctl 7.3 2022-02-28 r5338 [x86_64-linux-5.17.9-arch1-1] (local build)
Copyright (C) 2002-22, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Vendor:               HGST
Product:              HUS724020ALS640
Revision:             A2C0
Compliance:           SPC-4
User Capacity:        2,000,398,934,016 bytes [2.00 TB]
Logical block size:   512 bytes
LU is fully provisioned
Rotation Rate:        7200 rpm
Form Factor:          3.5 inches
Logical Unit id:      0x5000cca0284dc068
Serial number:        P6HBSKZV
Device type:          disk
Transport protocol:   SAS (SPL-4)
Local Time is:        Wed Jun  8 17:22:36 2022 PDT
SMART support is:     Available - device has SMART capability.
SMART support is:     Enabled
Temperature Warning:  Enabled
Read Cache is:        Enabled
Writeback Cache is:   Enabled

=== START OF READ SMART DATA SECTION ===
SMART Health Status: OK

Current Drive Temperature:     37 C
Drive Trip Temperature:        85 C

Manufactured in week 06 of year 2014
Specified cycle count over device lifetime:  50000
Accumulated start-stop cycles:  47
Specified load-unload count over device lifetime:  600000
Accumulated load-unload cycles:  1871
Elements in grown defect list: 5

Vendor (Seagate Cache) information
  Blocks sent to initiator = 498103379558400

Error counter log:
           Errors Corrected by           Total   Correction     Gigabytes    Total
               ECC          rereads/    errors   algorithm      processed    uncorrected
           fast | delayed   rewrites  corrected  invocations   [10^9 bytes]  errors
read:      44471        1         0     44472      36583      12783.706           0
write:         0        0         0         0      11015      19676.167           0
verify:        0        0         0         0       6221          0.000           0

Non-medium error count:        1

SMART Self-test log
Num  Test              Status                 segment  LifeTime  LBA_first_err [SK ASC ASQ]
     Description                              number   (hours)
# 1  Background short  Completed                   -   46820                 - [-   -    -]
# 2  Background short  Completed                   -   42138                 - [-   -    -]
# 3  Background short  Completed                   -   42111                 - [-   -    -]
# 4  Background short  Completed                   -   42103                 - [-   -    -]
# 5  Background short  Completed                   -   42099                 - [-   -    -]
# 6  Background short  Completed                   -   41365                 - [-   -    -]
# 7  Background short  Completed                   -   41341                 - [-   -    -]
# 8  Background short  Completed                   -   41317                 - [-   -    -]
# 9  Background short  Completed                   -   41293                 - [-   -    -]
#10  Background short  Completed                   -   41269                 - [-   -    -]
#11  Background short  Completed                   -   41245                 - [-   -    -]
#12  Background short  Completed                   -   41221                 - [-   -    -]
#13  Background short  Completed                   -   41197                 - [-   -    -]
#14  Background short  Completed                   -   41172                 - [-   -    -]
#15  Background short  Completed                   -   41149                 - [-   -    -]
#16  Background short  Completed                   -   41125                 - [-   -    -]
#17  Background short  Completed                   -   41101                 - [-   -    -]
#18  Background short  Completed                   -   41077                 - [-   -    -]
#19  Background short  Completed                   -   41053                 - [-   -    -]
#20  Background short  Completed                   -   41029                 - [-   -    -]

Long (extended) Self-test duration: 22650 seconds [6.3 hours]

Background scan results log
  Status: waiting until BMS interval timer expires
    Accumulated power on time, hours:minutes 46915:04 [2814904 minutes]
    Number of background scans performed: 294,  scan progress: 0.00%
    Number of background medium scans performed: 294

   #  when        lba(hex)    [sk,asc,ascq]    reassign_status
   1 42149:02  00000000becb3840  [3,11,0]   Recovered via rewrite in-place


Protocol Specific port log page for SAS SSP
relative target port id = 1
  generation code = 1
  number of phys = 1
  phy identifier = 0
    attached device type: no device attached
    attached reason: unknown
    reason: power on
    negotiated logical link rate: phy enabled; unknown
    attached initiator port: ssp=0 stp=0 smp=0
    attached target port: ssp=0 stp=0 smp=0
    SAS address = 0x5000cca0284dc069
    attached SAS address = 0x0
    attached phy identifier = 0
    Invalid DWORD count = 0
    Running disparity error count = 0
    Loss of DWORD synchronization count = 0
    Phy reset problem count = 0
relative target port id = 2
  generation code = 1
  number of phys = 1
  phy identifier = 1
    attached device type: expander device
    attached reason: SMP phy control function
    reason: unknown
    negotiated logical link rate: phy enabled; 6 Gbps
    attached initiator port: ssp=0 stp=0 smp=0
    attached target port: ssp=0 stp=0 smp=1
    SAS address = 0x5000cca0284dc06a
    attached SAS address = 0x50030480003954bf
    attached phy identifier = 12
    Invalid DWORD count = 10
    Running disparity error count = 9
    Loss of DWORD synchronization count = 2
    Phy reset problem count = 0

On Wed, Jun 8, 2022, at 15:56, o1bigtenor wrote:
> On Wed, Jun 8, 2022 at 5:22 PM Alan Braithwaite <alan@braithwaite.dev> wrote:
>>
> Just someone learning who asked questions in the past here
>>
>> Please let me know if there's any more information I can provide.
>>
>
> smartmontools is very likely something that will give some more
> information that (likely) will be asked for.
> If not previous installed you might want to get and then look at
> what it says about each drive. Often said information is asked
> for when the low down and dirty work gets a happening.
>
> HTH
