From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Grub-install, superblock corrupted/erased and other animals
Date: Fri, 05 Aug 2011 05:32:25 -0500
Message-ID: <4E3BC6B9.8050803@hardwarefreak.com>
References: <CADz4AWHJU5GGBji9uVbvGjPZCZ0CxseiPsQbssCULWxqyKvG8A@mail.gmail.com> <20110802163907.29fc40b4@notabene.brown> <CADz4AWEWm68H4ON=+StNE8epBfbnVHnSwJo+NjfTf8-w5Bd2Ug@mail.gmail.com> <20110803150108.58f5c70b@notabene.brown> <CADz4AWFekPKreuiwzYBvTnbXZnDGRH7nQ1WKEaeOdn7_6M5eQg@mail.gmail.com> <20110803192054.6097d2c0@notabene.brown> <CADz4AWE20OdL4VecVOrOH5X-UqdB4BA00AW33YbYEtD1z30acA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADz4AWE20OdL4VecVOrOH5X-UqdB4BA00AW33YbYEtD1z30acA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Aaron Scheiner <blue@aquarat.za.net>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/5/2011 5:04 AM, Aaron Scheiner wrote:
> I followed your advice and ran a scalpel instance for every drive in
> the array. The scanning process finished this morning yay (and
> obviously went a lot faster).

Glad I could help.

...
> So now the next step would have been to re-create the array and check

Unless Neil has some hex editor (or other similar) trick up his sleeve
that would allow you to manually recreate the sectors you hosed
installing grub..

> if a file system check finds something... but because of the offsets
> that probably won't work ?

If you are able to use the Force to assemble the disks in the correct
order, getting the raid device back up and running, then run 'xfs_repair
-n /dev/md0' to do the check.  The '-n' means "no modify".  xfs_repair
is better than xfs_check in many aspects.  They are two separate code
paths that serve the same function, but they behave a little differently
under the hood.

> Thanks again :)

Wish I could have helped you recover the array.  When a patient comes
through emergency with 3 GSWs to the forehead and no pulse, there's
nothing that can be done.  :(

-- 
Stan
