From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: ANNOUNCE: mdadm-1.0.9 - prelease for 1.1.0
Date: Fri, 21 Feb 2003 11:02:41 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15957.27809.433977.124341@notabene.cse.unsw.edu.au>
References: <15945.38175.58593.681394@notabene.cse.unsw.edu.au>
	<20030220175523.30AF33B809@jaded.cynicism.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Derek Vadala on Thursday February 20
To: Derek Vadala <derek@cynicism.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday February 20, derek@cynicism.com wrote:
> On Wed, 12 Feb 2003, Neil Brown wrote:
> 
> >     -   If the config file is called 'partitions' then it will be treated
> >         as though it contained exactly 'device partitions' so e.g.
> > 	  mdadm -Ebsc partitions
> > 	will fill all raid partitions easily.
> 
> So the difference between this and mdadm -Dbs is that it generates config
> entries for arrays that are online, but -Ebcs partitions gets a list of
> all the block devices from /proc/partitions and generates array lines
> based on those.

Yep.

> 
> How come -Dbs lists only num-device, and UUID while -Ebsc lists both of
> those as well as the devices list?
> 

Because the information is trivially and obviously available when
doing -E, but not quite so obviously available when doing -D.  Still
it shouldn't be hard to add that info.  I will put it on my todo list
for 1.1.


> This -Ebsc partitions is a nice feature by the way.
> 

Thanks,  It's the result of user feed back.  I like to encourage user
feedback!! 

NeilBrown
