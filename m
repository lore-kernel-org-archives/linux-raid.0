Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE9C343D9D;
	Mon, 22 Jun 2026 18:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782152515; cv=none; b=DR77XsXBQ7ESDNeurxraegEKlfQI3CB014/4GffquULjlieRGvF5Q5KwgI+VRulSKG+VJY857Pkp8r1NnVRsjwlTkAc4ufQlJpSxN9dmddQrcFNc0QguOjpIcGW+Orl2dBEKroravgyPUGTpXbooYnSfis2BJZlNt131+/xQ84Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782152515; c=relaxed/simple;
	bh=stuQTfb73FufXMCRBmqvR7Yhr2IPfoOpetylBXI/zuk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=kp2oRMne25KVFmMvmvskyvMe4jnoPwSjf1gMjuXuXSgPUfa+MiPRabeyAoe14++doaOO8wo9MOsZ4lt8Z7hmjc9vZQdl3xCTL1SYexM4qH6kqMjL5FbEXRz1EJlnowSeucVM6N7AT+Q2tCgP8xawWvegitPg4zI17O3vL4mTXWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=dWiRIyxw; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=UaoS57Vd; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="dWiRIyxw";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="UaoS57Vd"
From: Nam Cao <namcao@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1782152512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=stuQTfb73FufXMCRBmqvR7Yhr2IPfoOpetylBXI/zuk=;
	b=dWiRIyxwI8KR7dJ9MZcqv+CZqAr/iVzY6YcXWP2EgGHCfZlVhDgkjkSid2olVVGv0TykzI
	UjO4kPcT9X/IkPqhjDpaxNaO0m3Bg6I7F8mI7KnYdUL6F65vX5LB0Zymo4xjqxqlHrm271
	HjxqnL00QR6q1cwjtwS5I43D9mK/S5fAVOaDFr8ENyTy8r8vtwmz7OZmRAxJaxkgHAFM1J
	hAPpFyY1GntrYV2ztmQ3W9FC5vljqRGeKL6KL1kO9/jGf77/3GNrHr8k7iLloNILDPIAXh
	+mfl3i+cu1dcIu/7UbSzjYWWnDlSUMcDcJBZZF8hxCP6DD52CGyt5O0yjjOkwQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1782152512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=stuQTfb73FufXMCRBmqvR7Yhr2IPfoOpetylBXI/zuk=;
	b=UaoS57VdjEK09E69P9jtbnj8rorCMBaPaS0lpWwBWSeFNV4E+wnqQ/uAAJj5ULc57hK+gn
	Wavmlr4hUIypabCQ==
To: Ben Dooks <ben.dooks@codethink.co.uk>, linux-raid@vger.kernel.org, Song
 Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, Paul
 Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Ben Dooks
 <ben.dooks@codethink.co.uk>
Subject: Re: [PATCH] raid6: fix raid6_recov_rvv symbol undeclared warning
In-Reply-To: <20260622135535.481534-1-ben.dooks@codethink.co.uk>
References: <20260622135535.481534-1-ben.dooks@codethink.co.uk>
Date: Mon, 22 Jun 2026 20:21:51 +0200
Message-ID: <87echyv3k0.fsf@yellow.woof>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ben Dooks <ben.dooks@codethink.co.uk> writes:
> The riscv recov_rvv.c should have included pq_arch.h for
> the definition of raid6_recov_rvv. Add the include to
> fix the following sparse warning:
>
> lib/raid/raid6/riscv/recov_rvv.c:218:32: warning: symbol 'raid6_recov_rvv' was not declared. Should it be static?
>
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>

Reviewed-by: Nam Cao <namcao@linutronix.de>
