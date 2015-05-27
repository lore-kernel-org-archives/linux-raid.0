From: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
Subject: Re: Which physical device failed?
Date: Wed, 27 May 2015 14:10:03 +0200
Message-ID: <5565B41B.8040104@aei.mpg.de>
References: <5565B2BB.5090701@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5565B2BB.5090701@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Munger <michael.munger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

On 05/27/2015 02:04 PM, Michael Munger wrote:
> Or, does the OS have access to serial numbers, etc...?
> 
> I have to guide someone through a drive replacement on the phone, and it
> would be great if I could tell them exactly which drive to swap out...

If you have direct knowledge, which serial number is where, you could
use hdparm -I /dev/sdX or smartctl -a /dev/sdX against the still
reachable drives.

Possibly the easiest is to *read* data from the still reachable disks
and check which LED does not blink anymore - if you have LEDs for each
of the drives (dd if=/dev/sdX of=/dev/null).

Otherwise someone needs to look at the "open" hardware to find the
serial numbers.

Does this help?

cheers

Carsten


