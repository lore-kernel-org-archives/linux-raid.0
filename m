Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A17BC4338F
	for <linux-raid@archiver.kernel.org>; Sat, 14 Aug 2021 18:34:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D13360EE2
	for <linux-raid@archiver.kernel.org>; Sat, 14 Aug 2021 18:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238997AbhHNSfR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 14 Aug 2021 14:35:17 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:38661 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbhHNSfR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 14 Aug 2021 14:35:17 -0400
Received: from weisslap.aisec.fraunhofer.de ([178.27.102.95]) by
 mrelayeu.kundenserver.de (mreue010 [212.227.15.167]) with ESMTPSA (Nemesis)
 id 1MBlgy-1mMhBF450u-00CDbq; Sat, 14 Aug 2021 20:34:34 +0200
From:   =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Song Liu <song@kernel.org>, Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v2 0/3] dm: audit event logging
Date:   Sat, 14 Aug 2021 20:33:52 +0200
Message-Id: <20210814183359.4061-1-michael.weiss@aisec.fraunhofer.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:upD3yRH5hFfQxAWGBD+cbK34kBXTUgHSWOzn/0o6eeF1UV6INC8
 nWPgpTusd43NAKiNW/RRkfsimIls0/5covPu+MlMNO1CgSuOgsKyCxP67wyycvX6bpXZW8j
 9ntlEWN0juSCWi5UL3LWVABcW/IB1QL8mClvRBJ8NtfMnFH31qoERcZEl9qwYdCKD8OduYI
 erw+aM7QGnaCuvKgh6J/g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:eWWgpQeMjvI=:T0Hp/BqnPHfzstvVBrwuaq
 d9wZNcguphCGb0uUPPLHkAr47mebdBJ1ENtO7PAbg+r6Chhv2q5M4BuDxrSUkVAAEGqMaZhtX
 JwJTrLwnMMWcDYGgeAW0ew+0Mh6lLGRAO5qoScBCKB/YD2sS7+W46wFW1mIhj7p8ziCkGI1cn
 zs89DeL0zb17GPxBXOu6FkJxuYXL/N6PkzsJ3LYSqNItwmXHY86BD8hnwtXCZdZ7D1gO62Qzs
 F2Vwi2qXtsWiMJwm6aQShqpCqLAJTbJSBz5bECiLDv/6aJW8jt0AqjO4IQ9en1POH3SylTJiG
 mwuRk0rxHiih5CcY/a6zh8OHtTWKPBgg38xm2RIMa/skMskrJ2EYANQPmVZsfSQaMLEXpUlbs
 FKNShznyjfCzqhIteNK74OEZxfTPsuRMD2xrL3yBdFfTTZmW5psKg5q9k8/T/noMJDW9MzVvj
 QExk+2XP/0xvGc6H4pv2tuFN3xt40y9exlHpzG+T1GGfM05CjQaI6NNsdS9c5RvZVfwpyK0+c
 0zWCyEENWVoCzN7ewNeIxQaDiKaT3a7LeFpnT5n/M7DtDv+/ZD+TL1pBOaO/792n45O44aD5W
 ummoytgWaKbeMDdKAqJ8fLf136lbDLKOAlp5y3tsrWRZfX2IeEiXz876R2qyL5g3wxLhTfpUM
 KvDc1vQEiXFutEmjN6RKvpuBdLvx1oz6v3s0weoyCbzXOEzeDzZ39h+uknhcA5ZC8dzqzSAkr
 MMnasIL/khokW7o2JUAyAAWE/JqnEK9VfxJxPb3z2B07MuJ3yFaWKbS7I9yUoGMXIr6HpjiJ7
 UqrJGoBwQzUHP4cOcT9ioEmtfpyistA47sNu8AT1dQnGWT5vcikQ/4bWNaQOQMZtxNVs4+z0g
 Vv31CrOmyEIG6jcszs1A==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

dm integrity and also stacked dm crypt devices track integrity
violations internally. Thus, integrity violations could be polled
from user space, e.g., by 'integritysetup status'.

From an auditing perspective, we only could see that there were
a number of integrity violations, but not when and where the
violation exactly was taking place. The current error log to
the kernel ring buffer, contains those information, time stamp and
sector on device. However, for auditing the audit subsystem provides
a separate logging mechanism which meets certain criteria for secure
audit logging.

