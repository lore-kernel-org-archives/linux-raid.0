From: Aapo Laine <aapo.laine@shiftmail.org>
Subject: Re: potentially lost largeish raid5 array..
Date: Sat, 24 Sep 2011 23:57:58 +0200
Message-ID: <4E7E5266.5040205@shiftmail.org>
References: <201109221950.36910.tfjellstrom@shaw.ca>
 <20110923151108.08c1199f@notabene.brown>
 <201109222322.57040.tfjellstrom@shaw.ca>
 <201109230209.36209.thomas@fjellstrom.ca>
 <20110923191539.110b7be1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20110923191539.110b7be1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/23/11 11:15, NeilBrown wrote:
> On Fri, 23 Sep 2011 02:09:36 -0600 Thomas Fjellstrom<thomas@fjellstrom.ca>
> wrote:
>> I forgot to say, but: Thank you very much :) for the help, and your tireless
>> work on md.
>>
>
> You've very welcome .... but I felt I needed to respond to that word
> "tireless".
> The truth is that I am getting rather tired of md .... if anyone knows anyone
> who wants to get into kernel development and is wondering where to start -
> please consider whispering 'the md driver' in their ear.  Plenty to do, great
> mentoring possibilities, and competent linux kernel engineers with good
> experience are unlikely to have much trouble finding a job ;-)
>
> NeilBrown

Whoa this is shocking news!

Firstly then, thank you so much for your excellent work up to now. Linux 
has what I believe to be the best software raid of all operating systems 
thanks to you. Excellent in both features, and reliability i.e. quality 
of code.

And also the support through the list was great. I found so many 
problems solved already just by looking at the archives... so many 
people with their arse saved by you.

I think everybody here is sorry to see you willing to go.

Now the bad news... Regarding the MD takeover, there I think I see a 
problem...
The MD code is very tersely commented, compared to its complexity!

- there is not much explanation of overall strategies, or the structure 
of code. Also the flow of data between the functions is not much 
explained most of the times.

- It's not obvious to me what is the entry point for kernel processes 
related to MD arrays, how are they triggered and where do they run... 
E.g. in the past I tried to understand how did resync work, but I 
couldn't. I thought there was a kernel process controlling resync 
advancement, but I couldn't really find the boundaries of code inside 
which it was executing.

- it's not clear what the various functions do or in what occasion they 
are called. Except from their own name, most of them have no comments 
just before the definition.

- the algoritms within the functions are very long and complex, but only 
rarely they are explained by comments. I am now seeing pieces having 5 
levels of if's nested one inside the other, and there are almost no 
comments.

- last but not least, variables have very short names, and for most of 
them, it is not explained what they mean. This is mostly for local 
variables, but sometimes even for the structs which go into metadata 
e.g. in struct r1_private_data_s most members do not have an 
explanation. This is pretty serious, to me at least, for understanding 
the code.

- ... maybe more I can't think of right now ...

Your code is of excellent quality, as I wrote, I wish there were more 
programmers like you, but if you now want to leave, THEN I start to be 
worried! Would you please comment it (much) more before leaving? Fully 
understanding your code I think is going to take other people a lot of 
time otherwise, and you might not find a replacement easily and/or s/he 
might do mistakes.

There were times in the past when I had ideas and I wanted to contribute 
code, but when I looked inside MD and tried to understand where should I 
put my changes, I realized I wasn't able to understand what current code 
was doing. Maybe I am not a good enough C programmer, but I was able to 
change things in other occasions.


I hope you won't get these critiques bad...
and thanks for all your efforts, really, in the name of, I think, everybody.
Aapo L.
