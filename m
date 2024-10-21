Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE4A1EEE0
	for <linux-raid@vger.kernel.org>; Mon, 21 Oct 2024 06:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729493500; cv=none; b=jedMFD+DQmRWlRLyo9c1nrrDWkQ1kkLDIAXo4mF7NpZs8W3YxSnI5yB+ETUK5YK6Tvo0WM7EWH7OjwCXjkj+Z8PY6Sf8Z1ZyEUUY17cg0jqmXWEcsv/irhkNqOr9M0ovqnA8DKT0fJYg5tas009Z0gMYa4QUy1w544ahszUfHXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729493500; c=relaxed/simple;
	bh=1hZAZmjb/eZ12UboUTM2gPQksVw3IiiyTmDHCiJW/do=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e8lHaUtgq6kd8cCJAxIh/woDZz42btTanQHuzggAFescX3aAcw+N+x3PDPs3LjSvUGMXFqwMObHbs3KCIG+NRXHlXGcnHpOtZHKXfuL5T/6Zka+aQz0HIId7At6DnCd69Li1kNgTm1NRE58E1a+tXxv6PDW6aMC/LoKSfzKMptk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DJL84PfH; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DJL84PfH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729493498; x=1761029498;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1hZAZmjb/eZ12UboUTM2gPQksVw3IiiyTmDHCiJW/do=;
  b=DJL84PfH5rHXMGDTmcXTZ6oS4jSWq3BdrRH9DjU+kC0h/WUc4spwlr0A
   TA8IkKYFZgvkp2lZz5cJRowC/mUSOBl/TvwyXJER8KyXCpIkHLJLxK5wu
   6vkEfaOn68rIEreSeoxEqsjbdrmyeGV29YdzLpmXJ9JWp9bi/+HHSpCvF
   YuIZEdrjQoQW3WcZn1UjYEGarhnyZQ1C38Cv1PlcUgSNdZXbgTsDCdrkc
   tAnsvouYT3J7yHev4zgj8Pu87EmHL1zGEcW6IMmiyRvZyx9IBYWezamw/
   9/UEYv9fjdDu+a09YHELozycd446a94JZmQw/gmz6KE/YMGf34j2XXx1Z
   Q==;
X-CSE-ConnectionGUID: tko/Q0xNS3y1ci5bN6XmHw==
X-CSE-MsgGUID: nxVDCR+6RDipDBNUDT1opw==
X-IronPort-AV: E=McAfee;i="6700,10204,11231"; a="29080884"
X-IronPort-AV: E=Sophos;i="6.11,220,1725346800"; 
   d="scan'208";a="29080884"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2024 23:51:37 -0700
X-CSE-ConnectionGUID: GY9IiNBYTBeB93BNz7MFkA==
X-CSE-MsgGUID: 552t33y0T6qAjEyRB28yow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,220,1725346800"; 
   d="scan'208";a="79081327"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.20.233])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2024 23:51:36 -0700
Date: Mon, 21 Oct 2024 08:51:32 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Marc Haber <mh+linux-raid@zugschlus.de>
Cc: linux-raid@vger.kernel.org
Subject: Re: Cannot update homehost of an existing array: mdadm: /dev/sda3
 has wrong name.
Message-ID: <20241021085132.00000cad@linux.intel.com>
In-Reply-To: <ZxQTFA8Mwi8V5jye@torres.zugschlus.de>
References: <ZxNSmXIdVlQMWf9x@torres.zugschlus.de>
	<0e2df2b5-1215-44c3-b41a-086782c5fc37@demonlair.co.uk>
	<ZxQTFA8Mwi8V5jye@torres.zugschlus.de>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 19 Oct 2024 22:14:12 +0200
Marc Haber <mh+linux-raid@zugschlus.de> wrote:

> On Sat, Oct 19, 2024 at 11:03:53AM +0100, Geoff Back wrote:
> > I think instead of --name=realhostname you need --homehost=realhostname
> > here.  
> 
> Thanks for spotting this. It has worked now.
> 
> In the rescue system, the array was then available as /dev/md/md_root.
> Booting the production system, the array became
> /dev/md/realhostname:md_root. mdadm --detail says
> Name : realhostname:md_root  (local to host realhostname)
> 
> Is this how things are supposed to work? I had the impression that the
> host name part of the array name only shows up in /dev/md/ if it DOES
> NOT equal the local host name of the running system?
> 
> Greetings
> Marc
> 

I'm looking into Incremental right now and there is a comment:

	 * 3/ Check if there is a match in mdadm.conf
	 * 3a/ if not, check for homehost match.  If no match, assemble as
	 *    a 'foreign' array.

I believe that this is kind of "foreign" naming for native raid.

You can probably correct it by updating your mdadm.conf or you can update your
homehost to production system hostname.

So yes, it looks like expected, we are highlighting that it is not our MD array.
We need user to acknowledge it by updating conf or updating homehost to
change locality to "local".

Thanks,
Mariusz
