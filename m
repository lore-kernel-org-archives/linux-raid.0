From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm create error
Date: Fri, 24 Sep 2004 11:08:45 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16723.29597.739643.376166@cse.unsw.edu.au>
References: <1095961346.3465.29.camel@rich>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from rich turner on Thursday September 23
To: rich turner <rich@storix.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday September 23, rich@storix.com wrote:
> i cant figure out what is wrong with the following command. when i
> remove the "parity=right-asymmetric" command option it does not fail.
> but i need to be able to create the raid device with different parity
> algorithms. it also fails on --level=5 and using the short forms of the
> flags.
> 
> mdadm --create /dev/md2 --chunk=64 --level=6 --raid-devices=4 
> --parity=right-asymmetric --spare-devices=2 /dev/vg0/turnerlv1
> /dev/vg0/turnerlv2 /dev/vg0/turnerlv3 /dev/vg0/turnerlv4
> /dev/vg0/turnerlv5 /dev/vg0/turnerlv6
> 
> mdadm: layout may only be sent once.  Second value was
> right-asymmetric

There is a bug in 1.5.0 and 1.6.0 that prevents the --parity option
from working.   It is fixed in 1.7.0.

NeilBrown

> 
> rich:/tmp # mdadm --version
> mdadm - v1.5.0 - 22 Jan 2004
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
