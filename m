From: Doug Ledford <dledford@redhat.com>
Subject: Re: Bug report: mdadm -E oddity
Date: Fri, 20 May 2005 08:30:12 -0400
Message-ID: <1116592212.23785.75.camel@compaq-rhel4.xsintricity.com>
References: <1115999051.3974.14.camel@compaq-rhel4.xsintricity.com>
	 <1116004267.3974.35.camel@compaq-rhel4.xsintricity.com>
	 <17029.12773.197506.463977@cse.unsw.edu.au>
	 <1116077316.13780.52.camel@compaq-rhel4.xsintricity.com>
	 <17037.35615.456231.737766@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17037.35615.456231.737766@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2005-05-20 at 17:00 +1000, Neil Brown wrote:
> On Saturday May 14, dledford@redhat.com wrote:
> > On Sat, 2005-05-14 at 09:01 +1000, Neil Brown wrote:
> > > On Friday May 13, dledford@redhat.com wrote:
> > > So there are little things that could be done to smooth some of this
> > > over, but the core problem seems to be that you want to use the output
> > > of "--examine --scan" unchanged in mdadm.conf, and that simply cannot
> > > work.
> > 
> > Actually, what I'm working on is Fedora Core 4 and the boot up sequence.
> > Specifically, I'm trying to get the use of mdadm -As acceptable as the
> > default means of starting arrays in the initrd.  My choices are either
> > this or make the raidautorun facility handle things properly.  Since
> > last I knew, you marked the raidautorun facility as deprecated, that
> > leaves mdadm (note this also has implications for the raid shutdown
> > sequence, I'll bring that up later).
> 
> I'd like to start with an observation that may (or may not) be helpful.
>   Turn-key and flexibility are to some extent opposing goals.
> 
> By this I mean that making something highly flexible means providing
> lots of options.  Making something "just works" tends to mean not using
> a lot of those options.
> Making an initrd for assembling md arrays that will do what everyone
> wants in all circumstances just isn't going to work.
> 
> To illustrate: some years ago we had a RAID based external storage box
> made by DEC - with whopping big 9G drives in it!!
> When you plugged a drive in it would be automatically checked and, if
> it was new, labeled as a spare.  It would then appear in the spare set
> and maybe get immediately incorporated into any degraded array.
> 
> This was a great feature, but not something I would ever consider
> putting into mdadm, and definitely not into the kernel.
> 
> If you want a turnkey system, there must be a place at which you say
> "This is a turn-key system, you manage it for me" and you give up some
> of the flexibility that you might otherwise have said.  For many this
> is a good tradeoff.
> 
> So you definitely could (or should be able to) make a single initrd
> script/program that gets things exactly right providing they were
> configured according to the model that is proscribed by the maker of
> that initrd.
> 
> Version-1 superblocks have fields intended to be used in exactly this
> way.
> 
> 
> > 
> > So, here's some of the feedback I've gotten about this and the
> > constraints I'm working under as a result:
> > 
> >      1. People don't want to remake initrd images and update mdadm.conf
> >         files with every raid change.  So, the scan facility needs to
> >         properly handled unknown arrays (it doesn't currently).
> 
> If this is true, then presumably people also don't want to update
> /etc/fstab with every filesystem change.  
> Is that a fair statement?  Do you automatically mount unexpected
> filesystems?  Is there an important difference between raid
> configuration and filesystem configuration that I am missing?
> 
> 
> >      2. People don't want to have a degraded array not get started (this
> >         isn't a problem as far as I can tell).
> 
> There is a converse to this.  People should be made to take notice if
> there is possible data corruption.
> 
> i.e. if you have a system crash while running a degraded raid5, then
> silent data corruption could ensue.  mdadm will currently not start
> any array in this state without an explicit '--force'.  This is somewhat
> akin to fsck sometime requiring human interaction.  Ofcourse if there
> is good reason to believe the data is still safe, mdadm should -- and
> I believe does -- assemble the array even if degraded.

Well, as I explained in my email sometime back on the issue of silent
data corruption, this is where journaling saves your ass.  Since the
journal has to be written before the filesystem proper updates are
writting, if the array goes down it either is in the journal write, in
which case you are throwing those blocks away anyway and so corruption
is irrelevant, or it's in the filesystem proper writes and if they get
corrupted you don't care because we are going to replay the journal and
rewrite them.

> 
> >      3. Udev throws some kinks in things because the raid startup is
> >         handled immediately after disk initialization and from the looks
> >         of things /sbin/hotplug isn't always done running by the time
> >         the mdadm command is run so occasionally disks get missed (like
> >         in my multipath setup, sometimes the second path isn't available
> >         and the array gets started with only one path as a result).  I
> >         either need to add procps and grep to the initrd and run a while
> >         ps ax | grep hotplut | grep -v grep or find some other way to
> >         make sure that the raid startup doesn't happen until after
> >         hotplug operations are complete (sleeping is another option, but
> >         a piss poor one in my opinion since I don't know a reasonable
> >         sleep time that's guaranteed to make sure all hotplug operations
> >         have completed).
> 
> I've thought about this issue a bit, but as I don't actually face it I
> haven't progressed very far.
> 
> I think I would like it to be easy to assemble arrays incrementally.
> Every time hotplug reports a new device, it if appears to be part of a
> known array, it gets attached to that array.
> 
> As soon as an array has enough disks to be accessed, it gets started
> in read-only mode.  No resync or reconstruct happens, it just sits and
> waits.
> If more devices get found that are part of the array, they get added
> too.  If the array becomes "full", then maybe it switches to writable.
> 
> With the bitmap stuff, it may be reasonable to switch it to writable
> earlier and as more drives are found, only the blocks that have
> actually been updated get synced.
> 
> At some point, you would need to be able to say "all drives have been
> found, don't bother waiting any more" at which point, recovery onto a
> spare might start if appropriate.
> There are a number of questions in here that I haven't thought deeply
> enough about yet, partly due to lack of relevant experience.

At least at bootup, it's easier and less error prone to just let the
devices get probed and not start anything until that's done.  Post
bootup, that may be a different issue.

> 
> >                            However, with the advent of stacked md
> >         devices, this problem has to be moved into the mdadm binary
> >         itself.  The reason for this (and I had this happen to me
> >         yesterday), is that mdadm started the 4 multipath arrays, but
> >         one of them wasn't done with hotplug before it tried to start
> >         the stacked raid5 array, and as a result it started the raid5
> >         array with 3 out 4 of devices in degraded mode.  So, it is a
> >         requirement of stacked md devices that the mdadm binary, if it's
> >         going to be used to start the devices, wait for all md device it
> >         just started before proceeding with the next pass of md device
> >         startup.  If you are going to put that into the mdadm binary,
> >         then you might as well as use it for both the delay between md
> >         device startup and the initial delay to wait for all block
> >         devices to be started.
> 
> I'm not sure I really understand the issue here, probably due to a
> lack of experience with hotplug.
> What do you mean "one of them wasn't done with hotplug before it tried
> to start the stacked raid5 array", and how does this "not being done"
> interfere with the starting of the raid5?

OK, I didn't actually trace this to be positive, but knowing how the
block layer *used* to do things, I think this is what's going on.  Let's
say you create a device node in the udev space of /dev/sda
and /dev/sda1.  You do this *before* loading the SCSI driver.  You load
the SCSI driver and it finds a disk.  It then calls the various init
sequences for the block device.  I can't remember what it's called right
now, but IIRC you call init_onedisk or something like that for sda.
Assuming sda is not currently in use, it starts out by basically tearing
down all the sda1 - sda15 block devices, then rereading the partition
table, then rebuilding all the sda1 - sda15 devices according to what
exists in the partition table.  With a persistent /dev namespace, that
was fine.  If you tried to open /dev/sda1 while this was happening it
just blocked the open until the sequence was over.  With udev, tearing
down all those devices and reiniting them not only makes then
unopenable, but it removes the device entry from the /dev namespace.

Now enter a stacked md device.  So you pass auto=md to mdadm, and you
tell it to start md0 - md3.  Great.  It creates the various md
*target* /dev entries that it needs, and it scans /proc/partitions for
the constituent devices, but if those devices are in the middle of their
init/validate sequence at the time that mdadm is run, they might or
might not be present.  From the time that sda was found, we have a delay
for reading the partition table from disk (could be multiple disk reads
if extended partitions present) and then setting up the device minors
based upon that as a race window against the mdadm startup sequence.
What I found was that on host scsi2, which is the first path to the 4
multipath drives, all of those paths were reliably accessible at raid
startup.  However, the devices on scsi3, the last scsi controller in the
system, were occasionally unavailable.  Then you have the same sort of
delay between when you start md0 - md3 and when they are all available
in the /dev namespace to be utilized in constructing the stacked array.
So even though mdadm creates the target device if needed, what I seem to
be running into is inconsistent existence of the constituent devices.

> 
> 
> >      4. Currently, the default number of partitions on a partitionable
> >         raid device is only 4.  That's pretty small.  I know of no way
> >         to encode the number of partitions the device was created with
> >         into the superblock, but really that's what we need so we can
> >         always start these devices with the correct number of minor
> >         numbers relative to how the array was created.  I would suggest
> >         encoding this somewhere in the superblock and then setting this
> >         to 0 on normal arrays and non-0 for partitionable arrays and
> >         that becomes your flag that determines whether an array is
> >         partitionable.
> 
> How does hotplug/udev create the right number of partitions for other,
> non-md, devices?

Reads the partition table.

>   Can the same mechanism be used for md?
> I am loathe to include the number of partitions in the superblock much
> as I am loath to include the filesystem type.  However see later
> comments on version-1 superblocks.

Possibly, but that still requires knowing whether or not the kernel
*should* read the partition table and create the minors.

> 
> >      5. I would like to be able to support dynamic multipath in the
> >         initrd image.  In order to do this properly, I need the ability
> >         to create multipath arrays with non-consistent superblocks.  I
> >         would then need mdadm to scan these multipath devices when
> >         autodetecting raid arrays.  I can see having a multipath config
> >         option that is one of three settings:
> >              A. Off - No multipath support except for persistent
> >                 multipath arrays
> >              B. On - Setup any detected multipath devices as non-
> >                 persistent multipath arrays, then use the multipath
> >                 device in preference to the underlying devices for
> >                 things like persuant mounts and raid starts
> >              C. All - Setup all devices as multipath devices in order to
> >                 support dynamically adding new paths to previously
> >                 single path devices at run time.  This would be useful
> >                 on machines using fiber channel for boot disks (amongst
> >                 other useful scenarios, you can tie this
> >                 into /sbin/hotplug so that new disks get their unique ID
> >                 checked and automatically get added to existing
> >                 multipath arrays should they be just another path, that
> >                 way bringing up a new fiber channel switch and plugging
> >                 it into a controller and adding paths to existing
> >                 devices will all just work properly and seamlessly).
> 
> This sounds reasonable....
> I've often thought that it would be nice to be able to transparently
> convert a single device into a raid1.  Then a drive could be added and
> synced. the old drive removed, and then the drive morphed back into a
> single drive - just a different one.

I spent several hours one day talking with Al Viro about this basic
thing.  The conclusion of all that was that currently, there is no way
to "morph" a drive from one type to another.  So, the only way I could
see to support dynamic multipath was to basically make the kernel treat
*all* devices as multipath devices then let hotplug/udev do the work of
adding any new devices either to A) an existing multipath array or B) a
new multipath array.  The partitionable md devices are ideal for this
setup since they allow the device to act exactly the same as a multipath
device or a regular block device.

