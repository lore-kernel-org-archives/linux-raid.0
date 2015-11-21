From: Andre Tomt <andre@tomt.net>
Subject: Re: raid10 resync hangs in 4.2.6, 4.3
Date: Sat, 21 Nov 2015 02:27:44 +0100
Message-ID: <564FC890.3040507@tomt.net>
References: <564F6304.3040502@tomt.net>
 <22095.33515.989734.113452@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22095.33515.989734.113452@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 20. nov. 2015 21:30, John Stoffel wrote:
>
> Andre,
> I don't have time myself to test this, but since I'm running 4.2.6
> myself with triple mirror RAID1 arrays, I'm slightly worried now.  But
> can you make this failure happen with loop-back mounts by any chance?
> That might help narrow down if it's an MD layer, block layer or
> controller issue.

I've failed to reproduce it using loop devices, but I've found out the 
problem appeared somewhere between 4.1 and 4.2.

4.1.13 is stable, 4.2.0 to 4.2.6 and 4.3 is not.

Guess I'm starting a bisect now ;-)
