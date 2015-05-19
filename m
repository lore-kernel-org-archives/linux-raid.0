From: Phil Turmel <philip@turmel.org>
Subject: Re: Recent drive errors
Date: Tue, 19 May 2015 08:34:55 -0400
Message-ID: <555B2DEF.60905@turmel.org>
References: <3296560.sGbn0HyrQY@balsa>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3296560.sGbn0HyrQY@balsa>
Sender: linux-raid-owner@vger.kernel.org
To: thomas@fjellstrom.ca, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Thomas,

On 05/19/2015 07:08 AM, Thomas Fjellstrom wrote:
> Hi,
> 
> I have this one drive that dropped out of one of my arrays once. It shows UNC
> errors in SMART (log appended), and Reported_Uncorrect is 5. There are no
> smart test failures or any other SMART values that look spectacularly wrong,
> other than maybe Load_Cycle_Count which is 10625 (these seagates used to
> constantly park and unpark before i updated the firmware).
> 
> I'm wondering whether or not this drive is still safe to use. I feel like I
> can't trust it, especially after all the other Seagates I had that failed in
> the past few years. I'm running a tool called whdd on it right now and it
> shows very consistent latency spikes above 150ms. Really, I'm wondering if
> this drive is RMAable as is, or if i have to wait for it to degrade further as
> i have another drive with like 10k reallocated sectors to send in. I have
> already replaced both with WD Red's so I can do whatever tests are needed to
> figure it out.

Based on the smart report, this drive is perfectly healthy.  A small
number of uncorrectable read errors is normal in the life of any drive.
 It has no relocations, and no pending sectors.  The latency spikes are
likely due to slow degradation of some sectors that the drive is having
to internally retry to read successfully.  Again, normal.

I own some "DM001" drives -- they are unsuited to raid duty as they
don't support ERC.  So, out of the box, they are time bombs for any
array you put them in.  That's almost certainly why they were ejected
from your array.

If you absolutely must use them, you *must* set the *driver* timeout to
120 seconds or more.

HTH,

Phil

http://marc.info/?l=linux-raid&m=133761065622164&w=2
http://marc.info/?l=linux-raid&m=135811522817345&w=1
http://marc.info/?l=linux-raid&m=133761065622164&w=2
http://marc.info/?l=linux-raid&m=133665797115876&w=2


