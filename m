From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Software Raid Autodetection Problem
Date: Fri, 12 Sep 2003 16:51:09 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16225.27869.416690.372183@notabene.cse.unsw.edu.au>
References: <200309121545.05799.darrylb@iprimus.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Darryl Barlow on Friday September 12
To: darrylb@iprimus.com.au
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday September 12, darrylb@iprimus.com.au wrote:
> Neil,
> 
> Thanks for the reply.
> 
> Software Raid is linked directly into the kernel and not a module.  I notice 
> using make menuconfig on 2.4.21 there is no specific autodetect option as 
> with earlier kernels, and presume this is no longer necessary.  All options 
> under Multi-Device support are linked in, as is Reiserfs which I am using on 
> the array.  dmesg shows that autodetection is taking place but it does not 
> appear to find anything.  raidstart --all seems to bring it up, as do the 
> initscripts if I reconfigure raidtools2.
> 
> Any suggestions welcome.

You are right that there is no longer a special config option for
autodetect.

Could I see a complete copy of dmesg output?

Is anything interesting in modules? ide driver? scsi driver?...

ByTheWay, I *strongly* recommend against using raidstart.  It is very
fragile and will quite possibly fail miserable if you have a failed
drive.
I use and recommend (and wrote) mdadm which is much more reliable at
starting arrays.
  http://www.kernel.org/pub/linux/utils/raid/mdadm/  (I think)

NeilBrown
