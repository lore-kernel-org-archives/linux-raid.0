From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: [PATCH md 2 of 4] Fix raid6 problem
Date: Sun, 13 Feb 2005 16:05:36 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0502131602470.16537-100000@coffee.psychology.mcmaster.ca>
References: <4203BF83.4050408@h3c.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <4203BF83.4050408@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Interesting - the private mail was from me, and I've got two dual 
> Opterons in service. The one with significantly more PCI activity has 
> significantly more problems then the one with less PCI activity.

that's pretty odd, since the most intense IO devices I know of 
are cluster interconnect (quadrics, myrinet, infiniband),
and those vendors *love* opterons.  I've never heard any of them
say other than that Opteron IO handling is noticably better than
Intel's.

otoh, I could easily believe that if you're running the Opteron 
systems in acts-like-a-faster-xeon mode (ie, not x86_64),
you might be exercising some less-tested paths.

regards, mark hahn.

