Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88766C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 16:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiGSQnS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 12:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiGSQnS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 12:43:18 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BB356BB5
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 09:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:References:Cc:To:From:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=WLNU7Iyt06lnKN/PyKPZk5fvNcdPbQiq1PTgSsWGjNQ=; b=RtMvSsG/dL3SjCs+G0t0fIKFvH
        /Yntupj5rhScWHq/ekLAFFbzcWlAOLmr5wRHR2yZIlzvMC4erleNZT+Be5oN2PqBsrZAx85E1Japc
        UO7Xuxd6vs5jaOPGqFvvPgF7Q/i1G8J4a466o7oWVYQm5HglNCHDt5ANjKnR3t0U6jRQ5yYbbY1pX
        64VsW/dYv8RGMZ92m4mEjTWOr13YBqGY8i91ny02FmpFYxqfQCh+qXnkecAyigSsxxKqIb3qGTQQn
        9KAMUuGpN5d0YTvk+jbXN6NY0mzdo60myJBGPQLb6Pgzcgs+apolP+lqT1t08k0ZENQAA5/VWAz3T
        6zjOPShg==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oDqJT-001VS1-FK; Tue, 19 Jul 2022 10:43:12 -0600
Message-ID: <dcaf3af0-95c5-bf9a-bd2c-9c6a60c67e97@deltatee.com>
Date:   Tue, 19 Jul 2022 10:43:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   Logan Gunthorpe <logang@deltatee.com>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jsorensen@fb.com>,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>, Xiao Ni <xni@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Coly Li <colyli@suse.de>, Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
References: <20220714223749.17250-1-logang@deltatee.com>
 <150ffbb2-9881-9c1f-cc5e-331926b8e423@linux.dev>
 <20220719132739.00001b94@linux.intel.com>
Content-Language: en-CA
In-Reply-To: <20220719132739.00001b94@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: mariusz.tkaczyk@linux.intel.com, guoqing.jiang@linux.dev, linux-raid@vger.kernel.org, jsorensen@fb.com, song@kernel.org, hch@infradead.org, buczek@molgen.mpg.de, xni@redhat.com, himanshu.madhani@oracle.com, colyli@suse.de, bruce.dubbs@gmail.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH mdadm] mdadm: Don't open md device for CREATE and ASSEMBLE
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-07-19 05:27, Mariusz Tkaczyk wrote:
> On Fri, 15 Jul 2022 10:20:26 +0800
> Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>> On 7/15/22 6:37 AM, Logan Gunthorpe wrote:
>>> To fix this, don't bother trying to open the md device for CREATE and
>>> ASSEMBLE commands, as the file descriptor will never be used anyway
>>> even if it is successfully openned.
> Hi All,
> 
> This is not a fix, it just reduces race probability because file descriptor
> will be opened later.

That's not correct. The later "open" call actually will use the new_array
parameter which will wait for the workqueue before creating a new array
device, so the old one is properly cleaned up and there is no longer
a race condition with this patch. If new_array doesn't exist and it falls back
to a regular open, then it will still do the right thing and open the device 
with create_on_open.

> I tried to resolve it in the past by adding completion to md driver and force
> mdadm --stop command to wait for sysfs clean up but I have never finished it.
> IMO it is a better way, wait for device to be fully removed by MD during stop.
> Thoughts?

I don't think that would work very well. Userspace would end up blocking
on --stop indefinitely if there are any references delaying cleanup to
the device. That's not very user friendly. Given that opening the md
device has side-effects, I think we should avoid opening when we
should know that we are about to try to create a new device.

> One objection I have here is that error handling is changed, so it could be
> harmful change for users. 

Hmm, yes seems like I was a bit sloppy here. However, it still seems possible
to fix this up by not pre-opening the device. The only use for the mdfd
in CREATE, ASSEMBLE and BUILD is to get the minor number if
ident.super_minor == -2 and check if an existing specified device is an md 
device (which may be redundant). We could replace this with a stat() call to
avoid opening the device. What about the patch at the end of this email?

