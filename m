From: "John Stoffel" <john@stoffel.org>
Subject: Re: start dm-multipath before mdadm raid
Date: Fri, 11 Dec 2015 14:30:00 -0500
Message-ID: <22123.9272.750357.130814@quad.stoffel.home>
References: <CABdHLQ6Lo8WvgSf=MAuYdVoJJMHmLuV5gkE+N4MDMfxvAbG5OA@mail.gmail.com>
	<5669AE9C.7040904@turmel.org>
	<CABdHLQ4rh+Rtu6U+ZX6m0CWXu3sW4boEzHaPdxD03UBf82EJcQ@mail.gmail.com>
	<566AD7EA.4070903@turmel.org>
	<CABdHLQ7Wdg1sUdC-Ryamdy+et6SNJRJnfdnRXSPOrWJYX9sT_g@mail.gmail.com>
	<566AF4E8.5030801@turmel.org>
	<CABdHLQ4++kTu22YGkdDW3r1UAxf_7E_+fcn9SfFnTSg6MgSm9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABdHLQ4++kTu22YGkdDW3r1UAxf_7E_+fcn9SfFnTSg6MgSm9w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "P. Remek" <p.remek1@googlemail.com>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "P" == P Remek <p.remek1@googlemail.com> writes:

>> It's likely that the udev rules that drive incremental assembly don't
>> have the mapper aliases at the moment they run.  Try:
>> 
>> DEVICE /dev/dm*
>> 

P> That crossed my mind too, but no, this doesn't help, the array still
P> doesn't show up

What distro are you based on?  Have you re-built your initramfs and
then looked inside it to check that it made the changes?

Do you have everything setup as a module or a mix?  That can certainly
change things.  It might make sense to re-build the kernel so that the
MDADM stuff is modules, but the rest is compiled in, or visa versa.

John
