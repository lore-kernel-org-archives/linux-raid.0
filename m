Received: from shin.romanrm.net (shin.romanrm.net [146.185.199.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2DF3399A
	for <linux-raid@vger.kernel.org>; Thu,  7 Mar 2024 22:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=146.185.199.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709852307; cv=none; b=YmYmQvg7eFCX/hQjwAk3zfrUhSrYGX2WWiSWBvQPEGjhenq3wwVWNwvW/ND6zUotKaPEKI5hUICr0pzITvXw1gjEfo+TO7VklHXbQEXYVTeV6CMLu57tH+oZuFFjTke09WS3TYOlZ0gFTP20auYfQm6s5oZEzBOngTNz1T3VJ34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709852307; c=relaxed/simple;
	bh=j7hvsx5unOCtmCOYOZp7fgxW2xEnqT0z7SlP+///Aww=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QByeWZ4XtxnhD+iSQqlzZDTPVYpUWuAIII7V7Nq0TdymDa5UG+HihsfaX+5eV7ZwOumoLg7mLco2q6JXDIan1mp1yce3hmg4Tl/tw/ewZ5RoQ4gZz+YnelVxsX2P8MtJlKfhXyO7fnqIezFxGL9/Gfa/nrdKTjA1papZ8Uzkjyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net; spf=pass smtp.mailfrom=romanrm.net; arc=none smtp.client-ip=146.185.199.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=romanrm.net
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
	by shin.romanrm.net (Postfix) with SMTP id BC20B40A20;
	Thu,  7 Mar 2024 22:58:13 +0000 (UTC)
Date: Fri, 8 Mar 2024 03:58:13 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Stewart Andreason <sandreas41@gmail.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: raid1 show clean but md0 will not assemble
Message-ID: <20240308035813.22ffb052@nvm>
In-Reply-To: <f2737b90-fb63-4909-b2d9-496390d2c199@gmail.com>
References: <f2737b90-fb63-4909-b2d9-496390d2c199@gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 7 Mar 2024 14:39:17 -0800
Stewart Andreason <sandreas41@gmail.com> wrote:

> $ sudo mdadm --assemble --verbose /dev/md0 /dev/sdc1 /dev/sdd1
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 1.
> mdadm: added /dev/sdc1 to /dev/md0 as 0 (possibly out of date)
> mdadm: added /dev/sdd1 to /dev/md0 as 1
> mdadm: /dev/md0 has been started with 1 drive (out of 2).

Please include "dmesg" output that's printed after running this command.

> Where are the Last-updated timestamps? Don't they match?

See the "Event" counters, one drive indeed has less than the other. But that
shouldn't be a problem as you use a bitmap and the outdated parts should
simply resync from the other drive.

As for the actual steps, when you are in this state as in your report, I'd try:

  mdadm --re-add /dev/md0 /dev/sdc1

But to me it is puzzling why it got removed to begin with.

-- 
With respect,
Roman
