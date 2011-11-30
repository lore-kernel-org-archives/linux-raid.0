From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 01/11] imsm: FIX: Return longer map for failure setting
Date: Tue, 29 Nov 2011 18:30:52 -0800
Message-ID: <CAA9_cmdeSfx6dZVwUZ-00mLfFAi+PPKcGCDLBpB8icA5BS4j6g@mail.gmail.com>
References: <20111124121516.5254.48774.stgit@gklab-128-013.igk.intel.com>
	<20111124121718.5254.16301.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111124121718.5254.16301.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

On Thu, Nov 24, 2011 at 4:17 AM, Adam Kwolek <adam.kwolek@intel.com> wrote:
> When 2 maps are present, IMSM can use shorter map for setting disk
> in to degraded state. It can happen that degraded disk can be not present
> in shorter map.
> We should use longer map for setting disk in to degraded state.

I don't understand this patch.  If we are setting a new degraded disk
migration is idle and the degraded state is set in map[0].

--
Dan
