Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC04D4688
	for <linux-raid@vger.kernel.org>; Fri, 19 Apr 2024 07:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713511021; cv=none; b=m7wQuYMQPJKCfBFSJ2/5M/F4R0i58IFScbnbiRoCrIz+NMYIKKviq9MtZr5K20cgRqCeyWGHJvAN1ETq7jEL9WUeVdCq90nVSkVe564fN4XhdwnDkBaK/UCNxfeDCjPf3aDIB6g4/CNDxmCBZ9oo1jXWx45bHNjO6YJ5Ismco10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713511021; c=relaxed/simple;
	bh=r+asvAZe/P1K2egr6aQPMOdxY7fniYKyqvHVTGmkCyA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u4Ffg6V3hzBM49WfPpn1GY2uW3FYAcbUvi/4Wb/J1i+XvEptodKfD9R7HgrBz9eX0j4Jp0ZrhA4mUYjLf/Z5HTA6lqa29yQq2MP/RZEOMTqu8iqLN+xYV9JA4WZ9Kbm7JY6u3Mm1UeVpBxGCyTmQ+d2Xl8gDc7X68N64VvFE7dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tv+oHnx4; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tv+oHnx4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713511019; x=1745047019;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=r+asvAZe/P1K2egr6aQPMOdxY7fniYKyqvHVTGmkCyA=;
  b=Tv+oHnx48BDfAAU/Zzl3pCe4ZqZnA/yjsyDx7fR1uRd3Gv/P/7GqKQrK
   7V5x5lyhu7DUqPZg1d5bPbomij3M+4RnZIX+RBQSOP+zrAdrTC19nDksR
   2AxIMKX8crJYG9Ljr4luywuN9imuaMIav2Cyj6otCS8out/SU8cVZ9Qzt
   zXqQIBSxnLVxD9Ohitzamu883ar8U+Lr8njDjUfvGsRuITE79Rf3AOPmK
   8HO5LvK3fbuwAv5pjACYbXTLQYAbaOI1n1GbF0pkSt6bUM5xQ691zoH7i
   ykzPsQnsg/LFpIPbB52ruZSk94/by61xCanoShhMe1fP9ru4Muzf83sae
   A==;
X-CSE-ConnectionGUID: qFHYZ9anQpyy75uGisOEmA==
X-CSE-MsgGUID: x651KcNySWWES8CxUuH3Uw==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="8969718"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="8969718"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 00:16:59 -0700
X-CSE-ConnectionGUID: fosEeFywQ16FNWPDM+UY8Q==
X-CSE-MsgGUID: 3xP+CPiiRH6+MzzHEcmpdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="23760507"
Received: from mkusiak-mobl1.ger.corp.intel.com (HELO [10.246.35.139]) ([10.246.35.139])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 00:16:56 -0700
Message-ID: <bf7edcf8-9cb8-4349-ae34-a9ca5fa9cf17@linux.intel.com>
Date: Fri, 19 Apr 2024 09:16:53 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] tests/test enhance
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org, song@kernel.org, yukuai1@huaweicloud.com,
 ncroxon@redhat.com, colyli@suse.de, mariusz.tkaczyk@linux.intel.com
References: <20240418102321.95384-1-xni@redhat.com>
 <20240418102321.95384-2-xni@redhat.com>
Content-Language: pl, en-US
From: Mateusz Kusiak <mateusz.kusiak@linux.intel.com>
In-Reply-To: <20240418102321.95384-2-xni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Xiao,
one small note from me.

On 18.04.2024 12:23, Xiao Ni wrote:
> @@ -309,6 +322,7 @@ print_warning() {
>   main() {
>   	print_warning
>   	do_setup
> +	record_system_speed_limit
>   
>   	echo "Testing on linux-$(uname -r) kernel"
>   	[ "$savelogs" == "1" ] &&


I feel like record_system_speed_limit() should be called in do_setup() rather than main().
Saving current system settings is job of setup.

Thanks,
Mateusz
