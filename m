From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: RAID5 crash and burn
Date: Sun, 31 Oct 2004 11:26:27 +0000
Message-ID: <4184CBE3.10801@robinbowes.com>
References: <1430.63.204.219.3.1099198742.squirrel@63.204.219.3>    <200410310518.i9V5ION22004@www.watkins-home.com> <1867.63.204.219.3.1099216777.squirrel@63.204.219.3>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1867.63.204.219.3.1099216777.squirrel@63.204.219.3>
Sender: linux-raid-owner@vger.kernel.org
To: coreyfro@coreyfro.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

coreyfro@coreyfro.com wrote:

> About swap failing, would there be much of a performence hit if i mirrored
> swap?  I don't like running without it, and I don't want to repeat this
> incident...  My system has more than enough ram for the load it has, but I
> under stand the other reasons for having swap, so slow swap is better than
> nothing or faulty, i spose...

What other reasons are these (genuine question - I'm curious)

I've got a box that is in a similar situation - loads of RAM, never 
anywhere near memory filling up. Currently I've not got swap activated 
but my disk architecture was created to allow one or two 1.5GB mirrored 
partitions for swap.

R.
-- 
http://robinbowes.com
