From: "Wilson, Jonathan" <piercing_male@hotmail.com>
Subject: Re: Raid 10 far 2 layout clarification.
Date: Wed, 26 Nov 2014 22:26:47 +0000
Message-ID: <BLU436-SMTP109DF1509BE353AA10DD09E98700@phx.gbl>
References: <BLU436-SMTP2133418C1B434E36DB60B7198700@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU436-SMTP2133418C1B434E36DB60B7198700@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2014-11-26 at 18:30 +0000, Wilson, Jonathan wrote:
> I just wanted to double check something before I return a failing SSD.
> 
> I set up a 2 partition raid 10 in far 2 mode... from what I understood
> it allows a mirror and stripe to exist on a 2 drive set up, so that it
> gets the benefits of stripe with the redundancy of mirror.

I should clarify, two partitions on two different SSD's not the same
SSD :-/   /sda4 and /sdb4

> 
> I just wanted to double check this was correct and if so confirm that I
> can fail and remove one of the drives.
> 
> Obvioulsy I will have to drop one of the drives anyway/somehow but if it
> wont hold up/keep running after failing one drive then I will have to
> deal with it in another way, probably a quick clone onto a spare disk as
> a stop gap measure until I get the replacement, as this array is my OS
> disk.
> 
> Jon.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


