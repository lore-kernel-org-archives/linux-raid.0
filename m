From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: Odd linux raid problems with debian testing.
Date: Tue, 18 Mar 2003 12:56:35 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D6DD@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'Paul Downs' <paul@positive-internet.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul,

3 partitions need to be mirrored for a root disk to be truly redundant:
   root (your /dev/md0)
   boot (presumably /dev/md1, mounted as /boot)
   swap (perhaps /dev/md2)

The lilo.conf for these (once they boot ok), would have:
boot=/dev/md1
...
root=/dev/md0

Of course the partition types should be set to fd (Linux Raid) also.

See the Software-RAID-HOWTO from http://www.tldp.org/docs.html#howto
or http://scsirastools.sourceforge.net/docs/UserGuide section 4.0 
for more information.

Andy

-----Original Message-----
From: Paul Downs [mailto:paul@positive-internet.com] 
Sent: Tuesday, March 18, 2003 1:19 PM
To: linux-raid@vger.kernel.org
Subject: Odd linux raid problems with debian testing.



Hi,
  Sorry if this subject is already done to death on the group but I have
read the archives through google and couldn't find anything similar.  Also
apologies for the rather long winded post, just be thankful I didn't include
all the straces... ;-P

  I have an easily repeatable problem with software raid and kernel
2.4.18/19 + raidtools2 under debian.

  The root device (/dev/md0) has /dev/hda1 and /dev/hdc1. Here is a chunk of
the lilo.conf:

[----- lilo.conf -----]
# Specifies the boot device.  This is where Lilo installs its boot
# block.  It can be either a partition, or the raw device, in which
# case it installs in the MBR, and will overwrite the current MBR.
#
boot=/dev/hda

# Specifies the device that should be mounted as root. (`/')
#
root=/dev/hda1
[---------------------]

  You cannot do the following:

raidhotadd /dev/md0 /dev/hda1

  as it returns this:

/dev/md0: can not hot-add disk: invalid argument.

  an strace indicates:
[...]