What I started to setup was basically a setup in the initrd such that if
multipath was set to all devices, then it would do scsi_id on all
devices, create a list of unique IDs, then create multipath arrays for
each unique ID adding all elements into the multipath array of the same
ID, then move all the /dev/sd* entries to /dev/multipath_paths/sd* and
create links from /dev/sd? to /dev/md_d? and do the same for the
detected partitions.

Then you could also plug into the hotplug scripts a check of scsi_id
versus the scsi_id for already existing multipath devices, and if a
match was found, add the new drive into the existing array and create
the /dev/multipath_path entries and the /dev links for that device.
That way an admin won't accidentally try to access the raw path device.

> I remember many moons ago Linus saying that all this distinction
> between ide drives and scsi drives and md drive etc was silly.  
> There should be just one major number called "disk" and anything that
> was a disk should appear there.

I tend to agree with this.

> Given that sort of abstraction, we could teach md (and dm) to splice
> with "disk"s etc.  It would be nice.
> It would also be hell in terms of device name stability, but that is a
> problem that has to be solved anyway.

Hence why filesystem labels are nice.

> If I ever do look at unifying md and dm, that is the goal I would work
> towards.
> 
> But for now your proposal seems fine.  Is there any particular support
> needed in md or mdadm?

No, just clarification on the item below, aka how to properly create the
arrays.

