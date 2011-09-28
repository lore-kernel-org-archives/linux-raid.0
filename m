From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Recovery of failed RAID 6 and LVM
Date: Wed, 28 Sep 2011 21:20:36 +0800
Message-ID: <4E831F24.9030009@fnarfbargle.com>
References: <4E7EDE58.3000804@yazzy.org> <20110926074002.6399de56@notabene.brown> <4E7FA3E8.5010603@yazzy.org> <20110926081853.2819622b@notabene.brown> <4E804062.3020700@yazzy.org> <20110926193130.6377f5b9@notabene.brown> <4E82203A.60507@yazzy.org> <20110928091335.1df35f8e@notabene.brown> <4E828B92.40502@hardwarefreak.com> <4E82F923.8080807@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E82F923.8080807@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 28/09/11 18:38, Michal Soltys wrote:

> It's hard to find cases, when md driver or mdadm was really at fault for
> something. For the most part the typical route is: [bottom barrel cheap
> desktop ]hardware/[terribly designed sata ]cable issues -> a user
> applying random googled suggestions (with shaking hands) -> really,
> really bad problems. But that's not md's failure.

This really sums it up succinctly.

If you watched the cases of disaster that swing past linux-raid, the 
ones who always walk away whistling a happy tune are the ones who stop, 
think and ask for help.

The basket cases are more often than not created by people trying stuff 
out because they saw it mentioned somewhere else.

I'd suggest that users of real hardware raid suffer less "problems" 
because as they pay a bucketload of money for their raid card, they are 
far less likely to cheap out on cables, enclosures, drives and power 
supplies.

Most of the tales of woe here are related to the failures associated 
with commodity hardware. The 8TB I lost was entirely due to using a $15 
SATA controller.

