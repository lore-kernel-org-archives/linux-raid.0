From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm segfault
Date: Fri, 17 Dec 2004 15:35:16 +1100
Message-ID: <16834.25092.142003.103800@cse.unsw.edu.au>
References: <41C20D66.8040906@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Michael Stumpf on Thursday December 16
Sender: linux-raid-owner@vger.kernel.org
To: mjstumpf@pobox.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday December 16, mjstumpf@pobox.com wrote:
> mdadm 1.8.1 is segfaulting on red hat linux 7.3.  Kernel is 2.4.18smp5.  
> Happened when I try to assemble a 3 drive array with only 2 drives.
> 
> Not important to me; I just downgraded to 1.2.0 and it worked like a 
> champ, but I figured I'd throw that out there as an FYI.
> 

Why don't people read the release notes?

 From "ANNOUNCE-1.8.1":

   This is a "development" release of mdadm.  It should *not* be
   considered stable and should be used primarily for testing.
   The current "stable" version is 1.8.0.


I guess I should release a "1.9.0" and use "1.8.2 ..." for devel
releases.

NeilBrown
