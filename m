From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 2] md: Introduction - bugfixes for md/raid{1,10}
Date: Tue, 12 Jun 2007 11:09:23 +1000
Message-ID: <20070612110634.25171.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Mike Accetta <maccetta@laurelnetworks.com>, Neil Brown <neilb@suse.de>, stable@kernel.org
List-Id: linux-raid.ids


Following are a couple of bugfixes for raid10 and raid1.  They only
affect fairly uncommon configurations (more than 2 mirrors) and can
cause data corruption.  Thay are suitable for 2.6.22 and 21-stable.

Thanks,
NeilBrown


 [PATCH 001 of 2] md: Fix two raid10 bugs.
 [PATCH 002 of 2] md: Fix bug in error handling during raid1 repair.
