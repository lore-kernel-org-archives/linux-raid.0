From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: mismatch_cnt again
Date: Mon, 09 Nov 2009 13:11:20 -0500
Message-ID: <4AF85B48.3050601@tmr.com>
References: <4AF4C247.6050303@eyal.emu.id.au> <4AF4D323.6020108@panix.com>	<4AF5268D.60900@eyal.emu.id.au>	<4877c76c0911070008m789507f8h799d419287740ca5@mail.gmail.com> <87tyx6tpcb.fsf@frosties.localdomain> <4AF58B20.3000409@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF58B20.3000409@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Michael Evans <mjevans1983@gmail.com>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Doug Ledford wrote:
> And actually, with 1TB drives, your most likely culprit for this is the
> last item I just listed: reallocated drive sectors.  Here's the deal.
> If the drive detects the bad sectors during a write, it reallocates and
> redoes the write to the new sectors, data saved.  If, on the other hand,
> the sectors go bad after the write, then whether or not your data gets
> saved depends on a number of factors.  For instance, if the sectors were
> going bad slowly and you also read those sectors on a regular basis so
> the drive firmware would have reason to know that they are going bad (it
> would start gettings reads with errors that it had to ECC correct before
> it went totally bad), then some drives will reallocate the sectors and
> move the data before it's totally lost.  But, if they go bad suddenly,
> or if they went bad without having frequent enough intervening reads to
> pick it up that it was on its way to going bad, then the data is just
> lost.  But, that's what RAID is for, so we can get it back.  Anyway,
> that's my guess for the culprit of your situation.  And, unfortunately,
> without getting in and looking at the mismatch to identify the correct
> data, a repair operation is just as likely (50-50 chance) to corrupt
> things as opposed to correct things.
>
> With Fedora 11 there should be the palimpsest program installed.  Run it
> and it will allow you to see the SMART details on each drive.  Take a
> look and see if you have any showing reallocated sectors.  I happen to
> have 4 of 6 drives in my array that show reallocated sectors.  I also
> happen to be lucky in that none of my weekly raid-checks have turned up
> a mismatch count on any devices, so the bad sectors must have been
> caught in time (or there was a read error sometime for the sectors and
> the raid subsystem corrected it, but if that happened I missed it in the
> kernel logs).
>   

Are you saying or implying that this palimpsest program will show 
relocated sectors which the current tools (smartools) don't? If not, 
what does this tool do other than what's surrently done by most people 
using smartctl?

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

