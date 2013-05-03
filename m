From: Phil Turmel <philip@turmel.org>
Subject: Re: Failed during rebuild (raid5)
Date: Fri, 03 May 2013 10:51:53 -0400
Message-ID: <5183CF09.1080605@turmel.org>
References: <51839E4F.7050102@midgaard.us> <5183A1C7.5000905@mpstor.com> <20130503124023.GB27548@cthulhu.home.robinhill.me.uk> <20867.49429.400548.184315@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20867.49429.400548.184315@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Robin Hill <robin@robinhill.me.uk>, Andreas Boman <aboman@midgaard.us>, linux-raid@vger.kernel.org, Benjamin ESTRABAUD <be@mpstor.com>
List-Id: linux-raid.ids

On 05/03/2013 09:52 AM, John Stoffel wrote:
> 
> After watching endless threads about RAID5 arrays losing a disk, and
> then losing a second during the rebuild, I wonder if it would make
> sense to:
> 
> - have MD automatically increase all disk timeouts when doing a
>   rebuild.  The idea being that we are more tolerant of a bad sector
>   when rebuilding?  The idea would be to NOT just evict disks when in
>   potentially bad situations without trying really hard.  

This would be conterproductive for those users who actually follow
manufacturer guidelines when selecting drives for their arrays.

Anyways, it's a policy issue that belongs in userspace.  Distros can do
this today if they want.  There's no lack of scripts in this list's
archives.

> - Automatically setup an automatic scrub of the array that happens
>   weekly unless you explicitly turn it off.  This would possibly
>   require changes from the distros, but if it could be made a core
>   part of MD so that all the blocks in the array get read each week,
>   that would help with silent failures.

I understand some distros already do this.

> We've got all these compute cycles kicking around that could be used
> to make things even more reliable, we should be using them in some
> smart way.

But the "smart way" varies with the hardware at hand.  There's no "one
size fits all" solution here.

Phil

