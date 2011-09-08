From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: RE: [PATCH] FIX: Cannot continue reshape if incremental assembly is
 used
Date: Thu, 8 Sep 2011 08:26:53 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB02034E@IRSMSX101.ger.corp.intel.com>
References: <20110901131839.3293.49295.stgit@gklab-128-085.igk.intel.com>
	<CAA9_cme3X1T+nE4+-ADHJ-MkOtywKbKmN7Gw=BngjePMK5wssg@mail.gmail.com>
 <20110907123759.3b4106bb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110907123759.3b4106bb@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Wed, Sep 07, 2011 4:38 AM Neil Brown <neilb@suse.de> wrote:
> 
> On Tue, 6 Sep 2011 14:34:42 -0700 Dan Williams <dan.j.williams@intel.com>
> wrote:
> 
> > On Thu, Sep 1, 2011 at 6:18 AM, Lukasz Dorau <lukasz.dorau@intel.com>
> wrote:
> > > Description of the bug:
> > > Interrupted reshape cannot be continued using incremental assembly.
> > > Array becomes inactive.
> > >
> > > Cause of the bug:
> > > Reshape tried to continue with insufficient number of disks
> > > added by incremental assembly (tested using capacity expansion).
> > >
> > > Solution:
> > > During reshape adding disks to array should be blocked until
> > > minimum required number of disks is ready to be added.
> >
> > Can you provide a script test-case to reproduce the problem?
> 

The patch originally was intended to fix the following issue:

export MDADM_EXPERIMENTAL=1
mdadm -C /dev/md/imsm0 -amd -e imsm -n 2 /dev/sda /dev/sdb -R
mdadm -C /dev/md/raid1-0 -amd -l1  --size 5G -n 2 /dev/sda /dev/sdb -R 
mdadm --wait /dev/md/raid1-0 
mdadm /dev/md/imsm0 --add /dev/sdc
mdadm /dev/md/imsm0 --add /dev/sdd
mdadm -G /dev/md/raid1-0 -l0 
mdadm -G /dev/md/imsm0 -n 4 
sleep 5
mdadm -Ss
mdadm -I /dev/sda
mdadm -I /dev/sdb
# At this moment mdadm tries to start array and continue reshape,
# however there is insufficient number of disks, so it fails
# (not enough operational devices - failed to run raid set)
# - see syslog below.
mdadm -I /dev/sdc
# array is not started and reshape does not continue
mdadm -I /dev/sdd
# array is not started and reshape does not continue


### syslog:
kernel: md: bind<sda>
kernel: md: bind<sdb>
kernel: md: bind<sda>
kernel: md: bind<sdb>
kernel: bio: create slab <bio-1> at 1
kernel: md/raid:md126: reshape will continue
kernel: md/raid:md126: device sdb operational as raid disk 0
kernel: md/raid:md126: device sda operational as raid disk 1
kernel: md/raid:md126: allocated 5334kB
kernel: md/raid:md126: not enough operational devices (3/5 failed)
kernel: md/raid:md126: failed to run raid set.
kernel: md: pers->run() failed ...
kernel: md: bind<sdc>
kernel: md: bind<sdd>
kernel: md: bind<sdd>
kernel: md: bind<sdc>
kernel: md: export_rdev(sda)
kernel: md: export_rdev(sdb)

Regards,
Lukasz 

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

