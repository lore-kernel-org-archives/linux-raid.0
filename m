From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: Hardware versus Software
Date: Wed, 19 May 2004 16:03:02 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1084996982.4948.198.camel@localhost.localdomain>
References: <Pine.GSO.4.33.0405191452450.14297-100000@sweetums.bluetronic.net>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.33.0405191452450.14297-100000@sweetums.bluetronic.net>
To: Ricky Beam <jfbeam@bluetronic.net>
Cc: AndyLiebman@aol.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2004-05-19 at 15:00, Ricky Beam wrote:
> On Wed, 19 May 2004 AndyLiebman@aol.com wrote:
> >But the question still remains, is there any other safety and reliability
> >advantage to using Hardware? Is the data on a Hardware RAID more likely to
> >remain intact in the event of a computer crash or freeze?
> 
> The linux software RAID is good stuff.  It *can* be difficult to repair
> an array in a few cases -- don't put the root FS in a non-mirrored array
> and they shouldn't be a problem.
> 
> As you don't care about CPU cycles used by the array, you're far better
> off using the software raid with normal drive controllers. (esp. true
> for SATA.)  Hardware RAID cards generally offer better managability
> and stability -- the OS doesn't have to know if a drive fails, they're
> designed to hot-swap drives with little or no fuss, etc.  But, they will
> be just a reliable as anything else.
is there any support from linux that can do this hot swappable a little
easier? 


> 
> For a system I never want to have to touch, I use hardware raid.  For those
> systems sitting at my feet, that isn't as important.
> 
> --Ricky
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
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



