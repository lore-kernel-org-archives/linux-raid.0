Received: from shin.romanrm.net (shin.romanrm.net [146.185.199.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37A957C8D
	for <linux-raid@vger.kernel.org>; Thu, 13 Jun 2024 20:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=146.185.199.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718309043; cv=none; b=l8wBsx6GYmBlXjcN4k1kTkXL2u3QIgBKlmSMbAQN6zufOYcSR9CEqULJ1dgHMsWmyLXbXpR+Vs/WFEM2TYYR4jTgM1WHi0Gw4rS6JzDvzIEqCAQFPJCC39nZteHy4f1O/tu/MWmycDaqg1uvXjr6iEDCqM9/XvwNMEjfSP5e6qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718309043; c=relaxed/simple;
	bh=F2+dI2e83MXf96TQnUogKxAtDHbukyisJM1YJX/+kGk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u++C/JPRp9n+F5wmVOINvWNTLndWKsGh/fivLoBjvQRTMEsFf1jdqiySueccSeA2zkXBNwr12F2laK+nOdo3UBXbf9/BQIljpYaHQ9WzsaxpfrF/0qrXp/pVh2p3UC8r7d/uh3H+SriSeIeiXEpyWSv/rFsMWlnSyDTZxAQyp6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net; spf=pass smtp.mailfrom=romanrm.net; arc=none smtp.client-ip=146.185.199.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=romanrm.net
Received: from nvm (nvm.home.romanrm.net [IPv6:fd39::101])
	by shin.romanrm.net (Postfix) with SMTP id DCC9240B9D;
	Thu, 13 Jun 2024 19:55:15 +0000 (UTC)
Date: Fri, 14 Jun 2024 00:55:10 +0500
From: Roman Mamedov <rm@romanrm.net>
To: dfc <chernoff@astro.cornell.edu>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: Cleaning up a Raid5 after discrepancies discovered
Message-ID: <20240614005510.5d70944d@nvm>
In-Reply-To: <303bab326f482ac151f5f45c26aaf174a20e12e7.camel@astro.cornell.edu>
References: <303bab326f482ac151f5f45c26aaf174a20e12e7.camel@astro.cornell.edu>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 13 Jun 2024 12:36:50 -0400
dfc <chernoff@astro.cornell.edu> wrote:

> I noticed some data inconsistencies in my raid5 (5 disks, 3.6T per
> disk) and discovered via smartmon that 1 disk was about to fail (many
> reallocated sectors). Mismatch_cnt was approximately 128 at this point.
> I don't have a spare 6th disk in the setup.
> 
> I dd'd the failing disk's entire contents (including partition table)
> to a new (8T) disk and inserted it in the array. The new configuration
> was recognized without problems. I ran check without mounting the file
> system. This completed (I failed to check dmesg to see how many
> inconsistencies it found). I mounted the file system and things seemed
> OK.
> 
> Next I did a diff with respect to a backup (unfortunately a close but
> not perfect backup). There were definitely some differencies within
> some binary files.

If I'm not mistaken, the regular RAID5 cannot protect from data corruption; in
case of one RAID member content becoming corrupt (but readable) the recovery
of the affected stripe consistency will likely damage the user data.

If you know one disk has corrupted content, you may be better off removing
that one from the array ASAP, and putting in a clean new disk, then rebuilding
onto that from the known-good other RAID members. (Of course then you take the
usual risk in any RAID5 rebuild, of another drive failing...)

Meanwhile RAID6 supposedly can do better and detect which disk had the wrong
content, but I remember reading something to the effect that this math may or
may not have been implemented in mdadm RAID yet.

To protect from data corruption you need a RAID coupled with a checksumming
filesystem, like Btrfs or ZFS. But Btrfs RAID5/6 are not mature and not
recommended for use.

> My question is "how to clean up this array?"
> 
> Should I try to delete the specific files I know have discrepancies
> and recopy them from the backup? Does that cure the mismatches in the
> space occuppied by those files?

I would say yes, barring some corner case I'm missing. Writing new data will
write the new and consistent stripe content for that data on all disks
including the problematic one.

> What strategy one should take when it's clear that there's been a
> limited amount of bitrot?

If you do not use a checksumming filesystem, have a tool like "cfv" store
checksum files in each dir with rarely-modified content (such as a media
library). If you had those prior to this incident, you could easily recheck
them all and tell which files need to be restored from backups or reobtained
elsewhere, or have to deal with some rot of the content (may not be a fatal
issue for video files for example).

-- 
With respect,
Roman
