From: Phil Turmel <philip@turmel.org>
Subject: Re: mdadm expanded 8 disk raid 6 fails in new server, 5 original
 devices show no md superblock
Date: Wed, 15 Jan 2014 08:35:22 -0500
Message-ID: <52D68E9A.5030906@turmel.org>
References: <1389422546.11328.15.camel@achilles.aeskuladis.de>	 <52D183B5.3060006@turmel.org>	 <1389632980.11328.104.camel@achilles.aeskuladis.de>	 <52D4337F.4050307@turmel.org>	 <1389695513.11328.158.camel@achilles.aeskuladis.de>	 <52D5384E.6030408@turmel.org>	 <BLU0-SMTP57BD7000137CADA6A976CA98BF0@phx.gbl>	 <52D58539.7090501@turmel.org> <BLU0-SMTP2298EF7EE934F21F583ECCA98BE0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP2298EF7EE934F21F583ECCA98BE0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Wilson Jonathan <piercing_male@hotmail.com>
Cc: =?UTF-8?B?Ikdyb8Ofa3JldXR6LCBKdWxpYW4i?= <Julian.Grosskreutz@med.uni-jena.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>
List-Id: linux-raid.ids

On 01/15/2014 07:50 AM, Wilson Jonathan wrote:
> On Tue, 2014-01-14 at 13:43 -0500, Phil Turmel wrote:
>> On 01/14/2014 12:47 PM, Wilson Jonathan wrote:
>>
>> [trim /]
>>
>>> I understand the issue of "timeout" on drives that might perform long
>>> error checking which then causes mdadm, via the device (block?) driver
>>> issuing a time out, to then kick the drive. In this instance you allow
>>> some time for a drive to try and fix things at the expense of a hung
>>> array for a longer period of time.
>>>
>>> I also understand that with scterc the drive gives up (in effect timing
>>> its self out) when it hits the 7 second, or there about, mark and
>>> subsequently mdadm kicks the drive out. In this specific instance the
>>> idea is to kill a drive quickly to that the raid doesn't hang longer
>>> than a few seconds.
>>
>> No.  The intent is to fail the read without failing the controller channel.
> 
> Arrr, thanks for the clarification... I hadn't realised that instead of
> the drive returning a "Error, I can't get the data, I'm dead in the
> water" message it instead returned a "warning, I can't get the data, you
> deal with it and get back to me, I'm still working" kind of affair.

Let me emphasize one point here:  while a drive is performing error
recovery, it *stops talking to the controller*.  The drive isn't
replying with a warning as you suggest--it isn't replying *at all*.
Modern desktop drives try *very hard* to recover bad sectors, under the
assumption that they have the only copy of the data.  Typically, they'll
work at it for two *minutes* or more.

The linux kernel driver will give up after 30 seconds and try to reset
the drive.  The drive firmware ignores the reset, possibly multiple
times, until it is done retrying the original read.  When it does
finally reset, it is too late--it's been bumped from the array.

But the drive didn't really fail, leading to:

>> When you, the admin, get around to looking, the drive is idle but
>> apparently fine.  (It gains a "pending" sector, which stays until the
>> drive is told to write over that spot.)
>>
>> HTH,
> 
> It does, thanks for the information :-)

You are welcome.

Phil

