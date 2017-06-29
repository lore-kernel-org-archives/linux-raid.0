From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Re: Disk Monitoring
Date: Thu, 29 Jun 2017 12:16:27 +0200
Message-ID: <CAJH6TXiONYigcX1CtQw86ZXUgeOLvzD_+2couNfxSwL9hHj1gA@mail.gmail.com>
References: <20170628131917.BF1911235B6@gemini.denx.de> <CAJH6TXhJ8HoH=tnxreZ4EAFYQYDh05KHAQxwoLqp1f7zQM4N0g@mail.gmail.com>
 <2113365.0QvyMCaQ9I@matkor-lenovo>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2113365.0QvyMCaQ9I@matkor-lenovo>
Sender: linux-raid-owner@vger.kernel.org
To: Mateusz Korniak <mateusz-lists@ant.gliwice.pl>
Cc: Wolfgang Denk <wd@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2017-06-29 12:14 GMT+02:00 Mateusz Korniak <mateusz-lists@ant.gliwice.pl>:
> One can read of all disks/partitions used by RAIDs by script
> /usr/share/mdadm/checkarray
>
> In many distros it is set to be performed monthly out-of-box.

I know this and I'm running weekly. (just to be sure)
What Is unclear to me is why an hardware raid controller like LSI, has
two different kind of checks: patrol read and consistency check.
