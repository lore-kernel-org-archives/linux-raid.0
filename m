From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Question about recovery via mdadm
Date: Fri, 14 Feb 2003 10:15:07 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15948.9979.534439.238616@notabene.cse.unsw.edu.au>
References: <A5974D8E5F98D511BB910002A50A66470580D627@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Cress, Andrew R on Thursday February 13
To: "Cress, Andrew R" <andrew.r.cress@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday February 13, andrew.r.cress@intel.com wrote:
> 
> Question:
> Solving why I got into this is another issue, but:
> Is there any way, once I'm in this predicament, to force a recovery to the
> spare, from userland (via mdadm)?  

No.
Reconstrution should start automatically.  There is no mechanism to
start it from user-space.
You could try to hot-remove and hot-add again, but if it didn't work
the first time it is unlikely to work the second time.

I would appear to be a kernel bug.  Do you know if redhat:2.4.18-14
contains any patches particular to md?
Are there any kernel messages? An Oops or something?

NeilBrown
