From: Jean-Rene Cormier <jean-rene.cormier@cipanb.ca>
Subject: Re: Moving RAID 1 array to new server
Date: Tue, 11 Nov 2003 22:12:44 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1068603164.908.6.camel@forbidden.jrc.net>
References: <1068509010.907.4.camel@forbidden.jrc.net>
	 <news2mail-bordad$avv$1@cartman.spoiled.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <news2mail-bordad$avv$1@cartman.spoiled.org>
To: Juri Haberland <juri@koschikode.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2003-11-11 at 15:29, Juri Haberland wrote:
> Jean-Rene Cormier <jrc@vgmidi.com> wrote:
> > I just moved my RAID 1 array to a new server and I did the mistake of
> > moving only one disk at first to make sure that I would still have a
> > copy on the other server in case the new one couldn't read the array for
> > some reason. When I added the second disk it mark it as faulty or
> > something so I tried to remove it from the array and re-add it but it
> > added a spare drive instead. So now my array is running in degraded
> > mode, what can I do to so the second drive resync with the other one?
> 
> It should work work with something like this:
> 
> mdadm --manage /dev/md0 --add /dev/hdXy
> 
> where hdXy ist the partition you want to add.

I believe that's what I did but it added it as a spare drive. I'll try
it again tomorrow and see what it does.

Jean-Rene Cormier

