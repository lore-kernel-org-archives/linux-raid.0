Received: from torres.zugschlus.de (torres.zugschlus.de [81.169.166.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26C61FBF56
	for <linux-raid@vger.kernel.org>; Mon, 21 Oct 2024 20:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.169.166.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729542815; cv=none; b=Q1Evda6cLAlYZkKGJEH9y4NhTiW3mulNH+a9IgwHDjnjkfYyG7fOv2cPMrMzKJmst2OoL2LaExUfrXIlu2fCRfsPp6NKPkaGkkVaj/FEQz7ZOxQw8Jh6v4MRmN0DvZDalOiYpQAIxGrwWqUFjNYQDrDU57i17KSEHm2HA4jBQo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729542815; c=relaxed/simple;
	bh=n9i4SR7AUbHQ+Ax7p4wDKml1rqDbUH0Vqh4Hf8TOVVw=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jHpQUiJWepva7ahbmsUiY5Ni5U/MkII2aM0/9bhmyciVhBE108e/zMOt5vSFz35B2eHCT78qcYdF/bd4kGeKgNNUy36P8+zg8EBNz850oEcFdbDMF4k/7Xh/4hj1/GuO+wzW9CssofrRmtwabOoemLYe0a090HYFsEd2QMTjr6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zugschlus.de; spf=pass smtp.mailfrom=zugschlus.de; arc=none smtp.client-ip=81.169.166.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zugschlus.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zugschlus.de
Received: from mh by torres.zugschlus.de with local (Exim 4.96)
	(envelope-from <mh+linux-raid@zugschlus.de>)
	id 1t2z5e-002hZb-2e
	for linux-raid@vger.kernel.org;
	Mon, 21 Oct 2024 22:33:22 +0200
Date: Mon, 21 Oct 2024 22:33:22 +0200
From: Marc Haber <mh+linux-raid@zugschlus.de>
To: linux-raid@vger.kernel.org
Subject: Re: Cannot update homehost of an existing array: mdadm: /dev/sda3
 has wrong name.
Message-ID: <Zxa6knvDsm6KlNkH@torres.zugschlus.de>
References: <ZxNSmXIdVlQMWf9x@torres.zugschlus.de>
 <0e2df2b5-1215-44c3-b41a-086782c5fc37@demonlair.co.uk>
 <ZxQTFA8Mwi8V5jye@torres.zugschlus.de>
 <20241021085132.00000cad@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241021085132.00000cad@linux.intel.com>
User-Agent: Mutt/2.2.12 (2023-09-09)

Hi Mariusz,

thanks for your answer.

On Mon, Oct 21, 2024 at 08:51:32AM +0200, Mariusz Tkaczyk wrote:
> I'm looking into Incremental right now and there is a comment:
> 
> 	 * 3/ Check if there is a match in mdadm.conf
> 	 * 3a/ if not, check for homehost match.  If no match, assemble as
> 	 *    a 'foreign' array.
> 
> I believe that this is kind of "foreign" naming for native raid.

But the array is not intended to be considered as foreign, it is running
on its native host.

Good call, I indeed forgot updating mdadm.conf. And I also forgot that
we are on Debian stable with a current kernel now, that means Kernel
6.11.3 and mdadm 4.2

> You can probably correct it by updating your mdadm.conf or you can update your
> homehost to production system hostname.

It now says:
HOMEHOST <system>
ARRAY /dev/md/myrealhostname:md_root metadata=1.2 name=myrealhostname:md_root UUID=9d455b1e:35a52a2b:59b2bc1a:db22369f
The ARRAY line is what mdadm --detail --scan prints, and hostname(1)
returns "myrealhostname". And still, /dev/md/myrealhostname:md_root
exists after rebuilding initramfs and rebooting..

Changing the ARRAY line to
ARRAY /dev/md/md_root metadata=1.2 name=myrealhostname:md_root UUID=9d455b1e:35a52a2b:59b2bc1a:db22369f
and rebuilding initramfs yielded the expected behavior, having
/dev/md/md_root.

Thanks for pointing me so effienctly to the correct solution.

> So yes, it looks like expected, we are highlighting that it is not our MD array.

But it IS "our" MD array. Or, at least it is supposed to be.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
