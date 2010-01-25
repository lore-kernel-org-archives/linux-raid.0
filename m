From: Steven Haigh <netwiz@crc.id.au>
Subject: Re: Why does one get mismatches?
Date: Tue, 26 Jan 2010 09:49:28 +1100
Message-ID: <27F5783C-96DC-4B04-A3EF-D5E7F5F1DD6B@crc.id.au>
References: <201001252043.o0PKhseR027690@wind.enjellic.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201001252043.o0PKhseR027690@wind.enjellic.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 26/01/2010, at 7:43 AM, greg@enjellic.com wrote:

> On Jan 21, 12:48pm, Farkas Levente wrote:
> } Subject: Re: Why does one get mismatches?
> 
> Good afternoon to everyone, hope the week is starting well.
> 
>> On 01/21/2010 11:52 AM, Steven Haigh wrote:
>>> On Thu, 21 Jan 2010 09:08:42 +0100, Asdo<asdo@shiftmail.org>  wrote:
>>>> Steven Haigh wrote:
>>>>> On Wed, 20 Jan 2010 17:43:45 -0500, Brett Russ<bruss@netezza.com>
>>> wrote:
>>>>> 
>>>>> CUT!
>>>> Might that be a problem of the disks/controllers?
>>>> Jon and Steven, what hardware do you have?
>>> 
>>> I'm running some fairly old hardware on this particular server. It's a
>>> dual P3 1Ghz.
>>> 
>>> After running a repair on /dev/md2, I now see:
>>> # cat /sys/block/md2/md/mismatch_cnt
>>> 1536
>>> 
>>> Again, no smart errors, nothing to indicate a disk problem at all :(
>>> 
>>> As this really keeps killing the machine and it is a live system - the
>>> only thing I can really think of doing is to break the RAID and just rsync
>>> the drives twice daily :\
> 
>> the same happened with many people. and we all hate it since it
>> cause a huge load at all weekend on most of our servers:-( according
>> to redhat it's not a bug:-(
> 
> The RAID check/mismatch_count is an example of well intentioned
> technology suffering from 'featuritis' by the distributions which is,
> as I predicted a couple of times in this forum, causing all sorts of
> angst and problems throughout the world.  I've had some posts on this
> subject but will summarize in the hopes of giving some background
> information which will be useful to people.
> 
> There is an issue in the kernel which causes these mismatches.  The
> problem seems to be particularly bad with RAID1 arrays.  The
> contention is that these mismatches are 'harmless' because they only
> occur in areas of the filesystems which are not being used.
> 
> The best description is that the buffers containing the data to be
> written are not 'pinned' all the way down the I/O stack.  This can
> cause the contents of a buffer to be changed while in transit through
> the I/O stack.  Thus one copy of a mirror gets a buffer written to it
> different then the other side of the mirror.
> 
> I've read reasoned discussions about why this occurs with swap over
> RAID1 and why its harmless.  I've set to see the same type of reasoned
> discussion as to why it is not problematic with a filesystem over
> RAID1.  There has been some discussion that its due to high levels of
> MMAP activity on the filesystem.
> 
> We have confirmed, that at least with RAID1, this all occurs with no
> physical corruption on the 'disk drives'.  We implement geographically
> mirror storage with RAID1 against two separate data-centers.  At each
> data-center the RAID1 'block-device' are RAID5 volumes.  These latter
> volumes check out with no errors/mismatch counts etc.  So the issue is
> at the RAID1 data abstraction layer.
> 
> There do not appear to be any tools which allow one to determine
> 'where' the mismatches are.  Such a tool, or logging by the kernel,
> would be useful for people who want to verify what files, if any, are
> affected by the mismatch.  Otherwise running a 'repair' results in the
> RAID1 code arbitraily deciding which of the two blocks is the
> 'correct' one.
> 
> So thats sort of a thumbnail sketch of what is going on.  The fact the
> distributions chose to implement this without understanding the issues
> it presents is a bit problematic.
> 
>>   Levente                               "Si vis pacem para bellum!"
> 
> Hopefully this information is helpful.
> 
> Greg

Hi Greg and all,

The funny part is that I believe the mismatches aren't happening in the empty space of the filesystem - as it seems that the errors are causing the ext3 journal to abort and force the filesystem into readonly in my particular situation.

It is interesting that I do not get any mismatches on md0, md1 or md3 - only md2.

md0 = /boot
md1 = swap
md2 = /
md3 = /tmp

I ran weekly checks on the all four RAID1 arrays and ONLY md2 had a problem with mismatches, which also had a habit of going readonly - therefore I don't believe the part of common belief that this problem only affects empty parts of the filesystem.

I have also done just about every test to the disks that I can think of with no errors to be found - leaving only the md layer to be suspect.

--
Steven Haigh

Email: netwiz@crc.id.au
Web: http://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
Fax: (03) 8338 0299






