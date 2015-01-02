From: "John Stoffel" <john@stoffel.org>
Subject: Re: Re: =?iso-8859-1?Q?Re=A0:?= Re: Big trouble during reassemble a Raid5
Date: Thu, 1 Jan 2015 23:07:32 -0500
Message-ID: <21670.6532.641717.517799@quad.stoffel.home>
References: <2105542796.11263344.1419768937013.JavaMail.zimbra@laposte.net>
	<21668.1236.130012.995660@quad.stoffel.home>
	<2050225023.16668598.1420037480502.JavaMail.zimbra@laposte.net>
	<21668.8063.635941.184463@quad.stoffel.home>
	<A6F7476D-8314-480D-B6B5-F84FF1F0960B@laposte.net>
	<21668.12775.212408.482021@quad.stoffel.home>
	<480970436.16926591.1420048769566.JavaMail.zimbra@laposte.net>
	<21668.19044.575022.311461@quad.stoffel.home>
	<1476942476.18574241.1420136514556.JavaMail.zimbra@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1476942476.18574241.1420136514556.JavaMail.zimbra@laposte.net>
Sender: linux-raid-owner@vger.kernel.org
To: sylvain.depuille@laposte.net
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


sylvain> Happy New Year and received all my best wishes for 2015.  i'm
sylvain> back to home.

Me too, but heading to bed soon, been a busy day here.  

sylvain> Now, the failed raid is at 700km (~400 miles) :-( I should
sylvain> work only by phone and ssh to repair the Raid.

It sucks having to work at a distance like this.  

sylvain> We have changed the right disk and the raid is rebuilding. I
sylvain> wille write you when it's finished.  Many many thank's for
sylvain> your help and your patience.

My real suggestion to you is to now collect all the information you
can on the system, including drive serial numbers, and how they map to
each device and member of the RAID array.  Sometimes when a system
reboots, or you add new disks, things get re-arranged and you don't
notice at first.  And that leads you down the wrong path quite
quickly.

sylvain> I have a question to migrate Raid 5 to Raid 6 :

sylvain> This site
sylvain> http://www.ewams.net/?date=2013/05/02&view=Converting_RAID5_to_RAID6_in_mdadm
sylvain> describe the right cookbook?  I don't want re-do this bad
sylvain> Story.

It looks right to me.  But I would also suggest that you look through
the archives of this list, and make sure you have a newer version of
the mdadm tool before you try to do this.

I would also suggest that you add two new disks, one to be used as a
hot spare, and the other used to grow the array into a RAID6.  

Then go through and make sure that all your drive timeouts are set
properly on system boot, so that if a disk hangs when trying to
re-read a bad block, it won't cause it to be kicked out of the array
too quickly.  Again, check the recent archives (last three months of
2014) of the list for examples and discussions of this issue.

Good luck!
John

