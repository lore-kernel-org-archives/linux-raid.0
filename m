From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Raid 5 - not clean and then a failure.
Date: Wed, 26 Aug 2009 13:18:41 +0200
Message-ID: <87hbvu9626.fsf@frosties.localdomain>
References: <15771.7292.qm@web51312.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15771.7292.qm@web51312.mail.re2.yahoo.com> (Jon Hardcastle's
	message of "Tue, 25 Aug 2009 00:54:49 -0700 (PDT)")
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Hardcastle <jd_hardcastle@yahoo.com> writes:

> Guys,
>
> I have been having some problems with my arrays that I think i have nailed down to a pci controller (well I say that - it is always the drives connected to *a* controller but I have tried 2!) anyway the latest saga is i was trying some new kernel options last night - which didn't work.
>
> But when i booted up again this morning it said one of the drives was in an inconsistent state (not sure of the *exact* error message). I then kicked off an add of the drive and it started syncing. It got about 5% in and then the second drive in on that controller complained and the array failed. 
>
> Is there any hope for my data? If i get a good controller in there will the resync continue? can I try and tell it to assume the drives are good (which they ought to be)?
>
> Please help!

The inconsistency is probably just a block here or there and I'm
assuming none of your drives actualy failed. So 99.9999% of your data
should be there. Just rebooting might actualy just get your raid back
(to syncing). If not then you have to force reassembly from the drives
with the newest serials. That will give you some data corruption,
whatever was writing when the controler gave errors. Worst case you
have to recreate the raid with --assume-clean.

I recommend adding a bitmap to the raid. That way a wrongfully failed
drive can be resynced in a matter of minutes instead of hours or
days. Makes it way less likely another error occurs during resync.

MfG
        Goswin
