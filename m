Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D49F219302
	for <linux-raid@vger.kernel.org>; Wed, 26 Mar 2025 17:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743010614; cv=none; b=bZSVFzl6mk/O6gw5zRLU4tcvmW0+Ikx45NLO8EFS0jPjO1Fp9FB0xOUjZBxNlNHWbTCxpY7z7hYd1DQHSx1J6X5+h2vwT8Ou7qX/DJSU1FdPKyPeXkkIhGwQPFKYIuwWA0df8KZsR5Xx3/j8QYIVVx17IhYwAV+D5v04jJfi+48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743010614; c=relaxed/simple;
	bh=s568X5iUi8NSHdr9eY+iKNVTPjeXHyF0VzXWBVTRcVo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A75u5Y50eTLccUeUZuEL4IXw7R4boypfzDI04EqlkVy0gk6nkruLJwegqRWNUHct+shVUaNC1UGw/X8Le+S62OFloszrvhbwWdMdUYqAKxXVpunG6r+XwfjabNH52Ys5v2zn5qvLKEb1oC/byWrrGAIYROaTchHPxSVhWWbufBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CR7cmOi4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CR7cmOi4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743010611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pyXl0uUB3+4Q5mA/N+6OZtkbK3xnZ2VAfGTSp5B8Ojk=;
	b=CR7cmOi4ecHrQOo3DpOWntqOsb+mbXyekSxuibMMqXVJXmqtt47bR8/bv4ofSHNLCry6O6
	fBLkRz00Z6CSCrLg5S2C3TTOPWFxlnoTlm5kfFYRkfKDTrA/B9j76IvoNPzA5yLFyFYcEM
	ZlVeeLm9RDz1k0AyID2Y+TcvEjeHIAw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-1XJOptkiMYawiTXjiiJNLA-1; Wed, 26 Mar 2025 13:36:49 -0400
X-MC-Unique: 1XJOptkiMYawiTXjiiJNLA-1
X-Mimecast-MFC-AGG-ID: 1XJOptkiMYawiTXjiiJNLA_1743010609
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c5d608e6f5so36500585a.0
        for <linux-raid@vger.kernel.org>; Wed, 26 Mar 2025 10:36:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743010609; x=1743615409;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pyXl0uUB3+4Q5mA/N+6OZtkbK3xnZ2VAfGTSp5B8Ojk=;
        b=HebdSdsTv0MQika1AiFBdJyzgKsEKBBtqxyZix5k215BBvu2NRrVPYcEcD75DBokR9
         7K6gW/0IJDebTS14wCRUPg1pBe6rIXCmmgbJgsLDraTs/gr2oL1QPF5V4VpGjiwWQEWn
         S6CjkUYxv/4rkfT9PckKdliAK8fxcgwB4eeL/3os/NMEbTeE/W6onn2sV8qVRgHKZuSG
         tJVd4k2SpohMrlfLoEc4xmWYBjHPB8Sbj+1sDO6ApQ1azlrlVX7Com6i/y7itYRAXgi/
         i7cjbW8CCUy7c0hryvmFyQ2dc+p4hMgCOi3lWjZN8sNqdA9peTF4craNpQ7K5TZNQpUx
         t2YQ==
X-Gm-Message-State: AOJu0YzfBsrY9gwms9/zcdkPeCKdAFZEiG3383W34xwGVUSSCSzBprD9
	iCBglny21os527jSO0hfM1riWnAsszcLiybIi91BSuLKmw2MdJcE3u6PcdO6JbnEeA5E2UurMiE
	9j/0JZiZpDwicSi1eTD4KUblW+vv11rr30U1n+SRQoO8ukVqyQ4p+MyIraFo=
X-Gm-Gg: ASbGncuFfmvyrMSVs/AYnW4wsXKXPjzYh+TX63NswBvyqf1TcVeFVZGptyCDPD9XUxl
	oWUmh2MzLpQQQhZDD02ZMYTsQLeb6/2zpBK/CzKl2CkOn/EJg1xiPtcZkyO2Yzpssxy4oG+g1SN
	3m/TyvsLTWNdrFyPsTxhym5S1dMCXcoDm8ca5/ZQMUg8n3dghBoNW3Qt6x3i7h0Ibq6VYzXB6+g
	pUqWf23EjPn+tHYBGxqKnq5wn+hu+HaJD3x1PlI9RVh1IZ7EO9aMBIzSvIiUMFbP4DFsS0BfML6
	OZplPK9FTAkPB7KmR/WvauYfjYx556g=
