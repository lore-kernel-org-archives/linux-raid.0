From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: Re: raid5 recovery fails
Date: Tue, 15 Nov 2005 08:29:27 +0200
Message-ID: <5d96567b0511142229u2f0d131j14bd2c4912f1b3a7@mail.gmail.com>
References: <5d96567b0511141127v63377f0and41f998230a38dd7@mail.gmail.com>
	 <20051114205251.GA4040@jose.lug.udel.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051114205251.GA4040@jose.lug.udel.edu>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Ross Vandegrift <ross@jose.lug.udel.edu>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> mdadm --add /dev/md0 /dev/sda2..
yes , i am using raidstart for this.  it should be the same.
I am handling a big cluster with supermicro machines,each machine has its
own 4 sata disks.I am using 2.6.6 kernel.

Did you ever pulled out a disk from raid5 while the machine was running ?
Just want to know before i dive into the raid code that it is realy a bug.

On 11/14/05, Ross Vandegrift <ross@jose.lug.udel.edu> wrote:
> On Mon, Nov 14, 2005 at 09:27:25PM +0200, Raz Ben-Jehuda(caro) wrote:
> > I have made the following test with my raid5:
> > 1. created raid5 with 4 sata disks.
> > 2. waited untill raid was fully initialized.
> > 3. pulled a disk from the panel.
> > 4. shut the system.
> > 5. put back the disk.
> > 6. turn on the system.
> >
> > The raid failed failed to recver. i got message from the md layer
> > saying that it rejects the dirty disk.
> > Anyone ?
>
> Did you re-add the disk to the array?
>
> # mdadm --add /dev/md0 /dev/sda2
>
> Of course, substitude your appropriate devices for the ones that I
> randomly chose ::-)
>
>
> --
> Ross Vandegrift
> ross@lug.udel.edu
>
> "The good Christian should beware of mathematicians, and all those who
> make empty prophecies. The danger already exists that the mathematicians
> have made a covenant with the devil to darken the spirit and to confine
> man in the bonds of Hell."
>         --St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
>


--
Raz
