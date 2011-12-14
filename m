From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] FIX: Do not allow for multiple reshape_array() execution
	during reshape_container() call
Date: Wed, 14 Dec 2011 08:35:16 +0100
Message-ID: <20111214073245.5416.339.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

I'm resending it again.
I've noticed that I've made mistake in comment so previously one has compilation problem.

Sorry for my mistake.

BR
Adam


---

Adam Kwolek (1):
      FIX: Do not allow for multiple reshape_array() execution during reshape_container() call


 Grow.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

-- 
Signature
