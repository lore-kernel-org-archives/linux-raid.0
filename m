From: <linux-raid.vger.kernel.org@atu.cjb.net>
Subject: =?UTF-8?B?UmU6IFJBSUQtNiBtZGFkbSBkaXNrcyBvdXQgb2Ygc3luYyBpc3N1ZSAoZml2ZSBxdWVzdGlvbnMp?=
Date: Thu, 11 Jun 2009 12:43:42 -0600
Message-ID: <200906111843.n5BIhlcN024789@cjb.net>
References: <ed308b763e18e168a98f977857663bed.squirrel@neil.brown.name>
Reply-To: <linux-raid.vger.kernel.org@atu.cjb.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ed308b763e18e168a98f977857663bed.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> wrote :
> Once you are sure you have the 6 drives with the highest
> event counts working, assemble them with
>
> mdadm --assemble /dev/md13 --force /dev/sd?1

I had a few questions before I went ahead with the
reassembly:

1) Does it matter which order the disks are listed in when
reassembling the array (e.g. /dev/sda1 /dev/sdh1 ...)?

2) Is there any risk to the data stored on the disks by
merely reassembling the six working disks with the above
command?

3) Does /sys/module/md_mod/parameters/start_ro being
set to 1 prevent the array from syncing/rebuilding/etc.,
or does it only prevent new user data being written to
the array?  If it only prevents user data being written
to the /dev/md*, is there some way to also prevent mdadm
from doing syncing/rebuilding/etc. so I can be sure the
data is not at risk of further damage while testing?

4) Having checked what the "Events" refers to (I thought it
was write-syncing operations before), should I be worried
at the Event count being above 1,000,000?  I have rebuilt
two failed disks and the distro performed a few data
integrity checks on all the disks.  The array is about
nine to ten months old.

5) Any idea why "shutdown -h now" would cause three of
the six working disks to gain 4 events each (happened with
the filesystem unmounted from /dev/md13)?

 - S.A.





