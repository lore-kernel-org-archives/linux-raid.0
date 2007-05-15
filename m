From: Neil Brown <neilb@suse.de>
Subject: Re: how to synchronize two devices (RAID-1, but not really?)
Date: Tue, 15 May 2007 21:07:43 +1000
Message-ID: <17993.38016.174124.287952@notabene.brown>
References: <4649760A.1060805@wpkg.org>
	<17993.34959.150157.200536@notabene.brown>
	<46498E60.9060407@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tomasz Chmielewski on Tuesday May 15
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday May 15, mangoo@wpkg.org wrote:
> Neil Brown schrieb:
> 
> (...)
> 
> > An external bitmap means that if the link goes down, it keeps track of
> > which blocks are in sync and which aren't, and when the link comes
> > back up you re-add the missing device and the rebuild continues where
> > it left off.
> 
> >   mdadm --build /dev/md22 --level=1 --bitmap=/root/mybitmap \
> >      --write-behind --raid-disks=2 /dev/localdevice --write-mostly /dev/remotedevice
> 
> One more question - is there a way to estimate the size of the bitmap 
> file? Does it depend on the size of the array?
> 
> What bitmap file size can I expect for a 600 GB array?

Due to internal implementation details, mdadm limits the size of the
bitmap to 2^20 bits.  So the file will be 100K +/- 50%.
That will lead to about 1Meg per bit.  If you have a failure, this
might mean you end up re-copying several megabytes more than you
really need to, but that should add up to less than one second.

NeilBrown
