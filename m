Received: from smtp-5.sys.kth.se (smtp-5.sys.kth.se [130.237.48.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6256107
	for <linux-raid@vger.kernel.org>; Mon,  1 Jan 2024 12:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kth.se
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kth.se
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kth.se header.i=@kth.se header.b="ZTs+r947"
Received: from vinyamar (unknown [213.100.210.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: sfle)
	by smtp-5.sys.kth.se (Postfix) with ESMTPSA id 4T3b3r6RYyzPNPx;
	Mon,  1 Jan 2024 13:32:55 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp-5.sys.kth.se 4T3b3r6RYyzPNPx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kth.se; s=default;
	t=1704112378; bh=8VJK7MAGUUWpfHQnWXNsg+OKevGHhDFyotMgRL+96YQ=;
	h=Date:From:To:Cc:Subject:From;
	b=ZTs+r947mNB2bklr6s0GqDAaGtCUEAOjkW4Dy/jnrtwdkU/rfELCWidMYMZlUhA0G
	 J7tehHAnGeknd6mM9EkABg+ldEbEx/b6DT8G0/Bu2snoOtv40W3jxvLu6MvEYg2rl+
	 DheAGn12wzWvDNUeqRcObeg3JP6mWnKv5uO758x0=
Date: Mon, 1 Jan 2024 13:32:55 +0100
From: Stefan Fleischmann <sfle@kth.se>
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: Jes Sorensen <jes@trained-monkey.org>, linux-raid@vger.kernel.org
Subject: Re: [PATCH v2 0/6] mdadm: POSIX portable naming rules
Message-ID: <20240101133255.520a6149@vinyamar>
Organization: KTH
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On 6/1/23 03:27, Mariusz Tkaczyk wrote:
> Hi Jes,
> To avoid problem with udev and VROC UEFI driver I developed stronger
> naming policy, basing on POSIX portable names standard. Verification is
> added for names and config entries. In case of an issue, user can update
> name to make it compatible (for IMSM and native).
> 
> The changes here may cause /dev/md/ link will be different than before
> mdadm update. To make any of that happen user need to use unusual naming
> convention, like:
> - special, non standard signs like, $,%,&,* or space.
> - '-' used as first sign.
> - locals.
> 
> Note: I didn't analyze configurations with "names=1". If name cannot be
> determined mdadm should fallback to default numbered dev creation.
> 
> If you are planning release soon then feel free to merge it after the
> release. It is a potential regression point.
> 
> It is a new version of [1] but it is strongly rebuild. Here is a list
> of changes:
> 1. negative and positive test scenarios for both create and config
>    entries are added.
> 2. Save parsed parameters in dedicated structs. It is a way to control
>    what is parsed, assuming that we should use dedicated set_* function.
> 3. Verification for config entries is added.
> 5. Improved error logging for names:
>    - during creation, these messages are errors, printed to stderr.
>    - for config entries, messages are just a warnings printed to stdout.
> 6. Error messages reworked.
> 7. Updates in manual.
> 
> [1] https://lore.kernel.org/linux-raid/20221221115019.26276-1-mariusz.tkaczyk@linux.intel.com/
> 
> Mariusz Tkaczyk (6):
>   tests: create names_template
>   tests: create 00confnames
>   mdadm: set ident.devname if applicable
>   mdadm: refactor ident->name handling
>   mdadm: define ident_set_devname()
>   mdadm: Follow POSIX Portable Character Set


Hi,

it seems to me that the behavior after this change is inconsistent. The
default naming scheme for a created device is still <HOSTNAME>:<ID>. When
I create a new MD device with:

 # mdadm --version
 mdadm - v4.2 - 2021-12-30 - Debian 4.2+20231121-1
 # mdadm --create /dev/md32 -l 1 -n 2 /dev/loop2 /dev/loop3
 [...]
 # mdadm --detail /dev/md32
  /dev/md32:
           Version : 1.2
     Creation Time : Mon Jan  1 12:33:05 2024
  [...]
              Name : gondolin:32  (local to host gondolin)
              UUID : d84b8e26:3675a722:61869b83:670699da

The name set automatically by mdadm is not allowed by the new naming
rules, and mdadm complains about that later on. So for consistency one
would either have to include : in the allowed character list or change
the default naming scheme. Or am I missing something here?

Happy new year!
Stefan
