From: Darryl Barlow <darrylb@iprimus.com.au>
Subject: Re: Software Raid Autodetection Problem
Date: Fri, 12 Sep 2003 15:45:05 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200309121545.05799.darrylb@iprimus.com.au>
Reply-To: darrylb@iprimus.com.au
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

Thanks for the reply.

Software Raid is linked directly into the kernel and not a module.  I notice 
using make menuconfig on 2.4.21 there is no specific autodetect option as 
with earlier kernels, and presume this is no longer necessary.  All options 
under Multi-Device support are linked in, as is Reiserfs which I am using on 
the array.  dmesg shows that autodetection is taking place but it does not 
appear to find anything.  raidstart --all seems to bring it up, as do the 
initscripts if I reconfigure raidtools2.

Any suggestions welcome.

regards,

Darryl
-- 
_________________________________________________________

