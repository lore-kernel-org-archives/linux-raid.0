From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: RE: [PATCH] FIX: Cannot continue reshape if incremental assembly is
 used
Date: Wed, 7 Sep 2011 13:21:27 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB020100@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
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
> I can:
> 
> mdadm -C /dev/md/imsm -e imsm -n 4 /dev/sd[abcd]
> mdadm -C /dev/md/r5 -n3 -l5 /dev/md/imsm -z 2000000
> mdadm --wait /dev/md/r5
> mdadm -G /dev/md/imsm -n4
> sleep 10
> mdadm -Ss
> mdadm -I /dev/sda
> mdadm -I /dev/sdb
> mdadm -I /dev/sdc
> 
> array is started and reshape continues.
> 
> The problem is that container_content reports that array.working_disks is 3
> rather than 4.
> 'working_disks' should be the number of disks int the array that were working
> last time
> the array was assembled.
> However the imsm code only counts devices that can currently be found.
> I'm not familiar enough with the IMSM metadata to fix this.
> However by looking at the metadata on just one device in an array it should be
> possible
> to work out how many were working last time, and report that count.
> 

Neil, please consider the following script test-case (not 4 but 5 drives finally in the array):

mdadm -C /dev/md/imsm -e imsm -n 5 /dev/sd[abcde]
mdadm -C /dev/md/r5 -n3 -l5 /dev/md/imsm -z 2000000
mdadm --wait /dev/md/r5
mdadm -G /dev/md/imsm -n5
sleep 10
mdadm -Ss
mdadm -I /dev/sda
mdadm -I /dev/sdb
mdadm -I /dev/sdc
# array is not started and reshape does not continue!
mdadm -I /dev/sdd

and now array is started and reshape continues - the minimum required number of disks is added to array already.

So the question is:  when mdadm should start the array using incremental assembly?:
1) when minimum required number of disks is added and (degraded) array can be started or
2) when all disks that were working last time the array was assembled are added. 

If the second is true, there is another question: when to decide to give up waiting for non-present disks that can be (e.g.) removed meanwhile by user?

What do you suggest?

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

