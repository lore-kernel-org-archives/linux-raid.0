Return-Path: <SRS0=jU3t=D4=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D71EC4363A
	for <linux-raid@archiver.kernel.org>; Wed, 21 Oct 2020 20:38:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81F3B2237B
	for <linux-raid@archiver.kernel.org>; Wed, 21 Oct 2020 20:38:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=mail.mil header.i=@mail.mil header.b="RPOTihxC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505415AbgJUUi3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Oct 2020 16:38:29 -0400
Received: from UCOL19PA35.eemsg.mail.mil ([214.24.24.195]:41291 "EHLO
        UCOL19PA35.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505413AbgJUUi3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Oct 2020 16:38:29 -0400
X-Greylist: delayed 430 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Oct 2020 16:38:27 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=mail.mil; i=@mail.mil; q=dns/txt; s=EEMSG2018v1a;
  t=1603312707; x=1634848707;
  h=from:to:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=L3F0++KL2PMy1BfmqJdjCoMvXLDKnYTAZHeGxkOzMEI=;
  b=RPOTihxCfmSRstMBsHLjMbwVJpOX+Uy6ehh/r9JypnE0qJKWZKO3hETz
   pYhs/ExmneEZHlWWGki+EpbvY8JtMmWPaVnSon3Bir+eIvJPAWDUFd9nm
   SlD5+7tL82r52pyNbLpPV+ZzG85FodtYaVgyZNwVEmqHE9HWV/WPorfur
   gvOH4LB8sjDIMl+2sfm301JOcrNs/aeJB5nFvw32L4+w263wdaSSaQqVV
   yKwTZUn3KQWbJ2pVtz9OShdOY/TpuskPN1/qmxJ0XMXbhL1ddFOyoxYAE
   7EoOtd2BVwYMdNs4EMk9jPjLBBlBGpadk1vueC847FlIVymcKpWj4/zu2
   A==;
X-EEMSG-check-017: 164380007|UCOL19PA35_ESA_OUT02.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.77,402,1596499200"; 
   d="scan'208";a="164380007"
Received: from edge-mech02.mail.mil ([214.21.130.228])
  by UCOL19PA35.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA; 21 Oct 2020 20:30:17 +0000
Received: from UMECHPAOU.easf.csd.disa.mil (214.21.130.164) by
 edge-mech02.mail.mil (214.21.130.228) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Wed, 21 Oct 2020 20:29:19 +0000
Received: from UMECHPA7B.easf.csd.disa.mil ([169.254.5.75]) by
 umechpaou.easf.csd.disa.mil ([214.21.130.164]) with mapi id 14.03.0487.000;
 Wed, 21 Oct 2020 20:29:18 +0000
From:   "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
To:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Nr_requests mdraid
Thread-Topic: Nr_requests mdraid
Thread-Index: Adan6NmsRmtK8hFlSiegy3yaiyRpBw==
Date:   Wed, 21 Oct 2020 20:29:18 +0000
Message-ID: <5EAED86C53DED2479E3E145969315A23856DD0D3@UMECHPA7B.easf.csd.disa.mil>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [214.21.97.89]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

All,
I'm working on creating raid5 or raid6 arrays of 800K IOP nvme drives.   Ea=
ch of the drives performs well with a queue depth of 128 and I set to 1023 =
if allowed.   In order for me to try to max out the queue depth on each RAI=
D member, so I'd like to set the sysfs nr_requests on the md device to some=
thing greater than 128, like #raid members * 128.   Even though /sys/block/=
md127/queue/nr_requests is mode 644, when I try to change nr_requests in an=
y way as root, I get write error: invalid argument.  When I'm hitting the m=
d device with random reads, my nvme drives are 100% utilized, but only doin=
g 160K IOPS because they have no queue depth.  =20

Am I doing something silly?  =20
Regards,
Jim Finlayson

[root@hp-dl325 ~]# cd /sys/block/md127/queue
[root@hp-dl325 queue]# ls
add_random            discard_zeroes_data  io_timeout              max_segm=
ents      optimal_io_size      unpriv_sgio
chunk_sectors         fua                  logical_block_size      max_segm=
ent_size  physical_block_size  wbt_lat_usec
dax                   hw_sector_size       max_discard_segments    minimum_=
io_size   read_ahead_kb        write_cache
discard_granularity   io_poll              max_hw_sectors_kb       nomerges=
          rotational           write_same_max_bytes
discard_max_bytes     io_poll_delay        max_integrity_segments  nr_reque=
sts       rq_affinity          write_zeroes_max_bytes
discard_max_hw_bytes  iostats              max_sectors_kb          nr_zones=
          scheduler            zoned
[root@hp-dl325 queue]# cat nr_requests
128
[root@hp-dl325 queue]# ls -l nr_requests
-rw-r--r-- 1 root root 4096 Oct 21 18:55 nr_requests
[root@hp-dl325 queue]# echo 1023 > nr_requests
-bash: echo: write error: Invalid argument
[root@hp-dl325 queue]# echo 128 > nr_requests
-bash: echo: write error: Invalid argument
[root@hp-dl325 queue]# pwd
/sys/block/md127/queue
[root@hp-dl325 queue]#

[root@hp-dl325 queue]# mdadm --version
mdadm - v4.1 - 2018-10-01
[root@hp-dl325 queue]# uname -r
4.18.0-193.el8.x86_64
[root@hp-dl325 queue]# cat /etc/redhat-release
Red Hat Enterprise Linux release 8.2 (Ootpa)
[root@hp-dl325 queue]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [raid0]
md126 : active raid5 nvme9n1[10] nvme8n1[8] nvme7n1[7] nvme6n1[6] nvme5n1[5=
] nvme4n1[4] nvme3n1[3] nvme2n1[2] nvme1n1[1] nvme0n1[0]
      16877177856 blocks super 1.2 level 5, 512k chunk, algorithm 2 [10/10]=
 [UUUUUUUUUU]
      bitmap: 0/14 pages [0KB], 65536KB chunk

md127 : active raid5 nvme18n1[9] nvme17n1[7] nvme16n1[6] nvme15n1[5] nvme14=
n1[4] nvme13n1[3] nvme12n1[2] nvme11n1[1] nvme10n1[0]
      15001935872 blocks super 1.2 level 5, 512k chunk, algorithm 2 [9/9] [=
UUUUUUUUU]
      bitmap: 0/14 pages [0KB], 65536KB chunk

unused devices: <none>

[root@hp-dl325 queue]# cat /etc/udev/rules.d/99-local.rules
SUBSYSTEM=3D=3D"block", ACTION=3D=3D"add|change", KERNEL=3D=3D"md*", ATTR{m=
d/sync_speed_max}=3D"2000000",ATTR{md/group_thread_cnt}=3D"16", ATTR{md/str=
ipe_cache_size}=3D"1024" ATTR{queue/nomerges}=3D"2", ATTR{queue/nr_requests=
}=3D"1023", ATTR{queue/rotational}=3D"0", ATTR{queue/rq_affinity}=3D"2", AT=
TR{queue/scheduler}=3D"none", ATTR{queue/add_random}=3D"0", ATTR{queue/max_=
sectors_kb}=3D"4096"
SUBSYSTEM=3D=3D"block", ACTION=3D=3D"add|change", KERNEL=3D=3D"nvme*[0-9]n*=
[0-9]", ATTRS{model}=3D=3D"*PM1725a*", ATTR{queue/nomerges}=3D"2", ATTR{que=
ue/nr_requests}=3D"1023", ATTR{queue/rotational}=3D"0", ATTR{queue/rq_affin=
ity}=3D"2", ATTR{queue/scheduler}=3D"none", ATTR{queue/add_random}=3D"0", A=
TTR{queue/max_sectors_kb}=3D"4096"=
