Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE99B269B1C;
	Tue, 25 Nov 2025 09:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764062805; cv=none; b=K15RYniSyejqO9hfi+YEddhOFsv48WZ9H4kcZsVBtLAHftaqR1ltGnuFIkmXLycrwyB/cRmWyvI1sO5tRwO6+fCNBdKbZB5OnLyuXXPZhO3euj4dPmWye6+pSeWOvw/qUnxfS+s7Fe2req+xN2pQVtv4Qan+gBNqfqoNdFQovbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764062805; c=relaxed/simple;
	bh=ErOM444bOXMh61rVrobY83T6XHQyhnCIIqDGmHNaO+I=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Uq8bOmIVkBeIuxPoj0gA38rs6oI8UKqPN52UKjXtL8qu1pafZcqnmG15r/AF34SXI3Jmun8Gi/O94pBAbc47DxOpOxsWGknaf4j9j/Tjfnhr+JB+MXYZ96rzs+DmY5yk0ELOC35LP06ogl+kU0jaq1cdYRlqkBI2YS9T6D7arjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Di2nBLOS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Di2nBLOS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B145C4CEF1;
	Tue, 25 Nov 2025 09:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764062805;
	bh=ErOM444bOXMh61rVrobY83T6XHQyhnCIIqDGmHNaO+I=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=Di2nBLOSNMYX6/HckJXKqSEkHKif8fCu581MJdcRl+4veXlIsc/3xu6iRJGs+hpKl
	 V6+bg9GgXqXVsUUcgkHeUK+pgDF6yBX61eckxujcWVQypJbtq5l2t3O4QztdVBPkdD
	 CpPQ8f0JLhU0yzVeggD9iM4gBiA70aJN0C8o0VSgI3cR6AJVrP9BpuQimskeTzAJpq
	 Y46OB2fvCIHwiQ283v5+MaIhIAepLBh7gn7Y7vyQC5YEDvvEt/mNidsUpu7TOdv/IM
	 ZG8UgXssLmyrsV2Mvgktxd7uFea9k2K3GGUE6/WuWpheswv549N/WDWQkWyqMkCffG
	 Vccy3I6xp8ldA==
Date: Tue, 25 Nov 2025 02:26:42 -0700 (MST)
From: Paul Walmsley <pjw@kernel.org>
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
cc: Paul Walmsley <paul.walmsley@sifive.com>, 
    Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
    Alexandre Ghiti <alex@ghiti.fr>, Charlie Jenkins <charlie@rivosinc.com>, 
    Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, 
    linux-riscv@lists.infradead.org, linux-raid@vger.kernel.org, 
    linux-kernel@vger.kernel.org, Chunyan Zhang <zhang.lyra@gmail.com>
Subject: Re: [PATCH V3 3/5] raid6: riscv: Prevent compiler with vector support
 to build already vectorized code
In-Reply-To: <20250718072711.3865118-4-zhangchunyan@iscas.ac.cn>
Message-ID: <6c2a11f4-27ac-1389-23a6-5f5bcf1c5048@kernel.org>
References: <20250718072711.3865118-1-zhangchunyan@iscas.ac.cn> <20250718072711.3865118-4-zhangchunyan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi,

On Fri, 18 Jul 2025, Chunyan Zhang wrote:

> To avoid the inline assembly code to break what the compiler could have
> vectorized, this code must be built without compiler support for vector.
> 
> Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>

This one has been queued with a somewhat modified commit message to 
reflect what I thought the intention is.  But I might be wrong.  Can you 
check it, please?

thanks,


- Paul

From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Date: Mon, 17 Nov 2025 21:19:24 -0700

raid6: riscv: Prevent compiler from breaking inline vector assembly code

To prevent the compiler from breaking the inline vector assembly code,
this code must be built without compiler support for vector.

Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Link: https://patch.msgid.link/20250718072711.3865118-4-zhangchunyan@iscas.ac.cn
[pjw@kernel.org: cleaned up commit message]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
---
 lib/raid6/rvv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/raid6/rvv.c b/lib/raid6/rvv.c
index 89da5fc247aa..015f3ee4da25 100644
--- a/lib/raid6/rvv.c
+++ b/lib/raid6/rvv.c
@@ -20,6 +20,10 @@ static int rvv_has_vector(void)
 	return has_vector();
 }
 
+#ifdef __riscv_vector
+#error "This code must be built without compiler support for vector"
+#endif
+
 static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
 {
 	u8 **dptr = (u8 **)ptrs;
-- 
2.48.1

