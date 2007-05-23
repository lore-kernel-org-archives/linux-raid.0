From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: unreadable drives can be synchronized?
Date: Wed, 23 May 2007 13:46:23 -0400
Message-ID: <46547DEF.8040403@tmr.com>
References: <200705181447.l4IElO2a000640@cichlid.com>	 <464DC06F.2080609@wpkg.org> <7296208f0705181118n32537ddck4d94bed08625b79f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7296208f0705181118n32537ddck4d94bed08625b79f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Colin McCabe <colin.p.mccabe@gmail.com>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, Andrew Burgess <aab@cichlid.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Colin McCabe wrote:
> On 5/18/07, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
>> Andrew Burgess schrieb:
>> >> Basically, B appears to be "write-only"; it will never return an 
>> error on a
>> >> write, but just try to read from it, and you will be sorry.
>> >
>> > It would be interesting to see what SMART says about drive B, 
>> especially
>> > the short and long self tests.
>>
>> I wouldn't rely on SMART.
>>
>> I have a broken drive, which has lots of badblocks - but SMART happily
>> claims it's fine (short/long tests are completed without errors).
>>
>
> If you haven't seen Google's hard drive study yet, you should take a 
> look.
> It's at http://labs.google.com/papers/disk_failures.pdf
>
> The conclusion says that "some of the SMART parameters are
> well-correlated with higher failure probabilities," but also that "a
> large fraction of [google's] failed drives have shown no SMART error
> signals whatsoever."
Having covered that in a presentation to a user group related to SMART. 
may I offer a paraphrase which may be more obvious to people who are not 
native speakers of English:

High counts of some SMART parameters indicate that the drive is likely 
to fail. However, most drives fail without warning.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

