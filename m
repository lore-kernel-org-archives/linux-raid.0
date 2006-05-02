From: Ric Wheeler <ric@emc.com>
Subject: Re: md: Change ENOTSUPP to EOPNOTSUPP
Date: Tue, 02 May 2006 07:37:36 -0400
Message-ID: <44574480.8010405@emc.com>
References: <20060428124313.29510.patches@notabene>	 <1060428025144.30770@suse.de>	 <62b0912f0604280634x7df2a8a5m9022826876446cb6@mail.gmail.com>	 <44524765.6070703@emc.com> <62b0912f0604290650v6fa0759flace16041c26fa003@mail.gmail.com> <4453CB4D.9020907@emc.com> <445633D4.2000607@fooplanet.com> <4456BBE4.2000706@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4456BBE4.2000706@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: Gil <gil@fooplanet.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Paul Clements wrote:

>
> You'll see something like this in your system log if barriers are not 
> supported:
>
> Apr  3 16:44:01 adam kernel: JBD: barrier-based sync failed on md0 - 
> disabling barriers
>
>
> Otherwise, assume that they are. But like Neil said, it shouldn't 
> matter to a user whether they are supported or not. Filesystems will 
> work correctly either way.
>
> -- 
> Paul
>
File systems will work correctly, but if you are running without 
barriers and with your write cache enabled, you are running the risk of 
data loss or file system corruption on any power loss.

It is an issue of concern since drive companies ship the write cache on 
by default. When we detect a non-supported drive (queuing enabled, lack 
of support for the barrier low level mechanism) we disable future 
barrier request and leave the write cache enabled.

I guess that you could argue that this is what most home users want 
(i.e., best performance at the cost of some possible data loss on power 
outage since most people lose power rarely these days), but it is not 
good enough for critical data storage.

I would suggest that if you see this message on ext3 (or the reiserfs 
message for reiser users), you should run with your write cache disabled 
by default or disable queuing (which is often the reason the barrier ops 
get disabled).

ric