With this small series we make use of the kernel audit framework
and extend the dm driver to log audit events in case of such
integrity violations. Further, we also log construction and
destruction of the device mappings.

We focus on dm-integrity and stacked dm-crypt devices for now.
However, the helper functions to log audit messages should be
applicable to dm verity too.

The first patch introduce generic audit wrapper functions.
The second patch makes use of the audit wrapper functions in the
dm-integrity.c.
The third patch uses the wrapper functions in dm-crypt.c.

The audit logs look like this if executing the following simple test:

# dd if=/dev/zero of=test.img bs=1M count=1024
# losetup -f test.img
# integritysetup -vD format --integrity sha256 -t 32 /dev/loop0 
# integritysetup open -D /dev/loop0 --integrity sha256 integritytest
# integritysetup status integritytest
# integritysetup close integritytest
# integritysetup open -D /dev/loop0 --integrity sha256 integritytest
# integritysetup status integritytest
# dd if=/dev/urandom of=/dev/loop0 bs=512 count=1 seek=100000
# dd if=/dev/mapper/integritytest of=/dev/null

-------------------------
audit.log from auditd

type=UNKNOWN[1336] msg=audit(1628692862.187:409): module=integrity dev=254:3 op=ctr res=1
type=UNKNOWN[1336] msg=audit(1628692862.443:410): module=integrity dev=254:3 op=dtr res=1
type=UNKNOWN[1336] msg=audit(1628692862.543:411): module=integrity dev=254:3 op=ctr res=1
type=UNKNOWN[1336] msg=audit(1628692877.943:412): module=integrity dev=254:3 op=dtr res=1

type=UNKNOWN[1336] msg=audit(1628692887.287:413): module=integrity dev=254:3 op=ctr res=1

type=UNKNOWN[1336] msg=audit(1628692925.156:417): module=integrity dev=254:3 op=dtr res=1

type=UNKNOWN[1336] msg=audit(1628692930.720:418): module=integrity dev=254:3 op=ctr res=1

type=UNKNOWN[1336] msg=audit(1628692989.344:419): module=integrity dev=254:3 op=integrity-checksum sector=77480 res=0
type=UNKNOWN[1336] msg=audit(1628692989.348:420): module=integrity dev=254:3 op=integrity-checksum sector=77480 res=0
type=UNKNOWN[1336] msg=audit(1628692989.348:421): module=integrity dev=254:3 op=integrity-checksum sector=77480 res=0
type=UNKNOWN[1336] msg=audit(1628692989.348:422): module=integrity dev=254:3 op=integrity-checksum sector=77480 res=0
type=UNKNOWN[1336] msg=audit(1628692989.348:423): module=integrity dev=254:3 op=integrity-checksum sector=77480 res=0
type=UNKNOWN[1336] msg=audit(1628692989.348:424): module=integrity dev=254:3 op=integrity-checksum sector=77480 res=0
type=UNKNOWN[1336] msg=audit(1628692989.348:425): module=integrity dev=254:3 op=integrity-checksum sector=77480 res=0
type=UNKNOWN[1336] msg=audit(1628692989.348:426): module=integrity dev=254:3 op=integrity-checksum sector=77480 res=0
type=UNKNOWN[1336] msg=audit(1628692989.348:427): module=integrity dev=254:3 op=integrity-checksum sector=77480 res=0
type=UNKNOWN[1336] msg=audit(1628692989.348:428): module=integrity dev=254:3 op=integrity-checksum sector=77480 res=0

v2 Changes:
- Fixed compile errors if CONFIG_DM_AUDIT is not set
- Fixed formatting and typos as suggested by Casey

Michael Weiß (3):
  dm: introduce audit event module for device mapper
  dm integrity: log audit events for dm-integrity target
  dm crypt: log aead integrity violations to audit subsystem

 drivers/md/Kconfig         | 10 +++++++
 drivers/md/Makefile        |  4 +++
 drivers/md/dm-audit.c      | 59 ++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-audit.h      | 33 +++++++++++++++++++++
 drivers/md/dm-crypt.c      | 22 +++++++++++---
 drivers/md/dm-integrity.c  | 25 +++++++++++++---
 include/uapi/linux/audit.h |  1 +
 7 files changed, 146 insertions(+), 8 deletions(-)
 create mode 100644 drivers/md/dm-audit.c
 create mode 100644 drivers/md/dm-audit.h

-- 
2.20.1

