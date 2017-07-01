From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Re: Disk Monitoring
Date: Sat, 1 Jul 2017 16:12:37 +0200
Message-ID: <CAJH6TXg+AneWdtN=SggbJ9aQuZ8KXiUeO9LDYNSOruv70Nwihg@mail.gmail.com>
References: <20170628131917.BF1911235B6@gemini.denx.de> <CAJH6TXhJ8HoH=tnxreZ4EAFYQYDh05KHAQxwoLqp1f7zQM4N0g@mail.gmail.com>
 <2113365.0QvyMCaQ9I@matkor-lenovo> <CAJH6TXiONYigcX1CtQw86ZXUgeOLvzD_+2couNfxSwL9hHj1gA@mail.gmail.com>
 <59550FCB.4090508@youngman.org.uk> <CAJH6TXg+xf0giY5bC_ug4jm+t88LzHkTVJq_BYeYzxEKedF2OA@mail.gmail.com>
 <94fcf340-4924-2f01-e616-a9b6ba172459@turmel.org> <faaa61f1-da3c-036b-e6b0-1107759e1c1d@youngman.org.uk>
 <CACJz6Quin5jReORQMk_-30yBq6MhmBYoO8S_3yw+OEqBwYiAww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACJz6Quin5jReORQMk_-30yBq6MhmBYoO8S_3yw+OEqBwYiAww@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2017-07-01 15:42 GMT+02:00 Drew <drew.kay@gmail.com>:
> In the defense of the hw raid vendor I've worked with quite a bit
> (LSI), I've found you can migrate RAID arrays from controller to
> controller quite easily. So if your raid controller fails, you can
> always grab the current available controller that supports your
> required raid level. I've created arrays in the older 1068 controller
> (PCI-X card) and easily migrated it to a newer 2008 or 2108 based
> controller with no fuss. See's the older array as an 'external' array
> and imports just fine.

This is true for "real" LSI controllers.
But if you look at DELL specs, DELL is supporting only 1 generation to
1 generation migration.
DELL firmware is different from LSI, I'm unsure what could happen by
migrating a raid array
between multiple generations.

And in additiojn to this, DELL doesn't provide any kind of support to
move disks skipping more than 1 generation.
