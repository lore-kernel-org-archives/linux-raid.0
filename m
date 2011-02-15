From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: write-behind has no measurable effect?
Date: Tue, 15 Feb 2011 06:10:17 -0300
Message-ID: <AANLkTinAV4jJc8ueZ1mjRPpDnA_eWhUDcL8uz-0Ufifk@mail.gmail.com>
References: <20110214213817.GG836@hellgate.intra.guy>
	<20110215095042.51ef7e0a@notabene.brown>
	<20110214225754.GK19990@hellgate.intra.guy>
	<20110215104109.06b12b33@notabene.brown>
	<20110215010052.GA13135@hellgate.intra.guy>
	<4D59D4A5.9050106@anonymous.org.uk>
	<20110215021900.GB13135@hellgate.intra.guy>
	<AANLkTikFSOePZJXknAt=Tx6+FpdJ4tiSNwpuwuPC3RY=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikFSOePZJXknAt=Tx6+FpdJ4tiSNwpuwuPC3RY=@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andras Korn <korn@raidlist.elan.rulez.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

andras could you make some benchmarks to raid1 with round robin read ba=
lance?
at this site:
www.spadim.com.br/raid1/

it's kernel 2.6.37 based


2011/2/15 Roberto Spadim <roberto@spadim.com.br>
>
> andras could you make some benchmarks to raid1 with round robin read =
balance?
> at this site:
> www.spadim.com.br/raid1/
>
> it's kernel 2.6.37 based
>
> 2011/2/14 Andras Korn <korn@raidlist.elan.rulez.org>
>>
>> On Tue, Feb 15, 2011 at 01:19:33AM +0000, John Robinson wrote:
>>
>> > >Another approach to take would be to mark as dirty, on the fast d=
evices, all
>> > >areas being written to, and in the background continuously synch =
them to the
>> > >slow devices, sequentially (marking as clean synched-and-as-yet-u=
nwritten-to
>> > >areas); so that the array would be resyncing continually, but be =
very fast
>> > >for random writes. This would of course also require the bitmap t=
o only be
>> > >synchronously updated on the fast devices.
>> > >
>> > >Otoh, this is really a different mechanism from the current write=
-behind,
>> > >aimed at a different use-case, so maybe it could be implemented
>> > >orthogonally. (Patches welcome, I'm sure; it's times like these I=
 hate not
>> > >being a coder.)
>> >
>> > I wonder whether bcache might do roughly what you want? I haven't
>>
>> It only does very roughly what I want (the idea there is to _cache_ =
a much
>> larger spinning disk using a relatively small SSD, whereas I basical=
ly want
>> them both to be the same size, with the disk eventually mirroring th=
e
>> contents of the SSD); also, development of bcache has stalled (it do=
esn't
>> even compile with recent kernels and the developer has stated that h=
e's
>> taking a break).
>>
>> I also know of flashcache, which is similar to bcache and is more ac=
tively
>> developed, but is still lagging quite a few versions behind (the lat=
est
>> kernel it works with is 2.6.32, I think; it certainly doesn't compil=
e with
>> 2.6.38).
>>
>> So, while both of these may actually be good at what they do, neithe=
r of
>> them does what I have in mind and I also can't use either of them be=
cause I
>> need a newer kernel than what they support.
>>
>> But thanks anyway.
>>
>> --
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Andras Korn <korn at elan.ru=
lez.org>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 I'm not nearly as think as you confu=
sed I am.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial



--
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
