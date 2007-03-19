From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Failed reads from RAID-0 array (from newbie
 who has read the FAQ)
Date: Mon, 19 Mar 2007 14:17:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0703191414550.14222-100000@iolanthe.rowland.org>
References: <24685.64.122.229.18.1174323530.squirrel@www.multitool.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-users-bounces@lists.sourceforge.net>
In-Reply-To: <24685.64.122.229.18.1174323530.squirrel@www.multitool.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-users>
List-Post: <mailto:linux-usb-users@lists.sourceforge.net>
List-Help: <mailto:linux-usb-users-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-users-bounces@lists.sourceforge.net
Errors-To: linux-usb-users-bounces@lists.sourceforge.net
To: Michael Schwarz <mschwarz@multitool.net>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Bill Davidsen <davidsen@tmr.com>, linux-usb-users@lists.sourceforge.net
List-Id: linux-raid.ids

On Mon, 19 Mar 2007, Michael Schwarz wrote:

> Yeah; But here was where I lacked confidence. I used to know every inch of
> my kernel and my hardware, but, as previously stated, that was back in the
> 2.2.x days. I wasn't confident that I could run my hardware with a
> plain-vanilla kernel or that I could successfully roll my own working
> 2.6.x kernel in a timely manner. But, of course, I understand why this is
> a good idea.

It's not so hard to do, if you start from a known-good configuration.  
For instance, you could take the config your current distribution's kernel
is built from and just use it, although it would take a long time to build
because it includes so many drivers.  Whittling it down to just the
drivers you need would be tedious but not very difficult.

Alan Stern


-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys-and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
_______________________________________________
Linux-usb-users@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-users
