From: Vlad Dobrotescu <vlad@dobrotescu.ca>
Subject: Re: RAID6 questions (mdadm 3.2.6/3.3.x)
Date: Sun, 13 Jul 2014 06:07:29 +0000 (UTC)
Message-ID: <loom.20140713T073507-537@post.gmane.org>
References: <53C06815.2020302@dobrotescu.ca> <B953BC37-3769-4D9A-97FF-5EFE7C59EEA4@colorremedies.com> <20140712112034.6b04d49f@notabene.brown> <53C0A9A0.2020508@dobrotescu.ca> <20140713131505.6cd40cb8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb <at> suse.de> writes:
> 
> On Fri, 11 Jul 2014 23:21:04 -0400 Vlad Dobrotescu <vlad <at> 
> dobrotescu.ca> wrote:
> ...
>> Would you have any opinion on the questions 1-5?
>> 
>> Vlad
> 
> 1-yes
> 2-no, same -- Assuming I understand correctly.  I suggest you 
> test and see.
> 3-try it and see, but "yes"
> 4-Not wrong, no penalty
> 5-it would work but is dangerous - too easy to assemble wrongly.
>   Why are you using yesterday software to build tomorrows computer?

It's a mater of confidence. When I was writing software, I was, just 
as you seem to be, an adept of producing stuff people could really 
rely on and depend upon, without sparing any effort in this direction. 

Now Linux, as a whole, doesn't give me this "dependable" feeling, and 
a significant amount of testing is able to alleviate at least some of 
my concerns. When it comes to my home server (which will have many 
roles), I'd really like to get to a solution that I can "set it and 
forget about it", and which would require little human maintenance 
(so that the required actions could be described on one page that 
most non-IT people would understand).

That's why I'm stuck with something like CentOS, and I need to figure 
out as many what-if scenarios as I can, so I can write the proper 
scripts and set up the proper configurations that would take me as 
close to worry-free as possible.

> 
> You've obviously done lots of research and figured out or guessed 
> the correct answer to your questions.  I seriously recommend 
> experimentation to clarify remaining issues.  If you've actually 
> performed a few recoveries or replacements without live data, 
> you'll feel much more confident when a disaster happens after 
> you go live.
> 
> NeilBrown
> 

My plan was to get to a short list of options that make sense (and, 
with your help, I feel I got it) and start experimenting in a VM 
before setting up the real hardware.

Thanks a lot.

Vlad


