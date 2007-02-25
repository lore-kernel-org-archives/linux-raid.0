From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Linux Software RAID a bit of a weakness?
Date: Mon, 26 Feb 2007 08:15:29 +1300
Message-ID: <45E1E051.1020908@sauce.co.nz>
References: <1172258378.21648.51.camel@cowie>  <45DF46B7.3040707@maine.edu> <1172406243.3765.29.camel@cowie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1172406243.3765.29.camel@cowie>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Colin Simpson wrote:

> They therefore do not have the "check" option in the kernel. Is there
> anything else I can do? Would forcing a resync achieve the same result
> (or is that down right dangerous as the array is not considered
> consistent for a while). Any thoughts apart from my one being to upgrade
> them to RH5 when that appears with a probably 2.6.18 kernel (which will
> presumably have "check")? Any thoughts?

You could configure smartd to do regular long selftests, which would 
notify you on failures and allow you to take the drive offline and dd, 
replace etc.

Regards,

Richard
