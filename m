Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34BC7C433F5
	for <linux-raid@archiver.kernel.org>; Wed,  8 Sep 2021 01:00:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C94C6103E
	for <linux-raid@archiver.kernel.org>; Wed,  8 Sep 2021 01:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345534AbhIHBBK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Sep 2021 21:01:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56828 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344953AbhIHBBI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Sep 2021 21:01:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631062801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o6ZRcfmHu3oLQjavMIlcnpQ5aP7+DMFF/Fbdpa5BTbg=;
        b=Cntsf8TfPBNDGpNyuCz7CU3qL9faraSCD7VwAkDNi6JzO/6yKBcbLDwu4oGaQmfcFt2Pwb
        JwhY0jiBdt6RHQWTfE/5kejuYsjnUj7Wr7ykrCVLinObaRBTbNGzz2iT8e9Ct/ltxH/F/J
        JLXGF3kprKhl3n2YWi1QS1EWYyXlf90=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-CSHKauQnOdqrdmjV3itcmA-1; Tue, 07 Sep 2021 21:00:00 -0400
X-MC-Unique: CSHKauQnOdqrdmjV3itcmA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD46910054F6;
        Wed,  8 Sep 2021 00:59:58 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 40A2B5D9DC;
        Wed,  8 Sep 2021 00:59:44 +0000 (UTC)
Date:   Tue, 7 Sep 2021 20:59:42 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Michael =?iso-8859-1?Q?Wei=DF?= 
        <michael.weiss@aisec.fraunhofer.de>
Cc:     Paul Moore <paul@paul-moore.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Mike Snitzer <snitzer@redhat.com>,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
        dm-devel@redhat.com, linux-audit@redhat.com,
        Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH v4 0/3] dm: audit event logging
Message-ID: <20210908005942.GJ490529@madcap2.tricolour.ca>
References: <20210904095934.5033-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210904095934.5033-1-michael.weiss@aisec.fraunhofer.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2021-09-04 11:59, Michael Weiß wrote:
> dm integrity and also stacked dm crypt devices track integrity
> violations internally. Thus, integrity violations could be polled
> from user space, e.g., by 'integritysetup status'.
> 
> >From an auditing perspective, we only could see that there were
> a number of integrity violations, but not when and where the
> violation exactly was taking place. The current error log to
> the kernel ring buffer, contains those information, time stamp and
> sector on device. However, for auditing the audit subsystem provides
> a separate logging mechanism which meets certain criteria for secure
> audit logging.
> 
> With this small series we make use of the kernel audit framework
> and extend the dm driver to log audit events in case of such
> integrity violations. Further, we also log construction and
> destruction of the device mappings.
> 
> We focus on dm-integrity and stacked dm-crypt devices for now.
> However, the helper functions to log audit messages should be
> applicable to dm-verity too.
> 
> The first patch introduce generic audit wrapper functions.
> The second patch makes use of the audit wrapper functions in the
> dm-integrity.c.
> The third patch uses the wrapper functions in dm-crypt.c.
> 
> The audit logs look like this if executing the following simple test:
> 
> # dd if=/dev/zero of=test.img bs=1M count=1024
> # losetup -f test.img
> # integritysetup -vD format --integrity sha256 -t 32 /dev/loop0
> # integritysetup open -D /dev/loop0 --integrity sha256 integritytest
> # integritysetup status integritytest
> # integritysetup close integritytest
> # integritysetup open -D /dev/loop0 --integrity sha256 integritytest
> # integritysetup status integritytest
> # dd if=/dev/urandom of=/dev/loop0 bs=512 count=1 seek=100000
> # dd if=/dev/mapper/integritytest of=/dev/null
> 
> -------------------------
> audit.log from auditd
> 
> type=UNKNOWN[1336] msg=audit(1630425039.363:184): module=integrity op=ctr ppid=3807 pid=3819 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts2 ses=3 comm="integritysetup" exe="/sbin/integritysetup" subj==unconfined dev=254:3 error_msg='success' res=1
> type=UNKNOWN[1336] msg=audit(1630425039.471:185): module=integrity op=dtr ppid=3807 pid=3819 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts2 ses=3 comm="integritysetup" exe="/sbin/integritysetup" subj==unconfined dev=254:3 error_msg='success' res=1
> type=UNKNOWN[1336] msg=audit(1630425039.611:186): module=integrity op=ctr ppid=3807 pid=3819 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts2 ses=3 comm="integritysetup" exe="/sbin/integritysetup" subj==unconfined dev=254:3 error_msg='success' res=1
> type=UNKNOWN[1336] msg=audit(1630425054.475:187): module=integrity op=dtr ppid=3807 pid=3819 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts2 ses=3 comm="integritysetup" exe="/sbin/integritysetup" subj==unconfined dev=254:3 error_msg='success' res=1
> 
> type=UNKNOWN[1336] msg=audit(1630425073.171:191): module=integrity op=ctr ppid=3807 pid=3883 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts2 ses=3 comm="integritysetup" exe="/sbin/integritysetup" subj==unconfined dev=254:3 error_msg='success' res=1
> 
> type=UNKNOWN[1336] msg=audit(1630425087.239:192): module=integrity op=dtr ppid=3807 pid=3902 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts2 ses=3 comm="integritysetup" exe="/sbin/integritysetup" subj==unconfined dev=254:3 error_msg='success' res=1
> 
> type=UNKNOWN[1336] msg=audit(1630425093.755:193): module=integrity op=ctr ppid=3807 pid=3906 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts2 ses=3 comm="integritysetup" exe="/sbin/integritysetup" subj==unconfined dev=254:3 error_msg='success' res=1
> 
> type=UNKNOWN[1337] msg=audit(1630425112.119:194): module=integrity op=integrity-checksum dev=254:3 sector=77480 res=0
> type=UNKNOWN[1337] msg=audit(1630425112.119:195): module=integrity op=integrity-checksum dev=254:3 sector=77480 res=0
> type=UNKNOWN[1337] msg=audit(1630425112.119:196): module=integrity op=integrity-checksum dev=254:3 sector=77480 res=0
> type=UNKNOWN[1337] msg=audit(1630425112.119:197): module=integrity op=integrity-checksum dev=254:3 sector=77480 res=0
> type=UNKNOWN[1337] msg=audit(1630425112.119:198): module=integrity op=integrity-checksum dev=254:3 sector=77480 res=0
> type=UNKNOWN[1337] msg=audit(1630425112.119:199): module=integrity op=integrity-checksum dev=254:3 sector=77480 res=0
> type=UNKNOWN[1337] msg=audit(1630425112.119:200): module=integrity op=integrity-checksum dev=254:3 sector=77480 res=0
> type=UNKNOWN[1337] msg=audit(1630425112.119:201): module=integrity op=integrity-checksum dev=254:3 sector=77480 res=0
> type=UNKNOWN[1337] msg=audit(1630425112.119:202): module=integrity op=integrity-checksum dev=254:3 sector=77480 res=0
> type=UNKNOWN[1337] msg=audit(1630425112.119:203): module=integrity op=integrity-checksum dev=254:3 sector=77480 res=0