>>>
>>> Side note: it would be nice to disable create_on_open as well to help
>>> solve this, but it seems the work for this was never finished. By default,
>>> mdadm will create using the old node interface when a name is specified
>>> unless the user specifically puts names=yes in a config file, which
>>> doesn't seem to be vcreate_on_openery common yet.  
>>
>> Hmm, 'create_on_open' is default to true, not sure if there is any side 
>> effect
>> after change to false.
> 
> I'm slowly working on this. The change is not simple, starting from terrible
> create_mddev code and char *mddev and char *name rules , ending with hidden
> references which we are not aware off (it is common to create temp node and
> open mddevice in mdadm) and other references in systemd (because of that, udev
> is avoiding to open device).
> This also indicate that we should drop partition discover in kernel and use
> udev in the future, especially for external metadata (where RO -> RW transition
> happens during assembly). But this is a separate problem.

I'm glad to hear someone is still working on that. Thanks!

Logan

--

diff --git a/mdadm.c b/mdadm.c
index 56722ed997a2..7b757c79d6bf 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1349,6 +1349,8 @@ int main(int argc, char *argv[])
 
 	if (mode == MANAGE || mode == BUILD || mode == CREATE ||
 	    mode == GROW || (mode == ASSEMBLE && ! c.scan)) {
+		struct stat stb;
+
 		if (devs_found < 1) {
 			pr_err("an md device must be given in this mode\n");
 			exit(2);
@@ -1361,37 +1363,31 @@ int main(int argc, char *argv[])
 			mdfd = open_mddev(devlist->devname, 1);
 			if (mdfd < 0)
 				exit(1);
+
+			fstat(mdfd, &stb);
 		} else {
 			char *bname = basename(devlist->devname);
+			int ret;
 
 			if (strlen(bname) > MD_NAME_MAX) {
 				pr_err("Name %s is too long.\n", devlist->devname);
 				exit(1);
 			}
-			/* non-existent device is OK */
-			mdfd = open_mddev(devlist->devname, 0);
-		}
-		if (mdfd == -2) {
-			pr_err("device %s exists but is not an md array.\n", devlist->devname);
-			exit(1);
-		}
-		if ((int)ident.super_minor == -2) {
-			struct stat stb;
-			if (mdfd < 0) {
+
+			ret = stat(devlist->devname, &stb);
+			if (ident.super_minor == -2 && ret) {
 				pr_err("--super-minor=dev given, and listed device %s doesn't exist.\n",
					devlist->devname);
+				exit(1);
+			}
+
+			if (!ret && !md_array_valid_stat(&stb)) {
+				pr_err("device %s exists but is not an md array.\n", devlist->devname);
 				exit(1);
 			}
-			fstat(mdfd, &stb);
-			ident.super_minor = minor(stb.st_rdev);
-		}
-		if (mdfd >= 0 && mode != MANAGE && mode != GROW) {
-			/* We don't really want this open yet, we just might
-			 * have wanted to check some things
-			 */
-			close(mdfd);
-			mdfd = -1;
 		}
+		if (ident.super_minor == -2)
+			ident.super_minor = minor(stb.st_rdev);
 	}
 
 	if (s.raiddisks) {
diff --git a/mdadm.h b/mdadm.h
index 05ef881f4709..7462336b381c 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1504,6 +1504,7 @@ extern int Restore_metadata(char *dev, char *dir, struct context *c,
 			    struct supertype *st, int only);
 
 int md_array_valid(int fd);
+int md_array_valid_stat(struct stat *st);
 int md_array_active(int fd);
 int md_array_is_active(struct mdinfo *info);
 int md_get_array_info(int fd, struct mdu_array_info_s *array);
diff --git a/util.c b/util.c
index cc94f96ef120..20acdcf6af22 100644
--- a/util.c
+++ b/util.c
@@ -250,6 +250,23 @@ int md_array_valid(int fd)
 	return !ret;
 }
 
+int md_array_valid_stat(struct stat *st)
+{
+	struct mdinfo *sra;
+	char *devnm;
+
+	devnm = stat2devnm(st);
+	if (!devnm)
+		return 0;
+
+	sra = sysfs_read(-1, devnm, GET_ARRAY_STATE);
+	if (!sra)
+		return 0;
+
+	free(sra);
+	return 1;
+}
+
 int md_array_active(int fd)
 {
 	struct mdinfo *sra;