X-Received: by 2002:a05:620a:25ca:b0:7c5:49b7:2372 with SMTP id af79cd13be357-7c5ed9f856amr106738385a.18.1743010609231;
        Wed, 26 Mar 2025 10:36:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9yAVAkNzHWSMkUn+ErdSVunVmRf6jbNbQ6BqPoLN0+jNRChf3T7tnGwhCX8O5AM/LOtDemg==
X-Received: by 2002:a05:620a:25ca:b0:7c5:49b7:2372 with SMTP id af79cd13be357-7c5ed9f856amr106732885a.18.1743010608671;
        Wed, 26 Mar 2025 10:36:48 -0700 (PDT)
Received: from [192.168.50.111] ([23.160.248.161])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c5b92d8b30sm784581985a.39.2025.03.26.10.36.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Mar 2025 10:36:48 -0700 (PDT)
Message-ID: <10c404cb-c1a9-432b-b769-8ffade3e9155@redhat.com>
Date: Wed, 26 Mar 2025 13:36:47 -0400
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mdadm: Incremental mode creates file for udev rules
To: Mariusz Tkaczyk <mtkaczyk@kernel.org>
Cc: linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com,
 Xiao Ni <xni@redhat.com>
References: <ded3b88e-c0e8-4a66-89f3-43bc6bb9664a@redhat.com>
 <20250326134821.305ab2d8@mtkaczyk-private-dev>
Content-Language: en-US
From: Nigel Croxon <ncroxon@redhat.com>
In-Reply-To: <20250326134821.305ab2d8@mtkaczyk-private-dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/26/25 8:48 AM, Mariusz Tkaczyk wrote:
> On Tue, 25 Mar 2025 15:18:00 -0400
> Nigel Croxon <ncroxon@redhat.com> wrote:
> 
>> Mounting an md device may fail during boot from mdadm's claim
>> on the device not being released before systemd attempts to mount.
>>
>> While mdadm is still constructing the array (mdadm --incremental
>> that is called from within
>> /usr/lib/udev/rules.d/64-md-raid-assembly.rules), there is an attempt
>> to mount the md device, but there is not a creation of
>> "/run/mdadm/creating-xxx" file when in incremental mode that the rule
>> is looking for.  Therefore the device is not marked as
>> SYSTEMD_READY=0  in "/usr/lib/udev/rules.d/01-md-raid-creating.rules"
>> and missing synchronization using the "/run/mdadm/creating-xxx" file.
>>
>> Enable creating the "/run/mdadm/creating-xxx" file during
>> incremental mode.
> 
> Hi Nigel,
> The code is rather simple but the change is big. Before I will consider
> it is safe to merge please describe the particular scenario you are
> fixing.
> It is known, persistent issue? Is is sporadic issue?
> 
> In the commit message please add why you think it is safe change.
> 
> This will affect every environment. We need to be certain that it will
> not bring regression in booting flow. It might be hard to debug and
> have big impact on users.
> 
> Thanks,
> Mariusz
> 
>>
>> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
>> ---
>>    Incremental.c | 4 +++-
>>    1 file changed, 3 insertions(+), 1 deletion(-)
>>
> 

From: Nigel Croxon <ncroxon@redhat.com>
Date: Wed, 26 Mar 2025 13:34:01 -0400
Subject: [PATCH] mdadm: enable sync file for udev rules

Mounting an md device may fail during boot from mdadm's claim
on the device not being released before systemd attempts to mount.

In this case it was found that essentially there is a race condition
occurring in which the mount cannot happen without some kind of delay
being added BEFORE the mount itself triggers, or manual intervention
after a timeout.

The findings:
the inode was for a tmp block node made by mdadm for md0.

crash> detailedsearch ff1b0c398ff28380
ff1b0c398f079720: ff1b0c398ff28380 slab:filp state:alloc 
obj:ff1b0c398f079700 size:256
ff1b0c398ff284f8: ff1b0c398ff28380 slab:shmem_inode_cache state:alloc 
obj:ff1b0c398ff28308 size:768