Are these isolated records, or are they accompanied by a type=SYSCALL
record in your logs?

The reason I ask is that audit_log_task_info() is included in three of
the calling methods (dm_audit_log_{target,ctr,dtr}) which use a
combination of AUDIT_DM_CTRL/AUDIT_DM_EVENT type while the fourth
(dm_audit_log_bio) also uses one of the types above but does not include
audit_log_task_info().  If all these records are accompanied by SYSCALL
records, then the task info would be redundant (and might even conflict
if there's a bug).  Another minor oddity is the double "=" for the subj
field, which doesn't appear to be a bug in your code, but still puzzling.

Are those last 10 records expected to be identical other than event
serial number?

> v4 Changes:
> - Added comments on intended use of wrapper functions in dm-audit.h
> - dm_audit_log_bio(): Fixed missing '=' as spotted by Paul
> - dm_audit_log_ti(): Handle wrong audit_type as suggested by Paul
> 
> v3 Changes:
> - Use of two audit event types AUDIT_DM_EVENT und AUDIT_DM_CTRL
> - Additionaly use audit_log_task_info in case of AUDIT_DM_CTRL messages
> - Provide consistent fields per message type as suggested by Paul
> - Added sample events to commit message of [1/3] as suggested by Paul
> - Rebased on v5.14
> 
> v2 Changes:
> - Fixed compile errors if CONFIG_DM_AUDIT is not set
> - Fixed formatting and typos as suggested by Casey
> 
> Michael Weiß (3):
>   dm: introduce audit event module for device mapper
>   dm integrity: log audit events for dm-integrity target
>   dm crypt: log aead integrity violations to audit subsystem
> 
>  drivers/md/Kconfig         | 10 +++++
>  drivers/md/Makefile        |  4 ++
>  drivers/md/dm-audit.c      | 84 ++++++++++++++++++++++++++++++++++++++
>  drivers/md/dm-audit.h      | 66 ++++++++++++++++++++++++++++++
>  drivers/md/dm-crypt.c      | 22 ++++++++--
>  drivers/md/dm-integrity.c  | 25 ++++++++++--
>  include/uapi/linux/audit.h |  2 +
>  7 files changed, 205 insertions(+), 8 deletions(-)
>  create mode 100644 drivers/md/dm-audit.c
>  create mode 100644 drivers/md/dm-audit.h
> 
> -- 
> 2.20.1
> 
> --
> Linux-audit mailing list
> Linux-audit@redhat.com
> https://listman.redhat.com/mailman/listinfo/linux-audit

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

