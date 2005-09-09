From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Drive fails & raid6 array is not self rebuild .
Date: Fri, 9 Sep 2005 10:50:01 +1000
Message-ID: <17184.56377.773388.978710@cse.unsw.edu.au>
References: <60F5F1E2B94AD4119F0B00B0D0215FFF01A69F99@bsc.tt.umist.ac.uk>
	<Pine.LNX.4.63.0509081247060.29776@filesrv1.baby-dragons.com>
	<17184.43156.113155.811612@cse.unsw.edu.au>
	<Pine.LNX.4.63.0509081525380.30261@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mr. James W. Laferriere on Thursday September 8
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday September 8, babydr@baby-dragons.com wrote:
> 
>  	When I try to do the remove I get .
> root@devel-0:/ # mdadm /dev/md_d0 --remove /dev/sdao
> mdadm: hot remove failed for /dev/sdao: Device or resource busy
> 
>  	I should also have 3 other drives that are spares .  I could
>  	try hot remove on one of them .  See at bottom the output of
>  	mdadm --misc -Q --detail /dev/md_d0
>  	Which is showing no spare drives ?  And I built it with 4
>  	spares

Yes... /dev/sda[pqrs] are missing.  I wonder why..

What does
   mdadm -E /dev/sda[pqrs]
show?
What happens if you then
  mdadm /dev/md_d0 -a /dev/sda[pqrs]
??

NeilBrown
