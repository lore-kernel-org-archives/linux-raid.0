From: jim owens <jowens@hp.com>
Subject: Re: Converting system to raid
Date: Sat, 11 Apr 2009 11:04:40 -0400
Message-ID: <49E0B188.8050009@hp.com>
References: <003801c9b96d$21a0f420$0a00a8c0@vorg> <49DF0D06.8030705@musmo.com> <20090410195303.GB21242@cthulhu.home.robinhill.me.uk> <00cc01c9ba1d$3aefecf0$0a00a8c0@vorg> <20090410205942.GC21242@cthulhu.home.robinhill.me.uk> <00f301c9ba23$032025f0$0a00a8c0@vorg> <20090410215129.GD21242@cthulhu.home.robinhill.me.uk> <019701c9ba66$aeed5630$0a00a8c0@vorg> <20090411143642.GA9915@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090411143642.GA9915@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Hill wrote:
>> From: "CoolCold" <coolthecold@gmail.com>
>>
>> # rsync -avHhx --progress --delete / /mnt/raid-md0
>>
> Yes, this is an alternative to running from a bootable CD.  In
> single-user mode (init 1), there can be no background applications
> running, so there should be no open files to worry about.  I'd still
> rather use a bootable CD though.

Strong ACK on bootable CD as the right method, or doing it all
while init 1... not as a 2-step multi-user mode, single user.

rsync is a very good tool but unless you use:

    -c, --checksum    skip based on checksum, not mod-time & size

the consistency between runs is not 100% safe.  It may be 99.9%,
but the problem is that for file blocks being rewritten you don't
know what is on disk or in memory and mod-time only changes at the
whim of the FS (I'm an FS developer) and at the granularity of
the FS and system clock... nanosecond time stamps are a myth!

And if you are going to use the rsync -c 2-pass method it will
probably take your system off line longer than a CD boot and copy.

At the end of process, is 99.9% good enough?  For much of my
backup needs it is because I only care about not loosing more
than a small amount of work.  But if I'm converting to a new
disk and loosing the old one, I want 100%.

jim
