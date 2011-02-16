From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: write-behind has no measurable effect?
Date: Wed, 16 Feb 2011 12:00:41 -0300
Message-ID: <AANLkTinus5p_A0sADMv7Z=+xnfdfwnRRo8p_-uye3ddD@mail.gmail.com>
References: <20110214213817.GG836@hellgate.intra.guy>
	<20110215095042.51ef7e0a@notabene.brown>
	<20110214225754.GK19990@hellgate.intra.guy>
	<20110215104109.06b12b33@notabene.brown>
	<20110215010052.GA13135@hellgate.intra.guy>
	<4D59D4A5.9050106@anonymous.org.uk>
	<20110215021900.GB13135@hellgate.intra.guy>
	<AANLkTikFSOePZJXknAt=Tx6+FpdJ4tiSNwpuwuPC3RY=@mail.gmail.com>
	<AANLkTinAV4jJc8ueZ1mjRPpDnA_eWhUDcL8uz-0Ufifk@mail.gmail.com>
	<20110216120056.GD13135@hellgate.intra.guy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110216120056.GD13135@hellgate.intra.guy>
Sender: linux-raid-owner@vger.kernel.org
To: Andras Korn <korn@raidlist.elan.rulez.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

a question here...
what happen if all disks are write-mostly and just ssd is write-behind?

why?
write-behind is an async feature (md only return ok to filesystem if
non write-behind disks are sync writen)
write-mostly is a read_balance optimization (ony read from that device
if all non-write-mostly devices fail)

making all disks write-mostly could allow us to use write-behind on
slowest(s) disk(s)

another idea...
could we change raid1 write code? how?
if a total of X write are done, return ok to filesystem, all other
devices are marked as write-behind (automatic write-behind) after sync
writes disks are marked as non-write-behind again
maybe a optimization is: what disk MUST be sync(only non
write-behind), what disk MUST BE async (only write-behind), what disk
can be async/sync (any write-behind type)


another question...
can read balance use write-mostly device in a very busy system without
failed devices (all mirrors are in sync)?


2011/2/16 Andras Korn <korn@raidlist.elan.rulez.org>:
> On Tue, Feb 15, 2011 at 06:10:17AM -0300, Roberto Spadim wrote:
>
>> andras could you make some benchmarks to raid1 with round robin read=
 balance?
>> at this site:
>> www.spadim.com.br/raid1/
>
> For the record: we did some benchmarks and while the patch shows prom=
ise and
> seems to cause no problems, it resulted in no measurable performance
> increase for a RAID1 array composed of an SSD and two 7200rpm HDDs.
>
> Andras
>
> --
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Andras Korn <korn at elan.rul=
ez.org>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 If it ain't broken, play with it unti=
l it is.
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
