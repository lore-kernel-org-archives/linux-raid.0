From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: Software RAID-1: step-by-step help needed...
Date: Tue, 10 Aug 2004 22:19:17 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <87y8knxk1m.fsf@enki.rimspace.net>
References: <41188A95.5000608@provincia.verbania.it>
	<Pine.LNX.4.56.0408100948230.1665@lion.drogon.net>
	<411892D0.8050701@provincia.verbania.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10 Aug 2004, Boniforti Flavio wrote:
> Gordon Henderson wrote:
>
>> You can do either. Personally, I create identical partitions on each drive
>> and then mirror them.
>
> OK. What would be the difference (in terms of performance and/or ease of
> configuration/maintenance) between the two methods?

Partitions are vastly easier than whole-disk mirrors. If you set the
partition type to 'fd' and compile in the requisite RAID stuff the
kernel will start the RAID devices for you automatically.

Doing whole-disk mirrors, or modular RAID, requires an initrd to be in
place to create the root disk for you. This is harder, although some
distributions automate the process for you.

>> Probably the easiest way to get started is to pick a distribution that
>> lets you build the disks as a mirror from install time - Eg. Red Hat (or
>> whatever it's called these days) If you have an existing server with one
>> disk and want to add a 2nd as a mirror, thats not too difficult. you need
>> to read the stuff in the Software RADI HowTo which has the information on
>> how to do it all.
>
> I see, but I *have to* install Debian on it.
> I already installed it (as a test) following the instructions found at:
> http://www.inittab.de/manuals/debootstrap.html
> I guess the hardest task will be configuring RAID, as the system works 
> with the above procedure...

The easiest way to get a RAID array in Debian is to install the testing
or unstable branch; the installer there supports creating the devices as
part of the boot sequence.

For Debian/stable, the process is also relatively easy but not
automatic:

1. Partition both disks the way you want.
2. Install Debian to the first hard disk, with no RAID.
3. Install mdadm.
4. Create "degraded" RAID devices using only the second disk.
5. Boot to a non-intrusive mode (init=/bin/sh, usually).
6. Use 'tar' or whatever to transfer data from the hard disk to the RAID
   device.
7. Edit fstab, etc, in the RAID partition.
8. Boot with the RAID device as your root device.
9. Hot-add the other partitions to the running RAID devices.

This is a pretty trivial process, but a bit time consuming. Degraded
mirrors make it pretty easy, though, and I have done it many times while
installing systems.

Regards,
        Daniel
-- 
All television is children's television.
        -- Richard P. Adler

