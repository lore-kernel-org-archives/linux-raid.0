From: Jose Luis Domingo Lopez <linux-raid@24x7linux.com>
Subject: Re: raid 0 on different size devices?
Date: Wed, 19 Nov 2003 21:21:34 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031119202134.GA5015@localhost>
References: <1069269741.6952.33.camel@opus> <Pine.LNX.4.44.0311191300350.6810-100000@eglifamily.dnsalias.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0311191300350.6810-100000@eglifamily.dnsalias.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday, 19 November 2003, at 13:01:10 -0700,
Dan Egli wrote:

> How do I setup a linear array?
> 
Maybe you should give LVM a try if you just want to set up a linear
array, to aggregate disk space into one (large) block device. With LVM
you have all the features of a linear RAID array and more, for example
it is possible to add more drives at a later time and give the added
space to the LV (equivalent to a partition).

Better than trying to explain in two lines what LVM is, have a look at
LVM-HOWTO at http://tldp.org/HOWTO/LVM-HOWTO/

Greetings.

-- 
Jose Luis Domingo Lopez
Linux Registered User #189436     Debian Linux Sid (Linux 2.6.0-test9-mm3)
