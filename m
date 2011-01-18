From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Read algorithm-raid1/raid10
Date: Tue, 18 Jan 2011 15:51:08 +0000
Message-ID: <AANLkTinJNLYd6uYp+zjrQsWiwKS9ZWMuhMQfcpg-4rj4@mail.gmail.com>
References: <AANLkTin+Kd+RfuEUyBrvnunBbQ+2uzzdy57Xy-LEJ_6J@mail.gmail.com>
	<AANLkTi=ULecH9g9Mt+axPY_KsyvZU=KdawphxpJ2kDGi@mail.gmail.com>
	<20110118150149.GB602@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110118150149.GB602@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Keld_J=C3=B8rn_Simonsen?= <keld@keldix.com>
Cc: Roberto Spadim <roberto@spadim.com.br>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2011/1/18 Keld J=C3=B8rn Simonsen <keld@keldix.com>:
> On Tue, Jan 18, 2011 at 12:00:49PM -0200, Roberto Spadim wrote:
>> like this patch (a long time ago)
>> http://www.spinics.net/lists/raid/msg30003.html
>>
>>
>> 2011/1/18 Roberto Spadim <roberto@spadim.com.br>:
>> > hi guys, could we implement a load_balance read algorithm for SSD?
>> > nearest head isn't as fast as round robin for ssd.
>> > i'm talking about raid1 (raid10 too)
>> > what's my problem?
>> > as i can see, raid0 is faster than raid1
>> > for example:
>> > two disks raid0 is faster than
>> > two disks raid1.
>> >
>> > why?
>> > nearest head
>> > instead of a balanced read algorithm (like raid0) the nearest head
>> > make raid1 use only one disk for searchs where we could use two di=
sks
>> > (like raid0)
>> >
>> > could we implement a round robin for ssd? and make raid1 as fast a=
s
>> > raid0 for ssd?
>> > i didn't tested the raid10 algorithm yet.
>> > thanks a lot.
>
> This should only be in use for SSDs. For disks it would be a waste of=
 IO
> bandwidth. How do we detect whether it is a SSSD.
> Another way to accomplish an improvement os to use the offset layout =
of
> raid10.
>
> best regards
> Keld
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Hi,

There is a way to check if the device is an SSD or not; the rotational
queue flag in sysfs. See
http://amailbox.org/mailarchive/git-commits-head/2009/1/30/4859834/thre=
ad
=2E

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
