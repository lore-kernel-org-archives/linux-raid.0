From: Neil Brown <neilb@suse.de>
Subject: Re: [mdadm PATCH 00/13] rebuild / resync checkpointing and other
 external metadata fixes
Date: Wed, 30 Dec 2009 13:56:50 +1100
Message-ID: <20091230135650.05f80646@notabene.brown>
References: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

On Tue, 22 Dec 2009 16:59:19 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Hi Neil,
> 
> The latter half of this update consumes the new
> md/dev-XXX/recovery_start attribute for checkpointing and resuming
> resync/rebuild operations.  It requires one more kernel patch [1] on top
> of 2.6.33-rc1 to ensure that mdmon sees the recovery state.  One caveat
> is that we only get checkpoint events when the sync_action == idle, at
> array shutdown or as a part of 'mdadm --wait-clean --scan'.
> 
> The other bits are a collection of fixes to address unrelated issues
> discovered along the way.  The result is pushed out to:
> 
> 	git://github.com:djbw/mdadm.git master
> 
> Please have a look.

Thanks.  Looks good.  Applied.

NeilBrown
