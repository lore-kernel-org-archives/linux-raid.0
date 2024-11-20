Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1847189BAD;
	Wed, 20 Nov 2024 10:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732097924; cv=none; b=n+tURyU8Gn2mVPHzHyjUhSiAW0Itk1FkV/Yw2H8QUGDKFpuvnb07nYS7pkre/Fzvns49G9cwhSZn6/nZBQmeu/XCrShFtVnbfvbt2iCToi5dBiR7zik6jr8uyY+1JWc8cjAGv19aln5PGzaLhm2YklaChZMoLTB1xoO8psqJIfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732097924; c=relaxed/simple;
	bh=LkPH8U58IahTYF3y5TnmB5SV+dNexaCLUB57OTVcpgQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CDerxDIvIRN07itQV+Il6tX7tdNgF4gx9dl3ERPCrV47Ufr46dB6oj4/oZYtU+kDaeilBXzqZEk+FhXv7ASVxE08YPO3nM+EPe6iddx99u+KiEMhThZlYqDVTN29guP6QUOLT0k7JP3Y4A1qUvVBlt8UvAt3+G108M6hICsT5UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kPKWJs39; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kPKWJs39"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AK9H3ld021838;
	Wed, 20 Nov 2024 10:18:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=k2U2KD
	XYF7mJbcsjBayWTxaZc86neQ5rI++P9n882lo=; b=kPKWJs39gVFE9V44reClQH
	oiYmxB/YWc9bhBf91zvTTd9gGgpteqmDkaITzWY3I+iTiymWiuAbGyjAa7035Qyo
	gcGdXBNBszJnUlbr96p7DJhI6aJUBskhtshcHoqMGE7wlzA6S30vBAcskUCxNhPK
	NZOfVOCwmYRYYeYhFlkclcuZN5ti5M6F4EbH1593G1BjUbIYTfS1YmaBAVx4rY8e
	wQtd5/nk9MFfgGqHYV8g7nNrE4GbHenRiJALMhjiaekgT/FFFmEl5iZK4btFMXT8
	Nvhcegd/I77E00rMgIoABsuTSE1o+l1L1phmj429t1SY2lls+VTnCkhOOX0TrIKw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42xgttckq0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Nov 2024 10:18:21 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AK8Vbko031189;
	Wed, 20 Nov 2024 10:18:21 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 42y5qseeqg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Nov 2024 10:18:20 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AKAIJsY58327398
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Nov 2024 10:18:19 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3A5A12004F;
	Wed, 20 Nov 2024 10:18:19 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB91F2005A;
	Wed, 20 Nov 2024 10:18:17 +0000 (GMT)
Received: from li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com (unknown [9.109.253.82])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 20 Nov 2024 10:18:17 +0000 (GMT)
Date: Wed, 20 Nov 2024 15:48:15 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Genes Lists <lists@sapience.com>
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        linux@leemhuis.info
Subject: Re: md-raid  6.11.8 page fault oops
Message-ID: <Zz23Z3RK/AHSXY1I@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
References: <0b579808e848171fc64e04f0629e24735d034d32.camel@sapience.com>
 <34333c67f5490cda041bc0cbe4336b94271d5b49.camel@sapience.com>
 <Zzx34Mm5K42GWyKj@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
 <ef8bd4f9308dbf941076b2f7bd8a81590a09aa5e.camel@sapience.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ef8bd4f9308dbf941076b2f7bd8a81590a09aa5e.camel@sapience.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: reiykG7LFyPxA9MFJVI11BYNXOsDmKG9
X-Proofpoint-ORIG-GUID: reiykG7LFyPxA9MFJVI11BYNXOsDmKG9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=711 adultscore=0 priorityscore=1501
 bulkscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2411200070

On Tue, Nov 19, 2024 at 08:31:02AM -0500, Genes Lists wrote:
> On Tue, 2024-11-19 at 17:04 +0530, Ojaswin Mujoo wrote:
> > > 
> ...
> 
> > >  (gdb) list *(rb_first+0x13)
> > >   0xffffffff81de1af3 is in rb_first (lib/rbtree.c:473).
> > >   468       struct rb_node  *n;
> > >   469
> > >   470       n = root->rb_node;
> > >   471       if (!n)
> > >   472           return NULL;
> > >   473       while (n->rb_left)
> > 
> > Now this looks strange, we already make sure n is not NULL and then
> > somehow this line ends up in
> > 
> >  BUG: unable to handle page fault for address: 0000000000200010
> > 
> > Now, decoding the code with an x86 vmlinux, I see the fauling opcode
> > faulting:
> > 
> > Code starting with the faulting instruction
> > ===========================================
> >    0:   0f 1f 80 00 00 00 00    nopl   0x0(%rax)
> >    7:   90                      nop
> >    8:   90                      nop
> >    9:   90                      nop
> >    a:   90                      nop
> >    b:   90                      nop
> >    c:   90                      nop
> >    d:   90                      nop
> >    e:   90                      nop
> >    f:   90                      nop
> > 
> > Now RAX is 0x200000 but I don't think the nopl instruction should
> > have resulted
> > in a mem access AFA my limited understanding of x86 ISA goes.
> > 
> > I also don't see nopl in my vmlinux in rb_first, my binary being
> > compiled with
> > gcc 8.5. Are you by chance using clang or higher version or higher
> > optimization in gcc.
> > 
> > Regards,
> > ojaswin
> 
> I am using Arch toolchain with 
> 
>    gcc 14.2.1+r134+gab884fffe3fc-1
> 
> I do not set CFLAGS_KERNEL  so compile options are the default.

Got it, I'm still not sure what might be causing this oops. Would you
happen to a have a reproducer that I can play around with on my system?

Regards,
ojaswin
> 
> thanks
> 
> gene
> 
> 


