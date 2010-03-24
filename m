From: Daniel Reurich <daniel@centurion.net.nz>
Subject: Raid Containers
Date: Thu, 25 Mar 2010 10:27:09 +1300
Message-ID: <1269466029.5759.668.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi.

I'm wanting to know are containers properly supported now in mdadm and
recent kernels (I assume using only 1.X metadata)?

I'm wondering if containers might make a better approach than
partitioning and creating separate raid volumes.  My thoughts are that
maybe using containers potentially simplify the management of drives, to
simply adding new or replacement drives to the raid container and having
them added into degraded arrays automatically or as spares (for live
migration when it gets implemented).

Is there any more documentation around on the usage of containers in md?

Thanks,

	Daniel Reurich
-- 
Daniel Reurich.

Centurion Computer Technology (2005) Ltd
Mobile 021 797 722



