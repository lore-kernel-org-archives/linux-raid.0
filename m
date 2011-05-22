From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: HBA Adaptor advice
Date: Sun, 22 May 2011 04:41:05 -0500
Message-ID: <4DD8DA31.7030608@hardwarefreak.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com> <4DD6409F.9070904@hardwarefreak.com> <4DD79F4E.7000509@wildgooses.com> <4DD7A205.8070106@grumpydevil.homelinux.org> <4DD7A80C.8050808@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD7A80C.8050808@wildgooses.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/21/2011 6:54 AM, Ed W wrote:

> In fact if you go back to my question, the *entire* point is that I
> don't want the choice of card to be a point of failure, ie it's my
> specific point to purchase a card such that it can be swapped out for
> near any other card in the event of failure.

You're given about 3 or 4 conflicting requirement now WRT your 'perfect'
HBA.

What HBAs are you currently using?  How many of your stated requirements
over the past few days do your current HBAs fulfill?

Do you have a tape or D2D backup system in place?

There is no guarantee that you can swap one dead HBA for another brand
with a different chipset on board and have it work without issue.  If
you are that concerned you need to buy two identical cheap HBAs so you
have a spare.  But wait!  You must have hardware write cache for md RAID
as well.  But if you do that, you're locked into that vendor's cards.
And on, and on...

I've never seen nor heard of a real SA in a business environment
vacillate like this over a simple RAID/HBA acquisition, as if the
company's entire 1st quarter net profit was being wrapped up in this HBA
purchase.  And I've never head of an SA being concerned about cable
tripping of all damn things taking down a server.

Something in this whole thread just doesn't jibe...

-- 
Stan


