Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439A0256C79
	for <linux-raid@vger.kernel.org>; Wed,  4 Jun 2025 12:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749040459; cv=none; b=b2MX/wrVhHp6A5Yhn8uji9Zugw1cGtshHH8aCXvkRarRtSyH+uCDOvlF8WPURDHeKEj0jK0zlA6y5VxgAQ69rS1uFMK9l0YxOJGiooWBkbVd+GxEyvovlWBbHaCz0ZsaD7yiBeTfeAnmvh9k0Fz6iYoEfvCBp9THq1nihXJYTCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749040459; c=relaxed/simple;
	bh=VebfN2XBteKzBqUMT18SDeeL0Q3wfkpQGzbwbsPkLAA=;
	h=MIME-Version:Content-Type:Message-ID:Date:From:To:Cc:Subject:
	 In-Reply-To:References; b=Qve25VwmHDGwzuG9GvR81opWJKQr8DuJ+0ALEZtlxyFMNu+mAjbZTDpg5FDzboHQZ62bzFX4581ahbJnv/oO1m3c0CtTmAvBv5JNPo9DJwC6P7Pq01kOaZalz8uGcOja1Yq6YbG6tCYJpVdx0MWnOZ6SR2sYc4lxnr7aw4rtHdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org; spf=pass smtp.mailfrom=stoffel.org; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Received: from quad.stoffel.org (syn-097-095-183-072.res.spectrum.com [97.95.183.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 52F4D1E38B;
	Wed,  4 Jun 2025 08:24:30 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id 6B1E8A103F; Wed,  4 Jun 2025 08:24:29 -0400 (EDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <26688.15101.386901.684@quad.stoffel.home>
Date: Wed, 4 Jun 2025 08:24:29 -0400
From: "John Stoffel" <john@stoffel.org>
To: Reindl Harald <h.reindl@thelounge.net>
Cc: Linux RAID <linux-raid@vger.kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Subject: Re: Need help increasing raid scan efficiency.
In-Reply-To: <e6252171-45b5-4739-b2b7-683c1464de2d@thelounge.net>
References: <20250602210514.7acd5325@Zen-II-x12.niklas.com>
	<e6252171-45b5-4739-b2b7-683c1464de2d@thelounge.net>
X-Mailer: VM 8.3.x under 28.2 (x86_64-pc-linux-gnu)

>>>>> "Reindl" == Reindl Harald <h.reindl@thelounge.net> writes:

> Am 03.06.25 um 03:05 schrieb David Niklas:
>> My PC suffered a rather nasty case of HW failure recently where the MB
>> would break the CPU and RAM. I ended up with different data on different
>> members of my RAID6 array.
>> 
>> I wanted to scan through the drives and take some checksums of various
>> files in an attempt to ascertain which drives took the most data
>> corruption damage, to try and find the date that the damage started
>> occurring (as it was unclear when exactly this began), and to try and
>> rescue some of the data off of the good pairs.

> forget it and restore a backup

Or if your data is static, use last years backup and look for
un-changed files and them compare the data inside them?  

but yes, using a better backup system is a good idea.  I'm using
'burp' for my home backups.  And big disks are cheap.  How much is
your data worth to you?  

