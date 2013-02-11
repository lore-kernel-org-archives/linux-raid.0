From: Phil Turmel <philip@turmel.org>
Subject: Re: raid/device failure
Date: Sun, 10 Feb 2013 21:09:51 -0500
Message-ID: <511852EF.9070201@turmel.org>
References: <201302101827.36116.thomas@fjellstrom.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201302101827.36116.thomas@fjellstrom.ca>
Sender: linux-raid-owner@vger.kernel.org
To: thomas@fjellstrom.ca
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/10/2013 08:27 PM, Thomas Fjellstrom wrote:
> I've re-configured my NAS box (still haven't put it into "production") to be a 
> raid5 over 7 2TB consumer seagate barracuda drives, and with some tweaking, 
> performance was looking stellar.
> 
> Unfortunately I started seeing some messages in dmesg that worried me:

[trim /]

The MD subsystem keeps a count of read errors on each device, corrected
or not, and kicks the drive out when the count reaches twenty (20).
Every hour, the accumulated count is cut in half to allow for general
URE "maintenenance" in regular scrubs.  This behavior and the count are
hardcoded in the kernel source.

> I've run full S.M.A.R.T. tests (except the conveyance test, probably run that 
> tonight and see what happens) on all drives in the array, and there are no 
> obvious warnings or errors in the S.M.A.R.T. restults at all. Including 
> reallocated (pending or not) sectors.

MD fixed most of these errors, so I wouldn't expect to see them in SMART
unless the fix triggered a relocation.  But some weren't corrected--so I
would be concerned that MD and SMART don't agree.

Have these drives ever been scrubbed?  (I vaguely recall you mentioning
new drives...)  If they are new and already had a URE, I'd be concerned
about mishandling during shipping.  If they aren't new, I'd
destructively exercise them and retest.

> I've seen references while searching for possible causes, where people had 
> this error occur with faulty cables, or SAS backplanes. Is this a likely 
> senario? The cables are brand new, but anything is possible.
> 
> The card is a IBM M1015 8 port HBA flashed with the LSI 9211-8i IT firmware, 
> and no BIOS.

It might not hurt to recheck your power supply rating vs. load.  If you
can't find anything else, a data-logging voltmeter with min/max capture
would be my tool of choice.

http://www.fluke.com/fluke/usen/digital-multimeters/fluke-287.htm?PID=56058

Phil
