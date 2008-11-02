From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [mdadm git pull] "--assemble --scan" support for imsm
Date: Sun, 02 Nov 2008 16:15:52 -0700
Message-ID: <1225667752.14396.22.camel@dwillia2-linux.ch.intel.com>
References: <1225230241.5778.26.camel@dwillia2-linux.ch.intel.com>
	 <18696.10925.969583.445231@notabene.brown>
	 <e9c3a7c20810290912k6530790dv5cf7f6db8ff40389@mail.gmail.com>
	 <18697.11562.810718.957829@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18697.11562.810718.957829@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 2008-10-29 at 20:42 -0700, Neil Brown wrote:
> To fit the assembly of a specific member of a container into this
> model, we need to have the 'container' in the list of available
> devices.
> If the identity specifies 'container=whatever' then we clearly select
> all devices which match that.  You would expect at exactly one - the
> container.  You would then need to call ->container_content on that
> container and find the correct member array which matches the
> 'member=' specifier (or any other specifier there might be?)
> 
> Exactly how updates and "--force" are passed though would need to be
> sorted out.
> Then the devices in the selected array from ->container_content could
> be passed to sysfs_add_disk and the array started.
> 
> Auto-assembly would discover that the first unused-so-far device was a
> container, and would need to load the list of arrays and assemble the
> first one that was not yet assembled.
> 

I had a go at this, and the result is pushed out to my scratch-devel
branch.  mdadm can now:

1/ Scan and assemble container members
mdadm -Es > mdadm.conf
cat mdadm.conf
ARRAY metadata=imsm auto=md UUID=88f0b659-966978a7-842f86c0-879a414d
ARRAY /dev/md/r1 container=88f0b659-966978a7-842f86c0-879a414d
   member=0 auto=mdp UUID=42d6de62-bd27b267-96e8e960-13efc3a6
ARRAY /dev/md/r2 container=88f0b659-966978a7-842f86c0-879a414d
   member=1 auto=mdp UUID=b0764c97-8b4fdf0e-0821862e-a80f1452
mdadm -Asc mdadm.conf
mdadm: Container /dev/md/imsm127 has been assembled with 6 drives
mdadm: Started /dev/md/r1 with 6 devices
mdadm: Started /dev/md/r2 with 6 devices

2/ Assemble member array by uuid
mdadm -A /dev/md/r1 /dev/md/imsm -a mdp -u 42d6de62-bd27b267-96e8e960-13efc3a6

3/ Auto-assemble member arrays as foreign arrays

This still does not handle updates or --force... it seems awkward to try
and support --force at anything other than the container level, but that
is the extent of my thinking so far.

The following changes since commit fb9253084ab0b9e4ac1113e4fc8f0b88d818d4f8:
  NeilBrown (1):
        mdopen:  fix up name parsing.

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/mdadm.git scratch-devel

Dan Williams (21):
      Quiet uninitialized variable warnings
      Makefile: fixup install of udev rules
      imsm: match_home(), document why it is stubbed out
      Let symlinks to standard devices count as standard names
      imsm: display member array uuid in examine_super_imsm
      imsm: display container uuid in detail_super
      config: add 'containers' as a DEVICE keyword
      Add a 'container' flag to mddev_dev_t
      Assemble: check if the devlist entry is a container
      Assemble: let trustworthy be LOCAL when array is identified
      Assemble: replace 'info' with 'content'
      Assemble: teach it to look inside containers for matching arrays
      Assemble: discard non-container devices when not required
      cleanup an unused call to container2devname
      config: add containers to the default search list
      Assemble: revert preliminary -As support
      Copy container_dev in dup_super
      Assemble: factor out and call assemble_container_content
      fixup create_mddev
      Assemble: block attempts to reassemble container members
      Assemble: enable member array auto-assembly

 Assemble.c    |  428 ++++++++++++++++++++++++++++++++++++++-------------------
 Incremental.c |   99 +------------
 Makefile      |    4 +-
 config.c      |   46 ++++++-
 mdadm.c       |    1 +
 mdadm.h       |   17 ++-
 mdmon.c       |    9 ++
 mdopen.c      |    7 +-
 super-intel.c |   37 ++++--
 util.c        |  155 ++++++++++++++++++++-
 10 files changed, 542 insertions(+), 261 deletions(-)


