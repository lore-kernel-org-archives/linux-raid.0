From: Doug Ledford <dledford@redhat.com>
Subject: Re: Software RAID-0 striping over Hardware RAID-5
Date: Thu, 23 Sep 2004 08:34:10 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1095942849.4196.1585.camel@compaq.xsintricity.com>
References: <200409201713.i8KHDxj01473@www.watkins-home.com>
	 <41521782.7030908@nsr500.net>  <1095899244.29081.641.camel@tinny.home.foo>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1095899244.29081.641.camel@tinny.home.foo>
To: "Scott T. Smith" <scott@gelatinous.com>
Cc: Tim Moore <linux-raid@nsr500.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2004-09-22 at 20:27, Scott T. Smith wrote:
> On Wed, 2004-09-22 at 17:23, Tim Moore wrote:
> > >>From what I have read, RAID0 will just go as fast as your slowest disk.
> > 
> > Almost 2X faster.
> 
> writes will be as fast as the slowest disk; reads will be faster.

Eh?  I think the more correct way to phrase RAID0 characteristics over
*any* selection of disks is that the minimum theoretical speed for the
overall array when it comes to sequential reads *and* writes is
n*speed_slowest_disk, where n is the number of drives in the array.

> 	Scott
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


