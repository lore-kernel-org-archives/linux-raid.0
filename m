From: Wilson Jonathan <piercing_male@hotmail.com>
Subject: Re: mdadm expanded 8 disk raid 6 fails in new server, 5 original
 devices show no md superblock
Date: Tue, 14 Jan 2014 17:47:33 +0000
Message-ID: <BLU0-SMTP57BD7000137CADA6A976CA98BF0@phx.gbl>
References: <1389422546.11328.15.camel@achilles.aeskuladis.de>
	 <52D183B5.3060006@turmel.org>
	 <1389632980.11328.104.camel@achilles.aeskuladis.de>
	 <52D4337F.4050307@turmel.org>
	 <1389695513.11328.158.camel@achilles.aeskuladis.de>
	 <52D5384E.6030408@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52D5384E.6030408@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: "=?ISO-8859-1?Q?=22Gro=DFkreutz=2C?= Julian\"" <Julian.Grosskreutz@med.uni-jena.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>
List-Id: linux-raid.ids

On Tue, 2014-01-14 at 08:14 -0500, Phil Turmel wrote:

> ?.  What did "smartctl -l scterc" say?  If it says unsupported, you have
> a problem.  The workaround is to set the driver timeouts to ~180 seconds
> for each such drive.
> 
> If scterc is supported, but disabled, you can set 7-second timeouts with
> "smartctl -l scterc,70,70", but you must do so on every power cycle.
> Either way, you need boot-time scripting or distro support.
> 
> Raid-rated drives power up with a reasonable setting here.
> 
> Many people discover the timeout problem the first time they have an
> otherwise correctable read error in their array, and the array falls
> apart instead.  This list's archives are well-populated with such cases.

Snipped for brevity above.

I understand the issue of "timeout" on drives that might perform long
error checking which then causes mdadm, via the device (block?) driver
issuing a time out, to then kick the drive. In this instance you allow
some time for a drive to try and fix things at the expense of a hung
array for a longer period of time.

I also understand that with scterc the drive gives up (in effect timing
its self out) when it hits the 7 second, or there about, mark and
subsequently mdadm kicks the drive out. In this specific instance the
idea is to kill a drive quickly to that the raid doesn't hang longer
than a few seconds.

However surely these things (bar the amount of time) result in the same
final result of a drive being kicked out. Even in a non-madam hardware
raid set up, the drive is either kicked because it didn't return in 7
seconds, or the drive kicks its self because it gave up before 7
seconds.

If anything surely when you have a degraded array that will fail if any
more disks are kicked then you actually need to do the reverse of normal
raid wisdom... which is set the time out in the device (block) layer to
as long as possible and then if the drives have scterc enabled then
disable it (assuming the drive physically allows it and if disabled
performs a harder, or any, internal retry/crc/etc.) to force the drives
to give their all to get any, as yet unknown, potential failing sectors
back should they occur during a re-build of a failed drive.

Surely, unless I'm missing something, rebuilding a failed drive's data
means that you want the system to not kick if at all possible and having
scterc enabled or a short timeout (shorter than the drives max time,
unless that time is indefinite retry) is the last thing you want?

> 
> Regards,
> 
> Phil


Jon


