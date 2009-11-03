From: "NeilBrown" <neilb@suse.de>
Subject: Re: unbelievably bad performance: 2.6.27.37 and raid6
Date: Tue, 3 Nov 2009 17:28:57 +1100
Message-ID: <763d89fcf9c0164cbe8b6245dc3d2d7f.squirrel@neil.brown.name>
References: <cccedfc60910310855l5ca6c42aj503fb0e4fd6232ad@mail.gmail.com>
    <4AEEF29C.10309@tmr.com>
    <cccedfc60911020703s3188ebcsac867922f937bb39@mail.gmail.com>
    <9e52db7bed791d8c8f5653b1958b1874.squirrel@neil.brown.name>
    <4877c76c0911022209g60e40364i2cb82909e31f707d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0911022209g60e40364i2cb82909e31f707d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, November 3, 2009 5:09 pm, Michael Evans wrote:
> On Mon, Nov 2, 2009 at 9:36 PM, NeilBrown <neilb@suse.de> wrote:
>> On Tue, November 3, 2009 2:03 am, Jon Nelson wrote:
>>> On Mon, Nov 2, 2009 at 8:54 AM, Bill Davidsen <davidsen@tmr.com> wr=
ote:
>>>> Jon Nelson wrote:
>>>>>
>>>>> I have a 4 disk raid6. The disks are individually capable of (at
>>>>> least) 75MB/s on average.
>>>>> The raid6 looks like this:
>>>>>
>>>>> md0 : active raid6 sda4[0] sdc4[5] sdd4[4] sdb4[6]
>>>>> =A0 =A0 =A0613409536 blocks super 1.1 level 6, 64k chunk, algorit=
hm 2 [4/4]
>>>>> [UUUU]
>>>>>
>>>>> The raid serves basically as an lvm physical volume.
>>>>>
>>>>> While rsyncing a file from an ext3 filesystem to a jfs filesystem=
, I
>>>>> am observing speeds in the 10-15MB/s range.
>>>>> That seems really really slow.
>>>>>
>>>>>
>>>>
>>>> It is really slow, recent kernels seem to be unsuitable for use as
>>>> large
>>>> file servers, as the performance is, as you described it,
>>>> "unbelievably
>>>> bad."
>>>
>>> Yeah. I'm hoping that the 2.6.31.XX stable kernel series gets some =
of
>>> these improvements, the .27 series has been not the most stable for=
 me
>>> either. =A02.6.27.25 was the last rock-solid of the .27 series for =
me.
>>
>> I wouldn't get your hopes up...
>> I did some limited testing of simple writes to ext2 and the current
>> 32-pre kernel is noticably slower than .26 .27 .28 .29 .. (that is a=
s
>> far as I got with testing... I should write a script and leave it
>> running
>> overnight to get a broader picture).
>>
>> NeilBrown
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
> Maybe my speed results even after the 'fix' are also this issue:  I
> expect each of my drives is capable of at least 8MB/sec sustained
> (highly pessimistic).
>
>      2909829120 blocks super 1.1 level 6, 128k chunk, algorithm 18
> [8/8] [UUUUUUUU]
>      [=3D=3D>..................]  reshape =3D 10.4% (50708096/4849715=
20)
> finish=3D3989.0min speed=3D1813K/sec
>
> The 'backup file' is on a separate raid 1 device and approximately 25
> mb in size.  My cpu has virtually no load and I've got gigs of memory
> free.

A reshape is a fundamentally slow operation.  Each block needs to
be read and then written somewhere else so there is little opportunity
for streaming.
An in-place reshape (i.e the array doesn't get bigger or smaller) is
even slower as we have to take a backup copy of each range of blocks
before writing them back out.  This limits streaming even more.

It is possible to get it fast than it is by increasing the
array's stripe_cache_size and also increasing the 'backup' size
that mdadm uses.  mdadm-3.1.1 will try to do better in this respect.
However it will still be significantly slower than e.g. a resync.

So reshape will always be slow.  It is a completely different issue
to filesystem activity on a RAID array being slow.  Recent reports of
slowness are, I think, not directly related to md/raid.  It is either
the filesystem or the VM or a combination of the two that causes
these slowdowns.


NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
