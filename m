Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EE5182A8
	for <linux-raid@vger.kernel.org>; Wed,  3 Jan 2024 08:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wpa9OVRJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704272142; x=1735808142;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v7WWO8SdNxRAD2B73N7zp5OF3+Ev3qg50SCsuIhRnTY=;
  b=Wpa9OVRJlHKaiHfHVTz+ZC8rsS5kvfDzcu1coQI4NoKnODSY1F+v80Z/
   6xiy1YqHudS7uXWOoDVzANkQ/gFvbYAtRKxkSeCCiUDe/KRMWDe4dY7pQ
   XrjBzZfvUYXOmKXmQCIH41GIuBQTPX56rNoEQR7QQJmMxRUMaoeMrI+To
   vTLUYpenGdDj0mnGlAy6UnZW0tjP23sdqw+2ihD0UIm9KhLj94aMozbUf
   Ipc7svvaLRl0qxfN4VlnEuDGN2bEvLdl9QwIMk6qzvNDB2ptfWKMHy+/8
   /xMPYnM6nzmiQrILKWH+K6Kjqmr/0fKD+wy8Bqx3bK5Z+Z3ur5UvJR38A
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="3750504"
X-IronPort-AV: E=Sophos;i="6.04,327,1695711600"; 
   d="scan'208";a="3750504"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2024 00:55:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="870506496"
X-IronPort-AV: E=Sophos;i="6.04,327,1695711600"; 
   d="scan'208";a="870506496"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.132.134])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2024 00:55:38 -0800
Date: Wed, 3 Jan 2024 09:53:23 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Stefan Fleischmann <sfle@kth.se>
Cc: Jes Sorensen <jes@trained-monkey.org>, linux-raid@vger.kernel.org
Subject: Re: [PATCH v2 0/6] mdadm: POSIX portable naming rules
Message-ID: <20240103095323.00002d36@linux.intel.com>
In-Reply-To: <20240101133255.520a6149@vinyamar>
References: <20240101133255.520a6149@vinyamar>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 1 Jan 2024 13:32:55 +0100
Stefan Fleischmann <sfle@kth.se> wrote:

> On 6/1/23 03:27, Mariusz Tkaczyk wrote:
> > Hi Jes,
> > To avoid problem with udev and VROC UEFI driver I developed stronger
> > naming policy, basing on POSIX portable names standard. Verification is
> > added for names and config entries. In case of an issue, user can update
> > name to make it compatible (for IMSM and native).
> > 
> > The changes here may cause /dev/md/ link will be different than before
> > mdadm update. To make any of that happen user need to use unusual naming
> > convention, like:
> > - special, non standard signs like, $,%,&,* or space.
> > - '-' used as first sign.
> > - locals.
> > 
> > Note: I didn't analyze configurations with "names=1". If name cannot be
> > determined mdadm should fallback to default numbered dev creation.
> > 
> > If you are planning release soon then feel free to merge it after the
> > release. It is a potential regression point.
> > 
> > It is a new version of [1] but it is strongly rebuild. Here is a list
> > of changes:
> > 1. negative and positive test scenarios for both create and config
> >    entries are added.
> > 2. Save parsed parameters in dedicated structs. It is a way to control
> >    what is parsed, assuming that we should use dedicated set_* function.
> > 3. Verification for config entries is added.
> > 5. Improved error logging for names:
> >    - during creation, these messages are errors, printed to stderr.
> >    - for config entries, messages are just a warnings printed to stdout.
> > 6. Error messages reworked.
> > 7. Updates in manual.
> > 
> > [1]
> > https://lore.kernel.org/linux-raid/20221221115019.26276-1-mariusz.tkaczyk@linux.intel.com/
> > 
> > Mariusz Tkaczyk (6):
> >   tests: create names_template
> >   tests: create 00confnames
> >   mdadm: set ident.devname if applicable
> >   mdadm: refactor ident->name handling
> >   mdadm: define ident_set_devname()
> >   mdadm: Follow POSIX Portable Character Set  
> 
> 
> Hi,
> 
> it seems to me that the behavior after this change is inconsistent. The
> default naming scheme for a created device is still <HOSTNAME>:<ID>. When
> I create a new MD device with:
> 
>  # mdadm --version
>  mdadm - v4.2 - 2021-12-30 - Debian 4.2+20231121-1
>  # mdadm --create /dev/md32 -l 1 -n 2 /dev/loop2 /dev/loop3
>  [...]
>  # mdadm --detail /dev/md32
>   /dev/md32:
>            Version : 1.2
>      Creation Time : Mon Jan  1 12:33:05 2024
>   [...]
>               Name : gondolin:32  (local to host gondolin)
>               UUID : d84b8e26:3675a722:61869b83:670699da
> 
> The name set automatically by mdadm is not allowed by the new naming
> rules, and mdadm complains about that later on. So for consistency one
> would either have to include : in the allowed character list or change
> the default naming scheme. Or am I missing something here?
> 
> Happy new year!
> Stefan

Hi Stefan,
Yeah, I noticed this problem recently but I do not fixed it yet. For sure it
will be fixed before release.
It does not prompt about the name in metadata but about name entry in config
file. I analyzed the usage on name from config and it seems to be something
which can be dropped but I will reconsider it deeper later.

Could you please test if removing "name=hostanme:id" from ARRAYLINE in
mdadm.conf fixes issue for you?

Thanks,
Mariusz
