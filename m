From: Gordon Henderson <gordon@drogon.net>
Subject: Re: [PATCH md 2 of 4] Fix raid6 problem
Date: Sun, 13 Feb 2005 21:19:35 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0502132113430.29594@lion.drogon.net>
References: <Pine.LNX.4.44.0502131602470.16537-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <Pine.LNX.4.44.0502131602470.16537-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 13 Feb 2005, Mark Hahn wrote:

> > Interesting - the private mail was from me, and I've got two dual
> > Opterons in service. The one with significantly more PCI activity has
> > significantly more problems then the one with less PCI activity.
>
> that's pretty odd, since the most intense IO devices I know of
> are cluster interconnect (quadrics, myrinet, infiniband),
> and those vendors *love* opterons.  I've never heard any of them
> say other than that Opteron IO handling is noticably better than
> Intel's.
>
> otoh, I could easily believe that if you're running the Opteron
> systems in acts-like-a-faster-xeon mode (ie, not x86_64),
> you might be exercising some less-tested paths.

I was about to post that I've solved my problems with that Tyan dual
opteron motherboard, but it's still crap. I upgraded the BIOS to the 2.02
beta and it seemed to work a lot better.  Still couldn't boot off it with
all 8 drives in, but solved that with the use of a 32MB flash IDE unit
holding /boot... However, it dropped a drive during initial sync of the
raid6 arrays with lots of SCSI errors, and had given lots of DMA interrupt
missing, etc. thorugh the day when I've run soaktests on it, so I'm going
to conclude that that Tyan motherboard is utterly useless and deserves
nothing more than being driven over. Slowly. With a steam roller.  Then
jumped on. Just to make me feel better.

Gordon
