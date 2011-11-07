From: Martijn <mailinglist@mindconnect.nl>
Subject: All kinds of things on RAID/mdadm
Date: Mon, 07 Nov 2011 13:46:56 +0100
Message-ID: <4EB7D340.80009@mindconnect.nl>
Reply-To: mailinglist@mindconnect.nl
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear readers, perhaps Neil and/or fellow mdadm developers,

Over the last couple of weeks, I've been spending quite some time with 
mdadm and looking at a good way to use RAID on Linux for one of our 
servers. My colleagues (friends) and me are designing a new software 
platform for our company service, and RAID is an important base layer in 
the system.

To give you some context: our company was started not only to provide 
paid services, but also for learning purposes. We where all students 
when we started our company over nine years ago, and we still like to 
learn things related to all kinds of (IT) subjects. In that same 
direction, because we want to learn, we fancy a certain kind of 
'thoroughness' when creating and documenting something. At least, when 
we're given the time to do that, such as in this case.

Our current platform was set up early in 2005, when a colleague and I 
spent an evening finding out if we *really* couldn't just mirror full 
/dev/hda with /dev/hdb ;-) After reading it wasn't possible many, many 
times, we ended up manually copying partition tables from hda to hdb 
(eek!), mirroring partitions instead of drives (huh?), using some LVM 
(every time you think you know how it works, it's different), installing 
grub on both drives ("will this work on failover?"), and.. it worked.

I really slept bad after that though: we needed the reliability cheap, 
but it was so different from what I had imagined upfront and knew from 
hardware RAID. The extra complexity was a big deal for me too. Bigger 
than necessary I think. But I wanted to be more sure I could wrap my 
head around a problem if someone would call me in the middle of the 
night to fix it.

So this time around, I choose to be more thorough on the important 
aspects and one of those aspects is: recovery and what to do if 
something is wrong. While mdadm is a tool that's pretty clear in it's 
usage, supported by a good manual, I've come accross some things I 
cannot document to my full satisfaction after reading the manual. 
raid.wiki.kernel.org is down as well, and ironically the contents aren't 
'mirrored' anywhere. Google Cache may have it, but I can't find it: the 
results are littered with non-important meta pages from the wiki.
I also quickly searched through the mdadm code, but didn't see comments 
that cleared up my questions.

Searching for possible states of an array, I discovered that there are 
all sorts of combinations for states. The basics are clean, degraded and 
dirty. But what does 'clean, no-errors' mean? And 'dirty, no-errors'? 
Searching through the code, I even found a point where a label 'Dirty 
State' could be listed as 'clean'. Is it a good idea to add a list with 
explainations of possible states, basic and exotic, to the manual? Much 
in the same way all monitor events are listed. I can imagine not 
everyone knowing the difference between dirty and degraded for example. 
It's a basic thing that is skipped in most cases.

Perhaps the same could be done for individual disk states. Of course we 
all know "active sync", and based on what I've seen elsewhere the states 
"removed", "spare" and "faulty spare" exist. But having a list of all 
possible states would help prepare documentation for the things we 
really don't want to happen. Takes off the pressure a bit :-)

I'm not voting for mdadm to become a tool that even babies can use to 
create their arrays, but with this info others may be able to act with 
confidence based on their own knowledge, instead of search for articles 
on the web that happen to list the state of the array they're searching 
for. A lot of those articles do not teach anything. They just make you 
brainlessly copy and paste commands and fill in the character device 
files. Some of them are just plain wrong and may result in data being lost.
I also vote on articles giving partitionable devices a good kick over 
using partitions for RAID, but that's outside the scope of this post ;-)

Where do you think that important things, such as to 'how to organize 
failover' and questions like 'do I benifit from putting swap on a RAID 
char. device', should be documented? Is it the currently unreachable 
raid.wiki.kernel.org? Would it be better to provide the info that leads 
to the answers in the mdadm manual so that it is always available?

Are there any sources you would recommend reading if someone is 
interested in how mdadm/software-RAID 'works'? I'm not sure if RAID has 
an actual spec somewhere on which mdadm is based.

Looking forward to your replies and maybe a conversation leading to 
improvement where necessary :-)

Kind regards,
Martijn
