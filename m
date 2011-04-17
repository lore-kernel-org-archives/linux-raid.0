From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Recommended pci-e 1x SATA cards.
Date: Sun, 17 Apr 2011 13:44:38 +0800
Message-ID: <4DAA7E46.6040309@fnarfbargle.com>
References: <4DA6CCFE.8020708@crc.id.au>	<20110414185304.5bc1cca5@natsu>	<4DA6F3B2.8080402@crc.id.au>	<4DA7513C.5020505@hardwarefreak.com>	<20110415105846.1c4ec630@natsu>	<4DA8B91C.8050005@hardwarefreak.com> <20110416111554.09066e73@natsu> <4DA959E4.2080605@fnarfbargle.com> <4DA9FED8.2000308@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DA9FED8.2000308@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Roman Mamedov <rm@romanrm.ru>, Steven Haigh <netwiz@crc.id.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 17/04/11 04:40, Stan Hoeppner wrote:
> Brad Campbell put forth on 4/16/2011 3:57 AM:
>
>> I can't recommend anybody go within a mile of a product that works well
>> for 99.999% of people, when if you happen to be the 0.001% sample you
>> don't know you are until the device has silently eaten all your data.
>
> Then you may as well not recommend any board to anyone, because few
> manufacturers of relatively inexpensive boards have QC that high or an
> in the field failure rate that low, not matter whose control IC they
> mount on the PCB.  Margins on such products are razor thin, thus these
> manufacturers cut corners where they can.  Some cut corners more
> sharply, such as the in the case where 2/5 boards demonstrated the flaw
> and 3 didn't.  This directly points to a QC problem, not an IC design
> flaw in the 3132.
>

Now as I have a board here that demonstrates the exact same problem and 
is physically different from those boards then I'd suggest that there is 
more to this than bad QC on the part of one manufacturer.

While I understand what you are saying. What part of "silent data 
corruption" are you not getting?

Find me an example of an LSI or Marvell based board that causes *silent* 
data corruption. They all have their flaws, sure and some of those can 
be traced back to cheap dodgy manufacturing. The critical issue with all 
these other products is that when they have issues you know about it. 
The LSI boards used to lock up a channel when you sent an unaligned CDB 
to them, the Marvell boards have been known to drop channels completely 
(total hardware failure). Both these issues are highly visible, and 
whilst annoying you at least *know* there is a problem.

The whole premise of storage that has no end to end verification 
strategy is that you can trust your data path. The SIL chips (and I 
don't care how much you bang on about cheap hardware) have a bug that in 
certain circumstances invalidates all guarantees about data integrity 
silently.

Hells bells, there is even a case that Roman pointed to where the 
precise controller you recommend as being of suitable quality 
demonstrates the exact fault we are talking about, and you try to blame 
the copy program or the Windows driver.

There appears to be an insidious flaw in these chips that only manifests 
itself under "perfect storm" conditions, but when it does it silently 
eats your data.

