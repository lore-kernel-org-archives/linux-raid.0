From: Justin Kanoa Withington <kanoa@cfht.hawaii.edu>
Subject: Re: bad block remapping
Date: Thu, 23 May 2002 15:18:32 -1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3CED94E8.9040303@cfht.hawaii.edu>
References: <3CED830C.1010504@cfht.hawaii.edu> <15597.36010.276397.345833@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Neil,

No I'm not offering; I don't have the skill to do something like that 
though I would offer emotional support and pizza to anyone who could.

-Kanoa

Neil Brown wrote:

>On Thursday May 23, kanoa@cfht.hawaii.edu wrote:
>
>>I have philosophical question about the RAID software.
>>
>
>I think you are right.
>After a read error, the raid system would do well to:
>  read a few other random blocks on the drive
>    (first/last/middle/superblock) to see if the whole drive is dead
>    or not
>  Updates a failed-read-count in the superblock - abort if this fails
>  regnerate the data from redundant info
>  attempt a re-write
>  On success assume the device has coped.
>
>All we need now is code .... are you offering?
>
>NeilBrown
>
>


