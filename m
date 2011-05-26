From: Phil Turmel <philip@turmel.org>
Subject: Re: Storage device enumeration script
Date: Thu, 26 May 2011 08:00:55 -0400
Message-ID: <4DDE40F7.1090908@turmel.org>
References: <4DDDC301.7090608@turmel.org>	<BANLkTiky1L9fisPnxMKsceG19LbhxcF0ag@mail.gmail.com>	<4DDDC750.6040600@turmel.org> <BANLkTik-HjxNPGON7ZEwOSKJZOBzeETeAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTik-HjxNPGON7ZEwOSKJZOBzeETeAg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>, linux-raid@vger.kernel.org, Roman Mamedov <roman@rm.pp.ru>, John Robinson <john.robinson@anonymous.org.uk>
List-Id: linux-raid.ids

On 05/26/2011 04:24 AM, CoolCold wrote:
[...]
> On Debian Lenny produces error:
> root@gamma2:/tmp# python lsdrv
> Traceback (most recent call last):
>   File "lsdrv", line 17, in <module>
>     import os, io, re
> ImportError: No module named io

Huh.  The 'io' module is v2.6 and above.  Another reason to make a helper function for reading these files.

Phil
