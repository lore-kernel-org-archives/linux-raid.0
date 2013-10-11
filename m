From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Best practice for setting up "ordinary" RAID
Date: Fri, 11 Oct 2013 18:05:23 +1100
Message-ID: <5257A333.2010809@websitemanagers.com.au>
References: <CAPbD+RckkbYXF4Wpr_yzboJ0B+TBZayf0LbT3f4O3xQ-JN3gaA@mail.gmail.com>	<alpine.DEB.2.02.1310110827350.20065@uplift.swm.pp.se> <CAPbD+Rc-EDpVvm=-Ge5nWJNgJRBVWseqJKwnfCdDLoBjzC4hzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPbD+Rc-EDpVvm=-Ge5nWJNgJRBVWseqJKwnfCdDLoBjzC4hzg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guillaume Betous <guillaume.betous@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/10/13 17:52, Guillaume Betous wrote:
>> RAID6, preferrably with a spare.
> I'm not comfortable with RAID 6 setup. What is the minimal number of
> hard drives for having a RAID 6 + spare ?
>

Check wikipedia, but minimum of 4 drives for RAID6, consider 2 data
drives plus two redundant drives, allowing you to lose any two drives
(slightly better than RAID10 on 4 drives).

In direct answer, RAID6 + hot spare is a minimum of 5 drives.

Regards,
Adam


-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au

