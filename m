Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF61C433EF
	for <linux-raid@archiver.kernel.org>; Sat,  4 Sep 2021 10:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4255361057
	for <linux-raid@archiver.kernel.org>; Sat,  4 Sep 2021 10:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235347AbhIDKBJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 4 Sep 2021 06:01:09 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:58321 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbhIDKBH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 4 Sep 2021 06:01:07 -0400
Received: from weisslap.aisec.fraunhofer.de ([178.27.102.95]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis)
 id 1MpCz1-1ml86h26BD-00ql6S; Sat, 04 Sep 2021 11:59:52 +0200
From:   =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To:     Paul Moore <paul@paul-moore.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Cc:     =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>,
        Song Liu <song@kernel.org>, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v4 0/3] dm: audit event logging
Date:   Sat,  4 Sep 2021 11:59:27 +0200
Message-Id: <20210904095934.5033-1-michael.weiss@aisec.fraunhofer.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:dvMNFghMudCwae8r1WJmn/zZSZcP1zgZE2HVyVW2CBtvdZTAB1b
 n05Puw4rPFXFHEgUNjWc8ckEw4V9+Nb5L6kdOqcdap4XyQApbLjeDkEVq+RFY8vCxNrd8P+
 xVo9Uto+uZiWvzs5eftmtzWnMthr+Iji0fCKvi/aIRGL73u4DL4t/TBeh86McwPWKYeViCP
 dgauP2C1gmoDX7yT+ZavA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:V5M9YcIkkKM=:HENhpUOiEHPZCtljLT5kOT
 RgJgvb9cb8FL4ybygtEAOViolhLjEfiFbfkn7UhyRVBqNzLR4jiGzT6t2Zk+ouMXTCabpce4d
 XBPz3gvjIhZ7oLhL9mgayE/S0uFvwehS9o32MMgU+Qqq+fz3E+jnUr1IDwXM0aniHOzB5kZyj
 QRxh1qXpueWer0chEyZNTqaBOLdZ448Vplxwby38W98idLrc/MDiwzz/T5bnO12hiA6d/PF7I
 S8Of7Vw4RN3vPL3qGyskDi5WU1IxV7vlwLIU+WlpT2eamvgXbSdJcfu2ENakWjF7L4gmtSgjC
 OcAY7mQpzrdlHydxzFuzQ2G76HLNr/nBAvXnFbGLDqKDXzG03hgplHhBAY5aT+pJGjzfVLZvT
 d2fln4K/9g8Gzsj5sZUJxMhxes+XtU+ldkNGy9vG3EVFTyPNbTI2BTXvsshmsmsyhUOmX+he5
 xuITu4h4HmqO1tLLWWseypU4qbK3WxqalRLrkE/+HTdAEPQqkmq1eYPczIwU0RgEXngmKHLk6
 AIUJGWh5Rboll6gq0XrAMDik+ohGoEslzxbgPhKNVnPIiI/V75E1jGm6PPY7v9ZQ3e19P64Zd
 Lzsoc4jaI4a0FOqi5JcMKtEPxqzGR2D/mDnx+MDWHq2OIliu7wRcwKv8uC9V3eOj97vROQqQJ
 GtJudo4lGegwbqTivnilPsBfjzp9mJmiBAb5n4htz3VjJs+vEA9hhdjh+cteK1z0wfhYr7efc
 EBlSGPrvakaMtndcbCYI2Iriv3FWYHdwtfmzOQXnET9A5s59QnbBkFHffCY=
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
applicable to dm-verity too.

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

type=UNKNOWN[1336] msg=audit(1630425039.363:184): module=integrity
op=ctr ppid=3807 pid=3819 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0
egid=0 sgid=0 fsgid=0 tty=pts2 ses=3 comm="integritysetup"
exe="/sbin/integritysetup" subj==unconfined dev=254:3
error_msg='success' res=1
type=UNKNOWN[1336] msg=audit(1630425039.471:185): module=integrity
op=dtr ppid=3807 pid=3819 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0
egid=0 sgid=0 fsgid=0 tty=pts2 ses=3 comm="integritysetup"
exe="/sbin/integritysetup" subj==unconfined dev=254:3
error_msg='success' res=1
type=UNKNOWN[1336] msg=audit(1630425039.611:186): module=integrity
op=ctr ppid=3807 pid=3819 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0
egid=0 sgid=0 fsgid=0 tty=pts2 ses=3 comm="integritysetup"
exe="/sbin/integritysetup" subj==unconfined dev=254:3
error_msg='success' res=1
type=UNKNOWN[1336] msg=audit(1630425054.475:187): module=integrity
op=dtr ppid=3807 pid=3819 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0
egid=0 sgid=0 fsgid=0 tty=pts2 ses=3 comm="integritysetup"
exe="/sbin/integritysetup" subj==unconfined dev=254:3
error_msg='success' res=1

