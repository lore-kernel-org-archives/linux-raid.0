From: Jim Duchek <jim.duchek@gmail.com>
Subject: Re: Array 'freezes' for some time after large writes?
Date: Wed, 31 Mar 2010 10:25:29 -0600
Message-ID: <s2xdead81ad1003310925z4bec9e0cod5f39421f9d06299@mail.gmail.com>
References: <dead81ad1003301007h4015ac57x99f36d232bb705b6@mail.gmail.com>
	 <4BB2A6E0.5010504@gmail.com>
	 <p2m5bdc1c8b1003310912i7215b7abh88989839a76feb84@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <p2m5bdc1c8b1003310912i7215b7abh88989839a76feb84@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Roger Heflin <rogerheflin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Agreed, playing with some of these settings appear to clear the
problem up, for at least the cases in which I tend to trigger it.
Much obliged for the help!

Jim


On 31 March 2010 10:12, Mark Knecht <markknecht@gmail.com> wrote:
> On Tue, Mar 30, 2010 at 6:35 PM, Roger Heflin <rogerheflin@gmail.com>=
 wrote:
>> Jim Duchek wrote:
>>>
>>> Hi all. =A0Regularly after a large write to the disk (untarring a v=
ery
>>> large file, etc), my RAID5 will 'freeze' for a period of time --
>>> perhaps around a minute. =A0My system is completely responsive othe=
rwise
>>> during this time, with the exception of anything that is attempting=
 to
>>> read or write from the array -- it's as if any file descriptors sim=
ply
>>> block.
> <SNIP>
>>
>> In /etc/sysctl.conf or with "sysctl -a|grep vm.dirty" check these tw=
o
>> settings:
>> vm.dirty_background_ratio 5
>> vm.dirty_ratio =3D 6
>>
>> Default will be something like 40 for the second one and 10 for the =
first
>> on.
>>
>> 40% is how much memory the kernel lets get dirty with write data, 10=
% or
>> whatever the bottom number is, is once it starts cleaning it up how =
low it
>> has to go before letting anyone else write again (ie freeze all writ=
es and
>> massively slow down reads)
>>
>> I set the values to the above, in older kernels 5 is the min value, =
newer
>> ones may allow lower, I don't believe it is well documented what the=
 limits
>> are, and if you set it lower the older kernels silently set the valu=
e to the
>> min internally in the kernel, you won't see it on sysctl -a check. =A0=
 So on
>> my machine I could freeze for how long it takes to write 1% of memor=
y out to
>> disk, which with 8GB is 81MB which takes at most a second or 2 at
>> 60mb/second or so. =A0If you have 8G and have the difference between=
 the two
>> set to 10% it can take 10+ seconds, I don't remember the default, bu=
t the
>> large it is the bigger the freeze will be.
>>
>> And these depends on the underlying disk speed, if the underlying di=
sk is
>> slower the time it takes to write out that amount of data is larger =
and
>> things are uglier, and file copies do a good job of causing this.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
> Very interesting Roger. Thanks.
>
> I did some reading on a couple of web site and then did some testing.
> I found for the sort of jobs I do that create and write data, as an
> example compiling and installing MythTV, these settings have a big
> effect on the percentage of time my system drops into these 100%wa, 0=
%
> CPU type of states. The default setting on my system was 10/20 and
> that tended to create this state quite a lot. 3/40 reduced it by
> probably 50-75%, while 3/70 seemed to eliminate it until the end of
> the build where the kernel/compiler is presumably forcing it out to
> disk because the job is finishing.
>
> One page I read mentioned data centers using a very good UPS and
> internal power supply and then running it at 1/100. I think the basic
> idea is that if we lose power there should be enough time to flush al=
l
> this stuff to disk before the power completely drops out but up until
> that time let the kernel take care of things completely.
>
> Experimentally what I see is that when I cross above the lower value
> it isn't that nothing gets written, but more that the kernel sort of
> opportunistically starts writing it to disk without letting it get to=
o
> much in the way of running programs, and then when the higher value
> seems to get crossed the system goes 100% wait while it pushes the
> data out and is waiting for the disk. I used the command
>
> grep -A 1 dirty /proc/vmstat
>
> to watch a compile taking place and looked when it was 100%
> user/system and then also when it went to 100% wait.
>
> Some additional reading seems to suggest tuning things like
>
> vm.overcommit_ratio
>
> and possibly changing the I/O scheduler
>
> keeper ~ # cat /sys/block/sda/queue/scheduler
> noop deadline [cfq]
>
> or changing the number of requests
>
> keeper ~ # cat /sys/block/sda/queue/nr_requests
> 128
>
> or read ahead values
>
> keeper ~ # blockdev --getra /dev/sda
> 256
>
> I haven't played with any of those.
>
> Based on this info I think it's worth my time trying a new RAID
> install and see if I'm more successful.
>
> Thanks very much for your insights and help!
>
> Cheers,
> Mark
>
>
>
> keeper ~ # vi /etc/sysctl.conf
>
> vm.dirty_background_ratio =3D 10
> vm.dirty_ratio =3D 20
>
> keeper ~ # sysctl -p
>
> real =A0 =A08m50.667s
> user =A0 =A030m6.995s
> sys =A0 =A0 1m30.605s
> keeper ~ #
>
>
> keeper ~ # vi /etc/sysctl.conf
>
> vm.dirty_background_ratio =3D 3
> vm.dirty_ratio =3D 40
>
> keeper ~ # sysctl -p
>
> keeper ~ # time emerge -DuN mythtv
> <SNIP>
> real =A0 =A08m59.401s
> user =A0 =A030m9.980s
> sys =A0 =A0 1m30.303s
> keeper ~ #
>
>
> keeper ~ # vi /etc/sysctl.conf
>
> vm.dirty_background_ratio =3D 3
> vm.dirty_ratio =3D 70
>
> keeper ~ # time emerge -DuN mythtv
> <SNIP>
> real =A0 =A08m52.272s
> user =A0 =A030m0.889s
> sys =A0 =A0 1m30.609s
> keeper ~ #keeper ~ # vi /etc/sysctl.conf
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
