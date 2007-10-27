From: Alberto Alonso <alberto@ggsys.net>
Subject: Re: Implementing low level timeouts within MD
Date: Sat, 27 Oct 2007 16:46:01 -0500
Message-ID: <1193521561.7690.14.camel@w100>
References: <1193418753.4771.17.camel@w100>
	 <1193425254.10336.290.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193425254.10336.290.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2007-10-26 at 15:00 -0400, Doug Ledford wrote:
> 
> This isn't an md problem, this is a low level disk driver problem.  Yell
> at the author of the disk driver in question.  If that driver doesn't
> time things out and return errors up the stack in a reasonable time,
> then it's broken.  Md should not, and realistically can not, take the
> place of a properly written low level driver.
> 

I am not arguing whether or not MD is at fault, I know it isn't. 

Regardless of the fact that it is not MD's fault, it does make
software raid an invalid choice when combined with those drivers. A
single disk failure within a RAID5 array bringing a file server down
is not a valid option under most situations.

I wasn't even asking as to whether or not it should, I was asking if
it could. Should is a relative term, could is not. If the MD code
can not cope with poorly written drivers then a list of valid drivers
and cards would be nice to have (that's why I posted my ... when it
works and when it doesn't, I was trying to come up with such a list).

I only got 1 answer with brand specific information to figure out when
it works and when it doesn't work. My recent experience is that too
many drivers seem to have the problem so software raid is no longer
an option for any new systems that I build, and as time and money
permits I'll be switching to hardware/firmware raid all my legacy
servers.

Thanks,

Alberto


