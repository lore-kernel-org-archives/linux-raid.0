From: Mike Hardy <mhardy@h3c.com>
Subject: Re: [PATCH md 2 of 4] Fix raid6 problem
Date: Sun, 13 Feb 2005 14:58:50 -0800
Message-ID: <420FDBAA.4010005@h3c.com>
References: <Pine.LNX.4.44.0502131602470.16537-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <Pine.LNX.4.44.0502131602470.16537-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Mark Hahn wrote:
>>Interesting - the private mail was from me, and I've got two dual 
>>Opterons in service. The one with significantly more PCI activity has 
>>significantly more problems then the one with less PCI activity.
> 
> 
> that's pretty odd, since the most intense IO devices I know of 
> are cluster interconnect (quadrics, myrinet, infiniband),
> and those vendors *love* opterons.  I've never heard any of them
> say other than that Opteron IO handling is noticably better than
> Intel's.

Sure, but which variables are changed between the rigs the vendors 
loved, and the rig we're having problems with?

> otoh, I could easily believe that if you're running the Opteron 
> systems in acts-like-a-faster-xeon mode (ie, not x86_64),
> you might be exercising some less-tested paths.

Its running x86_64 (Fedora Core 3) and the problem is rooted in the 
chipset I believe. I don't think its Opterons per se, I think its just 
the Athlon take two - which is to say that its a wonderful chip, but 
some of the chipsets its saddled with are horrible, and careful 
selection (as well as heavy testing prior to putting a machine in 
service) is essential.

-Mike
