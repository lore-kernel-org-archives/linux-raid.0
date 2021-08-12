Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D5CC4338F
	for <linux-raid@archiver.kernel.org>; Thu, 12 Aug 2021 14:58:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57CFF610A4
	for <linux-raid@archiver.kernel.org>; Thu, 12 Aug 2021 14:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237636AbhHLO6q (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 12 Aug 2021 10:58:46 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:36601 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237758AbhHLO6o (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 12 Aug 2021 10:58:44 -0400
Received: from weisslap.aisec.fraunhofer.de ([178.27.102.95]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis)
 id 1MQMm9-1mRAbi44UT-00MJ0W; Thu, 12 Aug 2021 16:58:12 +0200
From:   =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To:     michael.weiss@aisec.fraunhofer.de
Cc:     Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Song Liu <song@kernel.org>, Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH 0/3] dm: audit event logging
Date:   Thu, 12 Aug 2021 16:57:41 +0200
Message-Id: <20210812145748.4460-1-michael.weiss@aisec.fraunhofer.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:E1yluKd3qSTn/LHmKKMFbuZnMtW/v47VwlVPW92Z/ltMRz2knBo
 LUQyCYEC2nBrlG4SmrbzjHjDS+Fd9D8OehmDmOZsqJTjivtsonN6npkNg2hb0DLCrbWKdMe
 vP+JeClAaWg4eL3AUzJ82BiSyzvh/upNN3Nu1JcQuCiX16YxsbS3NKsO4T3mVfUaolBaR93
 bRYbvp64iIhA48Q+iXc/g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:lZlLrnXJhrg=:PGh6NvpgZ0JUeh4mmqRVRw
 duVibXgDbJSpVvoewOSVe+GodEkk73GlV1alRP/DCjdwS3JcvoTN7KDyqEwgwwZISlRWMkzHT
 UBYDJgc83y8pysVLik2TRVYhuVhaY3gsKrRSOVbLv2A8YWd0DpzXSyvVq+9sePDSk9cLy1fEO
 32a27pPtS0tkOV1mWpLZzFx+C+mkDnBwS6xBh3w14ty8N7Gu/7Jj7opjXjRlAmX/lvLzN7Vou
 AElX01s2G36RGxkqjHo4LGaEiu9oUwaONEogOaM30sbcDHh+K6MW11ZNq1oAzE841qG8bec3R
 a9XkePcN4Sm4RTx4ipQ5+w03S1HkFZ0tcuy3D+v3B9nfh8COQ4ncxgoN25ru6+osj83WvUWIO
 zslJjwSuercv0x/kUZyNrK5npc+MuqhxbP76yUUpnOMlATU1tlGWKgwZQ3I/DjqaUnslvZGkq
 LNmjb6fLwIhkME6aF0A22sOTWZjTiRqYOs0UUMkUGFAUcKa2IGYxeZzzNWJBI5wlh7vRrCPw3
 bENH9wIZKo4S2BfF4Q7OnX9PshJKrJROFSkeaI4wQ932hyDX6Xl9pAcDmEL/lNmxl2UKU+BQT
 vuEd6sFK5EJmS6MUbBFNYLe4YfyA2G/kgBjIGCbeyvZccvJBoVY/bGDcOxJQn66pqa4k3UCRH
 sBd/O2ttmII2Zw5/KRA9Vwy7zwkJuTmxAevj0oY6J8r2SuAbXbO6akCtxDpvABjzxcR3g+/IQ
 ywwG/IS8Z2SBTeKwjFER0nRfl2v/TWj5/KGh1weRRs88v6EX4O5ukRfbMDqRQdMG9UXrrqtGE
 h1WETTjvtaABaKWYXdXEv3WzO1VeAf7kHqK+9zNIxH/66LCMiv0xjmHIHR5wlPyAlN0Qw9y0q
 +S2axYhga+FIijnwqbWg==
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

Michael Weiß (3):
  dm: introduce audit event module for device mapper
  dm integrity: log audit events for dm-integrity target
  dm crypt: log aead integrity violations to audit subsystem

 drivers/md/Kconfig         | 10 +++++++
 drivers/md/Makefile        |  4 +++
 drivers/md/dm-audit.c      | 59 ++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-audit.h      | 33 +++++++++++++++++++++
 drivers/md/dm-crypt.c      | 23 ++++++++++++---
 drivers/md/dm-integrity.c  | 25 +++++++++++++---
 include/uapi/linux/audit.h |  2 ++
 7 files changed, 148 insertions(+), 8 deletions(-)
 create mode 100644 drivers/md/dm-audit.c
 create mode 100644 drivers/md/dm-audit.h

-- 
2.20.1

