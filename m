From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Multi-layer raid status
Date: Fri, 2 Feb 2018 16:49:09 +0000
Message-ID: <5A749685.20107@youngman.org.uk>
References: <5A708F8E.2040604@hesbynett.no>
 <87372k2aix.fsf@notabene.neil.brown.name> <5A744054.4060305@hesbynett.no>
 <5A7448AF.3050108@youngman.org.uk> <5A744C4B.7030704@hesbynett.no>
 <5A7474B1.1020807@youngman.org.uk> <5A747AC1.8030206@hesbynett.no>
 <5A747DA5.2030801@youngman.org.uk> <5A748662.3030608@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5A748662.3030608@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/02/18 15:40, David Brown wrote:
> On 02/02/18 16:03, Wols Lists wrote:
>> On 02/02/18 14:50, David Brown wrote:
>>> What are these cases?  We have already eliminated the rebuild situation
>>> I described.  And in particular, which use-cases are you thinking of
>>> where you not be better off with alternative integrity improvements
>>> (like higher redundancy levels) without killing performance?
>>>
>> In particular, when you KNOW you've got a damaged raid, and you want to
>> know which files are affected. The whole point of my technique is that
>> either it uses the raid to recover (if it can) or it propagates a read
>> error back to the application. It does NOT "fix" the data and leave a
>> corrupted file behind.
> 
> If you read a block and the read fails, the raid system will already
> read the whole stripe to re-create the missing data.  If it can
> re-create it, it writes the new data back to the disk and returns it to
> the application.  If it cannot, it gives the read error back to the
> application.
> 
> I cannot imagine a situation where you would have a disk that you know
> has incorrect data, as part of your array and in normal use for a file
> system. 

Can't you? When I was discussing this originally I had a bunch of
examples given to me.

Let's take just one, which as far as I can tell is real, and is probably
far more common than system developers would like to admit. A drive
glitches, and writes a load of data - intended for let's say track 1398
- to track 1938 by mistake. Okay, that particular example is a decimal
blunder, and a drive would probably make a bit-flip mistake instead, but
writing data to the wrong place is apparently a well-recognised
intermittent failure mode. (And it's not even always hardware to blame -
just an unfortunate cosmic ray incident.)

Or - and it was reported on this list - a drive suffers a power glitch
and dumps the entire contents of its write buffer.

Either way, we now have a raid array which APPEARS to be functioning
normally, and a bunch of stripes are corrupt. If you're lucky (and yes,
this does seem to be the normal state of affairs) then it's just the
parity which has been corrupted, which a scrub will fix. But if it's not
the parity, then raid-1 and raid-5 you can kiss your data bye-bye, and
if it's raid-6, a scrub will send your data to data heaven.

And saying "it's never happened to me" doesn't mean it's never happened
to anyone else.


Let's go back a few years, to the development of the ext file system
from version 2, to version 4. I can't remember the exact saying, but
it's something along the lines of "premature optimisation is the root of
all evil". When an ext2 system crashed, you could easily spend hours
running fsck before the system was usable.

So the developers developed ext3, with a journal. By chance, this always
wrote the data blocks before the journal, so when the system crashed,
the journal fixed the file system, and the users were very happy they
didn't need a fsck.

Then the developers decided to optimise further into ext4 and broke the
link between data and journal! So now, an ext4 system might boot faster
after a crash, shaving seconds off journal replay time. But the system
took MUCH LONGER to be available to users, because now the filesystem
corrupted user data, and instead of running the system level fsck, users
had to replace it with an application data integrity tool.


So yes, my "integrity checking raid" might be slow. Which is why it
would be disabled by default, and require flipping a runtime switch to
enable it. But it's a hell of a lot faster than an "mkfs and reload from
backup", which is the alternative if your disk is corrupt (as opposed to
crashed and dead).

And my way gives you a list of corrupted files that need restoring, as
opposed to "scrub, fix, and cross your fingers".

And one last question - if my idea is stupid, why did somebody think it
worthwhile to write raid6check?

Why is it that so many kernel level guys seem to treat user data
integrity with contempt?

Cheers,
Wol
