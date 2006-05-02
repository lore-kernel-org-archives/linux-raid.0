From: Mike Hardy <mhardy@h3c.com>
Subject: Re: md: Change ENOTSUPP to EOPNOTSUPP
Date: Mon, 01 May 2006 19:17:15 -0700
Message-ID: <4456C12B.5070804@h3c.com>
References: <20060428124313.29510.patches@notabene>	 <1060428025144.30770@suse.de>	 <62b0912f0604280634x7df2a8a5m9022826876446cb6@mail.gmail.com>	 <44524765.6070703@emc.com> <62b0912f0604290650v6fa0759flace16041c26fa003@mail.gmail.com> <4453CB4D.9020907@emc.com> <445633D4.2000607@fooplanet.com> <4456BBE4.2000706@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4456BBE4.2000706@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>, Gil <gil@fooplanet.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Paul Clements wrote:
> Gil wrote:
> 
>> So for those of us using other filesystems (e.g. ext2/3), is there
>> some way to determine whether or not barriers are available?
> 
> 
> You'll see something like this in your system log if barriers are not
> supported:
> 
> Apr  3 16:44:01 adam kernel: JBD: barrier-based sync failed on md0 -
> disabling barriers
> 
> 
> Otherwise, assume that they are. But like Neil said, it shouldn't matter
> to a user whether they are supported or not. Filesystems will work
> correctly either way.

This seems very important to me to understand thoroughly, so please
forgive me if I'm being dense.

What I'm not sure of in the above is for what definition of "working"?

For the definition where the code simply doesn't bomb out, or for the
stricter definition that despite write caching at the drive level there
is no point where there could possibly be a data inconsistency between
what the filesystem thinks is written and what got written, power loss
or no?

My understanding to this point is that with write caching and no barrier
support, you would still care as power loss would give you a window of
inconsistency.

With the exception of the very minor situation Neil mentioned about the
first write through md not being a superblock write...

-Mike
