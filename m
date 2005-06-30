From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: linux-raid compatable w/ Adaptec AIC-7902?
Date: Wed, 29 Jun 2005 22:10:32 -0400
Message-ID: <200506300210.j5U2Acp04142@www.watkins-home.com>
References: <200506291655.39703.eric@pretorious.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200506291655.39703.eric@pretorious.net>
Sender: linux-raid-owner@vger.kernel.org
To: eric@pretorious.net, linux-raid@vger.kernel.org
Cc: 'Mike V' <mike@asacomputers.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Eric Pretorious
> Sent: Wednesday, June 29, 2005 7:56 PM
> To: linux-raid@vger.kernel.org
> Cc: Mike V
> Subject: Re: linux-raid compatable w/ Adaptec AIC-7902?
> 
> On Wednesday 29 June 2005 03:38 pm, Eric Pretorious wrote:
> >I'm trying to install CentOS 3.3 (a.k.a. RedHat Enterprise Linux 3) on a
> >Supermicro 5013C-M8 w/ on-board Adaptec AIC-7902 Ultra320 controller
> >(connected to two Seagate ST373207LC 73GB hdd's in RAID1 connfiguration)
> but
> >am getting random crashes. (The screen is FILLED with I/O errors and
> raid1
> >messages.)
> >
> >Is linux-raid compatible with the infamous AIC-7902? Is there any special
> >configuration that I need to perform in the Adaptect BIOS?
> 
> Hm... This sounds fishy:
> 
> %> dmesg
> ...
> md: md3: sync done.
> md: syncing: RAID array md2
> md: minimum _guarenteed_ reconstruction speed: 100KB/sec/disc.
> md: using maximum available idle IO bandwidth (but not more than...
> md: using 12k window, over a total of 48064 blocks.
> md: delaying resync of md0 until md2 has finished resync (they share one
> or more physical units)
> md: delaying resync of md1 until md2 has finished resync (they share one
> or more physical units)
> ...
> 
> Should I be concerned by the last two lines?
No, this is normal.  Your 3 arrays are on the same disk(s).  In this case,
it is faster to do them 1 at a time.

Guy

> 
> --
> Eric P.,
> Truckee, CA
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

