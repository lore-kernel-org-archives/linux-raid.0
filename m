Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from sender-op-o9.zoho.eu (sender-op-o9.zoho.eu [136.143.169.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6886BD4C
	for <linux-raid@vger.kernel.org>; Tue, 21 Nov 2023 08:13:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1700583170; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=Xeb7j1XXR2oz+WklS48KY5Ios5Ezw6HKyLNQspk+hpXxjT4H+7qVn8wQFczAauMnu8XRab+ykmhxvEi0SYey54+yj/DVfmppfSL5jImWklLxYiAg9D2QiHXNCQ/m5iwdo0QPxda9bvC6y+RyZX+jEjTaeo6Xq8JXymyvMo1XqME=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1700583170; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=N+lCGWomKy0TULID3wUagRacFILyEwv0/gkOBCKG+ZM=; 
	b=BrTEFVb5WFQ4Y9/469v6uEjgM1ix5GjKlyb1MMhX1SKDAjmcT4Zv8hJ5vatgdf9EFalMTq9svHLCIfcPX1SCG4j9JwylDPOEgXm4o9CTSWeNEviXMubV+DpMthNp/usLR5L2oSIgeT/bTo2ZdY1qT4jHdGZ1zDowzzb69rt1N8M=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	spf=pass  smtp.mailfrom=jes@trained-monkey.org;
	dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
	with SMTPS id 1700583167914368.8497648346596; Tue, 21 Nov 2023 17:12:47 +0100 (CET)
Message-ID: <40f371cd-db47-5e52-9ed9-790e9ed165af@trained-monkey.org>
Date: Tue, 21 Nov 2023 11:12:46 -0500
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v5 0/2] Mdmonitor refactor and udev event handling
 improvements
Content-Language: en-US
To: Kinga Tanska <kinga.tanska@intel.com>, linux-raid@vger.kernel.org
Cc: colyli@suse.de, Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
References: <20231121005824.3951-1-kinga.tanska@intel.com>
From: Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20231121005824.3951-1-kinga.tanska@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External

On 11/20/23 19:58, Kinga Tanska wrote:
> Along the way we observed many problems with current approach to event handling in mdmonitor.
> It frequently doesn't report Fail and DeviceDisappeared events.
> It's due to time races with udev, and too long delay in some cases.
> While there was a patch intending to address time races with udev, it didn't remove them completely.
> This patch series presents alternative approach, where mdmonitor wakes up on udev events, so that
> there should be no more conflicts with udev we saw before.
> 
> Additionally some code quality improvements were done, to make the code more maintainable.
> 
> v2:
> Fixed mismatched comment style and rebased onto master.
> 
> v3:
> Resend to cleanup on patchwork.
> 
> v4:
> Fix building errors. Only two last patches out of 8 didn't apply, so I'm sending just them.
> 
> v5:
> Patches didn't apply. Send updated version.
> 
> Mateusz Grzonka (2):
>   Mdmonitor: Improve udev event handling
>   udev: Move udev_block() and udev_unblock() into udev.c

Applied!

Thanks,
Jes


>  Create.c  |   1 +
>  Makefile  |  18 ++---
>  Manage.c  |   3 +-
>  Monitor.c | 137 ++++++++++++++------------------------
>  lib.c     |  42 ------------
>  mdadm.h   |   3 +-
>  mdopen.c  |  19 +++---
>  udev.c    | 194 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  udev.h    |  40 +++++++++++
>  9 files changed, 307 insertions(+), 150 deletions(-)
>  create mode 100644 udev.c
>  create mode 100644 udev.h
> 

