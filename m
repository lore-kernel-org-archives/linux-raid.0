Received: from mail.justnet.pl (mail.justnet.pl [78.9.185.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6B62C08A1
	for <linux-raid@vger.kernel.org>; Thu,  4 Sep 2025 08:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.9.185.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756974039; cv=none; b=pqpPf5gqx+Sc+8okNFjhIsEmiT3MhvczvnkE0XHWb7by6j+apOXfeO8LNdaehwbXi/sSEL331s5WwjU9cPAkmYLPE2e1NmjiLv+wZolTi9Pl29uk1rrAWmiNNl+lGkIrTVM4zuXTnhojJdfhejoSZsBBkHTL8NTkMpiPjOwD5Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756974039; c=relaxed/simple;
	bh=Kgh8SRV2s4NI8TysVkp0eED4PvOf4FQEtKb8pMGrIfw=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:References:
	 From:In-Reply-To; b=ERXpNi227ZFhWLDNWaVj+LtQ9QwR1knboUr8Otl2xlfHfaofkOVeFqEWSJ2nD1E7gD4nAyn3JeoEi5tB4zf9WGkGe19q+5CKqYKzewH5L/UYOwwELvZ1oftCo2olfewoGILrhkKuzGvaySZKMrCPCcTWJ7457VqeoS7OpG30mIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=justnet.pl; spf=pass smtp.mailfrom=justnet.pl; dkim=pass (2048-bit key) header.d=justnet.pl header.i=@justnet.pl header.b=E1yz1lzw; arc=none smtp.client-ip=78.9.185.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=justnet.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justnet.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justnet.pl header.i=@justnet.pl header.b="E1yz1lzw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=justnet.pl;
	s=dkim; h=In-Reply-To:From:References:To:Subject:Reply-To:MIME-Version:Date:
	Message-ID:Content-Type:Sender:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pJVF4gZ3QaYxL1DwP5DN6872cEfijPyOrxN+lXd/0tU=; b=E1yz1lzw6FA1MFJ6MTePugZKnd
	KHhIFPZpXPd0onINQHS9Qi4JLzWVQsr7NM/fCgGNut0OA66KlbtTVqmp5jJQvtfwcXWy5mc/nruGa
	9h0Z+nKulo7dMbVxtX6+J0GbSQG/nO11rjGWaarAHl1IAKxSERO1FD9taQpiTFEtqxxmv+GvLktnQ
	TGJW16TNIpB6xD4hOKzkLTV8UID/EBA4QrbbTKVQocPJi9GwKRAtjfMDS4FqAbyMY3RBZsYyM97U4
	0oSq8ufFs0WmVmO/yx7YUlVBRDV1cXYFyOdaq2p+PGxVPBrqBHUyFkL8lcllU4NFmi4MkmflnOsg1
	ALEYp2Mw==;
Received: from [78.9.185.84] (helo=[192.168.255.66])
	by mail.justnet.pl with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98)
	(envelope-from <adam.niescierowicz@justnet.pl>)
	id 1uu4bG-000000005YX-0mCX;
	Thu, 04 Sep 2025 09:41:43 +0200
Content-Type: multipart/mixed; boundary="------------DhPnpT1F0iTW6FJ45MnGPtOp"
Message-ID: <5cfd2066-7ddc-44b5-92ef-28c3a2d2c12a@justnet.pl>
Date: Thu, 4 Sep 2025 09:41:38 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Reply-To: adam.niescierowicz@justnet.pl
Subject: Re: What is the best way to set up RAID-1 on new Ubuntu install
To: Jeffery Small <jeff@cjsa.com>, linux-raid@vger.kernel.org
References: <109aahg$34jlp$1@dymaxion.cjsa2.com>
Content-Language: pl
From: Adam Niescierowicz <adam.niescierowicz@justnet.pl>
Organization: =?UTF-8?Q?Adam_Nie=C5=9Bcierowicz_JustNet?=
In-Reply-To: <109aahg$34jlp$1@dymaxion.cjsa2.com>
X-Spam-Score: -1.7
X-Spam-Level: -

This is a multi-part message in MIME format.
--------------DhPnpT1F0iTW6FJ45MnGPtOp
Content-Type: multipart/alternative;
 boundary="------------1J6pazTJJVygycA0sl2IHzWC"

--------------1J6pazTJJVygycA0sl2IHzWC
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

W dniu 3.09.2025 o 23:04, Jeffery Small pisze:
> I will be installing Xubuntu 24.04.3 on a newly built system having two
> 4TB Samsung M.2 SSDs which will be mirrored using RAID-1.  My question is
> what is the better way to set up the mirror.  I'll have 128GB of RAM and
> will be using a swapfile after installation.
>
> Method #1: After the UEFI partition is created on both disks, create GPT
>             /boot, / and /home partitions on each SSD and then create
> 	   three separate mirrors:
>
> 	   md0: /boot
>
> 	   md1: /
>
> 	   md2: /home
>
> Method #2: After the UEFI partition is created on both disks, mirror md0
> 	   using the rest of the free space.  Then create GPT partitions
> 	   directly on the mirror:
>
> 	   md0p1: /boot
>
> 	   md0p2: /
>
> 	   md0p3: /home
>
> This will be a straightforward desktop workstation, with no encryption or
> support for multiple OS installs.  Are there advantages or possible pitfalls
> with either approach?
>
> I'm also considering eliminating the boot and home partitions and just
> using a single root partition which feels strange after using UNIX for over
> 40 years. From a raid perspective does this also have advantages/pitfalls?
>
> Thanks.
> --
> Jeffery Small

What about:

sda1 and sdb1 for EFI no raid sda2 and sdb2 RAID-10 with -f2 option 
(diffrent offset that gives double speed of read and single speed of write)

md0: LVM and on top of LVM you can create partitions with XFS 
filesystem. XFS allows you to realtime grow partitons.

-- 
---
Thanks
Adam Nieścierowicz

--------------1J6pazTJJVygycA0sl2IHzWC
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <div class="moz-cite-prefix">W dniu 3.09.2025 o 23:04, Jeffery Small
      pisze:<br>
    </div>
    <blockquote type="cite"
      cite="mid:109aahg$34jlp$1@dymaxion.cjsa2.com">
      <pre wrap="" class="moz-quote-pre">I will be installing Xubuntu 24.04.3 on a newly built system having two
4TB Samsung M.2 SSDs which will be mirrored using RAID-1.  My question is
what is the better way to set up the mirror.  I'll have 128GB of RAM and
will be using a swapfile after installation.

Method #1: After the UEFI partition is created on both disks, create GPT
           /boot, / and /home partitions on each SSD and then create
	   three separate mirrors:

	   md0: /boot

	   md1: /

	   md2: /home

Method #2: After the UEFI partition is created on both disks, mirror md0
	   using the rest of the free space.  Then create GPT partitions
	   directly on the mirror:

	   md0p1: /boot

	   md0p2: /

	   md0p3: /home

This will be a straightforward desktop workstation, with no encryption or
support for multiple OS installs.  Are there advantages or possible pitfalls
with either approach?

I'm also considering eliminating the boot and home partitions and just
using a single root partition which feels strange after using UNIX for over
40 years. From a raid perspective does this also have advantages/pitfalls?

Thanks.
--
Jeffery Small
</pre>
    </blockquote>
    <p><span style="white-space: pre-wrap">What about:</span></p>
    <p><span style="white-space: pre-wrap">sda1 and sdb1 for EFI no raid
sda2 and sdb2 RAID-10 with -f2 option (diffrent offset that gives double speed of read and single speed of write)</span></p>
    <p><span style="white-space: pre-wrap">md0: LVM and on top of LVM you can create partitions with XFS filesystem.
XFS allows you to realtime grow partitons.</span></p>
    <p><span style="white-space: pre-wrap">
</span></p>
    <p><span style="white-space: pre-wrap">
</span></p>
    <pre class="moz-signature" cols="72">-- 
---
Thanks
Adam Nieścierowicz</pre>
  </body>
</html>

--------------1J6pazTJJVygycA0sl2IHzWC--
--------------DhPnpT1F0iTW6FJ45MnGPtOp
Content-Type: text/vcard; charset=UTF-8; name="adam_niescierowicz.vcf"
Content-Disposition: attachment; filename="adam_niescierowicz.vcf"
Content-Transfer-Encoding: base64

YmVnaW46dmNhcmQNCmZuO3F1b3RlZC1wcmludGFibGU6QWRhbSBOaWU9QzU9OUJjaWVyb3dp
Y3oNCm47cXVvdGVkLXByaW50YWJsZTpOaWU9QzU9OUJjaWVyb3dpY3o7QWRhbQ0KZW1haWw7
aW50ZXJuZXQ6YWRhbS5uaWVzY2llcm93aWN6QGp1c3RuZXQucGwNCngtbW96aWxsYS1odG1s
OlRSVUUNCnZlcnNpb246Mi4xDQplbmQ6dmNhcmQNCg0K

--------------DhPnpT1F0iTW6FJ45MnGPtOp--
