From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm never notify, grub cause fault
Date: Mon, 19 May 2003 21:25:02 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16072.48910.490668.497653@notabene.cse.unsw.edu.au>
References: <3EC4AD9A.6090104@bnap.hu>
	<news2mail-ba382u$uop$1@cartman.spoiled.org>
	<3EC52695.318811F7@SteelEye.com>
	<16072.17850.938484.250446@notabene.cse.unsw.edu.au>
	<3EC8B398.8090702@koschikode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Juri Haberland on Monday May 19
To: Juri Haberland <juri@koschikode.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 19, juri@koschikode.com wrote:
> Neil Brown wrote:
> 
> > There is a compile-time option which I have just made more explicit in
> > the Makefile.  
> > If you add:
> >    -DSendmail=\""/usr/sbin/sendmail -t"\"
> > to the CFLAGS line in the makefile you will change how mail is sent by
> > default.
> 
> The question is: why does it default to /usr/lib? Yes, I know that this
> is the historical place, but on virtually all Linux distributions
> sendmail is in /usr/sbin and if you're lucky you have a compatibility
> link to /usr/lib. As mdadm is intended to be used on Linux and not on any
> other Unix system I don't see the point in defaulting to /usr/lib.

Must be my grey hairs showing.  This 'sbin' thing still feels like a
wierd new invention that is some sort of cross between /etc and
/usr/lib.
When I first used a machine post locally-hacked-Edition-7 Unix, the
gateway to the mail system was "/usr/lib/sendmail", and
"/usr/lib/sendmail" has been there ever since, so I haven't seen a
need to change.

Old habits die hard.

NeilBrown
