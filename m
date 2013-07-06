From: Sam Bingner <sam@bingner.com>
Subject: Re: some general questions on RAID (OT)
Date: Sat, 6 Jul 2013 06:23:48 +0000
Message-ID: <CDFCDAFC.1379B%sam@bingner.com>
References: <1373073799.10569.41.camel@fermat.scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1373073799.10569.41.camel@fermat.scientia.net>
Content-Language: en-US
Content-ID: <3DF22B92BD79024E9B642FC3B21188DA@ds.sbdhi.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The TS-879 and 1079 have Intel i3 Processors, and use a normal socket. =
 I
replaced it with an E3-1275 Xeon processor.  You can use Sandy bridge b=
ut
they do not have BIOS support for Ivy bridge processors.  I also replac=
ed
my memory with 16GB ECC memory.

I did a lot of research about this stuff before buying it, which is why=
 I
went with the TS-1079 Pro.  Works great with debian except for some lac=
k
of LED support on a couple drives and the LCD always says "Booting=8A"

Sam

On 7/5/13 3:23 PM, "Christoph Anton Mitterer" <calestyo@scientia.net>
wrote:

>On Fri, 2013-07-05 at 01:39 +0000, Sam Bingner wrote:
>> That is because your CPU has encryption features - the QNAP devices
>> largely do not; I replaced the CPU in mine with one that had encrypt=
ion
>> features because otherwise there was nothing that could bring the
>> performance above about 80MB/sec
>That's a bit off topic now to my questions, but I guess many other
>people using RAIDs on their QNAPs might be interested later as well:
>which QNAP do you have exactly?
>
>I mean they all have either ARM based CPUs, or Atom... so in my case, =
a
>D2700 with an FCBGA559... which CPU (that has AESNI) could you find fo=
r
>that? Since AFAIK there are no[0] Atoms at all with AESNI?
>
>
>Cheers,
>Chris.
>
>
>[0]=20
>http://ark.intel.com/search/advanced/?s=3Dt&Sockets=3DFCBGA559&AESTech=
=3Dtrue

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
