From: Asdo <asdo@shiftmail.org>
Subject: Re: possible bus loading problem during resync
Date: Tue, 09 Mar 2010 12:00:17 +0100
Message-ID: <4B962A41.50207@shiftmail.org>
References: <4B95EB5E.5090702@vorgon.com>
 <73e903671003090230y135d104cte15e07604b85b8aa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <73e903671003090230y135d104cte15e07604b85b8aa@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>, "Timothy D. Lenz" <tlenz@vorgon.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Kristleifur Da=F0ason wrote:
> On Tue, Mar 9, 2010 at 6:31 AM, Timothy D. Lenz <tlenz@vorgon.com> wr=
ote:
>  =20
>> I'm working on 2 systems that are mainly for running vdr. I've had t=
hese
>> running somewhat for awhile with raid. But a couple nights ago as I =
was
>> quitting for the night, I noticed one of the computers drive light s=
taying
>> on. I had just made some changes to xine and didn't know if somethin=
g had
>> crashed. Turned on the TV and found the video was freezing for 10-20=
secs
>> every 10-20secs. Logging in using putty and winscp I found it very s=
luggish
>> to respond.Starting top I found it was doing the regular array check=
/resync.......
>> --
>>    =20
>
>
> Sorry about the incredibly brief answer: Not to dismiss other issues,
> but that behavior seems like exactly what I've seen when a disk has
> been failing.
>  =20

If that is true, how does that happen, the driver is hung? But anyway,=20
how can such things happen when there is more than one CPU-core?

try disabling NCQ by echo 1 > /sys/block/sdX/device/queue_depth for all=
=20
drives. After doing this, at most 1 request can be issued to one drive=20
until the drive has serviced such request.

After doing this, firstly I'd say the sluggishness should disappear, at=
=20
least on SSH when not touching the disks. And then you can look with=20
"iostat -x 1": probably the bad drive will have a service time (svctm)=20
or await much worse than the others.

Just guesses, correct me if I'm wrong
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
