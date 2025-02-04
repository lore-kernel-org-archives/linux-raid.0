Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883A720C02B;
	Tue,  4 Feb 2025 11:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738669117; cv=none; b=Vq59riFv3ovrsdBCir4IsnJguPb7YK9ni83/vEvgOMhhoEUU8GGOJNimx7atEFyuGdrCBAoth7kclJJ+OO83GqzF8Mk0cHjbAn8TQdRuKDSSb9BbGccdq+KBHrPJLhQ/iGHGdSl7r3TOr+DkxMF1DWMqxASqVY/MNKfKOj/nmdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738669117; c=relaxed/simple;
	bh=hAXierDHuy2wmPN6zYzpw48/5UbAyf0T0pv7aKUG6Fw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OTw6AVVb1fwO/+W3IMDAz4BamIttw1eUTdAOk1ign8kHsM1sZtEFYGvJYsyNhhSHwzHpOkBnUHu52oHn6Z3oakxjQfBzPPh+NpDx+LLxkeO139xTJGIh1zq3wKMTVTrVRe34hAohPmE2OL9hBIP3ZgtoSb8QH4dV0x71F4Mur8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oscbxZSu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oscbxZSu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88FFC4CEDF;
	Tue,  4 Feb 2025 11:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738669117;
	bh=hAXierDHuy2wmPN6zYzpw48/5UbAyf0T0pv7aKUG6Fw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oscbxZSuVTVz/zRekvTyBNFBg5lsJwKyVslgvNZkrRYg5UfcFWGYR9MWcKQCvCpRg
	 D86qxSkutTc1X8X6+HEKl+i/ZT8yD7dy0nYOT299viQXoZvDWAzbhmmFjfqw/TFMZA
	 t6Lphu2Ku+uRCp8i1ZCTuJl8WVmpCfdXO1wphjvs=
Date: Tue, 4 Feb 2025 12:38:34 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: stable@vger.kernel.org, song@kernel.org, yukuai3@huawei.com,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 6.6 2/6] md/md-bitmap: factor behind write counters out
 from bitmap_{start/end}write()
Message-ID: <2025020415-commend-battalion-3af7@gregkh>
References: <20250127085351.3198083-1-yukuai1@huaweicloud.com>
 <20250127085351.3198083-3-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250127085351.3198083-3-yukuai1@huaweicloud.com>

On Mon, Jan 27, 2025 at 04:53:47PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> commit 08c50142a128dcb2d7060aa3b4c5db8837f7a46a upstream.
> 
> behind_write is only used in raid1, prepare to refactor
> bitmap_{start/end}write(), there are no functional changes.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> Reviewed-by: Xiao Ni <xni@redhat.com>
> Link: https://lore.kernel.org/r/20250109015145.158868-2-yukuai1@huaweicloud.com
> Signed-off-by: Song Liu <song@kernel.org>

This is much different from the original commit, please document your
changes here somewhere.

thanks,

greg k-h
