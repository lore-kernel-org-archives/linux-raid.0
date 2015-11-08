From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID 6 Not Mounting (Block device is empty)
Date: Sun, 8 Nov 2015 12:48:29 -0500
Message-ID: <563F8AED.4020000@turmel.org>
References: <BD358508-33D4-4463-99AB-118019C2EB06@abitofthisabitofthat.com>
 <563E479E.50409@turmel.org>
 <6AC4B7C0-0AE8-4E0A-9B25-049025C386C3@abitofthisabitofthat.com>
 <563E685C.70208@turmel.org>
 <C57F2260-D20C-4688-93F6-CB3CE8CF9F30@abitofthisabitofthat.com>
 <563E843E.5060108@turmel.org>
 <251B709D-3310-433E-8817-E875194A69F9@abitofthisabitofthat.com>
 <563F5A1B.30506@turmel.org>
 <31D02BFE-239B-42BE-9176-10DF20A78A9C@abitofthisabitofthat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <31D02BFE-239B-42BE-9176-10DF20A78A9C@abitofthisabitofthat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francisco Parada <cisco@abitofthisabitofthat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Forgot to answer this one.

On 11/08/2015 09:48 AM, Francisco Parada wrote:
> 
>> Apple Mail? Eeeewwww!  :-)
> Hah! Jerk!  ;-) Just kidding

I'm a Linux enthusiast all the way -- servers, desktops, laptop, android
phone, ddwrt routers, etc.  I suffer to run Windows for some work
applications, but only in a VM.

>> Yeah, that's normal with partial successes.  Also, consider not using
>> md127.  That's mdadm's "I don't know what number to use" default.
>> (Followed by 126, then 125, as so on.)
> Just want to clarify this bit.  Are you saying I should use a number as such to mount it now instead the 127 that it was called until the failure?  Or in the future?  For the two newer arrays, I had called them 500 and 400, just to be safe so there was no overlap.

You need an mdadm.conf file that calls out your arrays by name and uuid.
 Your distro probably put a template in either /etc/ or /etc/mdadm/.
You can append your current running setup with:

mdadm -Es >>/etc/mdadm/mdadm.conf

Then trim the ARRAY lines to just:

ARRAY /dev/md1 UUID=......

Then use 'update-initramfs' or whatever ubuntu is using in 15.10 to
install that into your early boot environment.

Don't forget to fix your timeout mismatch problem.

Phil
