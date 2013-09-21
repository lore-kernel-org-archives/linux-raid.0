From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Why hardware RAID controllers when talking about mdadm?
Date: Fri, 20 Sep 2013 22:39:21 -0500
Message-ID: <523D14E9.3010009@hardwarefreak.com>
References: <CAK2H+edfTHdp-Ja56OSP2mPOz=KED-ucAhG9ALo32621iCHkwA@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+edfTHdp-Ja56OSP2mPOz=KED-ucAhG9ALo32621iCHkwA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sorry for the dup Mark.

On 9/20/2013 4:47 PM, Mark Knecht wrote:
> Hi,
>    OK, so I'm confused. This is very, very basic stuff I think. The
> first line of Neil's page
> 
> http://neil.brown.name/blog/mdadm
> 
> says "mdadm is a tool for managing Linux Software RAID arrays" which
> is the way I've used it, but I'm just a casual home user. However
> there are  and number of threads here where pros far more
> knowledgeable than I point people toward possibly purchasing hardware
> RAID controllers.

The name of the mailing list is not "mdadm", but "linux-raid".

http://vger.kernel.org/vger-lists.html#linux-raid

"Welcome to the linux-raid mailing list, hosted on vger.kernel.org.
Discussions on this list should be relevant to using RAID technologies
with Linux."

Hardware RAID isn't discussed here often, but it is on-topic on this
list.  LVM, dm-crypt, dm-raid, Intel Matrix RAID (hardware/fakeRAID)
management integration in mdadm, bcache, etc, are also discussed here,
just not often.  Likewise, they are on-topic.

>    Is this about something like creating a nested RAID using two or
> more underlying hardware RAIDs instead of just individual drives? 

No.

> Or is there something else going on here?

Yes, something else.  You've been under the mistaken impression that
this mailing list is dedicated solely to the Linux software RAID driver
and management util, aka md/mdadm, and that hardware RAID is OT or
taboo.  This is simply not the case.

-- 
Stan

