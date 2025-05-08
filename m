Received: from nt.romanrm.net (nt.romanrm.net [185.213.174.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFD820E314
	for <linux-raid@vger.kernel.org>; Thu,  8 May 2025 06:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.213.174.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746686202; cv=none; b=lqMdq7VHz32BNsxCyPZaFF2NPI+LCwY/iyV2NUWosSiDNR1THhXGlEUoFdlEVI48tl13kkeKwriOb5txNagfXFeebVk4Q3TxRA2XN0c1/YsPtUgwcOTCi/be1rIACRGGmw6h7tE9AvMddusBsJs5blvnJV54aFvmYxLTwvoNWGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746686202; c=relaxed/simple;
	bh=Z46LjYv2mgZ/hncZvSUao2fZKGoSF/++l/rotGMWW6o=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pFKVemo38X+/DE0naVBu+DXyb2BP3/J3kROwjNmsVVa7itJ3OVfAbVKHDCCO+u0uWDnxU58vMnoSEy1HZaCWOf68VgOwt+5BnrIYzLcA+4vbZuix72J8TTEiSV1U5GBBpNArQ6iyKNKDd8HYkqtJGndWN9++aXQa4MZI9CEH01w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net; spf=pass smtp.mailfrom=romanrm.net; arc=none smtp.client-ip=185.213.174.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=romanrm.net
Received: from nvm (umi.2.romanrm.net [IPv6:fd39:a37d:999f:7e35:7900:fcd:12a3:6181])
	by nt.romanrm.net (Postfix) with SMTP id 4188B40EFC;
	Thu,  8 May 2025 06:27:02 +0000 (UTC)
Date: Thu, 8 May 2025 11:27:01 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Daniel Buschke <damage@devloop.de>
Cc: linux-raid@vger.kernel.org
Subject: Re: add fails: nvme1n1p2 does not have a valid v1.2 superblock, not
 importing
Message-ID: <20250508112701.5a203e9a@nvm>
In-Reply-To: <5e5df22d-ecd4-40fc-84dc-9508e28a6aae@devloop.de>
References: <5e5df22d-ecd4-40fc-84dc-9508e28a6aae@devloop.de>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 6 May 2025 12:25:13 +0200
Daniel Buschke <damage@devloop.de> wrote:

> 1. What exactly does this error message mean? I think replacing a failed 
> drive with a new one is what RAID is for? So this shouldn't be an issue 
> at all?
> 
> 2. During my search I got the feeling that the problem is that the 
> failed drive is somehow still "present" in the raid. Thus the add is 
> handled as a "re add" which fails because there is no md superblock on 
> the new device. Is my conclusion correct?
> 
> 3. If 2. is correct how do I remove the failed but not really present 
> device? Commands like "mdadm ... --remove failed" did not help.
> 
> 4. I already replaced old devices in this RAID successfully before. What 
> may have changed that this issue happens?

I agree that it is a weird error to get in this situation. "man mdadm" gives
something to try:

       --add-spare
              Add  a  device as a spare.  This is similar to --add except that
              it does not attempt --re-add first.  The device will be added as
              a  spare  even  if it looks like it could be an recent member of
              the array.

Another idea (from the same man page) would be "mdadm ... --fail detached".

-- 
With respect,
Roman
