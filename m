From: Shai <shaibn@gmail.com>
Subject: raid5: switching cache buffer size, 512 --> 4096
Date: Wed, 22 Mar 2006 18:29:48 +0200
Message-ID: <e3edb0fa0603220829v770be4d6q44a1ea40627e3826@mail.gmail.com>
References: <e3edb0fa0603220456m1fc5687fl5960226c093a1b2f@mail.gmail.com>
	 <Pine.LNX.4.56.0603221313380.26251@lion.drogon.net>
	 <e3edb0fa0603220525g2c0ac99bsc00fb067515220be@mail.gmail.com>
	 <Pine.LNX.4.56.0603221326300.26251@lion.drogon.net>
	 <e3edb0fa0603220738l1450bf35o2c6643c6a42cc16c@mail.gmail.com>
	 <Pine.LNX.4.56.0603221542520.26251@lion.drogon.net>
	 <e3edb0fa0603220827q7376f49j300129724f7ec619@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e3edb0fa0603220827q7376f49j300129724f7ec619@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

FYI

---------- Forwarded message ----------
From: Shai
Date: Mar 22, 2006 6:27 PM
Subject: Re: raid5: switching cache buffer size, 512 --> 4096
To: Gordon H.

Hi,

I want to thank you very much for answering all my questions and I
don't want you to think for one second that I don't appricitate your
time... I do :)

Ok, so getting them removed via the source is the solution.. but what
if I don't have the source? Can you tell me what exactly I should look
for and change?

Thanks (again),
Shai

On 3/22/06, Gordon H. wrote:
> On Wed, 22 Mar 2006, Shai wrote:
>
> > Ok,
> >
> > say I don't care about md1 being redone. Is there anything i can do to
> > it that will fix these error messages? format again with some
> > parameters? rebuild the raid?
>
> They asren't really errors - more informational. Which is why you should
> comment them out of the source code if you don't want them...
>
> You aer probably taking a performance hit when they are printed though -
> for 2 reasons, one the overhead of actually printing them (and logging
> them), and the other when the cache is flushed, so best to stop it
> happening, so look in the xfs manuals to see if you can fix the blocks
> size on the journal.
>
>  Gordon
>
>
> >
> > Shai
> >
> > On 3/22/06, Gordon H. wrote:
> > > On Wed, 22 Mar 2006, Shai wrote:
> > >
> > > > I just found this email on the website but I don't know where the archives are.
> > > > I'm not very good with mdadm and I don't want to mess things up to
> > > > much trying things out.
> > >
> > > It's got nothing to do with mdadm - it's simply that xfs sometiems makes a
> > > request for a block-size of 512 bytes, then a block size of 4096 bytes,
> > > and theres only one block cache in the md system, so when the block size
> > > changes it has to flush the cache.
> > >
> > > > Can you show me the archives?
> > >
> > > http://www.google.co.uk/search?hl=en&q=linux-raid+archive&btnG=Google+Search&meta=
> > >
> > > > Can you maybe help me out in finding how to fix it rather then comment
> > > > out the error messages?
> > >
> > > If you can fix it, then the linux-raid crowd will welcome you with open
> > > arms :)
> > >
> > > But I'd start with looking at the man pages for xfs and seeing if theres a
> > > way to fix the block size of the journal.
> > >
> > > Gordon
> > >
> > >
> > > > Thanks in advance!!!
> > > >
> > > > Shai
> > > >
> > > > On 3/22/06, Gordon H. wrote:
> > > > > On Wed, 22 Mar 2006, Shai wrote:
> > > > >
> > > > > > Hi,
> > > > > >
> > > > > > I have two raid5 MDs: /dev/md0 and /dev/md1;
> > > > > >
> > > > > > I had broken md0 the other day and had to rebuild it.
> > > > > > i've formated it as xfs and wanted to make md1 also xfs so I decided to
> > > > > > move all the data from md1 to md0.
> > > > > >
> > > > > > while doing the cp of all that data, I'm getting lots of messages on
> > > > > > the console screen which don't enable me to work on it ( i use telnet
> > > > > > now ):
> > > > > >
> > > > > > > raid5: switching cache buffer size, 512 --> 4096
> > > > > > > raid5: switching cache buffer size, 4096 --> 512
> > > > > >
> > > > > > Can someone help me resolve this?
> > > > >
> > > > > Search the archives - I had this many moons ago. It's something to do with
> > > > > xfs using a different block-size for the journal to the data, and I think
> > > > > there are mount/mkfs options to remedy this, or the other solution is to
> > > > > find the kprintf in the driver and comment it out...
> > > > >
> > > > > (I stopped uing xfs, but not for other reasons. don't see it under ext3)
> > > > >
> > > > > Gordon
