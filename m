From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Mdadm dirty, no errors?
Date: Fri, 23 Aug 2002 14:17:07 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15717.46915.800251.666970@notabene.cse.unsw.edu.au>
References: <1122.68.14.247.164.1030103630.squirrel@mail.wearesimply.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jason Pfingstmann on Friday August 23
To: Jason Pfingstmann <stclists@wearesimply.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday August 23, stclists@wearesimply.com wrote:
...
>           State : dirty, no-errors
...
> 
> Again,  why is State:  dirty, no-errors??  Is this normal?
> 

Yes, that is normal.  While an array is active, it is 'dirty', as
there could be parity blocks that are not correct (new data has hit
disc but new parity block hasn't yet, or vice-versa).

Whenever you do
   mdadm -D /dev/mdX

you will always get "dirty", unless you have set it to --readonly first.

If you shut the array down with
   mdadm -S /dev/md0
then ook at individual devices with, e.g.
   mdadm -E /dev/hda1

you will see that the array is clean.

NeilBrown

