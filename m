From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm never notify, grub cause fault
Date: Mon, 19 May 2003 12:47:22 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16072.17850.938484.250446@notabene.cse.unsw.edu.au>
References: <3EC4AD9A.6090104@bnap.hu>
	<news2mail-ba382u$uop$1@cartman.spoiled.org>
	<3EC52695.318811F7@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Friday May 16
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: Juri Haberland <juri@koschikode.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday May 16, Paul.Clements@SteelEye.com wrote:
> Juri Haberland wrote:
>  
> > I also ran into this problem. I found the reason when I started mdadm
> > without '--daemonize': It tries to use '/usr/lib/sendmail' whereas most
> > recent distributions have sendmail (or it's replacement) in /usr/sbin.
> > So just create a link from /usr/sbin/sendmail to /usr/lib/sendmail and it
> > should work.
> 
> I was wondering myself how mdadm sent e-mail...sounds like there might
> be a need for a new "MAILPROG" entry in mdadm.conf...
> 

There is a compile-time option which I have just made more explicit in
the Makefile.  
If you add:
   -DSendmail=\""/usr/sbin/sendmail -t"\"
to the CFLAGS line in the makefile you will change how mail is sent by
default.

If you want runtime configuration, I would rather just leave the
PROGRAM entry and you and write a script to do whatever you like.

I'm thinking of causing the "NewArray" alert to 
 - be generate for all arrays at start time
 - contain an indication of whether the array is degraded
 - cause email to be sent if the array is degraded.

Thus you will get an alert of a failed drive when the mdadm --monitor
is started.

NeilBrown
