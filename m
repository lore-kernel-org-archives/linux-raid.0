From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Fw: mdadm options, and man page
Date: Mon, 23 Jan 2006 11:10:38 +0100
Message-ID: <044201c62016$c9524820$1400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message ----- 
From: "Neil Brown" <neilb@suse.de>
To: "JaniD++" <djani22@dynamicweb.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Thursday, January 19, 2006 3:09 AM
Subject: Re: mdadm options, and man page


> On Tuesday January 17, djani22@dynamicweb.hu wrote:
> > Hello, Neil,
> >
> > Some days before, i read the entire mdadm man page.
>
> Excellent...
>
> >
> > I have some ideas, and questions:
> >
> > Ideas:
> > 1. i think, it is neccessary, to make another one mode to mdadm like
"nop"
> > or similar, just for bitmaps, and another options, that only works with
> > assemble, and create (or grow) modes.
>
> This sounds like the 'misc' mode.  What exactly would you want to do
> with it?

Example:
I have one raid5 array, without bitmap, on already replaced bigger drives.
(for planned growing)
The array is online, dont want to stop, and need to create the bitmap
without to do the resizing of array.

>
> >
> > 2. i think the raid5 creation virtual spare drive technique necessary to
be
> > standalone option, to avoid more people to data lost, with re-creating
the
> > raid5 arrays, and who did'nt read carefully the entire man.
>
> I don't see why this could cause loss of data.  Can you explain?

One time i almost do that:
One big (2TB) raid5 array, the system crashed. (no bitmap at this time in
the array)
After the reboot, the system starts to resync, and don't want to wait until
its done, but with high workload and resync is too much work to the system.
(Yes, i know it is possible to set the minimum and maximum kb/s in proc...)
This time i plan to do that:
Stop the resync, with recreating the array, with --assume-clean, to stop the
resyncing.
After the weekend load is gone, recreate the array, with normal parameters,
to resync the entire parity infos, and this time if i dont know this
exception, i will loose some data!
The raid will overwrite the last disk, from half-clean parity information.

Today, i know it is already exists better options to do that, but some (and
possible a lot of) people did not read the entire man page!!!

>
> >
> > 3. i think it will be an usefull thing, set the recovery, resyncing
> > order(eg. from the end of the drive to the beginning) of array, or set
the
> > "from" and "to" limits for it, or stop, restart(retry) this function, if
it
> > is possible again.
> > (only experimental, it will be allow very easy to loose data.)
> > This is useful in very big arrays, wich takes some days to resync.
> > Yes, i know this caused to write the bitmap code, but i think the linux
is
> > beautiful because it is very configurable. :-)
> > ... i did not like the automated things, what i cannot controll....
>
> Why would you want to resync from the end to the beginning?
>
> I am looking into make raid1 be usable on a cluster and that would
> require better control of resyncing, but I'm not sure what exactly it
> is that you want, or how it would be useful.

Again big arrays...
I guess, you know this feeling, if the N TB array is synced about 95%, and
the system crashes again. :-)

1 pass sync the array from 0-95%, than crash, reboot.
2 pass sync the array from 100% to 90%, and marked to be clean by hand. :-)

Additional info:
I use currently 4x 2TB disk nodes, and if i need to repair, change, or sg
the nodes, the only way is to riad1 resync with the spare node.
On the online system, the 2TB resync between the nodes, takes some days.
I am really happy, if the raid1 starts to resync from the beginning, after
crash. :-)

Another issue:
The man pages did not contains info about the the spare drive in raid1 and
parity on raid4!
I mean wich drive will be the source, and wich the copy on raid1, and wich
the parity on raid4.
This is neccessary to avoid data lost on create (build) arrays, on pre
existent devices...

>
> >
> >
> > Questions:
> > 1. it will be possible to set/unset the --write-mostly, --write-behind
> > options online?
> > (i know, currently not.)
>
> Hmmm... I'll look into that.
>
> >
> > 2. it will be possible to create a bitmap in raid5 when it is resyncing,
or
> > recovering?
>
> No.  You new to either wait for the resync/recovery to complete, or
> abort it.

Anyway, i have other questions about bitmap and resync, but on another
mail.... (if i have time to write...)

>
> >
> > 3. it is possible to set unset the clean state of the array online?
(useful
> > for idea #3)
>
> There are some new attributes in /sys/block/mdX/md/ which might be of
> interest.
> Read through Documentation/md.txt in 2.5.16-rc1.

Thanks, i will read it.

>
> >
> > 4. why the md did not support raid4,5 with non-persistent superblock?
> > I think the non-persistent superblock raid4 is very useful thing to easy
> > upgrade (protect) from one big legacy raid0 array to raid4 with an
existing
> > data! :-)
> > At this time i need it too. :-)
>
> You need metadata (superblock) to be able to track failure and
> rebuilds and such.  Even raid1 with non-persistent superblock is
> something you have to be careful with.  You wouldn't use it for a
> long-lived array, only to copy data from one place to another but
> still have the data live.

Yes, the raid1 without superblock is the best way, to replace one (good, but
slow) disk in big raid5 array "almost" online.
Ahh, another idea! :-)

To do this, i need to stop the array, create the zero superblock raid1 on
slow disk, and assemble the raid5 with new md device.
I think it is neccessary to be one (or more) standalone option in mdadm, to
do that online, without stop, and assemble again. :-)

Thanks, for the answers!

Cheers,
Janos


>
> Hope that helps,
>
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