> >      6. There are some other multipath issues I'd like to address, but I
> >         can do that separately (things like it's unclear whether the
> >         preferred way of creating a multipath array is with 2 devices or
> >         1 device and 1 spare, but mdadm requires that you pass the -f
> >         flag to create the 1 device 1 spare type, however should we ever
> >         support both active-active and active-passive multipath in the
> >         future, then this difference would seem to be the obvious way to
> >         differentiate between the two, so I would think either should be
> >         allowed by mdadm, but since readding a path that has come back
> >         to life to an existing multipath array always puts it in as a
> >         spare, if we want to support active-active then we need some way
> >         to trigger a spare->active transition on a multipath element as
> >         well).
> 
> For active-active, I think there should be no spares.  All devices
> should be active.  You should be able to --grow a multipath if you find
> you have more paths than were initially allowed for.

Not true.  You have to keep in mind capacity planning and stuff like
that on fiber channel.  Given two controller that are dual port, and two
switches, and to ports on an external raid chassis, you could actually
have 4 or 8 paths to a device, but you really only want one path on each
controller active and maybe you want them to use different switches for
load reasons, so you really need to be able to specify a map in that
case (this would be a map for the user space stuff to access) and only
have the "right" paths be active up until such time as a failover
occurs.  And then you very well might want to specify the manner in
which failover happens (in which case the event mechanism would be very
helpful here).

