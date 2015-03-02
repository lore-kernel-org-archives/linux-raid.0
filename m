From: Phil Turmel <philip@turmel.org>
Subject: Re: Riad scrub generated errors, should I worry?
Date: Mon, 02 Mar 2015 16:09:02 -0500
Message-ID: <54F4D16E.8070909@turmel.org>
References: <BLU436-SMTP203777F3704141DF5C096B898100@phx.gbl> <alpine.DEB.2.02.1503021618580.20507@uplift.swm.pp.se> <1786620.4mivBfObx3@balsa>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1786620.4mivBfObx3@balsa>
Sender: linux-raid-owner@vger.kernel.org
To: thomas@fjellstrom.ca, Mikael Abrahamsson <swmike@swm.pp.se>
Cc: "Wilson, Jonathan" <piercing_male@hotmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/02/2015 12:43 PM, Thomas Fjellstrom wrote:
> On Mon 02 Mar 2015 04:22:00 PM Mikael Abrahamsson wrote:
>> On Mon, 2 Mar 2015, Wilson, Jonathan wrote:
>>> While the monthly scrub was running the following errors (at the bottom
>>> of the post, copied from syslog) were issued.
>>
>> As soon as you get UNC, it's the drive reporting that it can't
>> successfully read a sector. Usually this sector is then reported as
>> "pending" in your SMART output.
>>
>> Since the log you provided shows a lot of sectors being corrected and you
>> after that have 0 pending sectors on the drive, I'd say you are now fine.
>> I would run a new scrub manually in a few days just to check, but you
>> might be fine going forward. There is no really good way to know, but
>> generally, a drive that throws a bunch of UNC should be monitored so this
>> isn't becoming a common problem. I tend to replace drives that have thrown
>> these kinds of errors if it happens on any kind of regular basis.
> 
> Dumb question, but after pending, I assume they go into the reallocated 
> column? I think after a certain number of those, you should start thinking 
> about a replacement. Like with my recent issues, I had two drives with a few 
> too many reallocated sectors. One was over 16k and the other was over 32k. 
> They still "work", but I replaced them with WD Reds anyhow. Another drive 
> seemed to max out the start-stop count field at 65536. Hah. No more cheap 
> desktop seagates in raid for this fellow.

If the URE was simply due to magnetic decay without actual damage, you
can expect MD to rewrite the sector and fix it.  No more pending, no
relocation.  If the spot on the media is truly failing, the rewrite and
recheck the drive does for pending sectors will expose the problem, and
the firmware will relocate.

Read errors like this are normal and expected.  The drive data shows
10k+ hours of operation, so the honeymoon (no errors at all) is over.
Scrub weekly or monthly so these UREs don't accumulate and carry on.
When actual *relocations* climb into double digits, replace the drive.

HTH,

Phil

