Received: from torres.zugschlus.de (torres.zugschlus.de [81.169.166.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122E418C910
	for <linux-raid@vger.kernel.org>; Sat, 19 Oct 2024 06:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.169.166.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729319582; cv=none; b=OzhLltGt+xQaiwaSxI0lEakdCb8dvx/x7+RDPGnPElNiiJfuUjMvx6r29oSc49rX5NUSenuAJSSJNc89lEXaeNMEqq776arXyULSTwvMSSGqqwtL7XPo7kn2vJwtF2PffOJ4h2wQSQbDZIrSwbjOPrAhmLR1WD5GWnE/UbYTt1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729319582; c=relaxed/simple;
	bh=F0pxW6CTfeSfJfbW0WiZrT4Yl/4WqT0YzVCWnuC6jWA=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=LsV4vOsl01dAwEJvt3PkGyA9RBD13nyAz5kbd/uoCN0GiOmThSX5mVX3kXiwdPMjD4TWLd0aChBb3xVkW+sH4A3MiOSes0tgSRqvosNLQX7bg9llJtAP+etbV5V7hjHgiDTN7n8CbWvJumvqaGZJTY87w76bfy9iOIj5BtkXvEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zugschlus.de; spf=pass smtp.mailfrom=zugschlus.de; arc=none smtp.client-ip=81.169.166.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zugschlus.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zugschlus.de
Received: from mh by torres.zugschlus.de with local (Exim 4.96)
	(envelope-from <mh+linux-raid@zugschlus.de>)
	id 1t231F-001Sbs-0T
	for linux-raid@vger.kernel.org;
	Sat, 19 Oct 2024 08:32:57 +0200
Date: Sat, 19 Oct 2024 08:32:57 +0200
From: Marc Haber <mh+linux-raid@zugschlus.de>
To: linux-raid@vger.kernel.org
Subject: Cannot update homehost of an existing array: mdadm: /dev/sda3 has
 wrong name.
Message-ID: <ZxNSmXIdVlQMWf9x@torres.zugschlus.de>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/2.2.12 (2023-09-09)

Hi,

during a restore operation, I have recreated a RAID array using a rescue
system. That new array ended up being named grml:0. Renaming the array
to realhostname:md_root didn't work inside the rescue system

The rescue system is reasonably current, using kernel 6.11.2 and mdadm
4.3.

First, I tried changing the name of the array. That worked:
# mdadm --assemble md_root --update=name --name=md_root /dev/sda3 /dev/sdb3
mdadm: /dev/md/md_root has been started with 2 drives.
# mdadm --examine /dev/sda3
... Name: grml:md_root  (local to host grml) ...

What didn't work was changing the homehost:
# mdadm --assemble md_root --update=homehost --name=realhostname /dev/sda3 /dev/sdb3
mdadm: /dev/sda3 has wrong name.
mdadm: /dev/sdb3 has wrong name.

Adding --force didn't work, same error message.

What is the recommended way to create an array inside a rescue system
that has homehost and name to the values the local admin wants, and/or
to change those values for an array that has already been created and is
filled with data?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
