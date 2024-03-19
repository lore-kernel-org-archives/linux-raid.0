Received: from bsmtp5.bon.at (bsmtp5.bon.at [195.3.86.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A79C7D3EA
	for <linux-raid@vger.kernel.org>; Tue, 19 Mar 2024 14:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.3.86.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710857357; cv=none; b=GlrBi7f7wxmvCM1CQrsMtRv182F74fOYrBWUT93E/YcouvS8nCs0oKMFqZag49LdQTprmpVP7ClGRAp8Vd10C0Q/vFUqMtuuQeHw8yhHCsZ+zPAensTMf5DCi6tvog0/IVT3nsVq+RhomGSrvT48SRI8M8hp+LYSGI3vzT5ming=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710857357; c=relaxed/simple;
	bh=pE+LOihPXM7VkhalqN1iWqww3beylJATmX+2GVBSHCo=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KuXt970t5MPwKb57mxYEOHmNrsrOr7bcH01aGcPZ5tEoJeoGyuLb2OMMrJWI0BPABxQtuTPeQXypTzZbYRq3gwFRrOPJWBFTIGGMOkzN5fVFQXh5BGU3+orUOkdUKKkCz494XaL5Jo2lmz+fR9k8afC++RFsQ1/4J0SDbTqmsOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=reinelt.co.at; spf=pass smtp.mailfrom=reinelt.co.at; arc=none smtp.client-ip=195.3.86.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=reinelt.co.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=reinelt.co.at
Received: from bsmtp.bon.at (unknown [192.168.181.101])
	by bsmtp5.bon.at (Postfix) with ESMTPS id 4TzYVp0D6wz5x1D
	for <linux-raid@vger.kernel.org>; Tue, 19 Mar 2024 15:09:05 +0100 (CET)
Received: from artus.reinelt.local (unknown [91.113.221.42])
	by bsmtp.bon.at (Postfix) with ESMTPSA id 4TzYVf1BCzzRnQm
	for <linux-raid@vger.kernel.org>; Tue, 19 Mar 2024 15:08:57 +0100 (CET)
Message-ID: <ae0328a65c8a8df66dee1779036a941d2efd8902.camel@reinelt.co.at>
Subject: Re: heavy IO on nearly idle RAID1
From: Michael Reinelt <michael@reinelt.co.at>
To: linux-raid@vger.kernel.org
Date: Tue, 19 Mar 2024 15:08:57 +0100
In-Reply-To: <d26f7e96192abbbebd39448afe9a45e2fdd63d21.camel@reinelt.co.at>
References: <a0b4ad1c053bd2be00a962ff769955ac6c3da6cd.camel@reinelt.co.at>
	 <abae1cb3-2ab1-d6cb-5c31-3714f81ef930@huaweicloud.com>
	 <d26f7e96192abbbebd39448afe9a45e2fdd63d21.camel@reinelt.co.at>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

I think I found at least a workaround: the strange behaviour disappears imm=
ediately, if I disable
UAS, and use usb-storage for the externel USB drive.

options usb-storage quirks=3D04e8:4001:u

I am sure that UAS has been used with kernel 6.1, too, where it did not cau=
se any issues...

Ideas what is going wrong in kernel 6.6? I'd like to re-enable UAS, because=
 UAS is about 200 MB/sec
faster than usb-storage


regards, Michael

--=20
Michael Reinelt <michael@reinelt.co.at>
Ringsiedlung 75
A-8111 Gratwein-Stra=C3=9Fengel
+43 676 3079941
