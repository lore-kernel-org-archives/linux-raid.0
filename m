From: ross@jose.lug.udel.edu (Ross Vandegrift)
Subject: Re: raid5 recovery fails
Date: Mon, 14 Nov 2005 15:52:51 -0500
Message-ID: <20051114205251.GA4040@jose.lug.udel.edu>
References: <5d96567b0511141127v63377f0and41f998230a38dd7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5d96567b0511141127v63377f0and41f998230a38dd7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Nov 14, 2005 at 09:27:25PM +0200, Raz Ben-Jehuda(caro) wrote:
> I have made the following test with my raid5:
> 1. created raid5 with 4 sata disks.
> 2. waited untill raid was fully initialized.
> 3. pulled a disk from the panel.
> 4. shut the system.
> 5. put back the disk.
> 6. turn on the system.
> 
> The raid failed failed to recver. i got message from the md layer
> saying that it rejects the dirty disk.
> Anyone ?

Did you re-add the disk to the array?

# mdadm --add /dev/md0 /dev/sda2

Of course, substitude your appropriate devices for the ones that I
randomly chose ::-)


-- 
Ross Vandegrift
ross@lug.udel.edu

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
