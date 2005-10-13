From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm-2.1-1.i386.rpm and linux-gate.so.1
Date: Thu, 13 Oct 2005 20:24:01 +1000
Message-ID: <17230.13761.247780.898679@cse.unsw.edu.au>
References: <434BCA8A.8030303@panix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from berk walker on Tuesday October 11
Sender: linux-raid-owner@vger.kernel.org
To: berk walker <berk@panix.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday October 11, berk@panix.com wrote:
> so - rpm says mdadm depends on the so.1  Is this a problem with my 
> system/configuration, or in the rpm?

Probably the RPM.  I built in under Debian/unstable.
Google finds plenty of refs for linux-gate.  It is some magic 2.6
thing.

I suggest you just rebuild mdadm.rpm from the source.
 
  rpm -ta mdadm-2.1.tgz

NeilBrown
