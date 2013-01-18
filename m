From: Jes.Sorensen@redhat.com
Subject: [PATCH 0/2] add support for launching mdmon via systemd
Date: Fri, 18 Jan 2013 09:43:10 +0100
Message-ID: <1358498592-20827-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com, harald@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

It's been an ongoing issue for a while trying to figure out how to
handle launching mdmon from the initrd in Fedora and avoid it getting
killed by systemd due to it ending up in the wrong cgroup (udev).

We tried simply attaching mdmon to the cgroup of systemd but it didn't
really work, and in the end it seems to be more in line with the
systemd mentality to have systemd spawn it. With these patches and a
few pending changes to dracut, I am finally able to boot and reboot
systems with 1 or 2 IMSM arrays.

The patch for systemctl is implemented as a compile time option rather
than a command line option, since I think it is something that the
distro will decide. However we can make it a command line option if
preferred.

I also have matching systemd .service files for this, which I am happy
to contribute, but I am not sure if they are useful to other distros
or not? We haven't had a history of including .service files with
mdadm.

Cheers,
Jes


Jes Sorensen (2):
  Add support for launching mdmon via systemctl instead of fork/exec
  execl() only returns in case of error

 Makefile |  6 ++++++
 mdmon.c  |  4 +++-
 util.c   | 15 ++++++++++++++-
 3 files changed, 23 insertions(+), 2 deletions(-)

-- 
1.7.11.7

