From: berk walker <berk@panix.com>
Subject: Re: mismatch_cnt again
Date: Fri, 06 Nov 2009 20:53:39 -0500
Message-ID: <4AF4D323.6020108@panix.com>
References: <4AF4C247.6050303@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF4C247.6050303@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Eyal Lebedinsky wrote:
> For years I found the mismatch_cnt rising regularly every few weeks and 
> could
> never relate it to any evens.
> 
> I since replaced the computer, installed fedora 11 (was very old debian)
> and only kept the array itself (ext3 on 5x1TB raid5). I had the raid
> 'repair'ed to get it to mismatch_cnt=0.
> 
> I thought that I saw the last of these. I had a good run for almost three
> months, then last week I saw the first mismatch_cnt=184. It was still so
> on this weekly 'check'.
> 
> I cannot see any bad event logged.
> 
> Are there situations known to cause this without an actual hardware 
> failure?
> I know that this came up in the past (often) but I see little recent
> discussion and wonder what the current status is.
> 
> For the last 6 weeks (my uptime) the machine runs
>     2.6.30.5-43.fc11.x86_64 #1 SMP
> 
> The raid holds data (no root or swap) used mostly as DVR (nothing heavy).
> smartd checks each week and so far no errors. The disks are modern 1yo
> "SAMSUNG HD103UJ".
> 
> TIA
> 
 >I< am not quite sure what you are reporting as a problem here, sir. 
"new computer".. drives ~ 1 yr old...mismatch..I know.. seems like 
things just want to die ..
Do you have any logs showing these strangenesses?

I suggest - start off with SOMETHING at zero point, then track what 
changes...  oh BTW did you change the drive cables?

Best to you,
b-


