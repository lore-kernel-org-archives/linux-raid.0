From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH] proactive raid5 disk replacement for 2.6.11
Date: Mon, 29 Aug 2005 09:35:28 +1000
Message-ID: <17170.19008.732883.903851@cse.unsw.edu.au>
References: <1124050204.3810.28.camel@localhost.localdomain>
	<C0A1E607B5206F88D89CAF42@192.168.1.22>
	<62b0912f0508220347135352ea@mail.gmail.com>
	<1124711771.774.50.camel@localhost.localdomain>
	<62b0912f050822065547a70a8e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Molle Bestefich on Monday August 22
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: Pallai Roland <dap@mail.index.hu>, Claas Hilbrecht <claas+maillinglists.linux-raid@jucs-kramkiste.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 22, molle.bestefich@gmail.com wrote:
> > >
> > > My best guess would be that either you're using an old version of MD
> > > that won't try to write to bad blocks, or the spare area on your disk
> > > is full, in which case it should be replaced.  You can check the
> > > status of spare areas on disks with 'smartctl' or similar.
> >
> >  Which version of md tries to rewrite bad blocks in raid5?
> 
> Haven't followed the discussions closely, but I sure hope that the
> newest version does.  (After all, spare areas are a somewhat old
> feature in harddrives..)
> 

Sorry, but no - not yet.
Over-writing bad blocks is on my todo list, and will probably happen
this year, but it certainly is available yet.

NeilBrown
