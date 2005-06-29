From: seth vidal <skvidal@phy.duke.edu>
Subject: Re: Slow reconstruction
Date: Wed, 29 Jun 2005 13:46:55 -0400
Message-ID: <1120067215.10448.61.camel@cutter>
References: <1120061430.21458.236.camel@volt>  <42C2CEF0.7030108@h3c.com>
	 <1120066268.21458.252.camel@volt>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1120066268.21458.252.camel@volt>
Sender: linux-raid-owner@vger.kernel.org
To: John Rowe <rowe@excc.ex.ac.uk>
Cc: Mike Hardy <mhardy@h3c.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2005-06-29 at 18:31 +0100, John Rowe wrote:
> Thanks for all the suggestions. 
> 
> /proc/sys/dev/raid/speed_limit_max had the value "10000", changing it to
> 200000 didn't make a difference. hdparm looks OK to me:
> 

did you raise speed_limit_min??

if you didn't then you're probably being hit by the 'only use idle io'
problem.

-sv


