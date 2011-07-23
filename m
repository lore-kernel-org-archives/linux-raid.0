From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: how to recover filesystem after clobbering array?
Date: Sat, 23 Jul 2011 10:43:00 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1107231029280.20159@uplift.swm.pp.se>
References: <20110719104325.16112cl7f4lrzkjh@mail.sapo.pt> <j03lp4$h72$1@dough.gmane.org> <4E255FE1.2060006@tolaris.com> <20110719120153.1529669k4o1t6v4x@mail.sapo.pt> <4E2A8420.5000603@sapo.pt>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-137064504-1673026807-1311410552=:20159"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E2A8420.5000603@sapo.pt>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Vasco_N=E9voa?= <vasco.nevoa@sapo.pt>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---137064504-1673026807-1311410552=:20159
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15; FORMAT=flowed
Content-Transfer-Encoding: 8BIT

On Sat, 23 Jul 2011, Vasco Névoa wrote:

> I initially used "mdadm --create --assume-clean ..." on a level1 array 
> of 2 disks that came from another machine. I didn't know any other way 
> of starting an array in this situation. While this is an acceptable 
> practice in some cases, it is better to use "--assemble" and pass the 
> necessary info (like uuid).

In case someone finds this from the archives:

mdadm --create --assume-clean is a LAST RESORT. It's to be used when 
everything else fails. I've seen so many start doing this way too early in 
the process and who then subsequently lost their data because of 
superblock version and mdadm changes over time (especially when they 
forgot --assume-clean and got the layout wrong).

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
---137064504-1673026807-1311410552=:20159--
