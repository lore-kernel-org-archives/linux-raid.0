From: Steve Bergman <sbergman27@gmail.com>
Subject: Re: Is this expected RAID10 performance?
Date: Sun, 9 Jun 2013 18:53:31 -0500
Message-ID: <CAO9HMNEThHrtzCK1A16uSxxHTBY-XxoCgpdV6u5PAhtWK=OuTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>This is almost certainly a result of forced IDE mode.  With this you end
up with a master/slave setup between the drives on each controller, and
all of the other overhead of EIDE.

Thank you for that. Normally, I would not pursue the issue further, as
the server/filesystem is performing within 20%, on its most
challenging workload, of what it can do with the workload running in a
large tmpfs on the same machine. (I have lots of memory.) However, I'm
now engaged in the issue sufficiently that I'll be contacting Dell
tomorrow to ask them why we aren't getting what was advertised, and to
see if they have any suggestions.

So, would you expect the situation to change if there was some magic
way to make AHCI active?

I will briefly address the filesystems thing. I'm not running down
XFS. If anything, I'm shaking the bushes to see if it prompts anyone
to tell me something that I don't know about XFS which might change my
assessment of when it might be appropriate for my customers' use. I
wouldn't mind at all being able to expand use of XFS in appropriate
situations, if only to get more experience with it.

Beyond that, I'm not sure it would be constructive for you and me to
continue that conversation. I've already posted my views, and
repeating just gets... well... repetitive. ;-)

-Steve
