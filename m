From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm git pull] imsm fixes and general external metadata updates
Date: Wed, 21 Jan 2009 15:20:08 -0700
Message-ID: <1232576408.2029.56.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

The following changes since commit 78fbcc10312649f2f4f88283e3f19dce9b205733:
  NeilBrown (1):
        Merge branch 'master' into scratch-3.0

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/mdadm.git devel

Dan Williams (12):
      mdmon: fix missing ->subarray initialization
      imsm: fix dev_open return value handling
      imsm: imsm_read_serial check for zero-length response
      mdmon: expand permissible container device names
      mdmon: support scanning for containers
      Assemble: fix busy detection
      mdmon: make switchroot an undecorated option
      Create: allow per-metadata default layouts
      imsm: rename vprintf macro to pr_vrb
      imsm: enforce num_disks constraints
      imsm: enforce "all member disks must be members of all arrays"
      Create: warn when a metadata format's platform components are missing

 Assemble.c    |    3 +-
 Create.c      |   81 ++++++++++++++++++++++----------
 Detail.c      |    4 +-
 mdadm.h       |    4 +-
 mdmon.c       |  105 ++++++++++++++++++++++++++++-------------
 super-intel.c |  144 +++++++++++++++++++++++++++++++++++++++-----------------
 6 files changed, 234 insertions(+), 107 deletions(-)

Beyond the straightforward fixes the more interesting bits are:

mdmon: support scanning for containers
This is an attempt to make mdmon more manageable in the initramfs
environment.  Once mdadm has assembled the rootfs we need to switch the
currently running mdmon instance(s) over to the new mount point.  With
the current code it is awkward to do this in a generic way because a
script needs to know the names of all the active containers.  This tree
allows a script to do "mdmon /proc/mdstat /newroot" to batch convert all
mdmon instances to /newroot.  This is probably a good time to start
interfacing with initramfs@vger.kernel.org to make sure these "initramfs
helper" changes are relevant, and to see what else is missing.

Create: warn when a metadata format's platform components are missing
Currently if mdadm finds platform support for imsm it will block
creation of configurations that are not supported by the platform.
However if this support is not present it allows anything to be created.
This patch simply warns when mdadm cannot verify platform constraints.
The warning and verification can be silenced by setting
IMSM_NO_PLATFORM=1.

Please pull.

Thanks!
Dan

Full log:
commit 5615172f1d9daba1d5927758322f7addda803159
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Jan 20 01:36:51 2009 -0700

    Create: warn when a metadata format's platform components are missing
    
    If the metadata handler can not find its platform support components
    then there is no way for it to verify that the raid configuration will
    be supported by the option-rom.  Provide a generic method for metadata
    handlers to warn the user that the array they are about to create may
    not work as intended with a given platform.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a20d2ba5f32c76903ab6e32d83fa8c5e9c78d13f
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Jan 20 01:36:51 2009 -0700

    imsm: enforce "all member disks must be members of all arrays"
    
    This is a key orom-compatibility constraint.  A nice side effect is that
    it precludes the corner case of 'create' racing against 'spare activate'
    since the create will fail to convert a spare into an array member.  At
    create time we check if this is the first member array in the container
    if it is than all disks are possible candidates, if it is not then only
    current members are permitted.
    
    A bit hairier is spare-activation handling in the presence of this
    constraint.  It is difficult because spare handling is per array.  The
    approach taken is to:
    
    1/ check that a new spare can cover all defined arrays in the container
    2/ ensure that partially assimilated spares are the first candidates
       when looking for a spare region to activate.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 1c556e92bad85ab7591ddf5ac78b90513f315b32
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Jan 20 01:36:50 2009 -0700

    imsm: enforce num_disks constraints
    
    RAID1 == 2 disks
    RAID5 >= 3 disks
    RAID10 == 4 disks
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 35f81cbbc5ecc943c959f3c7153dcf6d83d1b994
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Jan 20 01:36:50 2009 -0700

    imsm: rename vprintf macro to pr_vrb
    
    Don't redefine standard library calls unnecessarily...
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a18a888ea7944aa1718e7a0daccb6f0a13b2e34d
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Jan 20 01:36:50 2009 -0700

    Create: allow per-metadata default layouts
    
    Let handlers specify their own defaults, specifically needed for the
    imsm-raid5 case where mdadm defaults to 'ls' and imsm to 'la'.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 5746141e3f48246cd51f74562e3f947e8d0ddf6a
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Jan 20 01:36:50 2009 -0700

    mdmon: make switchroot an undecorated option
    
    Simplify the usage from:
    	mdmon [--switch-root dir] /device/name/for/container
    to...
    	mdmon /device/name/for/container [target_dir]
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 66afdfa977d087a9cfae3175175537affd5ac6de
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Jan 20 01:36:50 2009 -0700

    Assemble: fix busy detection
    
    Use mddev_busy() as GET_ARRAY_INFO can succeed on 'clear' arrays.
    
    Ran into this after an encountering a case where mdadm -Ss ended in
    segfault (missing check for NULL return from map_by_devnum() in
    sles11:Manage.c).  So, tried to stop the array by hand with echo clear >
    md/array_state, after which I could not reassemble since GET_ARRAY_INFO
    was succeeding.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 1ffd2840df56eab568a5744c8d8a8484a42c18e2
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Jan 20 01:36:50 2009 -0700

    mdmon: support scanning for containers
    
    When the given container is '/proc/mdstat' then launch an mdmon instance
    per container found in /proc/mdstat.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 6f4098a6fd809acd6ef6a80051eec09f4536a27d
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Jan 20 01:36:50 2009 -0700

    mdmon: expand permissible container device names
    
    Allow any path that dereferences to an md device to be used in addition
    to the current symbolic md device names.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 03cd4cc810fdaea1613fa6a792564aa96451f447
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Jan 20 01:33:56 2009 -0700

    imsm: imsm_read_serial check for zero-length response
    
    VMWare virtual disks successfully run the inquiry but return a zero response.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit be2c0e387b88c801a5b5f07d7f447a4dba97100e
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Jan 20 00:29:34 2009 -0700

    imsm: fix dev_open return value handling
    
    dev_open returns an fd
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit c1363b408f7b9f7a997c4cd706934a062bfca3bc
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Jan 13 15:46:05 2009 -0700

    mdmon: fix missing ->subarray initialization
    
    This can cause mdmon to fail at startup.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>


