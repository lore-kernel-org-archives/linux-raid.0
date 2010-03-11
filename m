From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Fwd: Re: possible bus loading problem during resync
Date: Thu, 11 Mar 2010 11:16:30 -0700
Message-ID: <4B99337E.5070409@vorgon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This was ment to goto the list. Keep forgetting, this list uses=20
responder instead of list for reply address.

-------- Original Message --------
Subject: Re: possible bus loading problem during resync
Date: Wed, 10 Mar 2010 17:04:07 -0700
=46rom: Timothy D. Lenz <tlenz@vorgon.com>
To: Asdo <asdo@shiftmail.org>



On 3/9/2010 4:00 AM, Asdo wrote:
> Kristleifur Da=F0ason wrote:
>> On Tue, Mar 9, 2010 at 6:31 AM, Timothy D. Lenz <tlenz@vorgon.com> w=
rote:
>>> I'm working on 2 systems that are mainly for running vdr. I've had =
these
>>> running somewhat for awhile with raid. But a couple nights ago as I=
 was
>>> quitting for the night, I noticed one of the computers drive light
>>> staying
>>> on. I had just made some changes to xine and didn't know if somethi=
ng
>>> had
>>> crashed. Turned on the TV and found the video was freezing for 10-2=
0secs
>>> every 10-20secs. Logging in using putty and winscp I found it very
>>> sluggish
>>> to respond.Starting top I found it was doing the regular array
>>> check/resync.......
>>> --
>>
>>
>> Sorry about the incredibly brief answer: Not to dismiss other issues=
,
>> but that behavior seems like exactly what I've seen when a disk has
>> been failing.
>
> If that is true, how does that happen, the driver is hung? But anyway=
,
> how can such things happen when there is more than one CPU-core?
>
> try disabling NCQ by echo 1 > /sys/block/sdX/device/queue_depth for a=
ll
> drives. After doing this, at most 1 request can be issued to one driv=
e
> until the drive has serviced such request.
>
> After doing this, firstly I'd say the sluggishness should disappear, =
at
> least on SSH when not touching the disks. And then you can look with
> "iostat -x 1": probably the bad drive will have a service time (svctm=
)
> or await much worse than the others.
>
> Just guesses, correct me if I'm wrong
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>

=46irst output is 5.12 for sda and 1.15 for sdb every time it's started=
=2E
then mostly 0 for both. When there are numbers it changes back and fort=
h
between then as to which is greater.

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s
avgrq-sz avgqu-sz   await  svctm  %util
sda               6.90    30.46    2.09    1.90  1164.19   258.92
356.52     0.10   23.99   5.12   2.04
sdb               0.16    30.46    8.84    1.90  1165.65   258.92
132.67     0.02    2.25   1.51   1.62


Was this test supposed to be done while it was doing a sync? Because it
was the same if I made the change to 1 or put them back to the default
value 31.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
