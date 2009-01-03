From: Mike Myers <mikesm559@yahoo.com>
Subject: Re: Need urgent help in fixing raid5 array
Date: Sat, 3 Jan 2009 07:49:39 -0800 (PST)
Message-ID: <432505.65026.qm@web30805.mail.mud.yahoo.com>
References: <451872.61166.qm@web30802.mail.mud.yahoo.com> <alpine.DEB.1.10.0901011039110.9903@p34.internal.lan> <467705.96388.qm@web30807.mail.mud.yahoo.com> <alpine.DEB.1.10.0901011328380.17888@p34.internal.lan> <344038.60917.qm@web30808.mail.mud.yahoo.com> <alpine.DEB.1.10.0901020708210.3858@p34.internal.lan> <17665.11566.qm@web30804.mail.mud.yahoo.com> <alpine.DEB.1.10.0901021319330.26159@p34.internal.lan> <746863.34803.qm@web30803.mail.mud.yahoo.com> <alpine.DEB.1.10.0901021355370.3485@p34.internal.lan> <480194.8807.qm@web30808.mail.mud.yahoo.com> <26FE68629F5947799772AAAFA8A6DF6F@m5> <889784.63168.qm@web30805.mail.mud.yahoo.com> <495F5E17.4070600@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ugh.  This would explain a lot!  i'll try this out and see if it can help get md1 back online.  Is the only way to regenerate a superblock on a member doing a a create with the assume-clean option?

thx
mike



----- Original Message ----
From: John Robinson <john.robinson@anonymous.org.uk>
To: Mike Myers <mikesm559@yahoo.com>
Cc: linux-raid@vger.kernel.org
Sent: Saturday, January 3, 2009 4:46:15 AM
Subject: Re: Need urgent help in fixing raid5 array

On 03/01/2009 05:02, Mike Myers wrote:
> I have tried that.  It still complains about only having 4 disks to start the array (if don't tell it to use sdf1).
> 
> I have been unable to explain my md refuses to use some of the members even though they have good superblock info on them even with the force command.  There are two members of md1 that are online and seem to have proper superblock info, but md doesn't assemble md1 with them.  
> Is there a place (besides the code) where md's specifics about how it assembles members is documented?  

I'm absolutely no expert here, but I vaguely recall one of the developers recently noting that there was a minor bug in `mdadm --assemble --force` whereby if you didn't mention the broken member(s) first on the command line, and the early member(s) were good, the later member(s) didn't get forced. So in your case, you might try mentioning your array members in a different order, as long as you don't blame me when it eats your cat, or whatever.

Aha, here it is: http://marc.info/?l=linux-raid&m=122938233431234&w=2

Not quite what I said, but not a zillion miles off :-) Good luck.

Cheers,

John.



      
