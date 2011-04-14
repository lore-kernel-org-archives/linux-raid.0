From: CoolCold <coolthecold@gmail.com>
Subject: Re: Any pros or cons of using full disk versus partitons?
Date: Thu, 14 Apr 2011 11:57:47 +0400
Message-ID: <BANLkTi=vgVxVRomvpkX5uxSvN9Fe1cgvoQ@mail.gmail.com>
References: <07a801cbfa12$64b8a950$2e29fbf0$@gmail.com>
	<20110413.132112.102552472.davem@davemloft.net>
	<io52j7$cg4$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <io52j7$cg4$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 14, 2011 at 12:55 AM, David Brown <david.brown@hesbynett.no=
> wrote:
> On 13/04/11 22:21, David Miller wrote:
>>
>> From: "Matthew Tice"<mjtice@gmail.com>
>> Date: Wed, 13 Apr 2011 13:38:39 -0600
>>
>>> So of course it technically doesn't matter but are there certain
>>> (non-apparent) repercussions for choosing one over the other? =A0It=
 seems
>>> to
>>> save a couple steps by using the whole disk (not having to partitio=
n) -
>>> but
>>> is that it? =A0One thing I'm thinking about the pros of using parti=
tions is
>>> if
>>> all your disks (or some) are different sizes - then you can set the
>>> partition sizes the same.
>>
>> First, you sent this to "linux-raid-owner" instead of just
>> "linux-raid". =A0The former goes to me, not to the mailing list.
>>
>> I've corrected it in the CC:
>>
>> Second, to answer your question, for some disk label variants you
>> risk over-writing the disk label if you use the whole device
>> as part of your RAID volume. =A0This definitely will happen, for
>> example, with Sun disk labels.
>
> Using whole disks in the raid will make it easier for replacing disks=
 - you
> don't have to worry about partitioning them. =A0You can just plug the=
m in and
> use them. =A0If you have some sort of monitoring scripts and hot plug=
 disks,
> you may be able to avoid any interaction at all on disk replacement.
>
> On the other hand, using partitions gives you lots more flexibility. =
You can
> do things such as use a small partition on each disk to form a raid10=
 array
> for swap, while using a bigger partition for data. =A0Or perhaps you =
want a
> very small partition on each disk as a wide raid1 mirror, for your /b=
oot
> (not that you need so much safety for /boot, but that it's easier to =
boot
> from a raid1 with metadata format 0.90 than from other raid types).
Just my 2 cents: I've faced problems when newer disk was smaller than
old disk two or three times, so using partitions now with setting some
free space at the end - something near 80 or 100 megabytes.

If your system is located on the same disks which holds useful data,
it might be useful to split data into another mountpoint/block device
and let system skip fs check on startup and produce booted server,
which is helpful in case of system crash/powerloss and dirty
fs/breaked raid. RAID assembly problems may be caused by crappy
controller like lsi 1068e which was hanging the whole system and
desync data writes on disks on SMART request or completely on it's
own.


>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
