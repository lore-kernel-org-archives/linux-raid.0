From: David Greaves <david@dgreaves.com>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
 crashing repeatedly and hard)
Date: Tue, 04 Jan 2005 19:12:54 +0000
Message-ID: <41DAEAB6.8000101@dgreaves.com>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es> <l1nna2-e9i.ln1@news.it.uc3m.es> <200501031846.42950.maarten@ultratux.net> <200501032052.21459.maarten@ultratux.net> <a9noa2-o12.ln1@news.it.uc3m.es> <fh0pa2-kvp.ln1@news.it.uc3m.es> <16857.55609.534526.297577@cse.unsw.edu.au> <jh4pa2-pi.ln1@news.it.uc3m.es> <16857.64086.362458.177296@cse.unsw.edu.au> <ms4qa2-0qa.ln1@news.it.uc3m.es> <41DAA243.3060202@dgreaves.com> <qikqa2-4m2.ln1@news.it.uc3m.es> <41DAAB7D.2030400@dgreaves.com> <kboqa2-ana.ln1@news.it.uc3m.es> <41DACA39.4020700@dgreaves.com> <751ra2-amt.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <751ra2-amt.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer wrote:

>A joournalled file system is always _consistent_. That does no mean it
>is correct!
>  
>
To my knowledge no computers have the philosophical wherewithall to 
provide that service ;)

If one is rude enough to stab a journalling filesystem in the back as it 
tries to save your data it promises only to be consistent when it is 
revived - it won't provide application correctness..

I think we agree on that.

>>The md driver (somehow) gets to decide which half of the mirror is 'best'.
>>    
>>
>Yep - and which is correct?
>  
>
Both are 'correct' - they simply represent different points in the 
series of system calls made before the power went.

>Which is correct?
>  
>
<grumble> ditto

>And the question remains - which outcome is correct?
>  
>
same answer I'm afraid.

>Well, I'll answer that.  Assuming that the fs layer is only notified
>when BOTH journal writes have happened, and tcp signals can be sent
>off-machine or something like that, then the correct result is the 
>rollback, not the completion, as the world does not expect there to
>have been a completion given the data it has got.
>
>It's as I said. One always wants to rollback. So one doesn't want the
>journal to bother with data at all.
>
<cough>bullshit</cough> ;)

I write a,b,c and d to the filesystem

we begin our story when a,b and c all live on the fs device (raid or 
not), all synced up and consistent.
I start to write d
it hits journal mirror A
it hits journal mirror B
it finalises on journal mirror B
I yank the plug
The mirrors are inconsistent
The filesystem is consistent
I reboot

scenario 1) the md device comes back using A
the journal isn't finalised - it's ignored
the filesystem contains a,b and c
Is that correct?

scenario 2) the md device comes back using B
the journal is finalised - it's rolled forward
the filesystem contains a,b,c and d
Is that correct?

Both are correct.

So, I think that deals with correctness and journalling - now on to 
errors...

>>>No. I made no such assumption. I don't know or care what you do with a
>>>detectable error. I only say that whatever your test is, it detects it!
>>>IF it looks at the right spot, of course. And on raid the chances of
>>>doing that are halved, because it has to choose which disk to read.
>>>      
>>>
>>I did when I defined detectable.... tentative definitions:
>>detectable = noticed by normal OS I/O. ie CRC sector failure etc
>>undetectable = noticed by special analysis (fsck, md5sum verification etc)
>>    
>>
>
>A detectable error is one you detect with whatever your test is.  If
>your test is fsck, then that's the kind of error that is detected by the
>detection that you do ... the only condition I imposed for the analysis
>was that the test be conducted on the raid array, not on its underlying
>components.
>  
>
well, if we're going to get anywhere here we need to be clear about things.
There are all kinds of errors - raid and redundancy will help with some 
and not others.

An md device does have underlying components and to refuse to allow 
tests to compare them you remove one of the benefits of raid - 
redundancy. It may make it easier to model mathmatically - but then the 
model is wrong.

We need to make sure we're talking about bits on a device
md reads devices and it writes them.

We need to understand what an error is - stop talking bollocks about 
"whatever the test is". This is *not* a math problem - it's simply not 
well enough defined yet. Lets get back to reality to decide what to model.

