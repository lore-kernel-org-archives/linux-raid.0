From: Neil Brown <neilb@suse.de>
Subject: Re: [mdadm git pull] imsm fixes and general external metadata updates
Date: Mon, 2 Feb 2009 10:46:21 +1100
Message-ID: <18822.13389.938876.964972@notabene.brown>
References: <1232576408.2029.56.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Wednesday January 21
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday January 21, dan.j.williams@intel.com wrote:
> Hi Neil,
> 
> The following changes since commit 78fbcc10312649f2f4f88283e3f19dce9b205733:
>   NeilBrown (1):
>         Merge branch 'master' into scratch-3.0
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/mdadm.git devel
> 

Thanks.


> Dan Williams (12):
>       mdmon: fix missing ->subarray initialization
>       imsm: fix dev_open return value handling
>       imsm: imsm_read_serial check for zero-length response
>       mdmon: expand permissible container device names
>       mdmon: support scanning for containers
>       Assemble: fix busy detection
>       mdmon: make switchroot an undecorated option
>       Create: allow per-metadata default layouts
>       imsm: rename vprintf macro to pr_vrb
>       imsm: enforce num_disks constraints
>       imsm: enforce "all member disks must be members of all arrays"
>       Create: warn when a metadata format's platform components are missing

This all looks fine, though I confess that I didn't read "all
member disks must be members of all arrays" very closely...

> 
> Beyond the straightforward fixes the more interesting bits are:
> 
> mdmon: support scanning for containers
> This is an attempt to make mdmon more manageable in the initramfs
> environment.  Once mdadm has assembled the rootfs we need to switch the
> currently running mdmon instance(s) over to the new mount point.  With
> the current code it is awkward to do this in a generic way because a
> script needs to know the names of all the active containers.  This tree
> allows a script to do "mdmon /proc/mdstat /newroot" to batch convert all
> mdmon instances to /newroot.  This is probably a good time to start
> interfacing with initramfs@vger.kernel.org to make sure these "initramfs
> helper" changes are relevant, and to see what else is missing.

We really need a man page for mdmon don't we.  Then this sort of text
could be placed there for safely.

All pulled.

Thanks.

NeilBrown
