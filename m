From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: How to set speed_limit_max for mdrecoveryd?
Date: Wed, 25 Sep 2002 08:49:23 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15760.60403.398011.52618@notabene.cse.unsw.edu.au>
References: <A5974D8E5F98D511BB910002A50A66470580D1FE@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Cress, Andrew R on Tuesday September 24
To: "Cress, Andrew R" <andrew.r.cress@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday September 24, andrew.r.cress@intel.com wrote:
> 
> I couldn't find this is a quick scan of the code, and thought it should be
> documented somewhere.  Maybe I just have a blind spot.  Can someone tell me
> how to set the speed_limit_max variable for mdrecoveryd?  
> 
> Andy Cress

Get and install mdadm, and
   man 4 md

It says in the Files section:


       /proc/sys/dev/raid/speed_limit_max
              A readable and writable file that reflects the cur-
              rent goal rebuild speed  for  times  when  no  non-
              rebuild  activity  is  current  on  an  array.  The
              default is 100,000.


so
  echo 1000000 >  /proc/sys/dev/raid/speed_limit_max

Does that answer your question?

NeilBrown
