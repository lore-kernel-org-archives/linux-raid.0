From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Can't expand linear RAID on top of 2 x RAID1
Date: Fri, 22 Jun 2012 18:05:22 -0500
Message-ID: <4FE4FA32.8010506@hardwarefreak.com>
References: <4FE44BDD.302@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FE44BDD.302@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <adam@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/22/2012 5:41 AM, Adam Goryachev wrote:
> I have expanded my system over time, I started with 2 x 2TB drives in
> RAID1 (md2)
> 
> I then added 2 x 750GB drives, configured as RAID1 (md1)
> Then created a third raid (md3) as linear with the md2 + md1
> 
> Finally, I've upgraded the 2 x 750G to 2 x 1TB drives (one at a time).
> 
> I then did a mdadm --grow to expand the RAID1 from 750G to 1TB
> 
> The problem I am having is that I can't expand the linear (md3) array to
> grow the extra 250G of space.
> 
> Could anyone suggest how I might be able to get the extra 250G of space
> to become available?

If you think about this for a few minutes more, and re-read how md
--linear works, and thus how growing a linear array works, you'll surely
understand why you can't do what you're attempting to do.

As for seeing that extra 250GB, I don't have an answer.  Typically
linear arrays are used in lieu of growing constituent member arrays.
That's kinda the whole point of linear (concatenation).

You could try deleting the linear array and simply creating a new one.
But surely the changed offsets would wreak havoc on the filesystem
currently spanning this mess.

-- 
Stan