I proposed definitions and tests (the ones used in the real world where 
we don't run fsck) and you've ignored them.

I'll repeat them:
detectable = noticed by normal OS I/O. ie CRC sector failure etc
undetectable = noticed by special analysis (fsck, md5sum verification etc)

I'll add 'component device comparison' to the special analysis list.

No error is truly undetectable - if it were then it wouldn't matter 
would it?

>>- nothing's broken but a bit flipped during the write/store process (or 
>>the power went before it hit the media). Detectable errors are more 
>>likely to be permanent (since most detection algorithms probably have a 
>>retry).
>>    
>>
>
>I think that for some reason you are considering that a test (a
>detection test) is carried out at every moment of time.  No.  Only ONE
>test is ever carried out.  It is the test you apply when you do the
>observation: the experiment you run decides at that single point wether
>the disk (the raid array) has errors or not.  In practical terms, you do
>it usualy when you boot the raid array, and run fsck on its file system.
>
>OK? 
>You simply leave an experiment running for a while (leave the array up,
>let monkeys play on it, etc.) and then you test it. That test detects
>some errors. However, there are two types of errors - those you can
>detect with your test, and those you cannot detect. My analysis simply
>gave the probabilities for those on the array, in terms of basic
>parameters for the probabilities per an individual disk.
>
>I really do not see why people make such a fuss about this!
>  
>
We care about our data and raid has some vulnerabilites to corruption.
We need to understand these to fix them - your analysis is woolly and 
unhelpful and, although it may have certain elements that are 
mathmatically correct - your model has flaws that mean that the 
conclusions are not applicable.

>>>>However, we need to carry out risk analysis to decide if the increase in 
>>>>susceptibility to certain kinds of corruption (cosmic rays) is 
>>>>
>>>>        
>>>>
>>>Ahh. Yes you do. No I don't! This is your own invention, and I said no
>>>such thing. By "errors", I meant anything at all that you consider to be
>>>an error. It's up to you.  And I see no reason to restrict the term to
>>>what is produced by something like "cosmic rays". "People hitting the
>>>off switch at the wrong time" counts just as much, as far as I know.
>>> 
>>>
>>>      
>>>
>>You're talking about causes - I'm talking about classes of error.
>>    
>>
>
>No, I'm talking about classes of error! You're talking about causes. :)
>  
>
No, by comparing the risk between classes of error (detectable and not) 
I'm talking about classes of errror - by arguing about cosmic rays and 
power switches you _are_ talking about causes.

Personally I think there is a massive difference between the risk of 
detectable errors and undetectable ones. Many orders of magnitude.

>>Hitting the power off switch doesn't cause a physical failure - it 
>>causes inconsistency in the data.
>>    
>>
>I don't understand you - it causes errors just like cosmic rays do (and
>we can even set out and describe the mechanisms involved).  The word
>"failure" is meaningless to me here.
>  
>
yes, you appear to have selectively quoted and ignored what I said a 
line earlier:
 > (I live in telco-land so most datacentres I know have more chance of 
suffering cosmic ray damage than Joe Random user pulling the plug - but 
conceptually these events are the same).


When that happens I begin to think that further discussion is meaningless.

>>>I would guess that you are trying to classify errors by the way their
>>>probabilities scale with number of disks.
>>>
>>>      
>>>
>>Nope - detectable vs undetectable.
>>    
>>
>
>Then what's the problem? An undetectable error is one you cannot detect
>via your test. Those scale with real estate. A detectible error is one
>you can spot with your test (on the array, not its components).  The
>missed detectible errors scale as n-1, where n is the number of disks in
>the array.
>
>Thus a single disk suffers from no missed detectible errors, and a
>2-disk raid array does.
>
>That's all.
>
>No fuss, no muss!
>  
>
and so obviously wrong!
An md device does have underlying components and to refuse to allow 
tests to compare them you remove one of the benefits of raid - redundancy.


>>Also, it strikes me that raid can actually find undetectable errors by 
>>doing a bit-comparison scan.
>>    
>>
>
>No, it can't, by definition. Undetectible errors are undetectible. If
>you change your test, you change the class of errors that are
>undetectible.
>
>That's all.
>
>  
>
>>Non-resilient devices with only one copy of each bit can't do that.
>>raid 6 could even fix undetectable errors.
>>    
>>
>
>Then they are not "undetectible".
>  
>
They are. Read my definition. They are not detected in normal operation 
with some kind of event notification/error return code; hence undetectable.
However bit comparison with known good or md5 sums or with a mirror can 
spot such bit flips.
They are still 'undetectable' in normal operation.
Be consistent in your terminology.

>The analisis in not affected by your changing the definition of what is
>in the undetectible class of error and what is not. It stands. I have
>made no assumption at all on what they are. I simply pointed out how
>the probabilities scale for a raid array.
>  
>
What analysis - you are waving vague and changing definitions about and 
talk about grandma's favourite colour

David

PS any dangling sentences are because I just found so many 
inconsistencies that I gave up.

