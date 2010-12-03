From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 00/10] Pre-migration patch series
Date: Fri, 3 Dec 2010 15:19:49 +1100
Message-ID: <20101203151949.6fc4fbc2@notabene.brown>
References: <20101202080818.4639.38119.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101202080818.4639.38119.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Thu, 02 Dec 2010 09:18:41 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> This is bunch of patches that I've pull from my OLCE/Migration tree and I believe that
> they can be applied before we apply main feature (I'm curently going for some rework after your feedback).
> 
> This series is for some behaviours of mdadm that I've forund so far. 
> Mainly they are bugs that are present in code or behaviour that I've observe using takeover (i.e. geo map fix).
> Some of them are not visible at this moment, when we reshape big arrays (i.e. wait functions fixes) etc.
> 
> 
> ---

Thanks.
> 
> Adam Kwolek (10):
>       FIX: wait_backup() sometimes hungs
applied.

>       FIX: Honor !reshape state on wait_reshape() entry
Applied.

>       FIX: sync_completed_fd handler has to be closed
applied.  Also closed metadata_version_fd.

>       FIX: Do not use layout for raid4 and raid0 while geo map computing
applied.

>       FIX: open backup file for reshape as function
applied

>       Add spares to raid0 array using takeover
Not applied, as explained.

>       Add support to skip slot configuration
Applied.

>       FIX: Add error code for raid_disks set
Not applied.  As Dan said, this doesn't make sense in the current code.

>       FIX: Problem with removing array after takeover
Not applied as explained.

>       FIX: Cannot exit monitor after takeover
Applied.


Thanks,
NeilBrown


> 
> 
>  Grow.c      |  137 +++++++++++++++++++++++++++++++++++++----------------------
>  Manage.c    |  120 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>  managemon.c |    1 
>  mdadm.h     |    8 +++
>  monitor.c   |   16 +++++++
>  msg.c       |    8 +++
>  restripe.c  |    5 ++
>  sysfs.c     |    3 +
>  8 files changed, 242 insertions(+), 56 deletions(-)
> 

