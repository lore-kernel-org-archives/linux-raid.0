From: George Duffield <forumscollective@gmail.com>
Subject: Re: Rebuilding a RAID5 array after drive (hardware) failure
Date: Mon, 26 May 2014 21:57:15 +0200
Message-ID: <CAG__1a6yGqmU3CD4HV5uSFL8h3Eu5=mK03kjOp1sw2xhsdhSyg@mail.gmail.com>
References: <CAG__1a52uiLi8PAm6deHyx14yQ8JfOmaiOicEn86kYBqJG_1HQ@mail.gmail.com>
	<20140522144905.50511c1a@notabene.brown>
	<CAG__1a4-MxTjiFMt4n3YsK0DxLvcT2raadcPLvKDuOam9JgPXw@mail.gmail.com>
	<CAG__1a7QFWguQ_YDzDCLO1xM9DMe8bZs-p97-Jc0CYCjpdusXg@mail.gmail.com>
	<20140526104640.0895483c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140526104640.0895483c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> - Can it be renamed to md0?
>
> Sure.
> If this is being assembled by the initrd, then either the initrd must set the
> hostname to "fileserver" before mdadm gets to assemble the array, or the
> initrd must contain an /etc/mdadm.conf which lists "/dev/md0" has having the
> UUID of this array.
>
> NeilBrown
>

I'm learning a few things the hard way here e.g. I had saved my
mdadm.conf to a file in the home folder of the default user so I could
reference it later if needs be - no flash, no file.  Next time email
it to myself.

If I were to run sudo update-initramfs -u would that restore things or
pretty much make md127 permanent.

In the event update-initramfs -u is not the way to go, it there an
example of a good mdadm.conf floating about that I can reference to
make the necessary changes?
