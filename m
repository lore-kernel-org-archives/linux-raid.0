Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983E21CEAD6
	for <linux-raid@vger.kernel.org>; Fri, 13 Dec 2024 11:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734088484; cv=none; b=djTJM40GIW0uZv9zmkYecjHxYnFVfFf8k2NcFjzP9v1L5BD5nwDWjqDhtpWaTMm0CvAzcFy7pN0tWHZCBLWQMVG/hzZT861AnxWj2uBMGWweRhqM1ug37wuXuD1c0EkA1G68xIfXHL7nE/8WlXnMleLIrbJP0TQd7VWbcrqHedU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734088484; c=relaxed/simple;
	bh=NqRon6ji9id38aERU+r58jryHcyUQdEsCK2ggcgCjV0=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=mQt28O8V0kuu/9ovaE+/Xpipcymsv+FKKgIIcBtjLpjfwvTXiQtpdKenwprarQ3PorJFwD6MAj8SGQ6gE2+Kuu5wxyyiAy/cGDPchr+TP+w0l/a7ajZGZ8OFugCrqA3SUo9MslTwI4rL+tJZ1EWMW4d9SDqfontY4K5JqJcFh4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: from mtkaczyk-private-dev (unknown [31.7.42.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPSA id B1E8FC4CED0;
	Fri, 13 Dec 2024 11:14:42 +0000 (UTC)
Date: Fri, 13 Dec 2024 12:14:38 +0100
From: Mariusz Tkaczyk <mtkaczyk@kernel.org>
To: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Subject: Release mdadm-4.4
Message-ID: <20241213121438.7ed6a0fd@mtkaczyk-private-dev>
Organization: Linux development
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.34; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi,

Finally, I'm pleased to announce mdadm-4.4. It is published to both
remotes (github and kernel.org). Here highlights from CHANGELOG.md.

Features:
- Remove custom bitmap file support from Yu Kuai.
- Custom device policies implementation from Mariusz Tkaczyk.
- Self encrypted drives (**SED**) support for IMSM metadata from Blazej
  Kucman.
- Support more than 4 disks for **IMSM** RAID10 from Mateusz Kusiak.
- Read **IMSM** license information from ACPI tables from Blazej Kucman.
- Support devnode in **--Incremental --remove** from Mariusz Tkaczyk.
- Printing **IMSM** license type in **--detail-platform** from Blazej
  Kucman.
- README.md from Mariusz Tkaczyk and Anna Sztukowska.

Fixes:
- Tests improvements from Xiao Ni and Kinga Stefaniuk.
- Mdmon's Checkpointing improvements from Mateusz Kusiak.
- Pass mdadm environment flags to systemd-env to enable tests from
  Mateusz Kusiak.
- Superblock 1.0 uuid printing fixes from Mariusz Tkaczyk.
- Find VMD bus manually if link is not available from Mariusz Tkaczyk.
- Unconditional devices count printing in --detail from Anna Sztukowska.
- Improve SIGTERM handling during reshape, from Mateusz Kusiak.
- **Monitor.c** renamed to **Mdmonitor.c** from Kinga Stefaniuk.
- Mdmonitor service documentation update from Mariusz Tkaczyk.
- Rework around writing to sysfs files from Mariusz Tkaczyk.
- Drop of HOT_REMOVE_DISK ioctl in Manage in favour of sysfs from
  Mariusz Tkaczyk.
- Delegate disk removal to managemon from Mariusz Tkaczyk.
- Some clean-ups of legacy code and functionalities like **--auto=md**
  from Mariusz Tkaczyk.
- Manual clean-up, references to old kernels removed from Mariusz
  Tkaczyk.
- Various static code analysis fixes.

In this release we created Github repository and allowed participation
through Github. It allowed us to use Github actions and create CI.
Currently, we have:
- Compilation tests with various gcc.
- **mdadm** tests.
- Checkpatch test.

Other news:

Sadly, Intel (again) decided to move VROC (IMSM) to maintenance. It
means that part of the team will be disbanded and project will be
discontinued in next years. I'm leaving VROC team by the end of
December and I'm actively searching for new job.

I would love to still maintain mdadm but I cannot determine how long
it will be possible. I will make Kuai and Song sub-maintainers
of mdadm soon.

If there is someone/company interested in hiring me to continue my
story here or there are other possibilities I can explore - you are
more than welcome to contact me.

I already migrated my accounts, so I will be available on slack
or via this mail adress.

I would like to say "Thank You" to my Intel member team for the
dedicated work over the years, especially for last year and all energy
put to enable CI testing for MD and mdadm! I hope the infrastructure
will be useful for community as long as possible.

Thanks,
Mariusz