As for --grow'ing multipath, yes, that should be allowed.

> For active-passive, I think md/multipath would need some serious work.
> I have a suspicion that with such arrangements, if you access the
> passive path, the active path turns off (is that correct). 

Yes.

>  If so, the
> approach of reading the superblock from each path would be a problem.

Correct.  But this doesn't really rely on active/passive.  For dynamic
multipath you wouldn't be relying on superblocks anyway.  The decision
about whether or not a device is multipath can be made without that, and
once the decision is made, there is absolutely no reason to read the
same block multiple times or write it multiple times.  So, really,
ideally the multipath code should never do more than 1 read for any
superblock read/write since they are all the same block except when
trying to autodetect superblocks on two different devices that it
doesn't already know are multipath.

> 
> > > > > 
> > > > > [root@pe-fc4 devel]# /sbin/mdadm -E --scan
> > > ..
> > > > > ARRAY /dev/md0 level=raid5 num-devices=4
> > > > > UUID=910b1fc9:d545bfd6:e4227893:75d72fd8
> > > 
> > > Yes, I expect you would.  -E just looks as the superblocks, and the
> > > superblock doesn't record whether the array is meant to be partitioned
> > > or not. 
> > 
> > Yeah, that's *gotta* be fixed.  Users will string me up by my testicles
> > otherwise.  Whether it's a matter of encode it in the superblock or read
> > the first sector and look for a partition table I don't care (the
> > partition table bit has some interesting aspects to it, like if you run
> > fdisk on a device then reboot it would change from non partitioned to
> > partitioned, but might have a superminor conflict, not sure whether that
> > would be a bug or a feature), but the days of remaking initrd images for
> > every little change have long since passed and if I do something to
> > bring them back they'll kill me.
> 
> I would suggest that initrd should only assemble the array containing
> the root filesystem, and that whether it is partitioned or not probably
> won't change very often...
> 
> I would also suggest (in line with the opening comment) that if people
> want auto-assemble to "just work", then they should seriously consider
> making all for their md arrays the partitionable type and deprecating
> old major-9 non-partitionable arrays.  That would remove any
> confusion.

