From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm upgrade easy or brain surgery?
Date: Tue, 22 Nov 2005 16:56:06 +1100
Message-ID: <17282.45814.271960.889953@cse.unsw.edu.au>
References: <E1EeQy1-0005Jd-00@toko.jab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jeff Breidenbach on Monday November 21
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Breidenbach <jeff@jab.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday November 21, jeff@jab.org wrote:
> 
> Hi all,
> 
> Debian is a little slow tracking mdadm, and currently ships version
> 1.9 in unstable. Of course, I want to try out the fancy new features
> in mdadm 2.1 to match my shiny new 2.6.14 (Debian stock) Linux kernel.
> 
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=337903
> 
> Is upgrading mdadm the type of thing that requires exquisite care,
> meticulous expertise, and a sacrificial goat to the data safety gods?
> Or can a naive oaf like me blurt the latest unpatched mdadm onto a
> production system and probably come out just fine?

It should be fairly hard to get it wrong, except for one little issue.

The debian maintainer of mdadm chose to relocate '/etc/mdadm.conf' to
'/etc/mdadm/mdadm.conf'.  So you might have your mdadm.conf in the
later location, but a freshly compiled mdadm will look for it in the
former location.  You should be able to work around this though.

So, go for it!!!

NeilBrown
