From: Neil Brown <neilb@suse.de>
Subject: Re: filesystem corruption with md raid6
Date: Fri, 27 Apr 2007 16:24:43 +1000
Message-ID: <17969.38699.375955.735895@notabene.brown>
References: <200704261926.l3QJQ73d023414@focus.uchicago.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Clem Pryke on Thursday April 26
Sender: linux-raid-owner@vger.kernel.org
To: Clem Pryke <pryke@focus.uchicago.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday April 26, pryke@focus.uchicago.edu wrote:
>  have a system with 12 SATA disks attached via SAS. When copying into the 
> array during re-sync I get filesystem errors and corruption for raid6 but not 
> for raid5. This problem is repeatable. I actually have 2 separate 12 disk 
> arrays and get the same behavior on both.
> 
> Does this sound familiar to anyone?

Yes.

> 
> Here's a little more detail:
> 
> - 8 core AMD64 system running RHEL4U4 kernel 2.6.9-42.0.3.ELsmp
                                               ^^^^^

2.6.9 is very old.  If you want support for RHEL, you should really be
asking RedHat.

Tell them it might be fixed by 
   http://linux.bkbits.net:8080/linux-2.6/?PAGE=gnupatch&REV=1.1938.340.65

(I'm not sure how stable that URL is ... maybe take a copy now. it
should start
#### ChangeSet ####
2004-11-11 13:48:33-08:00, neilb@cse.unsw.edu.au 
  [PATCH] md: fix raid6 problem
  
  Sometimes it didn't read all (working) drives before a parity calculation.
)

but I cannot be certain (it was a long time ago).
That patch came out after 2.6.9 but about 2 months.
So another option is to build a more recent kernel.

NeilBrown
