From: Gregory Leblanc <gleblanc@linuxweasel.com>
Subject: Re: IDE bus rescan
Date: 04 Jun 2002 16:44:23 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1023234274.10648.67.camel@peecee>
References: <5.1.0.14.2.20020604123917.06a1ac50@mail.harddata.com>
	  <5.1.0.14.2.20020604171615.03d9ab90@mail.harddata.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5.1.0.14.2.20020604171615.03d9ab90@mail.harddata.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2002-06-04 at 16:17, Maurice Hilarius wrote:
> With regards to your message at 04:54 PM 6/4/02, Friedrich Lobenstock. 
> Where you stated:
> >Maurice Hilarius wrote:
> >>Hi There
> >>Problem:
> >>On IDE software RAID setup, we want to be able to hot-swap out a failed disk.
> >>Using 3Ware cards we can swap only by rebooting system to recognise the 
> >>new drive
> >>Question: Is there a way to rescan IDE bus to recognise a new drive?
> >
> >Are you using the 3Ware Diskmanager Daemon and its webinterface or not?
> >It seems not.
> As I understand it that is only useful if we use the 3Ware BIOS RAID.
> In this case we are interested in doing this with software RAID
> So how would we make it rescan with this??

Hmm, hard to say.  When I'm hot swapping PCI cards, I simply unload the
kernel module that is the driver for that card before I power-off/remove
the card.  I don't know enough about kernel internals to know how to do
this with a single IDE bus, though.  
	Greg

-- 
Portland, Oregon, USA.
Please don't copy me on replies to the list.

