From: David Rees <drees76@gmail.com>
Subject: Re: help with bad performing raid6
Date: Fri, 31 Jul 2009 12:19:44 -0700
Message-ID: <72dbd3150907311219v53bc4fbfja9cc29c806136ae0@mail.gmail.com>
References: <cccedfc60907271219n1f3431c4w50033d4f5bc43edc@mail.gmail.com>
	<72dbd3150907301409t5ea20979gcf400e4c53a32d62@mail.gmail.com>
	<20090731182118.GB11756@rap.rap.dk> <cccedfc60907311123i6232f926n6617ed9d2432c081@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60907311123i6232f926n6617ed9d2432c081@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-suse@jamponi.net>
Cc: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2009/7/31 Jon Nelson <jnelson-suse@jamponi.net>:
> 2009/7/31 Keld J=F8rn Simonsen <keld@dkuug.dk>:
>> On Thu, Jul 30, 2009 at 02:09:19PM -0700, David Rees wrote:
>>> On Mon, Jul 27, 2009 at 12:19 PM, Jon Nelson<jnelson-suse@jamponi.n=
et> wrote:
>>> > When I say "bad performance" I mean writes that vary down to 100K=
B/s
>>> > or less, as reported by rsync. The "average" end-to-end speed for
>>> > writing large (500MB to 5GB) files hovers around 3-4MB/s. This is=
 over
>>> > 100 MBit.
>>>
>>> That doesn't sound too unexpected. =A0rsync does a lot of reading a=
nd
>>> writing, so you're going to see less than network speeds.
>>
>> rsync also does a lot of computing, so that is also a source of dela=
y.
>> For faster cpu's the delay is not so big. I get near network speed (=
 80
>> Mbit/s on a 100 Mbit/s LAN) between two of my faster machines.
>
> In this case, you may all be assured it was not doing much reading
> over NFS or computing, as the file did not exist on the NFS share - i=
n
> this case NFS goes into (more or less) pure write mode - no updating
> per-se.

OK, so how fast does a simple dd write to the NFS share?

-Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
