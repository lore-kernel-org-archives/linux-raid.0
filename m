Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37311D552
	for <linux-raid@vger.kernel.org>; Tue, 19 Dec 2023 16:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m/4nqvms"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703001689; x=1734537689;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fpM6+Qy47YMswh3NsnkkdHvkFs7ZbDInfdOZ7TDpoIY=;
  b=m/4nqvmsiPQ6oWL0YXs0ptvySjB7hpKSZTlLS/LpXon98SzEbPUZA7HY
   DViCJSxBYr/qGwD0FnDymCLvY+WdwBqTXw8dqArOD/+hHsEUNNjPtqKgP
   ooWt8Vp+XyhHO2gyEbnJxEolopUaBcfOZOEcQwYOvAf4zbEMq+Ndrgdwn
   54fJg1OcLVbi7gxjmGpcR6Z61KMX7iIAYhVjF/0iU4nYa582cJFqoaGZZ
   iXqXnOyp5wsLVQ+NcpjaVaHK8+p+zSTIOrQyKsHf4nAsOR0WHDmgAF8kC
   WtTG7LJM1ahsufwb7MRaY2Q/C7RqFc0og16o62ruJOaXHNwqEzHz5BxCz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10929"; a="2502869"
X-IronPort-AV: E=Sophos;i="6.04,288,1695711600"; 
   d="scan'208";a="2502869"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 08:00:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,288,1695711600"; 
   d="scan'208";a="17652404"
Received: from ksoltys-mobl.ger.corp.intel.com (HELO localhost) ([10.249.130.19])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 08:00:52 -0800
Date: Tue, 19 Dec 2023 17:00:41 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Mateusz Kusiak <mateusz.kusiak@intel.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org
Subject: Re: [PATCH] Remove all "if zeros"
Message-ID: <20231219170041.00006d4f@linux.intel.com>
In-Reply-To: <20231218150351.10120-1-mateusz.kusiak@intel.com>
References: <20231218150351.10120-1-mateusz.kusiak@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 18 Dec 2023 16:03:51 +0100
Mateusz Kusiak <mateusz.kusiak@intel.com> wrote:

> No more random encounters of "if zeros".
> Remove all "if 0" code blocks.
> 
> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>

Thanks for cleanup. Applied! 

Thanks,
Mariusz
