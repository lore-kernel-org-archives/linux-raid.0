From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: Good news / bad news - The joys of RAID
Date: Sun, 28 Nov 2004 13:15:42 +0000
Message-ID: <41A9CF7E.4000804@robinbowes.com>
References: <200411192142.iAJLgRN12792@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200411192142.iAJLgRN12792@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy wrote:
> I use mdadm's monitor mode to send me email when events occur.

Guy,

I've been meaning to write this for a while...

I tried monitoring once but had a problem when shutting down as the 
arrays were reported as "busy" because mdadm --monitor was running on 
them. I guess it needs to be killed earlier in the shutdown process.

So, can you share with me how you start/stop mdadm to run in monitor mode?

Thanks,

R.
-- 
http://robinbowes.com
