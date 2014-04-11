From: David Brown <david.brown@hesbynett.no>
Subject: Re: Nvidia Raid5 Failure
Date: Fri, 11 Apr 2014 09:45:10 +0200
Message-ID: <53479D86.7090104@hesbynett.no>
References: <DUB122-W521994A2683B8CBD327D3DA3550@phx.gbl>	<CAK_KU4ZHZik=_=2=fMPW1c_y-xc0DW_9=ucsYQXU2e=eSOtYQg@mail.gmail.com> <CAK_KU4ab9OrmM06D6aPiNK44JpPudQOz=1Q9fTJ63NtGrwPedQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK_KU4ab9OrmM06D6aPiNK44JpPudQOz=1Q9fTJ63NtGrwPedQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Scott D'Vileskis <sdvileskis@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: peter davidson <merrymeetpete@hotmail.com>
List-Id: linux-raid.ids


Hi Scott,

I did not mean to imply that people here could not, should not or would
not help someone getting started with Linux - merely that discussions
like that are off-topic on this mailing list, and can quickly get out of
hand ("You recommended Ubuntu?  No, he should be using....").  It's
great that you had the time to help him here.

It's good that you posted your recipe here for loopback device raids for
testing.  I made a similar post a good while back, and have seen a few
others over the years.  But it is good to get it repeated, especially
for newer followers of the list.  Loopback md raid is a fantastic tool
for learning, and for practising risky operations such as resizes,
recovery, etc., and is something all md raid users should try on occasion.

mvh.,

David


On 11/04/14 06:15, Scott D'Vileskis wrote:
> OP Peter and I exchanged a few Emails and I recommended he start with
> a flavor of Ubuntu on a spare hard drive, and loop devices to learn
> mdadm. He found it helpful and thought it might help someone else, and
> despite this mailing list
>  """ not really really suitable for "how to get started with Linux"
> information. """"  the following is our EMail:
> 
> I would advise setting up Xubuntu on your spare drive, and leaving
> your RAID disks completely disconnected while you learn mdadm.
> 
> On that drive, create a few blank 1GB files, and loop devices:
> fallocate -l 1G file1.img
> losetup /dev/loop0 file1.img
> fallocate -l 1G file2.img
> losetup /dev/loop1 file2.img
> fallocate -l 1G file3.img
> losetup /dev/loop2 file3.img
> fallocate -l 1G file4.img
> losetup /dev/loop3 file4.img
> 
> Then you can create a raid array with these fake hard drives
> (/dev/loop0, /dev/loop1, etc...)
> mdadm --create -n4 -l5 /dev/md0 /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3
> 
> Check rebuild status with:
> cat /proc/mdstat
> 
> Create a file system:
> mkfs.ext4 /dev/md0
> 
> Mount the filesystem
> mkdir /mnt/testraid
> mount /dev/md0 /mnt/testraid
> 
> Copy some files to it, maybe a movie, episode of SVU, etc, then:
> mplayer somemovie.mkv
> 
> Then, while watching the movie, fail a disk
> mdadm --fail /dev/md0 /dev/loop3
> mdadm --remove /dev/md0  /dev/loop3
> 
> Check status, delete the loop device, delete the file:
> cat /proc/mdstat
> losetup -d /dev/loop3
> rm file4.img
> 
> And I'll leave it to you to figure out how to create a new loop disk,
> readd it to the raid, and resync while before your movie completes..
> 
> Once you are familiar and want to tackle your real drives.. From the
> command line you can usu mdadm commands to attempt to --assemble the
> array in degraded mode. When using the mdadm commands I believe there
> are some special options for running in readonly mode, and/or not starting
> it unless all devices are available. You may even need to use the
> --force command if your drives are out of sync but you trust the data
> on them.
> When you start deleting superblocks and using the --create flag is
> when you have to be careful.
> 
> -----------------------------------------------------------------------------------------
> 
> Hi Scot - excellent email - thanks a million...
> 
> Various hiccups getting the hardware ready but those were not
> insurmountable. Install went OK and I remember how excited I used to
> get about using the UNIX OS - various things are coming back to me.
> 
> I considered writing up the various tweaks to your instructions on the
> mail server - do you think that would be a valid exercise that someone
> else might gain from?
> 
> In case your feeling sceptical...
> 
> unused devices: <none>
> peter@peter-MS-7374:~$ cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 loop3[4] loop2[2] loop1[1] loop0[0]
>       3142656 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [UUU_]
>       [================>....]  recovery = 82.4% (864464/1047552)
> finish=0.1min speed=27014K/sec
> 
> unused devices: <none>
> peter@peter-MS-7374:~$ cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 loop3[4] loop2[2] loop1[1] loop0[0]
>       3142656 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4] [UUUU]
> 
> The film was an episode of Homelands - it didn't even hiccup!
> 
> If you have any other exercise suggestions to help me get up to speed
> then I am all ears - off to bed now - somehow it got late!
> 
> Thanks for you assistance.
> 
> Peter.
> 
> 
> ---------------------------------------------------------
> 
> Peter,
> For further exercises (to familiarize yourself with creating,
> breaking, and rebuilding a raid), I recommend the following additional
> scenarios:
> 
> a) With a working raid up and running, unmount the filesystem, stop
> the array, then stop one of your loop devices. Try to assemble the
> array with the missing disk, start and stop the array a few times, and
> also familiarize yourself with the --run and --no-degraded options, as
> well as the --examine features for understanding superblocks. Remember
> just mounting filesystems may change metadata on the raid disks, so
> this and this will impact the data integrity on the raid, even if you
> don't manipulate any files.
> b) After you have messed around a bit, maybe even changed some data in
> degraded mode, stop the array, restart your 'missing' loop device and
> attempt to restart the raid array with all the devices. After the
> array starts degraded, you'll likely have to --add the disk again for
> the rebuild to start.
> c) Try to --create an array with your existing loop devices and check
> out all the warnings you'll get about existing memberships in raid
> arrays. You'll find that, with the exception of the --zero-superblock
> command, it is usually pretty difficult to break things. If you
> somehow convince mdadm to start or recreate an array with questionable
> disks (like with the --assume-clean) option, familiarize yourself with
> the various filesystem check tools.
> 
> --Scott
> 
> That leads me to the following general questions about mdadm and linux raid...
> I have certainly RTFM and learned many things in the past dozen years
> or so from internet examples, broken arrays, kernel panics on suspend,
> bad drive cabling, mistypes using dd, blowing away the first gig of a
> partition, growing, shrinking, migrating, etc. Are there formal test
> cases and scenarios for mdadm and linux-raid?
> 
> Also many of the emails I have seen pass through this mailing list
> involve some interesting combinations of raid device superblock
> mismatches that beg the question.. How could you have possibly gotten
> your raid components into *that* state...
> 
> In addition to the typical use cases covered in the manual (creating
> an array, growing, shrinking, replacing disks, etc) it might be
> interesting to have a list of misuse cases for folks to try and work
> out..  (Ooops, I accidentally blew away my superblock, what can I do
> without a full rebuild)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

