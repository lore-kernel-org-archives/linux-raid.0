Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC7820CCE6
	for <linux-raid@vger.kernel.org>; Mon,  3 Mar 2025 14:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741011432; cv=none; b=WQDQ56p5CpZiuqxUDzV7mUqFbhGMvrK53S7TrCtKGecFXbiLJpH19Iru9f+p8zFu5FL1MkD9Nz2cSOGHUXcoC4GAyohROw/btYk4k2d+782Wh8r3AzI+TNSK2FI/aVAdsE+dXNSQ3pOghOwBXDB6AIYtGTVqCx8oThLEWNhbMzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741011432; c=relaxed/simple;
	bh=nLUbDz0e+CgsrliUs4cYiRJnSG/62DlE0viJtUQ1Td4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R+ZPg4e1+ayfINdPSyjvDPieBJwJ9QdRshLuErwwnlWdFs0gpztT8qKxmKzYEr1/QHLtbKNHQBZlSZEPLafoP2HG7RS70SrOAg9AI5ZdPoEZuSzfktSSa1mvOmJiUDyV+Bs8JF/hbaMW1ctohWAb+3PSZeWQYqUedK556rQCnp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: from mtkaczyk-private-dev (unknown [31.7.42.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPSA id DF72BC4CED6;
	Mon,  3 Mar 2025 14:17:09 +0000 (UTC)
Date: Mon, 3 Mar 2025 15:17:05 +0100
From: Mariusz Tkaczyk <mtkaczyk@kernel.org>
To: Blazej Kucman <blazej.kucman@linux.intel.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>, Xiao Ni <xni@redhat.com>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 "ncroxon@redhat.com" <ncroxon@redhat.com>, "song@kernel.org"
 <song@kernel.org>, "yukuai@kernel.org" <yukuai@kernel.org>
Subject: Re: [PATCH V2] mdmon: imsm: fix metadata corruption when managing
 new array
Message-ID: <20250303151705.30b17149@mtkaczyk-private-dev>
In-Reply-To: <20250303121535.00006fd8@linux.intel.com>
References: <20250218184831.19694-1-junxiao.bi@oracle.com>
	<20250224141541.000042f1@linux.intel.com>
	<CALTww2-DSfGAO-f2Porbu3+vrhNGcAd=SsP7h+wciw60v12JAA@mail.gmail.com>
	<20250228103807.000028e7@linux.intel.com>
	<6DAD41A3-A511-46C7-9361-A9D975A69991@oracle.com>
	<20250303121535.00006fd8@linux.intel.com>
Organization: Linux development
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.43; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 3 Mar 2025 12:15:35 +0100
Blazej Kucman <blazej.kucman@linux.intel.com> wrote:

> Hi, 
> I corrected it in PR.
> 

Thanks Blazej for handling it, merged.

Mariusz
