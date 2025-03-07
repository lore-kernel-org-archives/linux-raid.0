Received: from nt.romanrm.net (nt.romanrm.net [185.213.174.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CD619DF4A
	for <linux-raid@vger.kernel.org>; Fri,  7 Mar 2025 18:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.213.174.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741373612; cv=none; b=NO2Eqh++hR7xov7FAP8qXr9QkKk/oEHuiCpLL60WkHDKXQvnBbmry3Fk8doNCIX32oIyql/YdTBLrlYOzq/vF6DR9vXxkhRe8IvBivpMyXNTLPkf28Crv4eF2ifnEZa+WG1Md6TGaFjM4Q29wjKSRV1iNBdSYLfMym8HFA8VfH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741373612; c=relaxed/simple;
	bh=S+ecp6mdXGR5qokNi1TfYuXmFFji97QCnT7vvVc1P/0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ML16rI8p1pV5z9TaVZVuvcGjv4qAd02eYY7xnTLENjUCwkQQ6WH5VXyXFcc7RNK5ai2sBPA1cXo6MZ7fB3+6swk+RS8/F6fD4d4CfE5tPz04gaXZdBtB4JYyUs1vkz3dGNfbpFJcpPPnOpPoeo+Wbu7ND+yaBYK9msuvqzih91M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net; spf=pass smtp.mailfrom=romanrm.net; arc=none smtp.client-ip=185.213.174.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=romanrm.net
Received: from nvm (umi.2.romanrm.net [IPv6:fd39:a37d:999f:7e35:7900:fcd:12a3:6181])
	by nt.romanrm.net (Postfix) with SMTP id 25B1740F47;
	Fri,  7 Mar 2025 18:47:54 +0000 (UTC)
Date: Fri, 7 Mar 2025 23:47:53 +0500
From: Roman Mamedov <rm@romanrm.net>
To: David Hajes <d.hajes29a@pm.me>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: RAID 5, 10 modern post 2020 drives, slow speeds
Message-ID: <20250307234753.473dc4b5@nvm>
In-Reply-To: <lMRgP8wc-P3iUlmbrsOKyuXM834ndQZZUThbeEUIO0WoNKKMQLd-T5P6QrFMEYiYAoQUAWkFGaggDTMSzZFw9KzBagunLy1mRNDk2TljKUM=@pm.me>
References: <lMRgP8wc-P3iUlmbrsOKyuXM834ndQZZUThbeEUIO0WoNKKMQLd-T5P6QrFMEYiYAoQUAWkFGaggDTMSzZFw9KzBagunLy1mRNDk2TljKUM=@pm.me>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hello,

On Fri, 07 Mar 2025 18:36:13 +0000
David Hajes <d.hajes29a@pm.me> wrote:

> I have issues with RAID5 running on post-2020 14TB drives.
> 
> I am getting max writting speeds of 220MBs.

What about read speeds, do you get much more, or clamped in the same ballpark?

To not wait for a full resync just to check this (or various other settings),
you can create the array with --assume-clean.

In case reads are also limited to the same value, I'd suspect PCIe bandwidth
issues, such as the HBA getting choked by 2.5 GT/s x1 for whatever reason.
Check the bandwidth in "lspci -vvv".

> I have played with chunk size...default 512k-2MBs...no difference
> 
> "Read-ahead" set for md0 virtual disk
> 
> NCQ disabled - set 1 for all physical drives
> 
> I have basically tried every suggestion on famous ArchWiki.

Do you use the Write-Intent bitmap, and what is its chunk size?
Try without one briefly, to see if this was the issue.
For production use, increase the bitmap chunk size and see if that helps.

> Initial resync drops to 130MBs

Are your drives SMR or CMR? For SMR drives it is common to briefly write
quickly and then slow down as they need to do their housekeeping during the
same time as new writes. SMR are not recommended for RAID.

> Is it possible this weird issue is linked to HDD timeout described there >>> https://archive.kernel.org/oldwiki/raid.wiki.kernel.org/index.php/Timeout_Mismatch.html

No.

-- 
With respect,
Roman
