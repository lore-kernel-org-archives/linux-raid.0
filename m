From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: can metadata type be changed for an active array?
Date: Fri, 27 Feb 2009 20:30:31 +0100
Message-ID: <20090227193031.GA6602@lazy.lzy>
References: <dbd51810902261112h26ca8429l835272401f555c54@mail.gmail.com> <983bc6fdcd28a2885e2c5933dafc72eb.squirrel@neil.brown.name> <dbd51810902262110t5c5a996ew42662c9b399812ab@mail.gmail.com> <ca0a760919ed20431e24003d08b30998.squirrel@neil.brown.name> <dbd51810902262144r7af0ba60n918df5c6e736988a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dbd51810902262144r7af0ba60n918df5c6e736988a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: PGNet <pgnet.trash+raid@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> clearly best i read up more, and -- for now -- get it right the 1st
> time @ create.

well, for RAID-1 types, there is a (dirty) trick
to change this kind of information.

Mount the partition read-only, if it is not
possible (system), you'll have to use a live CD.
Fail and remove one of the components of the RAID-1.
Zero the superblock of the removed component and
re-create a RAID-1, using a "missing" device,
setting the proper features, with this component.
Create a filesystem on the new RAID-1 volume.
Mount it read-write and copy the files from the old
to the new.
Stop the old RAID-1 volume, zero the superblock, add
the, now clean, component to the newly created array.

Now, this could be risky, of course, since during
the process there is no mirror.
Also, if you make a mistake and do not realize in
time, there is the possibility to end up with no
data in both RAIDs.

This means that, clearly, if you try this trick,
you'll do at your own risk...

bye,

-- 

piergiorgio
