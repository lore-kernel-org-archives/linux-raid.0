From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/3] imsm: Warn user about reboot risk
Date: Wed, 6 Apr 2011 12:41:42 +1000
Message-ID: <20110406124142.6bb26379@notabene.brown>
References: <20110405134609.4843.95211.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110405134609.4843.95211.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Tue, 05 Apr 2011 15:46:09 +0200 Adam Kwolek <adam.kwolek@intel.com> wrote:

> Current check-pointing implementation doesn't allow for interrupting reshape of boot arrays
> due to checkpoint restore has to be done before system start.
> There is problem with passing backup file name to array automatically mounted during boot time,
> especially when scan mode is used.
> 
> Until IMSM check-pointing implementation will be introduced, warning about reboot risk
> should be placed in mdadm.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>

These three have been applied (in the master branch).

Thanks,
NeilBrown

