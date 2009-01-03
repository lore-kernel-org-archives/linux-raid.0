From: Mike Myers <mikesm559@yahoo.com>
Subject: Re: Need urgent help in fixing raid5 array
Date: Sat, 3 Jan 2009 08:47:10 -0800 (PST)
Message-ID: <273009.45761.qm@web30804.mail.mud.yahoo.com>
References: <451872.61166.qm@web30802.mail.mud.yahoo.com> <alpine.DEB.1.10.0901011039110.9903@p34.internal.lan> <467705.96388.qm@web30807.mail.mud.yahoo.com> <alpine.DEB.1.10.0901011328380.17888@p34.internal.lan> <344038.60917.qm@web30808.mail.mud.yahoo.com> <alpine.DEB.1.10.0901020708210.3858@p34.internal.lan> <17665.11566.qm@web30804.mail.mud.yahoo.com> <alpine.DEB.1.10.0901021319330.26159@p34.internal.lan> <746863.34803.qm@web30803.mail.mud.yahoo.com> <alpine.DEB.1.10.0901021355370.3485@p34.internal.lan> <480194.8807.qm@web30808.mail.mud.yahoo.com> <26FE68629F5947799772AAAFA8A6DF6F@m5> <889784.63168.qm@web30805.mail.mud.yahoo.com> <495F5E17.4070600@anonymous.org.uk> <432505.65026.qm@web30805.mail.mud.yahoo.com> <495F8EE1.3030007@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I tried doing the assemble without the one with the trashed superblock, but got the same result.  It may be the order of devices is a problem.  I'll play around with this knowing about the bug and see how I fare.

I am running lvm and xfs on top of the raid set, so knowing if it's working is somewhat more complicated, but I will continue to hold off on the assume-clean option for awhile more.

I have about 4 TB of storage on other servers that I can dump a lot of the data to for backup once I get this thing running again, then I'll reconfigure everything from scratch.

Thanks so much for the help.

thx
mike




----- Original Message ----
From: John Robinson <john.robinson@anonymous.org.uk>
To: Mike Myers <mikesm559@yahoo.com>
Cc: linux-raid@vger.kernel.org
Sent: Saturday, January 3, 2009 8:14:25 AM
Subject: Re: Need urgent help in fixing raid5 array

On 03/01/2009 15:49, Mike Myers wrote:
> Ugh.  This would explain a lot!  i'll try this out and see if it can help get md1 back online.

Good luck; the rest of that thread's probably worth a read before starting in too, just to see whether you need to mention your two dirty members first or last.

As Guy suggested earlier in this thread, you might try doing your reassemble while missing out the one with the apparently completely hosed superblock, to at least get the thing up in degraded mode, then test fsck it (e.g. `e2fsck -n`) and mount it read-only to see if you've still got any data. And perhaps take a backup then.

>  Is the only way to regenerate a superblock on a member doing a a create with the assume-clean option?

I'm not sure, but I expect so. Seconding what Justin said much earlier in this thread, personally I'd wait until one of the gurus arrives, in their shining armour and on their white charger, before trying this.

Cheers,

John.



      
