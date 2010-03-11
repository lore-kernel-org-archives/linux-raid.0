From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: possible bus loading problem during resync
Date: Thu, 11 Mar 2010 06:53:50 +0100
Message-ID: <871vfrcsk1.fsf@frosties.localdomain>
References: <4B95EB5E.5090702@vorgon.com>
	<73e903671003090230y135d104cte15e07604b85b8aa@mail.gmail.com>
	<4B962A41.50207@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B962A41.50207@shiftmail.org> (asdo@shiftmail.org's message of
	"Tue, 09 Mar 2010 12:00:17 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: Kristleifur Daoason <kristleifur@gmail.com>, "Timothy D. Lenz" <tlenz@vorgon.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Asdo <asdo@shiftmail.org> writes:

> Kristleifur Da=F0ason wrote:
>> On Tue, Mar 9, 2010 at 6:31 AM, Timothy D. Lenz <tlenz@vorgon.com> w=
rote:
>>
>>> I'm working on 2 systems that are mainly for running vdr. I've had =
these
>>> running somewhat for awhile with raid. But a couple nights ago as I=
 was
>>> quitting for the night, I noticed one of the computers drive light =
staying
>>> on. I had just made some changes to xine and didn't know if somethi=
ng had
>>> crashed. Turned on the TV and found the video was freezing for 10-2=
0secs
>>> every 10-20secs. Logging in using putty and winscp I found it very =
sluggish
>>> to respond.Starting top I found it was doing the regular array chec=
k/resync.......
>>> --
>>>
>>
>>
>> Sorry about the incredibly brief answer: Not to dismiss other issues=
,
>> but that behavior seems like exactly what I've seen when a disk has
>> been failing.
>>
>
> If that is true, how does that happen, the driver is hung? But anyway=
,
> how can such things happen when there is more than one CPU-core?

A drive produces an error, the whole controler hangs and resets all
ports, all drives have to finish being reset before any IO can continue=
=2E
Hapens easily enough.

> try disabling NCQ by echo 1 > /sys/block/sdX/device/queue_depth for
> all drives. After doing this, at most 1 request can be issued to one
> drive until the drive has serviced such request.
>
> After doing this, firstly I'd say the sluggishness should disappear,
> at least on SSH when not touching the disks. And then you can look
> with "iostat -x 1": probably the bad drive will have a service time
> (svctm) or await much worse than the others.
>
> Just guesses, correct me if I'm wrong

What I would start with is check the resync/check speed of the raid and
kernel messages. If it is running at high speed and there are no kernel
messages about IO errors then it is probably just a case of the IO
subsystem being busy. I got similar sluggish behaviour when I increased
the stripe cache to 16384 for a reshape.

If there are no hardware problems on the disks causing this then try
setting the max speed for the resync lower. That way the resync will
leave pauses where other IO and bus activity can happen. The raid shoul=
d
slow down automatically if there is normal IO pending but in my
experience that doesn't always work.

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
