From: Phil Turmel <philip@turmel.org>
Subject: Re: Questions about bitrot and RAID 5/6
Date: Sat, 25 Jan 2014 10:48:52 -0500
Message-ID: <52E3DCE4.4020909@turmel.org>
References: <20140121171943.GC6553@blisses.org> <52DFA01E.8000301@hesbynett.no> <78DCA4D1-9386-4BE7-894C-47EF4772C431@colorremedies.com> <52E0D060.3020508@hesbynett.no> <DE020E0C-E6EC-48E9-8D7B-09F5A65A2DF5@colorremedies.com> <52E16536.2070608@turmel.org> <30218363-7819-40A1-B647-D19C1FD90548@colorremedies.com> <52E2691E.4050701@turmel.org> <0466C42D-F51E-41D1-B220-F38EB43C1A38@colorremedies.com> <52E29CEF.7030408@turmel.org> <62EB0D79-9A50-4C50-ACBF-1C507D6F449B@colorremedies.com> <52E2AD10.5080208@turmel.org> <E222FBA0-8A1A-48EF-BEAA-BD059A8C1554@colorremedies.com> <52E2C5A3.1050803@turmel.org> <4ACB5D8F-CC0F-4CF2-96C7-03D05E40C89A@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4ACB5D8F-CC0F-4CF2-96C7-03D05E40C89A@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Chris,

I sat on my reply for a day so I could make sure my response was
suitably professional.

On 01/24/2014 03:54 PM, Chris Murphy wrote:
> 
> On Jan 24, 2014, at 12:57 PM, Phil Turmel <philip@turmel.org> wrote:
> 
>> On 01/24/2014 02:32 PM, Chris Murphy wrote:
>>>>> So a URE is either 4096 bits nonrecoverable, or 32768 bits 
>>>>> nonrecoverable, for HDDs. Correct?
>>>> 
>>>> Yes.  Note that the specification is for an *event*, not for a
>>>>  specific number of bits lost.  The error rate is not "bits
>>>> lost per bits read", it is "bits lost event per bits read".
>>> 
>>> I don't understand this. You're saying it's a "1 URE event in 
>>> 10^14 bits read" spec? Not a "1 bit nonrecoverable in 10^14 bits 
>>> read" spec?
>>> 
>>> It seems that a nonrecoverable read error rate of 1 in 2 would 
>>> mean, 1 bit nonrecoverable per 2 bits read. Same as 512 bits 
>>> nonrecoverable per 1024 bits read. Same as 1 sector 
>>> nonrecoverable per 2 sectors read.
>> 
>> I don't know what more to say here.  Your "seems" is not.
> 
> Please define "bits lost event" and cite some reference. Google 
> returns exactly ONE hit on that, which is this thread. If we cannot 
> agree on the units, we aren't talking about the same thing, at all, 
> with a commensurately huge misunderstanding of the problem and thus 
> the solution.

I am not trying to define terminology, nor do I intend to.  I have been
paraphrasing and rephrasing in an attempt to help you understand the
published terminology.  It's hardly surprising that this thread is the
only hit.

As this list is *the* reference for linux raid technology, and is a
reference for raid technology in general, I hope this helps future
googlers understand the issue.

> So please to not merely respond to the 2nd paragraph you disagree 
> with. Answer the two questions above that paragraph.

The paired questions simply restated my previous answer with a few
substitutions.  I skipped what I presumed was a rhetorical form, and
replied to your commentary in answer to the whole.

> If the spec is "1 URE event in 1E14 bits read" that is "1 bit 
> nonrecoverable in 2.4E10 bits read" for a 512 byte physical sector 
> drive, and hilariously becomes far worse at "1 bit nonrecoverable in 
> 3E9 bits read" for 4096 byte physical sector drives.

It is only hilariously far worse in *your* mind.

> A very simple misunderstanding should have a very simple corrective 
> answer rather than hand waiving and giving up.

I'm sorry if you think my attempts to teach have been hand-waving.  I'm
giving up.  I can't help you further.

Regards,

Phil Turmel