crash> struct file.f_inode,f_path ff1b0c398f079700
f_inode = 0xff1b0c398ff28380,
f_path = {
mnt = 0xff1b0c594aecc7a0,
dentry = 0xff1b0c3a8c614f00
},
crash> struct dentry.d_name 0xff1b0c3a8c614f00
d_name = {
{
{ hash = 3714992780, len = 16 },
hash_len = 72434469516
},
name = 0xff1b0c3a8c614f38 ".tmp.md.1454:9:0"
},

For the race condition, mdadm and udev have some infrastructure for making
the device be ignored while under construction. e.g.

$ cat lib/udev/rules.d/01-md-raid-creating.rules

do not edit this file, it will be overwritten on update
While mdadm is creating an array, it creates a file
/run/mdadm/creating-mdXXX. If that file exists, then
the array is not "ready" and we should make sure the
content is ignored.
KERNEL=="md*", TEST=="/run/mdadm/creating-$kernel", ENV{SYSTEMD_READY}="0"

However, this feature currently is only used by the mdadm create command.
(See calls to udev_block/udev_unblock in the mdadm code as to where and when
this behavior is used.) Any md array being started by incremental or
normal assemble commands does not use this udev integration. So assembly
of an existing array does not look to have any explicit protection from
systemd/udev seeing an array as in a usable state before an mdadm instance
with O_EXCL closes its file handle.
This is for the sake of showing the use case for such an option and why
it would be helpful to delay the mount itself.

While mdadm is still constructing the array (mdadm --incremental
that is called from within /usr/lib/udev/rules.d/64-md-raid-assembly.rules),
there is an attempt to mount the md device, but there is not a creation
of "/run/mdadm/creating-xxx" file when in incremental mode that
the rule is looking for.  Therefore the device is not marked
as SYSTEMD_READY=0  in
"/usr/lib/udev/rules.d/01-md-raid-creating.rules" and missing
synchronization using the "/run/mdadm/creating-xxx" file.

As to this change affecting containers or IMSM...
(container's array state is inactive all the time)

Even if the "array_state" reports "inactive" when previous components
are added, the mdadm call for the very last array component that makes
it usable/ready, still needs to be synced properly - mdadm needs to drop
the claim first (calling "close"), then delete the 
"/run/mdadm/creating-xxx".
Then lets the udev know it is clear to act now (the "udev_unblock" in
mdadm code that generates a synthetic udev event so the rules are
reevalutated). It's this processing of the very last array compoment
that is the issue here (which is not IO error, but it is that trying to
open the dev returns -EBUSY because of the exclusive claim that mdadm
still holds while the mdadm device is being processed already by udev in
parallel - and that is what the /run/mdadm/creating-xxx should prevent 
exactly).

The patch to Incremental.c is to enable creating the 
"/run/mdadm/creating-xxx"
file during incremental mode.

For the change to Create.c, the unlink is called right before dropping
the exculusive claim for the device. This should be the other way round
to avoid the race 100%. That is, if there's a "close" call and 
"udev_unblock"
call, the "close" should go first, then followed by "udev_unblock".

Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
---
  Create.c      | 2 +-
  Incremental.c | 4 +++-
  2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/Create.c b/Create.c
index fd6c9215..656de583 100644
--- a/Create.c
+++ b/Create.c
@@ -1318,8 +1318,8 @@ int Create(struct supertype *st, struct 
mddev_ident *ident, int subdevs,
  	} else {
  		pr_err("not starting array - not enough devices.\n");
  	}
-	udev_unblock();
  	close(mdfd);
+	udev_unblock();
  	sysfs_uevent(&info, "change");
  	dev_policy_free(custom_pols);

diff --git a/Incremental.c b/Incremental.c
index 228d2bdd..95de9598 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -30,6 +30,7 @@

  #include	"mdadm.h"
  #include	"xmalloc.h"
+#include	"udev.h"

  #include	<sys/wait.h>
  #include	<dirent.h>
@@ -286,7 +287,7 @@ int Incremental(struct mddev_dev *devlist, struct 
context *c,

  		/* Couldn't find an existing array, maybe make a new one */
  		mdfd = create_mddev(match ? match->devname : NULL, name_to_use, 
trustworthy,
-				    chosen_name, 0);
+				    chosen_name, 1);

  		if (mdfd < 0)
  			goto out_unlock;
@@ -606,6 +607,7 @@ out:
  		close(mdfd);
  	if (policy)
  		dev_policy_free(policy);
+	udev_unblock();
  	sysfs_free(sra);
  	return rv;
  out_unlock:
-- 
2.31.1


