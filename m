From: Andre Noll <maan@systemlinux.org>
Subject: mdadm-2.2 SEGFAULT: mdadm --assemble --scan
Date: Thu, 22 Dec 2005 21:58:09 +0100
Message-ID: <20051222205809.GC492@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

sorry if this is already known/fixed: Assemble() is called from mdadm.c with
the "update" argument equal to NULL:

	Assemble(ss, array_list->devname, mdfd, array_list, configfile,
		NULL, readonly, runstop, NULL, verbose-quiet, force);

But in Assemble.c we have

	if (ident->uuid_set && (!update && strcmp(update, "uuid")!= 0) && ...

which yields a segfault in glibc's strcmp().

Andre
-- 
Jesus not only saves, he also frequently makes backups
