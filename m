From: David Greaves <david@dgreaves.com>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
 crashing repeatedly and hard)
Date: Tue, 04 Jan 2005 16:54:17 +0000
Message-ID: <41DACA39.4020700@dgreaves.com>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es> <l1nna2-e9i.ln1@news.it.uc3m.es> <200501031846.42950.maarten@ultratux.net> <200501032052.21459.maarten@ultratux.net> <a9noa2-o12.ln1@news.it.uc3m.es> <fh0pa2-kvp.ln1@news.it.uc3m.es> <16857.55609.534526.297577@cse.unsw.edu.au> <jh4pa2-pi.ln1@news.it.uc3m.es> <16857.64086.362458.177296@cse.unsw.edu.au> <ms4qa2-0qa.ln1@news.it.uc3m.es> <41DAA243.3060202@dgreaves.com> <qikqa2-4m2.ln1@news.it.uc3m.es> <41DAAB7D.2030400@dgreaves.com> <kboqa2-ana.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <kboqa2-ana.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer wrote:

>David Greaves <david@dgreaves.com> wrote:
>  
>
>>Disks suffer from random *detectable* corruption events on (or after) 
>>write (eg media or transient cache being hit by a cosmic ray, cpu 
>>fluctuations during write, e/m or thermal variations).
>>    
>>
>
>Well, and also people hitting the off switch (or the power going off)
>during a write sequence to a mirror, but after one of a pair of mirror
>writes has gone to disk, but before the other of the pair has.
>
>(If you want to say "but the fs is journalled", then consider what if 
>the write is to the journal ...).
>  
>
Hmm.
In neither case would a journalling filesystem be corrupted.

The md driver (somehow) gets to decide which half of the mirror is 'best'.

If the journal uses the fully written half of the mirror then it's replayed.
If the journal uses the partially written half of the mirror then it's 
not replayed.
It's just the same as powering off a normal non-resilient device.

(Is your point here back to the failure to guarantee write ordering? I 
thought Neil answered that?)


but lets carry on...

>>Disks suffer from random *undetectable* corruption events on (or after) 
>>write (eg media or transient cache being hit by a cosmic ray, cpu 
>>fluctuations during write, e/m or thermal variations)
>>    
>>
>
>Yes. This is not different from what I have said. I didn't have any
>particular scenario in mind.
>
>But I see that you are correct in pointing out that some error
>posibilities arer _created_ by the presence of raid that would not
>ordinarily be present. So there is some scaling with the
>number of disks that needs clarification.
>
>  
>
>>Raid disks have more 'corruption-susceptible' data capacity per useable 
>>data capacity and so the probability of a corruption event is higher. 
>>    
>>
>
>Well, the probability is larger no matter what the nature of the event.
>In principle, and vry apprximately, there are simply more places (and
>times!) for it to happen TO.
>  
>
exactly what I meant.

>Yes, you may say but those errors that are produced by the cpu don't
>scale, nor do those that are produced by software.
>
No, I don't say that.

> I'd demur. If you
>think about each kind you have in mind you'll see that they do scale:
>for example, the cpu has to work twice as often to write to two raid
>disks as it does to have to write to one disk, so the opportunities for
>IT to get something wrong are doubled.  Ditto software.  And of course,
>since it is writing twice as often , the chance of being interrupted at
>an inopportune time by a power failure are also doubled.
>  
>
I agree - obvious really.

>See?
>  
>
yes

>
>  
>
>>Since a detectable error is detected it can be retried and dealt with.
>>    
>>
>
>No. I made no such assumption. I don't know or care what you do with a
>detectable error. I only say that whatever your test is, it detects it!
>IF it looks at the right spot, of course. And on raid the chances of
>doing that are halved, because it has to choose which disk to read.
>  
>
I did when I defined detectable.... tentative definitions:
detectable = noticed by normal OS I/O. ie CRC sector failure etc
undetectable = noticed by special analysis (fsck, md5sum verification etc)

And a detectable error occurs on the underlying non-raid device - so the 
chances are not halved since we're talking about write errors which go 
to both disks. Detectable read errors are retried until they succeed - 
if they fail then I submit that a "write (or after)" corruption occured.

Hmm.
It also occurs to me that undetectable errors are likely to be temporary 
- nothing's broken but a bit flipped during the write/store process (or 
the power went before it hit the media). Detectable errors are more 
likely to be permanent (since most detection algorithms probably have a 
retry).

>>This leaves the fact that essentially, raid disks are less reliable than 
>>non-raid disks wrt undetectable corruption events.
>>    
>>
>
>Well, that too. There is more real estate.
>
>But this "corruption"  word seems to me to imply that you think I was
>imagining errors produced by cosmic rays. I made no such restriction.
>  
>
No, I was attempting to convey "random, undetectable, small, non 
systematic" (ie I can't spot cosmic rays hitting the disk - and even if 
I could, only a very few would cause damage) vs significant physical 
failure "drive smoking and horrid graunching noise" (smoke and noise 
being valid detection methods!).

They're only the same if you have a no process for dealing with errors.

>>However, we need to carry out risk analysis to decide if the increase in 
>>susceptibility to certain kinds of corruption (cosmic rays) is 
>>    
>>
>
>Ahh. Yes you do. No I don't! This is your own invention, and I said no
>such thing. By "errors", I meant anything at all that you consider to be
>an error. It's up to you.  And I see no reason to restrict the term to
>what is produced by something like "cosmic rays". "People hitting the
>off switch at the wrong time" counts just as much, as far as I know.
>  
>
You're talking about causes - I'm talking about classes of error.

(I live in telco-land so most datacentres I know have more chance of 
suffering cosmic ray damage than Joe Random user pulling the plug - but 
conceptually these events are the same).

Hitting the power off switch doesn't cause a physical failure - it 
causes inconsistency in the data.

I introduce risk analysis to justify accepting the 'real estate 
undetectable corruption vulnerability' risk increase of raid versus the 
ability to cope with detectable errors.

>I would guess that you are trying to classify errors by the way their
>probabilities scale with number of disks.
>
Nope - detectable vs undetectable.

> I made no such distinction,
>in principle.  I simply classified errors according to whether you could
>(in principle, also) detect them or not, whatever your test is.
>  
>
Also, it strikes me that raid can actually find undetectable errors by 
doing a bit-comparison scan.
Non-resilient devices with only one copy of each bit can't do that.
raid 6 could even fix undetectable errors.

A detectable error on a non-resilient media means you have no faith in 
the (possibly corrupt) data.
An undetectable error on a non-resilient media means you have faith in 
the (possibly corrupt) data.

Raid ultimately uses non-resilient media and propagates and uses this 
faith to deliver data to you.


David
