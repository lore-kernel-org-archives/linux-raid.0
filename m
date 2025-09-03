Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73902D8768
	for <linux-raid@vger.kernel.org>; Wed,  3 Sep 2025 19:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.233.160.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756929059; cv=none; b=cSiZgUIZn0x4Rh9whOjy/hBXEi9HZk0I9THNegHg6VjGGOaBDzvfoKbaQOAkNC4i1xXHbgmjQSIxRsMkvNZ1JaLAsiPoPDXtcDxWULx07BumOZyx5vzcqR+jjb6knNfXbQ0vm/pGcphmineKLFHFENUpyaSPx5mtSJuQnz+hQ/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756929059; c=relaxed/simple;
	bh=CMTbfZFI3gOAaRxX7FthaPKS55RSJ5Jpfgxd0LxsI34=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H4gE6vpOBwuDRdPLcDEupc/IUP+kqmErh8wuWDTNc63opJua/L9yZgNFx5vwtR+lFAxRA/w0IPH/lRZMQVusiuaWtQQRsYs3HAVHsjfhMC70mi9IQLEQ2/B86cnkEUfJlwZR194GX2a3oNKvltEJNeukumEEPyXKlJKFmkkGdkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk; spf=fail smtp.mailfrom=youngman.org.uk; arc=none smtp.client-ip=85.233.160.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=youngman.org.uk
Received: from host51-14-94-149.range51-14.btcentralplus.com ([51.14.94.149] helo=[192.168.1.65])
	by smtp.hosts.co.uk with esmtpa (Exim)
	(envelope-from <antlists@youngman.org.uk>)
	id 1uttVO-00000000360-2uhc;
	Wed, 03 Sep 2025 20:50:54 +0100
Message-ID: <ec124f5e-8849-49ce-bf8e-e537452c1dd3@youngman.org.uk>
Date: Wed, 3 Sep 2025 20:50:55 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RAID 1 | Changing HDs
To: "Stefanie Leisestreichler (Febas)"
 <stefanie.leisestreichler@peter-speer.de>, Roman Mamedov <rm@romanrm.net>
Cc: linux-raid@vger.kernel.org
References: <5c8e3075-e45a-410e-a23a-cbf0e86bdfa6@peter-speer.de>
 <20250903204521.44e91df1@nvm>
 <0bec82b1-ab30-4d3b-b254-a461d1039dbf@peter-speer.de>
Content-Language: en-GB
From: Wol <antlists@youngman.org.uk>
In-Reply-To: <0bec82b1-ab30-4d3b-b254-a461d1039dbf@peter-speer.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/09/2025 18:47, Stefanie Leisestreichler (Febas) wrote:
> I like this method, hopefully I have a free connector on the board.
> 
> But still two questions left:
> - Do I need to turn off the computer for the new (3rd) disk to be known? 
> If I remember correct I had try a hot spare in another scenario and 
> wasn't able to expose the new hard disk to be recognized by lsblk or 
> similar.

As others have said, if your mobo doesn't support hotplug, DON'T TRY IT!

Otherwise, use eSATA (or USB).>
> Also I see problems with the device naming as long as no hd uuids are 
> not used by having a drive appearing as /dev/sdx and with next reboot 
> as /dev/sdn. Are my concerns reasonable or am I just too afraid?
As others have said, it doesn't matter. Not sure if as the other person 
said md uses uuids, or if it just scans all partitions, and looks for a 
superblock.
What I would say (and it's not for raid1, but definitely raid 5/6) if 
you do have parity raid then make sure every time you change the config, 
generate an mdadm.conf file (or whatever it's called). While md doesn't 
use it, if you have a problem with your raid you will wish you had it!

As I say, you're raid 1, you don't need it now, but if you ever do 
change, DO IT!

Cheers,
Wol