So, Jeremy Katz and I were discussing this at length in IRC the other
day.  There are some reasons why we can't just do as you suggest.

1) You can't reliably use whole disk devices as constituent raid devices
(like you can't make a raid1 partitionable array out of /dev/sda
and /dev/sdb, although this would be nice to do).  This is in large part
due to two things: 1) dual boot scenarios where other OSes won't know
about or acknowledge the superblock at the end of the device, but *will*
see a partition table and might do something like create a partition
that goes all the way to the end of the device and 2) ia64 and i386 both
have GPT partition tables that store partition information at the end of
the device, so we have overlap.

2) You can't reliably do a /boot partition out of a partitioned md
device because of #1.  In order for, say grub, to find the filesystem
and "do the right thing" at boot time, it wants to read a partition
table and find the filesystem.  If you could use whole disk devices as
partitioned md devices, that would be ideal because then the partition
table for say a root/boot raid1 array would *look* just like the
partition table on a single disk and grub wouldn't know the difference.
However, if you have to create a single, large linux raid autodetect
partition to hold the md device, then the md device is *further*
partitioned, you know have to traverse two distinct partition tables to
get to the actual /boot partition.  Oops, grub just went belly up (as
did lilo, etc)  So, in order to make booting possible, even if you want
to use a partitionable raid array for all non-boot partitions, you still
need an old style md device for the /boot partition.

> > 
> > >  With version-1 superblocks they don't even record the
> > > sequence number of the array they are part of.  In that case, "-Es"
> > > will report 
> > >   ARRAY /dev/?? level=.....
> > > 
> > > Possibly I could utilise one of the high bits in the on-disc minor
> > > number to record whether partitioning was used...
> > 
> > As mentioned previously, recording the number of minors used in creating
> > it would be preferable.
> > 
> (and in a subsequent email)
> > Does that mean with version 1 superblocks you *have* to have an ARRAY
> > line in order to get some specific UUID array started at the right minor
> > number?  If so, people will complain about that loudly.
> 
> What do you mean by "the right minor number"?  In these days of
> non-stable device numbers I would have thought that an oxy-moron.

Well, yes and no.  I'm not really referring to minor number as in the
minor used to create the device nodes, but assuming the name of the
devices are /dev/md_d0, /dev/md_d1, etc., then I was referring to what
used to be determined by the super-minor which is the device's place in
that numerical list of md_d devices.

> The Version-1 superblock has a 32 character 'set_name' field which can
> freely be set by userspace (it cannot currently be changed while the
> array is assembled, but that should get fixed).
> 
> It is intended effectively as an equivalent to md_minor in version0.90
> 
> mdadm doesn't currently support it (as version-1 support is still
> under development) but the intention is something like that:
> 
> When an array is created, the set_name could be set to something like:
> 
>    fred:bob:5
> 
> which might mean:
>   The array should be assembled by host 'fred' and should be get a
>   device special file at
>          /dev/bob
>   with 5 partitions created.
> 
> What minor gets assigned is irrelevant.  Mdadm could use this
> information when reporting the "-Es" output, and when assembling with 
>   --config=partitions

OK, good enough, I can see that working.

