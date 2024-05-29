Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1A71B960
	for <linux-raid@vger.kernel.org>; Wed, 29 May 2024 20:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717016094; cv=none; b=ZF3uWGbJxjhtogvJvaUef5wRNZb1TVYQNBcxCLD7q7FAQEszKhdd9bXZ2DIZEeui2rUQeajRKfo7RwO4uIgGfe7jJGeq2vd66a+9t00SKVD6SlYjwEvaQIBuFl5oDJxXtZC8j2rEIGA9FVxnCSOIq3yHl/wgfzG4LeQWFA0+phA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717016094; c=relaxed/simple;
	bh=hkf9ytSAUUgPF4QUvN6s/vxZYLy4Buai3GtqXk3D6Qw=;
	h=Content-Type:Message-ID:Date:MIME-Version:To:Cc:References:From:
	 In-Reply-To:Subject; b=e+s5s0+OlKJQjFR8H9ed1h67y6jOjupiOCueCgv1s3L5FkSh0MAKIHgTxP+eGacPboakcXfcYkSmrE6vatgDBBvVx1sgHIL9D25XNIBaHVv9NC4wLmpm9NDij/QVlitsRwZgIR85/yTmRVVGY02WD7gW3ih7UjM2kN9Wu5tCxnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=IDarI0hO; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="IDarI0hO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=hkf9ytSAUUgPF4QUvN6s/vxZYLy4Buai3GtqXk3D6Qw=; b=IDarI0hOIJRxWwdDMXBJ0nCH21
	3cE5+agz/5K8aAUep2G9wl0ETtsjTvpHQMS8tEM2USpcTInGLaTt7rc0gBNMuK2Yl7JZF185o/L3L
	p4hyUHDYlTf3QrfKITsTS5cgfmk3bxPspQGoRNVo8RBR+ZXe+4G0bjXIq9fba2UvbgxvXjVhtSxi5
	CXiJul1pgEmUc5hV9wc3UEl/55z2ki35fOKHmND+w4oddWGvnDmhCGJ4K/Fap2MjhLJ5NhiWGb5ir
	Jvs+lNR1g6jH4gU408Q5gCTrp1ybNNEZCLhxT2I4Ky9Cf/mC4bA3MRr2IygRp+1TypQRZX2n99LZf
	3UzQh76g==;
Received: from d205-206-125-85.abhsia.telus.net ([205.206.125.85] helo=[192.168.11.155])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <logang@deltatee.com>)
	id 1sCQJp-00BD95-0e;
	Wed, 29 May 2024 14:54:46 -0600
Content-Type: multipart/mixed; boundary="------------0bd6gQoS43vJc4cuSiVofJWl"
Message-ID: <4213b8bf-2907-48ac-b65a-6cb7b12f7a8b@deltatee.com>
Date: Wed, 29 May 2024 14:54:44 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
References: <CALTww28qp4d=mvdXvLqHPTrt0FAJihdMOQMrAyL44urstSdznQ@mail.gmail.com>
 <25ea3a8d-6331-476c-8fb4-8932185b3113@deltatee.com>
 <CALTww2-Rm=ORd0QtuWru6qz8VaTY3D-EnjJVQ48uf8gPTSG6Uw@mail.gmail.com>
 <5c0a5fdc-a86c-424d-9f8e-ee881baf82be@deltatee.com>
 <CALTww2_WnuQkMH4KeSvJNMJiiQtbP6NNA4SNt2BJPNriHcHZfQ@mail.gmail.com>
Content-Language: en-US
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <CALTww2_WnuQkMH4KeSvJNMJiiQtbP6NNA4SNt2BJPNriHcHZfQ@mail.gmail.com>
X-SA-Exim-Connect-IP: 205.206.125.85
X-SA-Exim-Rcpt-To: xni@redhat.com, linux-raid@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: mdadm/Create wait_for_zero_forks is stuck
X-SA-Exim-Version: 4.2.1 (built Wed, 06 Jul 2022 17:57:39 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)

This is a multi-part message in MIME format.
--------------0bd6gQoS43vJc4cuSiVofJWl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Xaio,

Sorry it took so long but I had a chance to dig into the bug today. It's
not what I had originally thought, but I do have a solution.

Turns out the problem is that multiple SIGCHLD signals can be coalesced
into one signal if they happen at the same time between reads to the
signalfd. This is just the way Linux works and I didn't account for it
in the code.

To fix this we, need to wait for multiple potential children being
completed after every SIGCHLD is received.

I've made two patches which you can get from:

https://github.com/lsgunth/mdadm/commits/write_zeros_sigbug/

I tested it with several hundred runs of your test script and it seems
to fix the problem. Please review and test for yourself.

On 2024-05-22 20:05, Xiao Ni wrote:
> I did a test in a simple c program.

