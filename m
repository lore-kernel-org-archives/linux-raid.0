From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: MD array keeps resyncing after rebooting
Date: Sat, 3 Aug 2013 13:02:37 +0200
Message-ID: <CAC9WiBj1STmwgUswei--dr1YSbnpPgc9M8thvGuAK1wziKa==Q@mail.gmail.com>
References: <CAC9WiBjm5-RJ=CfpXMG7CCBp7StzWDuhp5XyFs4hAW3sxX7Gfw@mail.gmail.com>
	<CAC9WiBjs4DQqt1G911OBALzSqn=o_=L1S4_K_MvUWhAu-rhtUw@mail.gmail.com>
	<51EED0DA.3020901@arcor.de>
	<51EED102.4020503@arcor.de>
	<CAC9WiBgN1-HBEgqwo7CWor=nihCYUcOrYKhGxYTgbC-d4a7_-g@mail.gmail.com>
	<51EEF3D3.7020305@arcor.de>
	<CAC9WiBgrjrPRcHa5kh8TUfqN0rBBFC4M0_8iDkU3O0SOFgFW5g@mail.gmail.com>
	<CAC9WiBjQz6MJxBuw+cLWFZ-vOsdbYYSKdE575emH_AG5EmnGdw@mail.gmail.com>
	<51F1754B.5000905@arcor.de>
	<CAC9WiBhgF_-Ya7GW8DW0DcOQ-UhpN503hr=6_=46W5nbK04FTQ@mail.gmail.com>
	<51FAA5C3.8030109@arcor.de>
	<CAC9WiBhGyE=OJdSeL_OsPxtirhJ2=3WRsk=uBPiOTzMjBCf-dA@mail.gmail.com>
	<51FBF830.5060606@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51FBF830.5060606@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Martin,

First of all, thanks a lot for your detailed analysis.

On Fri, Aug 2, 2013 at 8:19 PM, Martin Wilck <mwilck@arcor.de> wrote:
> On 08/02/2013 02:46 PM, Francis Moreau wrote:
>
>> Please tell me if you can find something suspicous.
>
> One thing that I can see is that your BIOS seems to use the same time
> stamp everywhere. It is clear from the dump that the BIOS has changed
> the timestamp in the VD GUID, too. The timestamp used in the
> "before-bios" data is 2013-08-02 08:21:10, the timestamp after is
> 2013-08-02 14:27:27. Wonder if that fits?

Probably. I booted the system at 8:21, let the resync finish and did
the dump after. So it seems to fit.

>
> The spec says that the VD GUID consists of the vendor ID ("LSI     " in
> your case), controller type (the controller's PCI ID,
> 8086:1d60:0000:0000), the 4-byte time stamp, and a "random number"
> (0000 1450). Strangely, I also have an LSI fake RAID and it uses the
> same random number. It even generated the same number through several
> RAID creations. Seems to be a truly strange random number generator :-)
>
> All in all, this makes your controller's RAID GUIDs very predictable.
> But they change whenever the timestamp changes. It also explains why
> this controller can't have more than a single array.
>
> But that's not what you wanted to know, right?

Well that was very instructive, thanks.

> Besides the time stamp,
> sequence number, and CRC32, there is actually no difference between the
> two dumps. The suspicious part is here, same in both dumps:
>
> 00000860  00 00 ff ff ff ff ff ff  ff ff ff ff ff ff ff ff
>
> The first two bytes in thus line are the state and init state, and the
> meaning is "Optimal, consistent, *not initialized*".
> And this is before *and* after BIOS started. Suspiciously, this doesn't
> match what you wrote before:
>
>> I checked during the shudown process that the array is correctly
>> > stopped since at that point I got:
>> >
>> > # mdadm -E /dev/sda | egrep "state"
>> >         state[0] : Optimal, Consistent
>> >    init state[0] : Fully Initialised
>
> This would correspond to "00 02", and it's what we should see after
> initialization. On my system the BIOS sets "00 01" (Optimal, consistent,
> Quick Init in progress) when it first creates an array, because the BIOS
> doesn't do a full initialization. But "not initialized" is weird. The
> mdadm DDF code won't set this by itself, AFAIK. Please make sure again
> that the "before" data matches what mdadm/mdmon wrote just after
> stopping during shutdown.

I'm pretty sure that's the "before" dump was just after stopping the
array, this is how I proceed: during the shutdown, I stop the system
right after "mdadm -S", then I checked the state  of the array with
"mdadm -E", which was initialized for sure. Then I powered off the
machine, removed one disk and did the "before" dump from my laptop.
After that I booted the machine with the disk in place until grub menu
appeared. I then powered off the machine and did the same procedure as
previously to get "after" dump.

Perhaps some data were still in a "cache" and was not written to the
disk when the power-off/reboot did happen ?

Maybe one thing that worths to note is that the same disk array
configuration with the same system works fine on qemu.
-- 
Francis