> Possibly, mdadm could also be given a helper program which parses the
> set_name and returns the core information that mdadm needs (which I
> guess is a yes/no for "should it be assembled", a named for the
> device, a preferred minor number if any, and a number of partitions).
> This would allow a system integrator a lot of freedom to do clever
> things with set_name but still use mdadm.

Yes, which is exactly the sort of thing we have to contend with.  As you
said earlier, flexibility and features are not always what the customer
wants ;-)  Sometimes they want it to "just work".  Our job is to try and
get as many of those features accessible as possible while maintaining
that "just work" operation.  If they want things other than "just work",
then they are always free to go to the command line, create things
themselves, add ARRAY lines into the /etc/mdadm.conf file, etc (unlike
Windows where if it doesn't "just work", then you can't do it yourself,
which is why I always hated Windows and switched to linux 12 or so years
ago, when you both A) don't do what I want and B) keep me from doing it
myself, you piss me off)

> You could conceivably even store a (short) path name in there and have
> the filesystem automatically mounted if you really wanted.  This is
> all user-space policy and you can do whatever your device management
> system wanted (though you would impose limits on how users of your
> system could create arrays.  e.g. require version-1 super blocks).

Doesn't work that way (the imposing limits part).  If we try that, then
they just download your mdadm instead of our prebuilt one and make what
they want.  Trust me, they do that a lot ;-)  The design goal in a
situation like that may be that we don't automatically do anything with
the stuff they manually create, but we can't allow it to break the stuff
we do automatically.

> 
> > > 
> > > What warnings are they?  I would expect this configuration to work
> > > smoothly.
> > 
> > During stop, it tried to stop all the multipath devices before trying to
> > stop the raid5 device, so I get 4 warnings about the md device still
> > being in use, then it stops the raid5.  You have to run mdadm a second
> > time to then stop the multipath devices.  Assembly went smoother this
> > time, but it wasn't contending with device startup delays.
> 
> 
> This should be fixed in mdadm 1.9.0. From the change log:
>     -   Make "mdadm -Ss" stop stacked devices properly, by reversing the
> 	order in which arrays are stopped.
> 
> Is it ?

Nope.  It seems to be an ordering issue.  The mdadm binary assumes that
md0 is first, md1 second, etc.  In my case, md0 and md_d0 got sorted
into the same place, tried to start md_d0 first, but it needed md0-3, so
it failed.  So, no it's broken.  It either needs to A) not warn on
missing devices and just loop through the list until no further progress
can be made (the simple way) or B) do real dependency resolution and
only start a device after it's constituent devices have been started
regardless of the ordering of the devices in the ARRAY lines or
regardless of the ordering of device names.

> > 
> > Well, if you intend to make --brief work for a default mdadm.conf
> > inclusion directly (which would be useful specifically for anaconda,
> > which is the Red Hat/Fedora install code so that after setting up the
> > drives we could basically just do the equivalent of
> > 
> > echo "DEVICE partitions" > mdadm.conf
> > mdadm -Es --brief >> mdadm.conf
> > 
> > and get things right) then I would suggest that each ARRAY line should
> > include the dev name (properly, right now /dev/md_d0 shows up
> > as /dev/md0), level, number of disks, uuid, and auto={md|p(number)}.
> > That would generate a very useful ARRAY line.
> 
> I'll have to carefully think through the consequences of overloading a
> high bit in md_minor.
> I'm not at all keen on including the number of partitions in a
> version-0.90 superblock, but maybe I could be convinced.....

This is when I was thinking about the whole UUID thing in my last email.
If you encode a machine serial number into the uuid, you could also
encode the partition information.  Maybe a combination of serial number
in high 32 bits, magic in next 24 bits, then either the number of
partitions or just a partition shift encoded in the remaining 8 bits.
Still leaves 64 bits of UUID and now the 64 bits of UUID are tied to a
specific machine.  Something like that anyway.

-- 
Doug Ledford <dledford@redhat.com>
http://people.redhat.com/dledford


