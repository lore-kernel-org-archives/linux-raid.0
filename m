From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: What the heck happened to my array?
Date: Tue, 05 Apr 2011 17:02:43 +0800
Message-ID: <4D9ADAB3.7040205@fnarfbargle.com>
References: <4D9876E4.6080501@fnarfbargle.com>	<AANLkTi=2GNYdySbCDXmaDC8-8vF8GU9V3Uoy1qByNq58@mail.gmail.com>	<4D995E27.3060800@fnarfbargle.com>	<BANLkTi=prv_vzfJr2JJt3LLhdB0GFSMy4w@mail.gmail.com>	<4D9A6694.4040606@fnarfbargle.com> <20110405161043.00d54901@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110405161043.00d54901@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/04/11 14:10, NeilBrown wrote:
 >> - Reboot required to get system back.
 >> - Restarted reshape with 9 drives.
 >> - sdl suffered IO error and was kicked
 >
 > Very sad.

I'd say pretty damn unlucky actually.

 >> - Array froze all IO.
 >
 > Same thing...
 >
 >> - Reboot required to get system back.
 >> - Array will no longer mount with 8/10 drives.
 >> - Mdadm 3.1.5 segfaults when trying to start reshape.
 >
 > Don't know why it would have done that... I cannot reproduce it easily.

No. I tried numerous incantations. The system version of mdadm is Debian 
3.1.4. This segfaulted so I downloaded and compiled 3.1.5 which did the 
same thing. I then composed most of this E-mail, made *really* sure my 
backups were up to date and tried 3.2.1 which to my astonishment worked. 
It's been ticking along _slowly_ ever since.

 >>     Naively tried to run it under gdb to get a backtrace but was unable
 >> to stop it forking
 >
 > Yes, tricky .... an "strace -o /tmp/file -f mdadm ...." might have been
 > enough, but to late to worry about that now.

I wondered about using strace but for some reason got it into my head 
that a gdb backtrace would be more useful. Then of course I got it 
started with 3.2.1 and have not tried again.

 >> - Got array started with mdadm 3.2.1
 >> - Attempted to re-add sdd/sdl (now marked as spares)
 >
 > Hmm... it isn't meant to do that any more.  I thought I fixed it so 
that it
 > if a device looked like part of the array it wouldn't add it as a 
spare...
 > Obviously that didn't work.  I'd better look in to it again.

Now the chain of events that led up to this was along these lines.
- Rebooted machine.
- Tried to --assemble with 3.1.4
- mdadm told me it did not really want to continue with 8/10 devices and 
I should use --force if I really wanted it to try.
- I used --force
- I did a mdadm --add /dev/md0 /dev/sdd and the same for sdl
- I checked and they were listed as spares.

So this was all done with Debian's mdadm 3.1.4, *not* 3.1.5

 >
 > No, you cannot give it extra redundancy.
 > I would suggest:
 >    copy anything that you need off, just in case - if you can.
 >
 >    Kill the mdadm that is running in the back ground.  This will mean 
that
 >    if the machine crashes your array will be corrupted, but you are 
thinking
 >    of rebuilding it any, so that isn't the end of the world.
 >    In /sys/block/md0/md
 >       cat suspend_hi>  suspend_lo
 >       cat component_size>  sync_max
 >
 >    That will allow the reshape to continue without any backup.  It 
will be
 >    much faster (but less safe, as I said).

Well, I have nothing to lose, but I've just picked up some extra drives 
so I'll make second backups and then give this a whirl.

 >    If something goes wrong, you will need to scrap the array, 
recreate it, and
 >    copy data back from where-ever you copied it to (or backups).

I did go into this with the niggling feeling that something bad might 
happen, so I made sure all my backups were up to date before I started. 
No biggie if it does die.

The very odd thing is I did a complete array check, plus SMART long 
tests on all drives literally hours before I started the reshape. Goes 
to show how ropey these large drives can be in big(iash) arrays.

 > If anything there doesn't make sense, or doesn't seem to work - 
please ask.
 >
 > Thanks for the report.  I'll try to get those mdadm issues addressed -
 > particularly if you can get me the mdadm file which caused the segfault.
 >

Well, luckily I preserved the entire build tree then. I was planning on 
running nm over the binary and have a two thumbs type of look into it 
with gdb, but seeing as you probably have a much better idea what you 
are looking for I'll just send you the binary!

Thanks for the help Neil. Much appreciated.

