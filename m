From: Drew <drew.kay@gmail.com>
Subject: Re: Disk Monitoring
Date: Sat, 1 Jul 2017 08:36:19 -0700
Message-ID: <CACJz6Qt6XY=6x0rjeKyLvti8E8wx+RhB0d2OLmbpYKa-BTsQ7g@mail.gmail.com>
References: <20170628131917.BF1911235B6@gemini.denx.de> <CAJH6TXhJ8HoH=tnxreZ4EAFYQYDh05KHAQxwoLqp1f7zQM4N0g@mail.gmail.com>
 <2113365.0QvyMCaQ9I@matkor-lenovo> <CAJH6TXiONYigcX1CtQw86ZXUgeOLvzD_+2couNfxSwL9hHj1gA@mail.gmail.com>
 <59550FCB.4090508@youngman.org.uk> <CAJH6TXg+xf0giY5bC_ug4jm+t88LzHkTVJq_BYeYzxEKedF2OA@mail.gmail.com>
 <94fcf340-4924-2f01-e616-a9b6ba172459@turmel.org> <faaa61f1-da3c-036b-e6b0-1107759e1c1d@youngman.org.uk>
 <CACJz6Quin5jReORQMk_-30yBq6MhmBYoO8S_3yw+OEqBwYiAww@mail.gmail.com> <CAJH6TXg+AneWdtN=SggbJ9aQuZ8KXiUeO9LDYNSOruv70Nwihg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXg+AneWdtN=SggbJ9aQuZ8KXiUeO9LDYNSOruv70Nwihg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> This is true for "real" LSI controllers.
> But if you look at DELL specs, DELL is supporting only 1 generation to
> 1 generation migration.
> DELL firmware is different from LSI, I'm unsure what could happen by
> migrating a raid array
> between multiple generations.
>
> And in additiojn to this, DELL doesn't provide any kind of support to
> move disks skipping more than 1 generation.

There's your problem. :-)

I have nothing good to say about DELL, and what I could say, well it's
nothing I can print in a public forum that wouldn't be expletive
laced.

"Real" LSI, or IBM/Lenovo branded LSI raid cards don't restrict their
users in such a fashion. I've taken IBM branded drives out of a failed
IBM/LSI controller, imported them into a genuine LSI controller, and
then ran it for years before the machine became too old and was
replaced. It's telling when you take the IBM stickers off their LSI
raid controllers and you see the original OEM markings still on the
card. Add to that how easy it is to reflash 'genuine' LSI firmware on
the IBM cards and the cards run slightly faster because all IBM
apparently inserted into the controller BIOS was interface code for
the BMC & IMM. :)

Try doing that with a PERC card. :P


-- 
Drew
