From: Max Waterman <davidmaxwaterman@fastmail.co.uk>
Subject: Re: trouble adding spare
Date: Wed, 14 Jan 2009 16:32:17 +0200
Message-ID: <496DF771.4010407@fastmail.co.uk>
References: <496DB3A4.4090605@fastmail.co.uk> <alpine.DEB.1.10.0901140654100.11696@p34.internal.lan> <496DE2BD.6070905@fastmail.co.uk> <496DE763.9010300@fastmail.co.uk> <alpine.DEB.1.10.0901140830280.11696@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0901140830280.11696@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
> Output from when I have run this in the past:
> p34:~# mdadm --zero-superblock /dev/hde1
> p34:~#
Ok, shuffling the args (why is it that the args are sometimes one way, 
and sometimes another?) made it at least run, but it made no difference 
to the device being added at boot-time.
>
> If that does not work, clean the drive out manually after removing it 
> as a spare from the array:
> dd if=/dev/zero of=/dev/sdi bs=1M
This is taking forever. Isn't there a way to force mdadm to ignore the 
contents and just add it? How about a specific 'dd' that targets 
whatever is on the disk that is causing the problem (partition table?)?
> Then try to re-add it.
>
> If that still does not work you may need to modify some additional 
> bits possibly with/in regards to the spare itself, I only have one 
> spare in my array and I use a partition with type (fd) for the spare.
>
> The only other thing I can think of is the events for that spare were 
> 0.123 (example) and then after you installed OSX onto the drive,
Well, I didn't install OSX on it...just formatted it on OSX - what's 
that? HFS+ or something? Anyway, it makes several different partitions 
for some reason. Do you think that's causing the problem?
> it could have deleted the superblock for mdadm from when it was 
> created as a spare.
I would expect it to have deleted everything on the drive.
>
> I have not fixed this problem in any of my use-cases, but it may(?) be 
> necessary to re-write that superblock onto the spare so it is 
> identified as such, however, how to do this, is a good question, it 
> would probably be assembly or if that does not work you would need to 
> create the array, assume clean (as you originally created it before) 
> so the superblock is written to the spare.  This all seems too 
> complicated though, there should (and probably) is a simpler way.
That's kind of that I was thinking...

Thanks for your continued help though :)

Max.