type=UNKNOWN[1336] msg=audit(1630425073.171:191): module=integrity
op=ctr ppid=3807 pid=3883 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0
egid=0 sgid=0 fsgid=0 tty=pts2 ses=3 comm="integritysetup"
exe="/sbin/integritysetup" subj==unconfined dev=254:3
error_msg='success' res=1

type=UNKNOWN[1336] msg=audit(1630425087.239:192): module=integrity
op=dtr ppid=3807 pid=3902 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0
egid=0 sgid=0 fsgid=0 tty=pts2 ses=3 comm="integritysetup"
exe="/sbin/integritysetup" subj==unconfined dev=254:3
error_msg='success' res=1

type=UNKNOWN[1336] msg=audit(1630425093.755:193): module=integrity
op=ctr ppid=3807 pid=3906 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0
egid=0 sgid=0 fsgid=0 tty=pts2 ses=3 comm="integritysetup"
exe="/sbin/integritysetup" subj==unconfined dev=254:3
error_msg='success' res=1

type=UNKNOWN[1337] msg=audit(1630425112.119:194): module=integrity
op=integrity-checksum dev=254:3 sector=77480 res=0
type=UNKNOWN[1337] msg=audit(1630425112.119:195): module=integrity
op=integrity-checksum dev=254:3 sector=77480 res=0
type=UNKNOWN[1337] msg=audit(1630425112.119:196): module=integrity
op=integrity-checksum dev=254:3 sector=77480 res=0
type=UNKNOWN[1337] msg=audit(1630425112.119:197): module=integrity
op=integrity-checksum dev=254:3 sector=77480 res=0
type=UNKNOWN[1337] msg=audit(1630425112.119:198): module=integrity
op=integrity-checksum dev=254:3 sector=77480 res=0
type=UNKNOWN[1337] msg=audit(1630425112.119:199): module=integrity
op=integrity-checksum dev=254:3 sector=77480 res=0
type=UNKNOWN[1337] msg=audit(1630425112.119:200): module=integrity
op=integrity-checksum dev=254:3 sector=77480 res=0
type=UNKNOWN[1337] msg=audit(1630425112.119:201): module=integrity
op=integrity-checksum dev=254:3 sector=77480 res=0
type=UNKNOWN[1337] msg=audit(1630425112.119:202): module=integrity
op=integrity-checksum dev=254:3 sector=77480 res=0
type=UNKNOWN[1337] msg=audit(1630425112.119:203): module=integrity
op=integrity-checksum dev=254:3 sector=77480 res=0

v4 Changes:
- Added comments on intended use of wrapper functions in dm-audit.h
- dm_audit_log_bio(): Fixed missing '=' as spotted by Paul
- dm_audit_log_ti(): Handle wrong audit_type as suggested by Paul

v3 Changes:
- Use of two audit event types AUDIT_DM_EVENT und AUDIT_DM_CTRL
- Additionaly use audit_log_task_info in case of AUDIT_DM_CTRL messages
- Provide consistent fields per message type as suggested by Paul
- Added sample events to commit message of [1/3] as suggested by Paul
- Rebased on v5.14

v2 Changes:
- Fixed compile errors if CONFIG_DM_AUDIT is not set
- Fixed formatting and typos as suggested by Casey

Michael Weiß (3):
  dm: introduce audit event module for device mapper
  dm integrity: log audit events for dm-integrity target
  dm crypt: log aead integrity violations to audit subsystem

 drivers/md/Kconfig         | 10 +++++
 drivers/md/Makefile        |  4 ++
 drivers/md/dm-audit.c      | 84 ++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-audit.h      | 66 ++++++++++++++++++++++++++++++
 drivers/md/dm-crypt.c      | 22 ++++++++--
 drivers/md/dm-integrity.c  | 25 ++++++++++--
 include/uapi/linux/audit.h |  2 +
 7 files changed, 205 insertions(+), 8 deletions(-)
 create mode 100644 drivers/md/dm-audit.c
 create mode 100644 drivers/md/dm-audit.h

-- 
2.20.1

