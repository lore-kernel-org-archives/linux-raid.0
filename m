From: NeilBrown <neilb@suse.com>
Subject: ANNOUNCE: mdadm 3.3.4 - A tool for managing md Soft RAID under
 Linux
Date: Wed, 5 Aug 2015 08:04:34 +1000
Message-ID: <20150805080434.0b78fb74@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



I am somewhat disappointed to have to announce the availability of
   mdadm version 3.3.4

It is available at the usual places:
   http://www.kernel.org/pub/linux/utils/raid/mdadm/
and via git at
   git://github.com/neilbrown/mdadm
   git://neil.brown.name/mdadm
   http://git.neil.brown.name/git/mdadm.git

In mdadm-3.3 a change was made to how IMSM (Intel Matrix Storage
Manager) metadata was handled.  Previously an IMSM array would only
be assembled if it was attached to an IMSM controller.

In 3.3 this was relaxed as there are circumstances where the
controller is not properly detected.  Unfortunately this has negative
consequences which have only just come to light.

If you have an IMSM RAID1 configured and then disable RAID in the
BIOS, the metadata will remain on the devices.  If you then install
some other OS on one device and then install Linux on the other, Linux
might eventually start noticing the IMSM metadata (depending a bit on whether
mdadm is included in the initramfs) and might start up the RAID1.  This could
copy one device over the other, thus trashing one of the installations.

Not good.

So with this release IMSM arrays will only be assembled if attached to
an IMSM controller, or if "--force" is given to --assemble, or if the
environment variable IMSM_NO_PLATFORM is set (used primarily for
testing).

I strongly recommend upgrading to 3.3.4 if you are using 3.3 or later.

NeilBrown 3rd August 2015.
