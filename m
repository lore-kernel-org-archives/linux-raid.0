From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Need urgent help in fixing raid5 array
Date: Sat, 03 Jan 2009 16:14:25 +0000
Message-ID: <495F8EE1.3030007@anonymous.org.uk>
References: <451872.61166.qm@web30802.mail.mud.yahoo.com> <alpine.DEB.1.10.0901011039110.9903@p34.internal.lan> <467705.96388.qm@web30807.mail.mud.yahoo.com> <alpine.DEB.1.10.0901011328380.17888@p34.internal.lan> <344038.60917.qm@web30808.mail.mud.yahoo.com> <alpine.DEB.1.10.0901020708210.3858@p34.internal.lan> <17665.11566.qm@web30804.mail.mud.yahoo.com> <alpine.DEB.1.10.0901021319330.26159@p34.internal.lan> <746863.34803.qm@web30803.mail.mud.yahoo.com> <alpine.DEB.1.10.0901021355370.3485@p34.internal.lan> <480194.8807.qm@web30808.mail.mud.yahoo.com> <26FE68629F5947799772AAAFA8A6DF6F@m5> <889784.63168.qm@web30805.mail.mud.yahoo.com> <495F5E17.4070600@anonymous.org.uk> <432505.65026.qm@web30805.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <432505.65026.qm@web30805.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Myers <mikesm559@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/01/2009 15:49, Mike Myers wrote:
> Ugh.  This would explain a lot!  i'll try this out and see if it can help get md1 back online.

Good luck; the rest of that thread's probably worth a read before 
starting in too, just to see whether you need to mention your two dirty 
members first or last.

As Guy suggested earlier in this thread, you might try doing your 
reassemble while missing out the one with the apparently completely 
hosed superblock, to at least get the thing up in degraded mode, then 
test fsck it (e.g. `e2fsck -n`) and mount it read-only to see if you've 
still got any data. And perhaps take a backup then.

>  Is the only way to regenerate a superblock on a member doing a a create with the assume-clean option?

I'm not sure, but I expect so. Seconding what Justin said much earlier 
in this thread, personally I'd wait until one of the gurus arrives, in 
their shining armour and on their white charger, before trying this.

Cheers,

John.
