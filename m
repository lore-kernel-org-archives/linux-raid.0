Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D56343D9D;
	Mon, 22 Jun 2026 18:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782152639; cv=none; b=uDe1umdurhhA6Q/hiagooTCHVbB5thVIV7TAgdZ0FcX+WVdK6lOG6pphgcbX0q2rarOkUYzT6CfiEPEsB0ywDQ/H+8X/0z5JOrsPouxsGIEg/ay9t5mHVF2BX2gruU8gkeih5LCHv0z6MrZVPzk0QE1Q+7D5D9x4Z80SjXw3t7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782152639; c=relaxed/simple;
	bh=QS25aE7f7r24J60S69DFeF+9M8rlw/O9k82LqPNua+w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=dvPn4NahSEvxQZWci+gegZmqExSuSF3iitab59S0I8ArsC18QBI3yzPKJ0AuGMrKrf+l59fHuuno7ClvKF/RdDjWEMSGCgF4ahHIMVNki1Sk1Mr84hHLjrk6UPCMV2csQDT8g+dB7othdoThCcDuOF0I5axk265uUm0kV5/QA/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=BLhm88dC; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=j4zdh1Ry; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="BLhm88dC";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="j4zdh1Ry"
From: Nam Cao <namcao@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1782152637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QS25aE7f7r24J60S69DFeF+9M8rlw/O9k82LqPNua+w=;
	b=BLhm88dCPvbGIbFcJUPY86yIK5/2RDwFIP5VZycxgNKGcY+3G+rKee4g8zms/VkCHYMtx+
	zPYbIezwLeE9/HwpMQg5sD0JcyZrCuE17xvVnAp6Y3pFmD3NSK1ZPRPGYQxDdST39xJXpl
	ALzm0MK1qu+5NY/7LNAD1DD6Yqm1Oxj1T9NOiinCJNcgSFmUD89Glv1J2lTs4qCFQrIpJD
	AJK22TRunIqJ3ze8ggov9rm0QysTF0gxuN38OrGllRU6Ac0riWWJZcJDENXQJ2BwRn11cy
	ugXp1OQBjnwX5zywpmfYzmZT2OrRSuKnRTDG24h/jJJmjRjN6GBHS7aZ6K0svA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1782152637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QS25aE7f7r24J60S69DFeF+9M8rlw/O9k82LqPNua+w=;
	b=j4zdh1RyUH9wL1nTlY7Ptx8Qwb4ebMYMiETawSr8Z8a6EN2bNiM1Wm2fF7kNgS42dWyVl6
	dL1V61azElZu3hDA==
To: Ben Dooks <ben.dooks@codethink.co.uk>, linux-raid@vger.kernel.org, Song
 Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, Paul
 Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Ben Dooks
 <ben.dooks@codethink.co.uk>
Subject: Re: [PATCH] raid6: fix riscv symbol undeclared warnigns
In-Reply-To: <20260622135207.480540-1-ben.dooks@codethink.co.uk>
References: <20260622135207.480540-1-ben.dooks@codethink.co.uk>
Date: Mon, 22 Jun 2026 20:23:56 +0200
Message-ID: <87bjd2v3gj.fsf@yellow.woof>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ben Dooks <ben.dooks@codethink.co.uk> writes:
> The riscv rvv.c file is missing the include of pq_arch.h
> which defines all the exported functions. Include this
> to remove the following sparse warnings:
>
> lib/raid/raid6/riscv/rvv.c:1225:1: warning: symbol 'raid6_rvvx1' was not declared. Should it be static?
> lib/raid/raid6/riscv/rvv.c:1226:1: warning: symbol 'raid6_rvvx2' was not declared. Should it be static?
> lib/raid/raid6/riscv/rvv.c:1227:1: warning: symbol 'raid6_rvvx4' was not declared. Should it be static?
> lib/raid/raid6/riscv/rvv.c:1228:1: warning: symbol 'raid6_rvvx8' was not declared. Should it be static?
>
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>

Reviewed-by: Nam Cao <namcao@linutronix.de>
