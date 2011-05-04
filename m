From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Mirrored volume peformance questions
Date: Wed, 4 May 2011 12:43:24 -0300
Message-ID: <BANLkTimten+bOJpsoDERDsE2CH1MT_NQ7g@mail.gmail.com>
References: <96B30EF4F3E17749BCFF7F1816090EDA02DCE41A87@EX-SEA31-B.ant.amazon.com>
	<BANLkTikcVPQwFEancNbOkKvdHTwdHDb=XA@mail.gmail.com>
	<20110503213430.GC24265@www2.open-std.org>
	<ipqvv6$ru1$1@dough.gmane.org>
	<20110504081339.GB414@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110504081339.GB414@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i think that a good add to today read balance could be add disk
acess_time (1/rpm, 0 for 'non rotational', 1 for unknow)
head_distance * acess_time, could allow a better select of disks or
mix of 7200/10000/15000 rpm disks
maybe it can be read from disk information at assemble time, i don't
know if disk speed (rpm) can be read from device block (some disks
display information with hdparm and smartctl)
it's not a 1000% improvement, it's 1% at high read/write load

2011/5/4 Keld J=F8rn Simonsen <keld@keldix.com>:
> On Wed, May 04, 2011 at 09:42:40AM +0200, David Brown wrote:
>> raid10,far is better for sequential reads - it gives better-than-rai=
d0
>> performance on average since it will do striped reads from the faste=
r
>> outer tracks. =A0And for multi-threaded reads, it should also be a l=
ittle
>> faster than other raid10 layouts (and raid1, which is much the same =
as
>> raid10,near). =A0Since it prefers to get the data from the outer hal=
f, you
>> get the benefits of short-stroking your disks - faster transfer spee=
ds
>> and less head movement.
>>
>> The cost of raid10,far is greater head movement for writes - but tha=
t is
>> not the OP's main concern.
>
> yes, in theory this is so. But two reasons almost eliminates this in
> practice. First, the processes do not wait for completion of the IO o=
f
> writes, the processes only deliver the data to the file buffer cache =
of
> the kernel, which then periodically flushes the data to the disk driv=
es.
> Second, the flushing of the data is ordered so that the collected dat=
a
> buffers are written as much sequentially as possible to the drives.
> This goes for all Linux MD RAID1/RAID10 layouts. Given that random
> writes are random over the whole set of drives, for any mirrored
> raid1/raid10 layout, the flushing of the data is about the same.
>
> best regards
> keld
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
