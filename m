From: NeilBrown <neilb@suse.com>
Subject: Re: Subject: ANNOUNCE: mdadm 3.3.3 - A tool for managing md Soft
 RAID under Linux
Date: Fri, 31 Jul 2015 09:34:04 +1000
Message-ID: <20150731093404.28e7df7e@noble>
References: <20150724163530.768da131@noble>
	<20150727162906.GA3051@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150727162906.GA3051@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 27 Jul 2015 18:29:06 +0200 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> On Fri, Jul 24, 2015 at 04:35:30PM +1000, NeilBrown wrote:
> > 
> > 
> > I am pleased to announce the availability of
> >    mdadm version 3.3.3
> > 
> > It is available at the usual places:
> >    http://www.kernel.org/pub/linux/utils/raid/mdadm/
> > and via git at
> >    git://github.com/neilbrown/mdadm
> >    git://neil.brown.name/mdadm
> >    http://git.neil.brown.name/git/mdadm.git
> > 
> > The 100 changes since 3.3.3 are mostly little bugfixes and some improvements
> > to the selftests.
> > raid6check now handle all RAID6 layouts including DDF correctly.
> > See git log for the rest.
> > 
> > NeilBrown 24th July 2015
> 
> Hi Neil,
> 
> I would like to thank you for clean up and improving
> "raid6check.c".
> I personally appreciate your contribution very much,
> and I think it is good to have your expert eye
> looking at the code.
> 
> Thanks again for your time,
> 
> bye,
> 

Happy to help, but I should confess that the motivation was purely
selfish.
I was doing some testing and the 01raid6integ test (which fails
different devices in a RAID6 and checks the data is still correct) was
occasionally reporting errors - a bit of a worry.

It eventually turned out to be a hardware issue - I was running in VMs
and after power-cycling my workstation the problem doesn't appear any
more.
But before I got to the stage I wanted to get a clearer idea of what
sort of corruption was happening, so I added a call to raid6check to
the test and it reported really strange results for some layouts.
So in order to get the data I needed, I fixed the code to work properly
for all layout.  i.e. write a test script to test all layouts, then fix
things until the script stopped complaining :-)

So despite that fact that it didn't actually lead me to the cause:
thank you for providing the program in the first place :-)

Thanks,
NeilBrown
