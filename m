From: "Michael Schwarz" <mschwarz@multitool.net>
Subject: Re: Failed reads from RAID-0 array (from newbie
 who has read the FAQ)
Date: Sat, 17 Mar 2007 22:42:43 -0600 (CST)
Message-ID: <3123.72.21.237.163.1174192963.squirrel@www.multitool.net>
References: <2885.72.21.237.163.1174167308.squirrel@www.multitool.net>
	<Pine.LNX.4.44L0.0703172208400.16306-100000@netrider.rowland.org>
Reply-To: mschwarz@multitool.net
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-users-bounces@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0703172208400.16306-100000@netrider.rowland.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-users>
List-Post: <mailto:linux-usb-users@lists.sourceforge.net>
List-Help: <mailto:linux-usb-users-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-users-bounces@lists.sourceforge.net
Errors-To: linux-usb-users-bounces@lists.sourceforge.net
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-usb-users@lists.sourceforge.net
List-Id: linux-raid.ids

Yeah, I understand that.

Sorry, I use squirrelmail. Pretty limited...

I'll get you a "raw" dmseg output when I replicate the problem.

Let me clarify on khubd: There is such an entry in my process table, but
there was no kernel thread stack trace for it when I dumped the traces. I
don't know if that is a bad sign...

Right now I thought it would be best to verify my hardware, so I'm working
with the new hubs and cables, writing a large file to each of seven
attached (non-md) flash drives and diff-ing the usb drive contents against
the original file. If I have dead cables, connectors, or flash drives that
would save you all a lot of hassle.

When I'm done with that, I'll again replicate my problem, grab the logs
straight from dmesg, and post another entry here. I'll even fire up kmail
or mutt to avoid bad formatting.

Thanks again.

-- 
Michael Schwarz

> On Sat, 17 Mar 2007, Michael Schwarz wrote:
>
>> Nasty big stack trace set follows:
>
> This format is kind of awkward.  For one thing, a lot of lines were
> wrapped by your email program.
>
> For another, you copied the stack trace from the syslog log file.  That is
> not a good way to do it; syslogd is liable to miss bits and pieces of
> the kernel log when a lot of information comes along all at once.  You're
> much better off getting the stack trace data directly from dmesg.  (And
> when you do, you don't end up with 30 columns of wasted data added to the
> beginning of each line.)
>
> Alan Stern
>
>


-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys-and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
_______________________________________________
Linux-usb-users@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-users
