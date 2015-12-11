From: Phil Turmel <philip@turmel.org>
Subject: Re: start dm-multipath before mdadm raid
Date: Fri, 11 Dec 2015 11:39:06 -0500
Message-ID: <566AFC2A.7040009@turmel.org>
References: <CABdHLQ6Lo8WvgSf=MAuYdVoJJMHmLuV5gkE+N4MDMfxvAbG5OA@mail.gmail.com>
 <5669AE9C.7040904@turmel.org>
 <CABdHLQ4rh+Rtu6U+ZX6m0CWXu3sW4boEzHaPdxD03UBf82EJcQ@mail.gmail.com>
 <566AD7EA.4070903@turmel.org>
 <CABdHLQ7Wdg1sUdC-Ryamdy+et6SNJRJnfdnRXSPOrWJYX9sT_g@mail.gmail.com>
 <566AF4E8.5030801@turmel.org>
 <CABdHLQ4++kTu22YGkdDW3r1UAxf_7E_+fcn9SfFnTSg6MgSm9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABdHLQ4++kTu22YGkdDW3r1UAxf_7E_+fcn9SfFnTSg6MgSm9w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "P. Remek" <p.remek1@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/11/2015 11:32 AM, P. Remek wrote:
>> It's likely that the udev rules that drive incremental assembly don't
>> have the mapper aliases at the moment they run.  Try:
>>
>> DEVICE /dev/dm*
> 
> That crossed my mind too, but no, this doesn't help, the array still
> doesn't show up

Next step would be to run udevadm trigger while running udevadm monitor
in another session right after boot to see what events run and what
rules are executed.  That should help narrow this down.  Also compare
dmesg from boot with dmesg from udevadm trigger.

I'm not familiar enough with ubuntu to be much more help.
