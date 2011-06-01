From: Phil Turmel <philip@turmel.org>
Subject: Re: Storage device enumeration script
Date: Tue, 31 May 2011 23:58:23 -0400
Message-ID: <4DE5B8DF.4010807@turmel.org>
References: <4DDDC301.7090608@turmel.org>	<BANLkTiky1L9fisPnxMKsceG19LbhxcF0ag@mail.gmail.com>	<4DDDC750.6040600@turmel.org>	<BANLkTik-HjxNPGON7ZEwOSKJZOBzeETeAg@mail.gmail.com>	<4DDE40F7.1090908@turmel.org>	<4DE538C2.5050504@gmail.com> <BANLkTimxnJaS0J6ZWLfZUo1GHiahMA+4gQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimxnJaS0J6ZWLfZUo1GHiahMA+4gQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: simonmcnair@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Simon,

On 05/31/2011 05:21 PM, CoolCold wrote:
> On Tue, May 31, 2011 at 10:51 PM, Simon McNair <simonmcnair@gmail.com> wrote:
>> Hi Phil,
>> Thanks for doing this work off your own back, I'm sure it'll help a lot of
>> people.
>>
>> My 2p would be to ask if you could have a comment at the start of the file
>> with the prerequisite applications/packages named it may help the people
>> that it doesn't work for (initially).  The other thing is that the
>> virtualbox install of Ubuntu 11.04 that I just completed did not contain the
>> LVM2 package.
> There is debian packaging for this tool, checkout
> https://github.com/pturmel/lsdrv
> You should be able build your package with proper dependencies.

The latest version (this evening) reports on the utilities that didn't work, so you can look for what you need.  Of course, if you have LVM volumes, but not the utilities, your system won't actually be able to start up those devices.

If you don't have LVM volumes, you can safely ignore the warning.  Hmmm.  Maybe I should suppress that if no LVM PVs are found in the first pass....

G'night!

Phil