I made a similar test program to try it out and I think the reason it
wasn't working for you was due to the coalescing and simply blocking
solves the (now only theoretical) race at startup. Once the coalescing
problem is fixed we still need to move the block earlier to fix the
race. I've attached the code for that program if you want to try it out.

Thanks for finding and triaging the bug!

Logan
--------------0bd6gQoS43vJc4cuSiVofJWl
Content-Type: text/x-csrc; charset=UTF-8; name="sigfdtest.c"
Content-Disposition: attachment; filename="sigfdtest.c"
Content-Transfer-Encoding: base64

CgojaW5jbHVkZSA8c2lnbmFsLmg+CiNpbmNsdWRlIDxzdGRpby5oPgojaW5jbHVkZSA8c3Rk
bGliLmg+CiNpbmNsdWRlIDxzeXMvc2lnbmFsZmQuaD4KI2luY2x1ZGUgPHN5cy90eXBlcy5o
PgojaW5jbHVkZSA8c3lzL3dhaXQuaD4KI2luY2x1ZGUgPHVuaXN0ZC5oPgoKCnN0YXRpYyBw
aWRfdCBkb19mb3JrKGludCBzbGVlcF9mb3IpCnsKCXBpZF90IHBpZDsKCglwaWQgPSBmb3Jr
KCk7CglpZiAocGlkICE9IDApCgkJcmV0dXJuIHBpZDsKCglzbGVlcChzbGVlcF9mb3IpOwoJ
cHJpbnRmKCJkb25lOiAlZFxuIiwgZ2V0cGlkKCkpOwoJZXhpdCgwKTsKfQoKaW50IG1haW4o
KQp7CglzdHJ1Y3Qgc2lnbmFsZmRfc2lnaW5mbyBmZHNpOwoJaW50IGksIHNmZCwgd3N0LCBy
ZXQgPSAwOwoJc2lnc2V0X3Qgc2lnc2V0OwoJcGlkX3QgcGlkOwoJc3NpemVfdCBzOwoKCXNp
Z2VtcHR5c2V0KCZzaWdzZXQpOwoJc2lnYWRkc2V0KCZzaWdzZXQsIFNJR0lOVCk7CglzaWdh
ZGRzZXQoJnNpZ3NldCwgU0lHQ0hMRCk7CglzaWdwcm9jbWFzayhTSUdfQkxPQ0ssICZzaWdz
ZXQsIE5VTEwpOwoKCWZvciAoaSA9IDA7IGkgPCA1OyBpKyspIHsKCQlwaWQgPSBkb19mb3Jr
KGkpOwoJCWlmIChwaWQgPCAwKSB7CgkJCWZwcmludGYoc3RkZXJyLCAiRXJyb3IgZm9ya2lu
ZyAlZDogJW1cbiIsIGkpOwoJCQlyZXQgPSAxOwoJCQlicmVhazsKCQl9Cgl9CgoJc2xlZXAo
Mik7CgoJc2ZkID0gc2lnbmFsZmQoLTEsICZzaWdzZXQsIDApOwoJaWYgKHNmZCA8IDApIHsK
CQlmcHJpbnRmKHN0ZGVyciwgIlVuYWJsZSB0byBjcmVhdGUgc2lnbmFsZmQ6ICVtXG4iKTsK
CQlyZXR1cm4gMTsKCX0KCgl3aGlsZSAoaSkgewoJCXMgPSByZWFkKHNmZCwgJmZkc2ksIHNp
emVvZihmZHNpKSk7CgkJaWYgKHMgIT0gc2l6ZW9mKGZkc2kpKSB7CgkJCWZwcmludGYoc3Rk
ZXJyLCAiSW52YWxpZCBzaWduYWxmZCByZWFkOiAlbVxuIik7CgkJCXJldHVybiAxOwoJCX0K
CgkJaWYgKGZkc2kuc3NpX3NpZ25vID09IFNJR0lOVCkgewoJCQlmcHJpbnRmKHN0ZGVyciwg
IkludGVycnVwdGVkXG4iKTsKCQkJcmV0ID0gMTsKCQl9IGVsc2UgaWYgKGZkc2kuc3NpX3Np
Z25vID09IFNJR0NITEQpIHsKCQkJcHJpbnRmKCJzaWdjaGxkXG4iKTsKCgkJCXdoaWxlICgx
KSB7CgkJCQlwaWQgPSB3YWl0cGlkKC0xLCAmd3N0LCBXTk9IQU5HKTsKCQkJCWlmIChwaWQg
PD0gMCkKCQkJCQlicmVhazsKCQkJCXByaW50Zigid2FpdGVkOiAlZFxuIiwgcGlkKTsKCQkJ
CWktLTsKCQkJfQoJCX0KCX0KCgljbG9zZShzZmQpOwoKCXJldHVybiByZXQ7Cn0K

--------------0bd6gQoS43vJc4cuSiVofJWl--
