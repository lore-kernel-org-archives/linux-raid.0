From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: bad block remapping
Date: Fri, 24 May 2002 10:43:22 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15597.36010.276397.345833@notabene.cse.unsw.edu.au>
References: <3CED830C.1010504@cfht.hawaii.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Justin Kanoa Withington on Thursday May 23
To: Justin Kanoa Withington <kanoa@cfht.hawaii.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday May 23, kanoa@cfht.hawaii.edu wrote:
> I have philosophical question about the RAID software.

I think you are right.
After a read error, the raid system would do well to:
  read a few other random blocks on the drive
    (first/last/middle/superblock) to see if the whole drive is dead
    or not
  Updates a failed-read-count in the superblock - abort if this fails
  regnerate the data from redundant info
  attempt a re-write
  On success assume the device has coped.

All we need now is code .... are you offering?

NeilBrown
