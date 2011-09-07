From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] FIX: Cannot continue reshape if incremental assembly is
 used
Date: Wed, 7 Sep 2011 12:37:59 +1000
Message-ID: <20110907123759.3b4106bb@notabene.brown>
References: <20110901131839.3293.49295.stgit@gklab-128-085.igk.intel.com>
	<CAA9_cme3X1T+nE4+-ADHJ-MkOtywKbKmN7Gw=BngjePMK5wssg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cme3X1T+nE4+-ADHJ-MkOtywKbKmN7Gw=BngjePMK5wssg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Lukasz Dorau <lukasz.dorau@intel.com>, linux-raid@vger.kernel.org, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Tue, 6 Sep 2011 14:34:42 -0700 Dan Williams <dan.j.williams@intel.com>
wrote:

> On Thu, Sep 1, 2011 at 6:18 AM, Lukasz Dorau <lukasz.dorau@intel.com> wrote:
> > Description of the bug:
> > Interrupted reshape cannot be continued using incremental assembly.
> > Array becomes inactive.
> >
> > Cause of the bug:
> > Reshape tried to continue with insufficient number of disks
> > added by incremental assembly (tested using capacity expansion).
> >
> > Solution:
> > During reshape adding disks to array should be blocked until
> > minimum required number of disks is ready to be added.
> 
> Can you provide a script test-case to reproduce the problem?

I can:

mdadm -C /dev/md/imsm -e imsm -n 4 /dev/sd[abcd]
mdadm -C /dev/md/r5 -n3 -l5 /dev/md/imsm -z 2000000
mdadm --wait /dev/md/r5
mdadm -G /dev/md/imsm -n4
sleep 10
mdadm -Ss
mdadm -I /dev/sda
mdadm -I /dev/sdb
mdadm -I /dev/sdc

array is started and reshape continues.

The problem is that container_content reports that array.working_disks is 3 rather than 4.
'working_disks' should be the number of disks int the array that were working last time
the array was assembled.
However the imsm code only counts devices that can currently be found.
I'm not familiar enough with the IMSM metadata to fix this.
However by looking at the metadata on just one device in an array it should be possible
to work out how many were working last time, and report that count.

NeilBrown

