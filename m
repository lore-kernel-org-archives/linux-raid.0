From: Phil Dibowitz <phil@ipom.com>
Subject: Raid Monitoring Question
Date: Thu, 21 Nov 2002 17:16:23 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3DDD8567.3050102@ipom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm really not sure if this is the right place to ask this question or 
not. For starters it's a hardware raid question and I *think* this list 
leans more towards software raid. But this is about the best place I 
could find, so if you know of a better one, feel free to point me there.

That said...

I have a Raid Array off of a MegaRAID Express 500 card. 2 disks doing 
mirroring, the exact details of the array aren't by any means private, 
but they're (I don't believe) not necessary to my questions, so I'll 
spare you.

The card came with a utility called "linmon" or Linux Monitor: a linux 
utility to monitor the status of the drive (and email problems to us). 
It turns out it's not very uniquely named - there are _tons_ of 
utilities similarly named. Go Figure.

Anyway, so I'm trying to figure out kind of tests and how often I should 
do them so I can tell this thing, and I'm relatively new to raid. The 
docs mention all of the options, but do little by way of explination of 
standard practice, good, bad, normal, etc.

So I have a few questions about a few options, and what standard 
practice is for most people. I'll gladly tweak but I need a place to start:

1. Consistancy checks. It can do regular consistency checks. I would 
GUESS this does not need to be done often... or even regularly at all? 
Is this something that should be done regularly? If so how often is this 
customarily done? Weekly, monthly?

2. SMART log checking. OK, I must confess I'm pretty ignorant here. I 
know SMART has been around for ... quite a long time, but I know 
basically nothing about it. This utility can check the "SMART logs" (on 
the drive??? in the kernel?? huh??) on a regular basis. I figure this is 
probably good. Again, how often is a reasonable value for this... my 
options here are every 20 to every 9999 seconds.

3. linmon may be very good on it's monitoring (I dunno), but it's 
options for notification aren't great (email to 'root' and that's it). 
I've used sendmail aliases to moveall other root email to a 'postmaster' 
account and then the root email to an alerts list all of us admins get, 
but this is REALLY UGLY and I don't like it. Does anyone know of other 
good hardware raid monitoring utilities that are better with 
notification options?

Um, some information that might be helpful particulary in the last 
question: Redhat Linux 7.3, latest updates (redhat kernel 2.4.18), one 
single mirroring array with 2 disks.

Thanks,
-- 
Phil Dibowitz                             phil@ipom.com
Freeware and Technical Pages              Insanity Palace of Metallica
http://home.earthlink.net/~jaymzh666/     http://www.ipom.com/

"They that can give up essential liberty to obtain a little temporary
safety deserve neither liberty nor safety."
  - Benjamin Franklin, 1759


