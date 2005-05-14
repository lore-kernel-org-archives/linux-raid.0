From: Doug Ledford <dledford@redhat.com>
Subject: Re: Bug report: mdadm -E oddity
Date: Sat, 14 May 2005 09:28:35 -0400
Message-ID: <1116077316.13780.52.camel@compaq-rhel4.xsintricity.com>
References: <1115999051.3974.14.camel@compaq-rhel4.xsintricity.com>
	 <1116004267.3974.35.camel@compaq-rhel4.xsintricity.com>
	 <17029.12773.197506.463977@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17029.12773.197506.463977@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2005-05-14 at 09:01 +1000, Neil Brown wrote:
> On Friday May 13, dledford@redhat.com wrote:
> So there are little things that could be done to smooth some of this
> over, but the core problem seems to be that you want to use the output
> of "--examine --scan" unchanged in mdadm.conf, and that simply cannot
> work.

Actually, what I'm working on is Fedora Core 4 and the boot up sequence.
Specifically, I'm trying to get the use of mdadm -As acceptable as the
default means of starting arrays in the initrd.  My choices are either
this or make the raidautorun facility handle things properly.  Since
last I knew, you marked the raidautorun facility as deprecated, that
leaves mdadm (note this also has implications for the raid shutdown
sequence, I'll bring that up later).

So, here's some of the feedback I've gotten about this and the
constraints I'm working under as a result:

     1. People don't want to remake initrd images and update mdadm.conf
        files with every raid change.  So, the scan facility needs to
        properly handled unknown arrays (it doesn't currently).
     2. People don't want to have a degraded array not get started (this
        isn't a problem as far as I can tell).
     3. Udev throws some kinks in things because the raid startup is
        handled immediately after disk initialization and from the looks
        of things /sbin/hotplug isn't always done running by the time
        the mdadm command is run so occasionally disks get missed (like
        in my multipath setup, sometimes the second path isn't available
        and the array gets started with only one path as a result).  I
        either need to add procps and grep to the initrd and run a while
        ps ax | grep hotplut | grep -v grep or find some other way to
        make sure that the raid startup doesn't happen until after
        hotplug operations are complete (sleeping is another option, but
        a piss poor one in my opinion since I don't know a reasonable
        sleep time that's guaranteed to make sure all hotplug operations
        have completed).  However, with the advent of stacked md
        devices, this problem has to be moved into the mdadm binary
        itself.  The reason for this (and I had this happen to me
        yesterday), is that mdadm started the 4 multipath arrays, but
        one of them wasn't done with hotplug before it tried to start
        the stacked raid5 array, and as a result it started the raid5
        array with 3 out 4 of devices in degraded mode.  So, it is a
        requirement of stacked md devices that the mdadm binary, if it's
        going to be used to start the devices, wait for all md device it
        just started before proceeding with the next pass of md device
        startup.  If you are going to put that into the mdadm binary,
        then you might as well as use it for both the delay between md
        device startup and the initial delay to wait for all block
        devices to be started.
     4. Currently, the default number of partitions on a partitionable
        raid device is only 4.  That's pretty small.  I know of no way
        to encode the number of partitions the device was created with
        into the superblock, but really that's what we need so we can
        always start these devices with the correct number of minor
        numbers relative to how the array was created.  I would suggest
        encoding this somewhere in the superblock and then setting this
        to 0 on normal arrays and non-0 for partitionable arrays and
        that becomes your flag that determines whether an array is
        partitionable.
     5. I would like to be able to support dynamic multipath in the
        initrd image.  In order to do this properly, I need the ability
        to create multipath arrays with non-consistent superblocks.  I
        would then need mdadm to scan these multipath devices when
        autodetecting raid arrays.  I can see having a multipath config
        option that is one of three settings:
             A. Off - No multipath support except for persistent
                multipath arrays
             B. On - Setup any detected multipath devices as non-
                persistent multipath arrays, then use the multipath
                device in preference to the underlying devices for
                things like persuant mounts and raid starts
             C. All - Setup all devices as multipath devices in order to
                support dynamically adding new paths to previously
                single path devices at run time.  This would be useful
                on machines using fiber channel for boot disks (amongst
                other useful scenarios, you can tie this
                into /sbin/hotplug so that new disks get their unique ID
                checked and automatically get added to existing
                multipath arrays should they be just another path, that
                way bringing up a new fiber channel switch and plugging
                it into a controller and adding paths to existing
                devices will all just work properly and seamlessly).
     6. There are some other multipath issues I'd like to address, but I
        can do that separately (things like it's unclear whether the
        preferred way of creating a multipath array is with 2 devices or
        1 device and 1 spare, but mdadm requires that you pass the -f
        flag to create the 1 device 1 spare type, however should we ever
        support both active-active and active-passive multipath in the
        future, then this difference would seem to be the obvious way to
        differentiate between the two, so I would think either should be
        allowed by mdadm, but since readding a path that has come back
        to life to an existing multipath array always puts it in as a
        spare, if we want to support active-active then we need some way
        to trigger a spare->active transition on a multipath element as
        well).

That pretty much covers it for now.

> > On Fri, 2005-05-13 at 11:44 -0400, Doug Ledford wrote:
> > > If you create stacked md devices, ala:
> > > 
> > > [root@pe-fc4 devel]# cat /proc/mdstat
> > > Personalities : [raid0] [raid5] [multipath]
> > > md_d0 : active raid5 md3[3] md2[2] md1[1] md0[0]
> > >       53327232 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
> ...
> > > 
> > > and then run mdadm -E --scan, then you get this (obviously wrong)
> > > output:
> > > 
> > > [root@pe-fc4 devel]# /sbin/mdadm -E --scan
> ..
> > > ARRAY /dev/md0 level=raid5 num-devices=4
> > > UUID=910b1fc9:d545bfd6:e4227893:75d72fd8
> 
> Yes, I expect you would.  -E just looks as the superblocks, and the
> superblock doesn't record whether the array is meant to be partitioned
> or not. 

Yeah, that's *gotta* be fixed.  Users will string me up by my testicles
otherwise.  Whether it's a matter of encode it in the superblock or read
the first sector and look for a partition table I don't care (the
partition table bit has some interesting aspects to it, like if you run
fdisk on a device then reboot it would change from non partitioned to
partitioned, but might have a superminor conflict, not sure whether that
would be a bug or a feature), but the days of remaking initrd images for
every little change have long since passed and if I do something to
bring them back they'll kill me.

>  With version-1 superblocks they don't even record the
> sequence number of the array they are part of.  In that case, "-Es"
> will report 
>   ARRAY /dev/?? level=.....
> 
> Possibly I could utilise one of the high bits in the on-disc minor
> number to record whether partitioning was used...

As mentioned previously, recording the number of minors used in creating
it would be preferable.

> > OK, this appears to extend to mdadm -Ss and mdadm -A --scan as well.
> > Basically, mdadm does not properly handle mixed md and mdp type devices
> > well, especially in a stacked configuration.  I got it to work
> > reasonably well using this config file:
> > 
> > DEVICE partitions /dev/md[0-3]
> > MAILADDR root
> > ARRAY /dev/md0 level=multipath num-devices=2
> > UUID=34f4efec:bafe48ef:f1bb5b94:f5aace52 auto=md
> > ARRAY /dev/md1 level=multipath num-devices=2
> > UUID=bbaaf9fd:a1f118a9:bcaa287b:e7ac8c0f auto=md
> > ARRAY /dev/md2 level=multipath num-devices=2
> > UUID=a719f449:1c63e488:b9344127:98a9bcad auto=md
> > ARRAY /dev/md3 level=multipath num-devices=2
> > UUID=37b23a92:f25ffdc2:153713f7:8e5d5e3b auto=md
> > ARRAY /dev/md_d0 level=raid5 num-devices=4
> > UUID=910b1fc9:d545bfd6:e4227893:75d72fd8 auto=part
> > 
> > This generates a number of warnings during both assembly and stop, but
> > works.
> 
> What warnings are they?  I would expect this configuration to work
> smoothly.

During stop, it tried to stop all the multipath devices before trying to
stop the raid5 device, so I get 4 warnings about the md device still
being in use, then it stops the raid5.  You have to run mdadm a second
time to then stop the multipath devices.  Assembly went smoother this
time, but it wasn't contending with device startup delays.

> > One more thing, since the UUID is a good identifier, it would be nice to
> > have mdadm -E --scan not print a devices= part.  Device names can
> > change, and picking up your devices via UUID regardless of that change
> > is preferable, IMO, to having it fail.
> 
> The output of "-E --scan" was never intended to be used unchanged in
> mdadm.conf.
> It simply provides all available information in a brief format that is
> reasonably compatible with mdadm.conf.  As is says in the Examples
> section of mdadm.8
> 
>          echo 'DEVICE /dev/hd*[0-9] /dev/sd*[0-9]' > mdadm.conf
>          mdadm --detail --scan >> mdadm.conf
>        This  will  create  a  prototype  config  file that describes currently
>        active arrays that are known to be made from partitions of IDE or  SCSI
>        drives.   This file should be reviewed before being used as it may con-
>        tain unwanted detail.
> 
> However I note that the doco for --examine says
> 
>               If --brief is given, or --scan then multiple  devices  that  are
>               components of the one array are grouped together and reported in
>               a single entry suitable for inclusion in  /etc/mdadm.conf.
> 
> which seems to make it alright to use it directly in mdadm.conf.

Well, if you intend to make --brief work for a default mdadm.conf
inclusion directly (which would be useful specifically for anaconda,
which is the Red Hat/Fedora install code so that after setting up the
drives we could basically just do the equivalent of

echo "DEVICE partitions" > mdadm.conf
mdadm -Es --brief >> mdadm.conf

and get things right) then I would suggest that each ARRAY line should
include the dev name (properly, right now /dev/md_d0 shows up
as /dev/md0), level, number of disks, uuid, and auto={md|p(number)}.
That would generate a very useful ARRAY line.

> Maybe the -brief version should just give minimal detail (uuid), and
>  --verbose be required for the device names.
> 
> 

> 
> NeilBrown
-- 
Doug Ledford <dledford@redhat.com>
http://people.redhat.com/dledford


