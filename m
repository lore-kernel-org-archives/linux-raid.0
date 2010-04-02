From: Max Eaves <max@maxeaves.co.uk>
Subject: Re: Problems with RAID 6 across 15 disks
Date: Fri, 02 Apr 2010 11:21:58 +0100
Message-ID: <4BB5C546.2090401@maxeaves.co.uk>
References: <4BB49E4D.1090809@maxeaves.co.uk>	<4BB4A461.5030704@redhat.com>	<4BB4A89F.7030707@maxeaves.co.uk>	<20100402074325.3ce34e8f@notabene.brown>	<20100401224644.GA2455@lazy.lzy>	<1270162736.24051.0.camel@travelmate.workshop>	<20100401230437.GA5067@lazy.lzy>	<1270172413.24051.2.camel@travelmate.workshop> <20100402160338.389ca4d8@notabene.brown>
Reply-To: max@maxeaves.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100402160338.389ca4d8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear all,

Thank you all very much for everybody's replies over the past 24 hours 
on this.  It did make me chuckle on how I seem to have wandered into a 
hornets nest and given it a jolly good stir.

So - I have decided that what I will do is make the checking script a 
bi-monthly process (it runs every other month), in a new folder on my 
server called /etc/cron.bimonthly and referenced it in /etc/crontab

I feel what should really happen is a more sensible checking of the raid 
arrays, and instead of scanning every single RAID array at the same time 
(not good for my I/O).  I have a slow PCI-X 133Mhz bus here where my 
RAID cards are connected into, so I feel that this is the way forward.  
I'll see what I can do in that direction.

Thanks



Max


