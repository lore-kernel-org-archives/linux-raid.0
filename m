From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 05/10] Add spares to raid0 array using takeover
Date: Fri, 3 Dec 2010 14:52:25 +1100
Message-ID: <20101203145225.2acd7436@notabene.brown>
References: <20101202080818.4639.38119.stgit@gklab-170-024.igk.intel.com>
	<20101202081920.4639.78609.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101202081920.4639.78609.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Thu, 02 Dec 2010 09:19:20 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> Spares are used by Online Capacity Expansion to expand array.
> To run expansion on raid0, spares have to be added to raid0 volume also.
> Raid0 cannot have spares (no mdmon runs for raid0 array).
> To do this, takeover to raid5 (and back) is used. mdmon runs temporary for raid5 and spare drives can be added to container.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>

This is just wrong.

If mdmon is running (maybe because some other array in the container needs
it) then you add a spare to the container and send mdmon a metadata update to
apply.

If mdmon is not running, then you add a spare to the container and apply a
metadata update directly in mdadm.

There is no need to switch to raid5 and back just to add a spare.

NeilBrown

