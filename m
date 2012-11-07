From: joystick <joystick@shiftmail.org>
Subject: Re: is "replaceable" in 3.2 considered stable
Date: Wed, 07 Nov 2012 19:08:48 +0100
Message-ID: <509AA3B0.70607@shiftmail.org>
References: <alpine.DEB.2.00.1211050546420.13802@uplift.swm.pp.se> <20121105162227.7bc5c103@notabene.brown> <5099BC6B.7030500@fnarfbargle.com> <509A3029.4050402@shiftmail.org> <509A65CF.8020409@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <509A65CF.8020409@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: NeilBrown <neilb@suse.de>, Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/07/12 14:44, Brad Campbell wrote:
> On 07/11/12 17:55, joystick wrote:
>
>>
>> we still need someone to test the other case, a more common scenario I'd
>> say: the disk to be replaced fails during hot-replace
>
> I suspect I can do that by creating some "media errors" using hdparm 
> while the replacement is in progress.

Hi Brad

That seems to be one way, but only for read errors, another would be 
with dm-flakey, which AFAIU would also allow to fail writes, and the 
faulty raid type (man mdadm)
the last two should allow to also test with write failures and hence 
complete failure of the source disk which should interrupt hotreplace 
and fallback to normal rebuild (I don't know if restarting from first 
byte or more intelligently going ahead with rebuild from the point of 
failure of hot-replace).

Then, the presence of the bad-blocks-list also changes the behaviour of 
hot-replace, so that one also would have to be tested if you are 
interested, so that makes already a lot of cases:

- read error only or readwrite error in source device
- presence of bad-block-list yes/no
(4 cases)

- write error of destination device
- power loss in the middle of hot-replace
- bad-blocks set for many devices (more than parity or mirror level) all 
on the same strip (4k wide) including the disk to be replaced, which 
AFAIR should cause a corresponding bad-block hole in the device 
destination of hotreplace, which in turn would cause read-error to be 
returned immediately by MD if that area is read.

- simultaneous hot-replace of 2+ drives; I don't know if this is 
supposed to work...

> If you put together a set of tests you'd like performed I'll be happy 
> to run them and see what happens. The machine is on a managed APC PDU 
> (yay Gumtree!), so remote power cycling is a lot easier than it used 
> to be and I really don't mind hammering the disks with emergency parks 
> or excessive cycles. 

Did that :-P
I'll tell you if some other test comes to my mind

Thanks for your work
