From: David Brown <david@westcontrol.com>
Subject: Re: Software RAID and TRIM
Date: Wed, 29 Jun 2011 15:10:12 +0200
Message-ID: <iuf8b0$kaj$1@dough.gmane.org>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk> <BANLkTimswAVra6qnMS4g8WRzs=dhi_f7OQ@mail.gmail.com> <alpine.OSX.2.00.1106291133060.257@trogdor.csi.cam.ac.uk> <iuf6me$9us$1@dough.gmane.org> <alpine.OSX.2.00.1106291348430.257@trogdor.csi.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.00.1106291348430.257@trogdor.csi.cam.ac.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29/06/2011 14:55, Tom De Mulder wrote:
> On Wed, 29 Jun 2011, David Brown wrote:
>
>>> While you are mostly correct, over time even consumer SSDs will end=
 up
>>> in this state.
>> I don't quite follow you here - what state will consumer SSDs end up=
 in?
>
> Sorry, I meant to say "SSDs in typical consumer desktop machines". Th=
e
> state where writes are very slow.
>

Well, many consumer level systems use older or cheaper SSDs which don't=
=20
have the benefit of newer garbage collection, and don't have much=20
over-provisioning (you can always do that yourself by leaving some spac=
e=20
unpartitioned - but "consumer" users would typically not do that).  And=
=20
remember that for users in this class, who will probably have small SSD=
s=20
to keep costs down, will have fairly full drives - making TRIM almost=20
useless.

>> Have you tried any real-world benchmarking with realistic loads with=
 a
>> single SSD, ext4, and TRIM on and off? Almost every article I've see=
n
>> on the subject is using very synthetic benchmarks, almost always on
>> windows, few are done with current garbage-collecting SSDs. It seems
>> to be accepted wisdom from the early days of SSDs that TRIM makes a
>> big difference - and few people challenge that with real numbers or
>> real thought, even though the internal structure of the flash has
>> changed dramatically (transparent compression, for example, gives a
>> completely different effect).
>>
>> Of course, if you /do/ try it yourself and can show clear figures,
>> then I'm willing to change my mind :-) If I had a spare SSD, I'd do
>> the testing myself.
>
> I have a set of 4 Intel 510 SSDs purely for testing, and I have used
> these to simulate the kinds of workload I would expect them to
> experience in a server environment (focused mainly on database access=
).
> So far, those tests have focused on using single drives (ie. without
> RAID) on a variety of controllers.
>
> Once the drives get fuller (something which does happen on servers) I=
 do
> indeed see write latencies that are in the order of several seconds (=
I
> saw from 1500=B5s to 6000=B5s), as the drive suddenly struggles to fr=
ee
> entire blocks, where initially latency was in the single digits.
>
> I am hoping to get my hands on some Sandforce controller-based SSDs a=
s
> well, to compare, but even they show degradation as they get fuller i=
n
> AnandTech's tests (and those tests seem, IME, trustworthy).
>
> My current plan is to sacrifice half the capacity by partitioning, st=
ick
> 2 of them in md RAID1 (so, without TRIM) and over the next few days t=
o
> run benchmarks over them, to see what the end result is.
>

Well, try it and see - and let us know the results.  50% manual=20
over-provisioning seems excessive, but I guess that's what you'll find=20
out with the tests.

>
> Best,
>
> --
> Tom De Mulder <tdm27@cam.ac.uk> - Cambridge University Computing Serv=
ice
> +44 1223 3 31843 - New Museums Site, Pembroke Street, Cambridge CB2 3=
QH
> -> 29/06/2011 : The Moon is Waning Crescent (18% of Full)


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
