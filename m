From: Jes.Sorensen@redhat.com
Subject: [PATCH 0/1] IMSM do not assume prev + current map in same state means reshape
Date: Mon, 17 Oct 2011 22:40:14 +0200
Message-ID: <1318884015-14749-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, dledford@redhat.com, lukasz.dorau@intel.com, adam.kwolek@intel.com, Marcin.Labun@intel.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

I believe there is a bug in the current IMSM code. It makes the
assumption that if the state of the previous map and the current map
are the same, it means we are trying to reshape the array. However if
you have a large array and just installed on it, and it was still
resyncing when you rebooted, it will come up in the same state and
'mdadm -Aa' will fail with an error that it is lacking a resync file.

This is what prevents an update Fedora 15 system from booting, such as
https://bugzilla.redhat.com/show_bug.cgi?id=736387

If I am missing something here, I'd appreciate to hear about it.

Thanks,
Jes

Jes Sorensen (1):
  IMSM only run reshape if number of disks has changed

 super-intel.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

-- 
1.7.6.4

