Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AF61400B
	for <linux-raid@vger.kernel.org>; Mon,  8 Jan 2024 11:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VB4ubK0Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704711758; x=1736247758;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Gwx8ZotCAKgx9Q6QqxOtWkmnhcKi8SXp3+r5JDZbxCc=;
  b=VB4ubK0QNbhZTWU4OzbuXJ4LlFCyPeFKrGZANB5bI5LsTWaLDEWa+OtI
   SvhTAVLdQCmLm2jy1TO9LKUFQLI76UQqjIfd9/B4NvgLwraPDDRFqQOcO
   uLXFFgzVDTqM7vJH2H5pm9qSHLN3+rMxZsReFNFA0xEDKu64TkDCqgBBD
   Mw33vmbTH+OoUiy00k7p4j9rNHsvGdPu/nJIn3nGR/30qjgJc/PKtvHiq
   9m7WfaGaAFN2XSApDQvJsTLs9LODhSJhTWTtTGHhKN2cOZLaCc+ZPR1nS
   2YlctSnmHjGamDn1jFoc8qUc1wh/xHyUSSffNCxqK29FVMk6vAhqLexiT
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10946"; a="16451458"
X-IronPort-AV: E=Sophos;i="6.04,340,1695711600"; 
   d="scan'208";a="16451458"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2024 03:02:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10946"; a="815571984"
X-IronPort-AV: E=Sophos;i="6.04,340,1695711600"; 
   d="scan'208";a="815571984"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.133.118])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2024 03:02:35 -0800
Date: Mon, 8 Jan 2024 12:02:30 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Andrea Janna <andrea1@newsletter.dpss.psy.unipd.it>
Cc: linux-raid@vger.kernel.org
Subject: Re: mdadm: --update=resync not understood for 1.x metadata
Message-ID: <20240108120230.00004b80@linux.intel.com>
In-Reply-To: <ZZqJlCToUS3Qrl4J@bianca.dpss.psy.unipd.it>
References: <ZZqJlCToUS3Qrl4J@bianca.dpss.psy.unipd.it>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hello Andrea,
Thanks for your patch. It looks reasonable.
Please resolve few nits and I will take it.

On Sun, 7 Jan 2024 12:23:00 +0100
Andrea Janna <andrea1@newsletter.dpss.psy.unipd.it> wrote:

I'm not familiar with your mail domain, "newsletter" suggest me that it is not
something I can trust. Could you please update mail address?
I'm afraid that accidentally I may record list for a spam messages as
"newsletter" generally provides them.

> After upgrading mdadm from released version mdadm-4.2 to the current git
> version the command mdadm --assemble --update=resync
> started failing with the error "mdadm: --update=resync not understood for 1.x
> metadata". My array superblock version is 1.0.
> 
> I think this is a regression introduced by
> https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=7e8daba8b7937716dce8ea28298a4e2e72cb829e
> This commit deleted the "else if (strcmp(update, "resync") == 0)" code block
> without replacing it with a switch case.

"I think" it is not something that we can accept in commit message. You provided
patch so I must believe that you are familiar with problem and it is properly
root causes.
In this case, it is obvious that the problem is introduced by this
patch because the solution is a partial revert of the change so please be more
direct, (just skip "I think").

Please read sending patches best practices carefully:
https://www.kernel.org/doc/html/latest/process/submitting-patches.html

Please run checkpatch script, before sending the patch, it is really helpful:
https://docs.kernel.org/dev-tools/checkpatch.html

Me <mariusz.tkaczyk@linux.intel.com> and Jes <jes@trained-monkey.org> should be
added in --to or --Cc for mdadm patches.

> 
> The following patch fixed the error for me.
> 
> diff --git a/super1.c b/super1.c
> index dfde4629..6f23b9eb 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -1356,6 +1356,10 @@ static int update_super1(struct supertype *st, struct
> mdinfo *info, __cpu_to_le16(info->disk.raid_disk);
>  		break;
>  	}
> +	case UOPT_RESYNC:
> +		/* make sure resync happens */
> +		sb->resync_offset = 0;
> +		break;
>  	case UOPT_UUID:
>  		copy_uuid(sb->set_uuid, info->uuid, super1.swapuuid);
>  
> 
> Regards,
> Andrea Janna
> 
Please sign-off your patch!

Do not forgot to add v2 for sending new version. You can search for examples in
list history:
https://lore.kernel.org/linux-raid/

Thanks,
Mariusz
