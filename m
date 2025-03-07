Received: from nt.romanrm.net (nt.romanrm.net [185.213.174.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A2E19DF53
	for <linux-raid@vger.kernel.org>; Fri,  7 Mar 2025 20:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.213.174.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741380446; cv=none; b=m31V1rFXpa4DZaDPN0ZreRGHB3EdgsUrcMrZA/0SZNVoz16NtiN362ks0rJY8g3pilYB1jTPAlm+fy7xWJzGuJoVh4jTfC4/x6fItSgpy7pSdQLacfr4M2bnROg1p51G9PGhIT+2Aw+elKbj3emChkzz3kvPfVP1F8oHbKQq1rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741380446; c=relaxed/simple;
	bh=l/KxW8DM5zUxiS1NTIvmKBXnFRw3HvRG8sEXpgIcQNk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=quRE7DmWcDszsEbU2aWh5Q+oP0CV91Zl0PITBUlwcqWlyO4uC/fw3aiNbPzEdHb4IXxM68Q3hP4hTJklhiYuTsinMFMxpVdy/odCAxVZyY5L10jBNPP5DSZiy2rKgl+9EC7Cout4g7vRPaqWcUST99fbOtt7PsPKvCORLSDcjuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net; spf=pass smtp.mailfrom=romanrm.net; arc=none smtp.client-ip=185.213.174.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=romanrm.net
Received: from nvm (umi.2.romanrm.net [IPv6:fd39:a37d:999f:7e35:7900:fcd:12a3:6181])
	by nt.romanrm.net (Postfix) with SMTP id 423C540F47;
	Fri,  7 Mar 2025 20:47:19 +0000 (UTC)
Date: Sat, 8 Mar 2025 01:47:18 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Roger Heflin <rogerheflin@gmail.com>
Cc: David Hajes <d.hajes29a@pm.me>, "linux-raid@vger.kernel.org"
 <linux-raid@vger.kernel.org>
Subject: Re: RAID 5, 10 modern post 2020 drives, slow speeds
Message-ID: <20250308014718.24418feb@nvm>
In-Reply-To: <CAAMCDefMK6PD7+BpfQ9e2WGjdsk_hQaoGOAYmQ2_Rtn5o7nGrQ@mail.gmail.com>
References: <lMRgP8wc-P3iUlmbrsOKyuXM834ndQZZUThbeEUIO0WoNKKMQLd-T5P6QrFMEYiYAoQUAWkFGaggDTMSzZFw9KzBagunLy1mRNDk2TljKUM=@pm.me>
	<20250307234753.473dc4b5@nvm>
	<wbKuA1vBv5kD_KeuudRU95HVHtIXiMs9hvH40_jlVcKTvwOR_4vszdQADWASxjhfBXFS2JkNpQnCnrdaoiombOE6Tof66ktqnXyRnwQXw7o=@pm.me>
	<CAAMCDefMK6PD7+BpfQ9e2WGjdsk_hQaoGOAYmQ2_Rtn5o7nGrQ@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 7 Mar 2025 14:42:24 -0600
Roger Heflin <rogerheflin@gmail.com> wrote:

> I put an external bitmap on a raid1 SSD and that seemed to speed up my
> writes.  I am not sure if external bitmaps will continue to be
> supported as I have seen notes that I don't exactly understand for
> external bitmaps, and I have to reapply the external bitmap on each
> reboot for my arrays which has some data loss risks in a crash case
> with a dirty bitmap.
> 
> This is the command I used to set it up.
> mdadm --grow --force --bitmap=/mdraid-bitmaps/md15-bitmap.img /dev/md15

In this case the result cited seems to have shown the bitmap is not the issue.

I remember seeing patches or talks to remove external bitmap support, too.

In my experience the internal bitmap with a large enough chunk size does not
slow down the write speed that much. Try a chunk size of 256M. Not sure how
high it's worth going before the benefits diminish.

-- 
With respect,
Roman
