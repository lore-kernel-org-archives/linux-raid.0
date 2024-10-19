Received: from torres.zugschlus.de (torres.zugschlus.de [81.169.166.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C5D18DF6B
	for <linux-raid@vger.kernel.org>; Sat, 19 Oct 2024 20:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.169.166.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729368863; cv=none; b=HkCKAAt8IaKkSUjL/AiEfXHtxEvVbl0ZEY83gYrNytOBjaUI1XQPcH7TStFDP704plCkwvDvQ3l2fZh4hYMSTklYLlB/E0kbGIosrbq5/AVtEhMMUzIEpN18sW8rcAlUJrR/jv7T/TMO7z1oY+5IX9GjxfTzX9k+4BLZJZ6zmXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729368863; c=relaxed/simple;
	bh=DjXnHmEEBDuvaa4h4C9H5yuyHXGHWEsoDUnBHgKNfOQ=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YKGxPRNkdRyVwsrODQ7WaflAWLUDLwSQQA2MxXUQQQfZJ8+QT9wWmpVpF4tT5ewHxaLPZWFoOfQsXX69Jr/jyjrl99kD9foTctg9qHtkCUsnyOOGhrHzK+xXAPuh5XkNToo9qh1TYD4Y/fnr28OopKEGK1IasQqIDRLomFhS/LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zugschlus.de; spf=pass smtp.mailfrom=zugschlus.de; arc=none smtp.client-ip=81.169.166.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zugschlus.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zugschlus.de
Received: from mh by torres.zugschlus.de with local (Exim 4.96)
	(envelope-from <mh+linux-raid@zugschlus.de>)
	id 1t2Fq0-001iYj-2z
	for linux-raid@vger.kernel.org;
	Sat, 19 Oct 2024 22:14:12 +0200
Date: Sat, 19 Oct 2024 22:14:12 +0200
From: Marc Haber <mh+linux-raid@zugschlus.de>
To: linux-raid@vger.kernel.org
Subject: Re: Cannot update homehost of an existing array: mdadm: /dev/sda3
 has wrong name.
Message-ID: <ZxQTFA8Mwi8V5jye@torres.zugschlus.de>
References: <ZxNSmXIdVlQMWf9x@torres.zugschlus.de>
 <0e2df2b5-1215-44c3-b41a-086782c5fc37@demonlair.co.uk>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0e2df2b5-1215-44c3-b41a-086782c5fc37@demonlair.co.uk>
User-Agent: Mutt/2.2.12 (2023-09-09)

On Sat, Oct 19, 2024 at 11:03:53AM +0100, Geoff Back wrote:
> I think instead of --name=realhostname you need --homehost=realhostname
> here.

Thanks for spotting this. It has worked now.

In the rescue system, the array was then available as /dev/md/md_root.
Booting the production system, the array became
/dev/md/realhostname:md_root. mdadm --detail says
Name : realhostname:md_root  (local to host realhostname)

Is this how things are supposed to work? I had the impression that the
host name part of the array name only shows up in /dev/md/ if it DOES
NOT equal the local host name of the running system?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
