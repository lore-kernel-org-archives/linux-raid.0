From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: unbelievably bad performance: 2.6.27.37 and raid6
Date: Mon, 2 Nov 2009 22:09:46 -0800
Message-ID: <4877c76c0911022209g60e40364i2cb82909e31f707d@mail.gmail.com>
References: <cccedfc60910310855l5ca6c42aj503fb0e4fd6232ad@mail.gmail.com>
	 <4AEEF29C.10309@tmr.com>
	 <cccedfc60911020703s3188ebcsac867922f937bb39@mail.gmail.com>
	 <9e52db7bed791d8c8f5653b1958b1874.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9e52db7bed791d8c8f5653b1958b1874.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Nov 2, 2009 at 9:36 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, November 3, 2009 2:03 am, Jon Nelson wrote:
>> On Mon, Nov 2, 2009 at 8:54 AM, Bill Davidsen <davidsen@tmr.com> wro=
te:
>>> Jon Nelson wrote:
>>>>
>>>> I have a 4 disk raid6. The disks are individually capable of (at
>>>> least) 75MB/s on average.
>>>> The raid6 looks like this:
>>>>
>>>> md0 : active raid6 sda4[0] sdc4[5] sdd4[4] sdb4[6]
>>>> =A0 =A0 =A0613409536 blocks super 1.1 level 6, 64k chunk, algorith=
m 2 [4/4]
>>>> [UUUU]
>>>>
>>>> The raid serves basically as an lvm physical volume.
>>>>
>>>> While rsyncing a file from an ext3 filesystem to a jfs filesystem,=
 I
>>>> am observing speeds in the 10-15MB/s range.
>>>> That seems really really slow.
>>>>
>>>>
>>>
>>> It is really slow, recent kernels seem to be unsuitable for use as =
large
>>> file servers, as the performance is, as you described it, "unbeliev=
ably
>>> bad."
>>
>> Yeah. I'm hoping that the 2.6.31.XX stable kernel series gets some o=
f
>> these improvements, the .27 series has been not the most stable for =
me
>> either. =A02.6.27.25 was the last rock-solid of the .27 series for m=
e.
>
> I wouldn't get your hopes up...
> I did some limited testing of simple writes to ext2 and the current
> 32-pre kernel is noticably slower than .26 .27 .28 .29 .. (that is as
> far as I got with testing... I should write a script and leave it run=
ning
> overnight to get a broader picture).
>
> NeilBrown
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Maybe my speed results even after the 'fix' are also this issue:  I
expect each of my drives is capable of at least 8MB/sec sustained
(highly pessimistic).

     2909829120 blocks super 1.1 level 6, 128k chunk, algorithm 18
[8/8] [UUUUUUUU]
     [=3D=3D>..................]  reshape =3D 10.4% (50708096/484971520=
)
finish=3D3989.0min speed=3D1813K/sec

The 'backup file' is on a separate raid 1 device and approximately 25
mb in size.  My cpu has virtually no load and I've got gigs of memory
free.

(also sorry for duplicates, I hit reply at the top instead of reply to
all at the bottom out of habit)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
