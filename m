From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: Hardware versus Software
Date: Wed, 19 May 2004 19:23:26 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1085009006.4948.202.camel@localhost.localdomain>
References: <Pine.GSO.4.33.0405191759380.14297-100000@sweetums.bluetronic.net>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.33.0405191759380.14297-100000@sweetums.bluetronic.net>
To: Ricky Beam <jfbeam@bluetronic.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So the question here is that if I want to use software raid with SATA,
is there any good hardware combination to support this hot plug? Thanks
a lot.

Ming

On Wed, 2004-05-19 at 18:02, Ricky Beam wrote:
> On Wed, 19 May 2004, Ming Zhang wrote:
> >is there any support from linux that can do this hot swappable a little
> >easier?
> 
> It's not the kernel's fault.  Not entirely... SCSI will let you hot plug
> with little trouble.  IDE is a different problem.
> 
> The real problem is the system hardware.  Aside from SATA, I don't know
> of any MB that openly supports hot plugging of drives without some risk of
> Real Trouble (tm).
> 
> --Ricky
-- 
 --------------------------------------------------
| Ming Zhang, PhD. Student
| Dept. of Electrical & Computer Engineering
| College of Engineering
| University of Rhode Island
| Kingston RI. 02881
| e-mail: mingz at ele.uri.edu
| Tel. (401) 874-2293 
| Fax. (401) 782-6422
| http://www.ele.uri.edu/~mingz/
 --------------------------------------------------



