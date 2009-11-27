From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Help on first dangerous scrub / suggestions
Date: Fri, 27 Nov 2009 16:08:06 -0500 (EST)
Message-ID: <alpine.DEB.2.00.0911271557550.30813@p34.internal.lan>
References: <4B0E7111.20202@shiftmail.org> <alpine.DEB.2.00.0911260720220.23317@p34.internal.lan> <4B0E8B75.2030006@shiftmail.org> <alpine.DEB.2.00.0911260915520.17452@p34.internal.lan> <4B0ED0DF.10502@shiftmail.org> <alpine.DEB.2.00.0911261554170.14297@p34.internal.lan>
 <4B0FD689.9030904@shiftmail.org> <4B101653.8040904@shiftmail.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B101653.8040904@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Fri, 27 Nov 2009, Asdo wrote:

> Asdo wrote:
>> ....
>> Without knowing this I will probably opt for your way: rsync data out, 
>> starting from the smallest and most important stuff...
>> ...
>
> I had another thought:
>
> If I take the computer offline, boot with a livecd (one of the worst messes 
> here is that the root filesystem is also in that array), run the raid6 array 
> in READONLY MODE and maybe without spares, then I start a check (scrub) ...

>
> If drives are kicked I can probably reasseble --force the array and it's like 
> nothing happened, right?
If *more* than 2 drives fail you would need to --force.  Also, when you do that
(I have done it before), you need to fsck the filesystem and often many of
your files will end up in /lost+found, depending on how bad it is.  But in all
of my tests, the FS was R/W, not R/O, so I am unsure of the outcome, it sounds
like a possibility.  With SW/RAID-6 I have lost two disks before and suffered
no problems at all (you can't use Western Digital Velociraptors in RAID), I was
able to copy the data that I needed off of the array without any issues but my
server was not being heavily utilized as yours is.

I think you need to run a smartctl on each of the drives, e.g.:

for disk in /dev/sd[a-z]
do
   echo "disk $disk" >> /tmp/a
   smartctl -a $disk >> /tmp/a
done

Inspect each disk, is there really a failing disk?..

> Since it was mounted readonly I think it would be clean...
>
> Only problem would be if 1 or more drives definitively die during the 
> procedure, but I hope this is unlikely...
> If less than 3 drives die I can still reassemble --force, and take the data 
> out (at least SOME data, then if it degrades, reassemble again and try to get 
> out data from another location...)
>
> Do you agree?
I agree, but would you not want to just rsync the data off first before going
through all of this?

>
> I am starting to think that during the procedure for taking the data out 
> and/or attempt first scrubbing the main problem are write accesses to the 
> array, because if rebuild starts on a spare and then fails again and then 
> there were writes in the middle... I think I end up doomed. Probably even 
> reassemble --force would refuse to work on me. What do you think?
I think you have a point there..  In my opinion:

1. Check each disk, how bad is it, really? (it seems like your array and
    disks are fine, one disk may have a re-allocated sector or two,
    nothing to worry about) in all seriousness.  Do any of the attributes say
    *FAILING NOW*?

2. If everything looks OK, copy all of the data off while the system is ONLINE
    and WORKING, it will be *MUCH* more difficult trying to extract pieces of
    data using dd_rescue and friends vs. just rsyncing the entire array to
    another host.

3. Do you not have another host to rsync to?  If that is the case then we may
    need to approach this problem from a different angle.  E.g., making it
    read-only after booting from a LiveCD may not be a bad idea, but doing that
    BEFORE you rsync'd all the data off is still risking all of the data on the
    array, whereas since it is currently up and running you could at least make
    a point-in-time copy of all of the data that lives there right now.

Justin.


