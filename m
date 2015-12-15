From: "John Stoffel" <john@stoffel.org>
Subject: Re: start dm-multipath before mdadm raid
Date: Tue, 15 Dec 2015 10:42:17 -0500
Message-ID: <22128.13529.455835.671099@quad.stoffel.home>
References: <CABdHLQ6Lo8WvgSf=MAuYdVoJJMHmLuV5gkE+N4MDMfxvAbG5OA@mail.gmail.com>
	<5669AE9C.7040904@turmel.org>
	<CABdHLQ4rh+Rtu6U+ZX6m0CWXu3sW4boEzHaPdxD03UBf82EJcQ@mail.gmail.com>
	<566AD7EA.4070903@turmel.org>
	<CABdHLQ7Wdg1sUdC-Ryamdy+et6SNJRJnfdnRXSPOrWJYX9sT_g@mail.gmail.com>
	<566AF4E8.5030801@turmel.org>
	<CABdHLQ4++kTu22YGkdDW3r1UAxf_7E_+fcn9SfFnTSg6MgSm9w@mail.gmail.com>
	<22123.9272.750357.130814@quad.stoffel.home>
	<CABdHLQ5jy1jNQ5uKF5AqJftHXw6CG3sEsrwguhgqP3mNr10aWA@mail.gmail.com>
	<CABdHLQ5mHPymE6teRq9mCOGas5ydGZhFwUXoS5-j0NjsmNHp+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABdHLQ5mHPymE6teRq9mCOGas5ydGZhFwUXoS5-j0NjsmNHp+g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "P. Remek" <p.remek1@googlemail.com>
Cc: John Stoffel <john@stoffel.org>, Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Sorry, haven't had a chance yet.  Maybe later today/tonight.

It might be a good thing to compile your own kernel, using the latest
Linux version (v4.4-rc5) and see how that works for you.

John
 

P> have you managed to look at the information in the link below? I think
P> dm-multihost is as module.

P> Regards,
P> Remek

>> 
>> Here is all the information I collected: http://pastebin.com/VF4Sfrq5
>> 
>> 
>> Regarding the testing setup, we can safely consider whole system as a
>> test, we will rebuild the system once we figure final config anyway.
>> So we can play around with the current raid with no risk of data loss.
