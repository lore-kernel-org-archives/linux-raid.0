From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Raid 1 install revealed poor HD performance (I think)
Date: Tue, 17 May 2005 17:23:53 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0505171720070.32621@lion.drogon.net>
References: <428A09A3.9000802@heyjay.com> <Pine.LNX.4.56.0505171649090.32621@lion.drogon.net>
 <428A1924.8030801@heyjay.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <428A1924.8030801@heyjay.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jay Strauss <me@heyjay.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 17 May 2005, Jay Strauss wrote:

> Gordon Henderson wrote:
> > On Tue, 17 May 2005, Jay Strauss wrote:
> >
> >
> >>I'm very unfamiliar with options for speeding up hard drive access.
> >>What might Knoppix be setting (and how would I look for it), that it's
> >>getting 100% better drive performance than a plain jane Sarge install?
> >
> >
> > The usual culprit is DMA. (Or lack of it in your case)
> >
> > What does
> >
> >   hdparm /dev/hda
> >
> > give under each OS?
> >
> > You can use hdparm to enable DMA, but this doesn't always work - the real
> > solution is to work out what type of IDE controller you have and make sure
> > it's compiled into your kernel.

> thanks Gordon, below are the outputs from both trials.  How would I go
> about finding out the IDE controller I have?

From the outputs below, it looks like it's not DMA. (damn)

> Sarge:~# hdparm /dev/hda
>
> /dev/hda:
>   multcount    =  0 (off)
>   IO_support   =  0 (default 16-bit)
>   unmaskirq    =  0 (off)
>   using_dma    =  1 (on)

It's on here.


>   keepsettings =  0 (off)
>   readonly     =  0 (off)
>   readahead    = 256 (on)
>   geometry     = 19457/255/63, sectors = 312581808, start = 0
>
> knoppix
>
> /dev/hda:
>   multcount    = 16 (on)
>   IO_support   =  0 (default 16-bit)
>   unmaskirq    =  0 (off)
>   using_dma    =  1 (on)

And here.

However, I notice that Sarge isn't using multicount. You can turn that on
with hdparm -m 16 /dev/hda /dev/hdc

To work out your IDE controller, try: lspci and have a look at the output
of /var/log/dmesg (or just type dmesg | less - knoppix might not create a
/var/log/dmesg) The output of lspci will tell you what hardware you have
then you'll need to examinf the dmesg output to see if you have support
for it, or need to compile it in.

Gordon
