Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793178840;
	b=VajHkKk2fjPLYNj4SjQG0JmyPAkrby83vTQqpz2CswlcMzCK/9FkE6vOC/D7Est+GPKq
	 yGxT/2bMx51P80B15/2zRW1Fn/FKnB2AnTfyLv5DLWffzHAYWbbwclNIdTQlzWnV0MvtA
	 zn2lskhE4cQf+sMzmdhNQTufBW5IcRlrnCeu3QzOK1Vjrpm3aABLLltZ6HzJ1TkeD35Ku
	 /HJilE9NlDOuO9ZQrHOh9bsimU7Ll+WRBdj4a9nLBCtEhiuxf708VmAywaJAiEA6+uNJX
	 9hsYzqXwaYx9rfpr/6IllW2zMFBY/JwKnfH5+4JLKJXjptaBZ2yMoXKhL/gOu4F5xQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793178840;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:Organization:X-Mailer:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=3xrgxneouFwtOs11/XMOG8refXLuhdXbWO3nsZfe/0o=;
	b=YLgdk7UpmaqvL0Mhu0iZE+NXacpjOLKfucwzEMGfB6h4Uy9Eh7EwqqApJGscBq2gvXoy
	 RbIW141WWkgSzszfCAH6FJcX4dNrpePr5f8ojXGrIqYeCnCO4Ep73QjhujHvTk9unPu8r
	 Trj9QC2BuwD5cRS5fQpCKcY3wSmAQDmPEiawcjfP+LHxZSEvZTFFBxGfsTBcgsyEvXdEe
	 mcZNr8101ieA2yoGqhkUboxB+ZAHoFHusU2AU+BNN5uZzMylhr7fE3+u3UuYJnMWXqkgF
	 kuuxvJG4nARgMUVN/KpwD6ndOi/Y3qig8dTcGIQ4iSo+Th4FAvE4CZi4phvecLHIYqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hfq41xx9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD07D606A31A;
	Wed, 28 Oct 2026 09:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hfq41xx9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524C91F01829;
	Wed, 28 Oct 2026 09:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793178839;
	bh=3xrgxneouFwtOs11/XMOG8refXLuhdXbWO3nsZfe/0o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Hfq41xx99QV6H2SzL4rtHsY8+5Na4ghifwatVT4Zgvp7TtKioqtHMuI/GlXYlWc15
	 1Iu4OT/nDhBGvsHsGaNNNEgXofgMRoJZGmbWReulW2g1Tc48bHY59G+8R9Zm59llnt
	 pEMSI3oIjh2EQ7jVjz8zraQVO+obN0rtKP11FEJ48RBehGHt3aF6oVRn1D7MAthtq3
	 wqAYxoNQs+JFSFF/Y3f3zQ30fvZHnNU5eq2QevKmP39L83DDLpeqUCHv8v6MFi7dey
	 3nd51m3T7VpFCe+zhM3eFFtoQeYkUGm3nzDNzbxx3rZzj6ThWZXKuCqKZHDwdjlD/h
	 hjJmA8wDBZQHw==
Date: Wed, 28 Oct 2026 10:13:52 +0100
From: Mariusz Tkaczyk <mtkaczyk@kernel.org>
To: "Masalkhi, Abd Alrhman" <abd.masalkhi@gatech.edu>
Cc: "song@kernel.org" <song@kernel.org>, "yukuai@fygo.io" <yukuai@fygo.io>,
 "chengzhihao1@huawei.com" <chengzhihao1@huawei.com>,
 "magiclinan@didiglobal.com" <magiclinan@didiglobal.com>, "xiao@kernel.org"
 <xiao@kernel.org>, "abd.masalkhi@gmail.com" <abd.masalkhi@gmail.com>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v4 0/4] md: add a control device for array
 management
Message-ID: <20261028101352.272d7d37@kernel.org>
In-Reply-To: <20261015204640.1184848-1-abd.masalkhi@gatech.edu>
References: <20261015204640.1184848-1-abd.masalkhi@gatech.edu>
Organization: Linux Development
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.50; x86_64-suse-linux-gnu)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Oct 2026 20:47:51 +0000
"Masalkhi, Abd Alrhman" <abd.masalkhi@gatech.edu> wrote:

> A warning is emitted when it is used to recommend upgrading mdadm to
> use the new control interface.


Definitely you should not refer to mdadm from kernel context, user can
send ioctls from the own applications which would be misleading.

Mariusz
