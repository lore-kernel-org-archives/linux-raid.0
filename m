From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [RFH] Partition table recovery
Date: Mon, 23 Jul 2007 16:22:29 -0400
Message-ID: <46A50E05.3080905@tmr.com>
References: <200707200813.03553.a1426z@gawab.com> <46A24846.7050803@gmail.com> <20070722011141.GJ26752@thunk.org> <200707220710.31402.a1426z@gawab.com> <20070722162802.GA20174@thunk.org> <46A46399.5090406@gmail.com> <20070723084146.GP22998@lug-owl.de> <46A488EB.2050305@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <46A488EB.2050305@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Rene Herman <rene.herman@gmail.com>
Cc: Jan-Benedict Glaw <jbglaw@lug-owl.de>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Rene Herman wrote:
> On 07/23/2007 10:41 AM, Jan-Benedict Glaw wrote:
>
>> As multibyte on-disk variables, these will need LE/BE conversion.
>
> Indeed, thanks -- has been updated in the version that is attached.
>
> Also fixes a bug that snuck in (failed to add offset to entry->start).
>
>>> struct entry {
>>>     uint8_t flags;
>>>     uint8_t type;
>>>     uint16_t __1;
>>>     uint64_t start;
>>>     uint32_t size;
>>
>> Dito.
>
> This can stay for now. The partition table backup would indeed need 
> some defined byte-order but it might be "whatever order the filesystem 
> it's backed up onto uses". Since it's not directly written to any 
> filesystem for now, host order will do currently.
>
>> Looks like a useful program, but you'd definively fix the LE/BE issues.
>> If you do that, it'll be able to even run on BE machines, too.
>
> I might disagree with the usefulness. I believe that preferably a 
> backup should be made with help from the kernel (if only by walking 
> sysfs) to avoid things getting out of sync between kernel and backup 
> program.
>
> (this program largely does the same as the kernel does but even now 
> there's already a difference in so far that I didn't bother to 
> de-garbage the 3rd and 4th entries in the second level extendeds).
>
How can I politely say this code really needs comments?
To quote the late R. W. Benway, "If it was hard to write it should be 
hard to understand."
(regarding code in FORTRAN II on punched cards, ca 1965)
> Rene.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

