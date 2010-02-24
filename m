From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: emergency call for help: raid5 fallen apart
Date: Wed, 24 Feb 2010 20:54:37 +0100
Message-ID: <4B8583FD.8090406@xunil.at>
References: <4B853DB7.1060406@xunil.at> <4B854040.5080603@xunil.at> <20100224152228.GB11039@cthulhu.home.robinhill.me.uk> <4B85467C.5020008@xunil.at> <4B855621.5010000@xunil.at> <4B855987.1010605@xunil.at> <20100224170951.GC11039@cthulhu.home.robinhill.me.uk> <4B856372.6000900@xunil.at> <20100224181219.GA8043@cthulhu.home.robinhill.me.uk>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100224181219.GA8043@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 24.02.2010 19:12, schrieb Robin Hill:

>> mdadm --stop /dev/md4
>>
>> ddrescue /dev/sda4 /dev/sdd4
>>
>> mdadm --assemble --force /dev/md4 /dev/sdb4 /dev/sdd4
>>
>> ??
>>
> Yes, that'd be what I'd recommend - the ddrescue will only need to make
> a single pass across sda4 (except for failed blocks of course), so will
> have the lowest risk of exacerbating the disk problems.  Of course, the
> practicality of doing the assemble will depend on the number of
> unreadable blocks found by ddrescue.

I decided to somehow roll back.

As far as we see we lose 1.5 hrs of work done by some people ... thanks
to the rsnapshots ...

The LV containing the VM was/is healthy, I was able to copy the
vm-directory fine and the VM boots and runs. No work lost here.

So far I don't use that flaky md4 for now ... doing the ddrescue would
take quite some time and this box has to be UP tomorrow.

And additionally I wouldn't know about the result.

I'll decide how to proceed tomorrow. For now the data and the function
for tomorrow comes first, even without full RAID now. So I restore stuff
now ...

I am somehow tired and exhausted now and not willing to risk what I have
got now.

> Good luck!
>     Robin

Thanks a lot ... Stefan
