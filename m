From: Ian Young <ian@duffrecords.com>
Subject: Re: I will pay money for the correct RAID recovery instructions
Date: Thu, 16 Oct 2014 15:08:07 -0700
Message-ID: <CANs+QMy7d+kAxazgdk_r+iPtK45+ddSMwEQg6M_6e4giqJgJmw@mail.gmail.com>
References: <CANs+QMz3jNpAneHLzN5c=EtK+RAOhQJZy=n3P0oYTRm7yNDzjg@mail.gmail.com>
	<20141016202202.GA22898@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141016202202.GA22898@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Ok, if I can pull this off I owe you a beer.

On Thu, Oct 16, 2014 at 1:22 PM, Robin Hill <robin@robinhill.me.uk> wrote:
> On Thu Oct 16, 2014 at 12:59:18pm -0700, Ian Young wrote:
>
>> I've been trying to fix a degraded array for a couple of months now
>> and it's getting frustrating enough that I'm willing to put a bounty
>> on the correct solution.  The array can start in a degraded state and
>> the data is accessible, so I know this is possible to fix.  Any
>> takers?  I'll bet someone could use some beer money or a contribution
>> to their web hosting costs.
>>
>> Here's how the system is set up:  There are (6) 3 TB drives.  Each
>> drive has a BIOS boot partition.  The rest of the space on each drive
>> is a large GPT partition that is combined in a RAID 10 array.  On top
>> of the array there are four LVM volumes: /boot, /root, swap, and /srv.
>>
>> Here's the problem:  /dev/sdf failed.  I replaced it but as it was
>> resyncing, read errors on /dev/sde kicked the new sdf out and made it
>> a spare.  The array is now in a precarious degraded state.  All it
>> would take for the entire array to fail is for /dev/sde to fail, and
>> it's already showing signs that it will.  I have tried forcing the
>> array to assemble using /dev/sd[abcde]2 and then forcing it to add
>> /dev/sdf2.  That still adds sdf2 as a spare.  I've tried "echo check >
>> /sys/block/md0/md/sync_action" but that finishes immediately and
>> changes nothing.
>>
> If sdf didn't finish syncing then it's no use adding it to the array as
> anything other than a spare. Also, you can't run a check on a degraded
> array (as there's nothing to check against), which is why that's
> finishing immediately.
>
> If sde is giving a read error during rebuild then the solution is to
> stop the array (you'll need to do this via a bootable CD/USB stick I
> guess) and use ddrescue to duplicate sde onto a new disk, The
> read errors may well mean that some can't be copied (though ddrescue
> will try very hard to do so), which may cause file/filesystem corruption
> later. You can then reassemble the (degraded) array with the old sda-sdd
> and the new sde, then add sdf and wait for the array to recover. You
> can then run a fsck on the filesystem to check for any corruption there.
> File corruption is a lot trickier to spot - if you have checksums for
> the files then that's one way, otherwise you may be able to work out
> what files are affected based on the offsets of the missing data (that's
> rather beyond the limits of my knowledge though).
>
> HTH,
>     Robin
> --
>      ___
>     ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
>    / / )      | Little Jim says ....                            |
>   // !!       |      "He fallen in de water !!"                 |
