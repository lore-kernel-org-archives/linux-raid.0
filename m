Received: from mail.esperi.org.uk (icebox.esperi.org.uk [81.187.191.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835281C10
	for <linux-raid@vger.kernel.org>; Wed, 28 Feb 2024 15:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.187.191.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709133908; cv=none; b=gVzl/93JfhnQR+lCgGUaLgfHoFqw3KIttXwwrkpIksqcteWoiq0eNKGYbzqIR/GcmCGRDgfFWTQSXkLCPlAzFv/lhtkI9waa7mZlOPNad8kzhbZQdhGeBfUnoTI3cPo3FOTRGUjE0IXfKa9jdu2lFiO3p6WRuuCtUr2CNC2A5ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709133908; c=relaxed/simple;
	bh=1XlpcTW2DOXAbKqAoTSFl7ZYpeuSkT/AeG7uR3TelEM=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=lbzd91rZLe7AmIYnOsRreNDZU9/ibvMfYosxYUoiGQO73WM6oBBRo0/UAwczW8HORNz4J1ibQaD69uklqvOWIOYJaWRrbSMI3R7KvItnTyncl9o7MiC5vFaIcZpFYeKQpmiDArg8QoJl+6H3DTPeFt0IRojwKr8LFZrTnpKaEa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=esperi.org.uk; spf=pass smtp.mailfrom=esperi.org.uk; arc=none smtp.client-ip=81.187.191.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=esperi.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=esperi.org.uk
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
	by mail.esperi.org.uk (8.17.2/8.17.2) with ESMTPS id 41SEeMVe016351
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 28 Feb 2024 14:40:23 GMT
From: Nix <nix@esperi.org.uk>
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: jes@trained-monkey.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/6] mdadm: remove ANNOUNCEs
References: <20240223145146.3822-1-mariusz.tkaczyk@linux.intel.com>
	<20240223145146.3822-2-mariusz.tkaczyk@linux.intel.com>
Emacs: no job too big... no job.
Date: Wed, 28 Feb 2024 14:40:22 +0000
In-Reply-To: <20240223145146.3822-2-mariusz.tkaczyk@linux.intel.com> (Mariusz
	Tkaczyk's message of "Fri, 23 Feb 2024 15:51:41 +0100")
Message-ID: <871q8wsld5.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.3 (gnu/linux)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-sonic-Metrics: loom 1255; Body=3 Fuz1=3 Fuz2=3

On 23 Feb 2024, Mariusz Tkaczyk uttered the following:

> Release stuff is not necessary in repository. Remove it.

... it's actually pretty useful to have the ANNOUNCEs there for people
building from the repo. Given that the changelog is not updated, having
a summary of changes *somewhere* without having to grovel around in
mailing list archives seems like a thing that shouldn't just be thrown
out as "not necessary".
