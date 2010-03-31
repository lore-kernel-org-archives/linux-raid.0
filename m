From: Neil Brown <neilb@suse.de>
Subject: Re: Auto Rebuild on hot-plug
Date: Wed, 31 Mar 2010 12:42:07 +1100
Message-ID: <20100331124207.55d01146@notabene.brown>
References: <20100325113543.0e2124c5@notabene.brown>
	<70ed7c3e1003260052q3b65c76taa2f4d992c6f7eca@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e1003260052q3b65c76taa2f4d992c6f7eca@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: Doug Ledford <dledford@redhat.com>, Dan Williams <dan.j.williams@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, linux-raid@vger.kernel.org, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

On Fri, 26 Mar 2010 10:52:07 +0300
"Majed B." <majedb@gmail.com> wrote:

> Why not treat this similar to how hardware RAID manages disks & spares?
> Disk has no metadata -> new -> use as spare.
> Disk has metadata -> array exists -> add to array.
> Disk has metadata -> array doesn't exist (disk came from another
> system) -> sit idle & wait for an admin to do the work.

That would certainly be a sensible configuration to support.

> 
> As to identify disks and know which disks were removed and put back to
> an array, there's the metadata & there's the disk's serial number
> which can obtained using hdparm. I also think that all disks now
> include a World Wide Number (WWN) which is more suitable for use in
> this case than a disk's serial number.
> 
> Some people rant because they see things only from their own
> perspective and assume that there's no case or scenario but their own.
> So don't pay too much attention :p
> 
> Here's a scenario: What if I had an existing RAID1 array of 3 disks. I
> bought a new disk and I wanted to make a new array in the system. So I
> add the new disk, and I want to use one of the RAID1 array disks in
> this new array.
> 
> Being lazy, instead of failing the disk then removing it using the
> console, I just removed it from the port then added it again. I
> certainly don't want mdadm to start resyncing, forcing me to wait!

Lazy people often do cause themselves more work in the long run, there is
nothing much we can do about that.  Take it up with Murphy.

> 
> As you can see in this scenario, it includes the situation where an
> admin is a lazy bum who is going to use the command line anyway to
> make the new array but didn't bother to properly remove the disk he
> wanted. And there's the case of the newly added disk.
> 
> Why assume things & guess when an admin should know what to do?
> I certainly don't want to risk my arrays in mdadm guessing for me. And
> keep one thing in mind: How often do people interact with storage
> systems?
> 
> If I configure mdadm today, the next I may want to add or replace a
> disk would be a year later. I certainly would have forgotten whatever
> configuration was there! And depending on the situation I have, I
> certainly wouldn't want mdadm to guess.

That is a point worth considering.  Where possible we should discourage
configurations that would be 'surprising'.
Unfortunately a thing that is surprising to one person in one situation may
be completely obvious to someone else in a different situation.

Thanks,
NeilBrown

