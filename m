From: "Robin Bowes" <robin-lists@robinbowes.com>
Subject: Re: Moving controllers
Date: Tue, 23 Mar 2004 10:22:57 -0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <39776.194.60.85.4.1080037377.squirrel@194.60.85.4>
References: <24101.194.60.85.4.1079965526.squirrel@194.60.85.4>
    <Pine.LNX.4.44.0403221748490.13036-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0403221748490.13036-100000@coffee.psychology.mcmaster.c
     a>
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Mark,

On Mon, March 22, 2004 22:53, Mark Hahn said:
>> connect my four disks to the two ports of this controller, i.e. I will
>> have a master and slave drive on each channel.
>
> this will cause anomalous performance in some circumstances,
> since master and slave are not concurrent.

Yeah, I read that in the list archives after I'd posted this message.

>> First question: what is the kernel support like for this controller?
>
> mediocre - the controller isn't generally as good as promise,
> nor is the support.

OK.

>
>> Secondly, I am aware that this is not the ideal configuration, but my
>> performance requirements are not massive as I won't be doing much more
>> than streaming MP3s to clients on my home network. However, if I were to
>
> which is very low data rate, what, under 200 KB/s?  since a floppy can
> do this, there is no performance issue with disks, no matter how badly
> configured.

:-)

I will doing other things with the box; for example, this box will also
host my mail, web server, databases, etc. None of this will require
spectacular performance, though.

>> possible to install an additional controller in a PCI slot, and move the
>> two
>> slave disks onto the new controller without re-building the array.
>
> this might work.  linux raid seems to want to have partitions marked 0xfd,
> and it writes some kind of self-identifying superblock onto each.
>
> why not just experiment and find out?  put two disks on a single channel,
> make the raid, power down, move the slave to another channel, and see if
> the raid assembles.

One word: time; I was hoping someone could tell me if it would work to
save me messing around. Of course, if I plan to do this I will perform
some sort of test first.

>
>> Third question: If I were to decide on a replacement 4-port controller,
>> what models are well-supported?
>
> promise.  3ware works well, but is silly expensive.

Yeah, I've seen that. What about the MegaRAID i4 ? That appears to do
hardware RAID5 which would save me having to bother with software RAID. Do
you know if it is true hardware RAID? Does it have good linux support?

>> dealing with disks and filesystems of this size. For example, are there
>> any inherent limitations or absolute maximums I need to be aware of?
>> What
>
> 2TB block-dev limit < 2.6.

What's the limit in 2.6? What about filesystem size?

>> about low-level issues like chunk size and block size, etc.? Any
>
> for mp3's, it cannot possibly matter.
>
>> recommendations as to the optimum settings, bearing in mind I will be
>> dealing with relatively large files?
>
> more than the 3-5 MB for a typical song?

I'll actually be using flac, and have a lot of classical music which has
movements up to 20 mins long  resulting in larger file sizes.

I read somewhere that XFS is robust and fast, but performance degrades
when the filesystem holds a lot of small files. When I say "relatively
large" I was meaning that I won't have a lot of small (eg. < 5k) files.

Thanks for the reply.

R.
-- 
http://robinbowes.com
