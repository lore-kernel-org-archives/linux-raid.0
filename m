From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: write only raid1
Date: Wed, 10 Nov 2004 10:05:34 -0500
Message-ID: <41922E3E.7050206@steeleye.com>
References: <1100096418.3190.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1100096418.3190.4.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: mingz@ele.uri.edu
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ming Zhang wrote:

> is there any technical issue that lead not to be implemented?

No. In fact, it has been implemented. Both Peter T. Breuer and I have 
come up with slightly different patches to implement the write only 
functionality.

> is there any place to find previous discussion on this? i try the google
> but fail. i do no know which key word can find that. thx.

Try the archives of this mailing list:

http://marc.theaimsgroup.com/?l=linux-raid&r=1&w=2

This has been discussed a couple of times and patches have been posted 
to the list in the past.

--
Paul



> On Thursday November 4, mingz@ele.uri.edu wrote:
> 
>>Hi, folks?
>>
>>I would like to know if current RAID1 support or willing to support a
>>RAID1 with a write only device? For example, u can setup 2 disks to
> 
> form
> 
>>a raid1, you fork 2 writes to both disks while you only read from one.
>>this will be very useful for logging purpose or replication.
> 
> 
> This functionality has been discussed, but have not been implemented
> in a released kernel yet.
> 
> NeilBrown
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

