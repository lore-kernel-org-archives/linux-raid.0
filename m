From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: mdadm never notify, grub cause fault
Date: Fri, 16 May 2003 13:57:41 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EC52695.318811F7@SteelEye.com>
References: <3EC4AD9A.6090104@bnap.hu> <news2mail-ba382u$uop$1@cartman.spoiled.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Juri Haberland <juri@koschikode.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Juri Haberland wrote:
 
> I also ran into this problem. I found the reason when I started mdadm
> without '--daemonize': It tries to use '/usr/lib/sendmail' whereas most
> recent distributions have sendmail (or it's replacement) in /usr/sbin.
> So just create a link from /usr/sbin/sendmail to /usr/lib/sendmail and it
> should work.

I was wondering myself how mdadm sent e-mail...sounds like there might
be a need for a new "MAILPROG" entry in mdadm.conf...

--
Paul
