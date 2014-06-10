From: Phil Turmel <philip@turmel.org>
Subject: Re: writing zeros to bad sector results in persistent read error
Date: Tue, 10 Jun 2014 09:40:30 -0400
Message-ID: <53970ACE.6080001@turmel.org>
References: <B7EA34DA-1064-45B1-B0C0-B7C423C7EB47@colorremedies.com> <20140607075140.277c0880@natsu> <0E76B97E-96DF-43A3-B8EC-4867964BF8E9@colorremedies.com> <20140609193723.79F1B3809B0@gemini.denx.de> <19559C36-08B4-4C2F-ABC3-9DE79BE37B54@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19559C36-08B4-4C2F-ABC3-9DE79BE37B54@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>, Wolfgang Denk <wd@denx.de>, Roman Mamedov <rm@romanrm.net>
Cc: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/09/2014 10:48 PM, Chris Murphy wrote:
> 
> On Jun 9, 2014, at 1:37 PM, Wolfgang Denk <wd@denx.de> wrote:
> 
>> Dear Chris,
>> 
>> In message
>> <0E76B97E-96DF-43A3-B8EC-4867964BF8E9@colorremedies.com> you
>> wrote:
>>> 
>>> # dd if=/dev/zero of=/dev/sda seek=430234064 count=8 oflag=direct
>>> 8+0 records in 8+0 records out 4096 bytes (4.1 kB) copied,
>>> 3.73824 s, 1.1 kB/s
>> 
>> This has been pointed out before - if this is a 4k sector drive, 
>> then you should really write in units of 4 k, not 8 x 512 bytes as 
>> you do here.
> 
> It worked so, why?

Because writing 512 bytes into a 4096 byte physical sector requires a
read-modify-write cycle.  That will fail if the physical sector is
unreadable.  If you try to overwrite a bad 4k sector with eight 512-byte
writes, each will trigger an RMW, and the 'R' of the RMW will fail for
all eight logical sectors.  If you tell dd to use a block size of 4k, a
single write will be created and passed to the drive encompassing all
eight logical sectors at once.  So the drive doesn't need an RMW
cycle--a write attempt can be made without the preceding read.  Then the
drive has the opportunity to complete its rewrite or remap logic.

> The drive interface only accepts LBAs based on 512 byte sectors, so 
> bs=512 count=8 is the same as bs=4096 count=1, it has to get
> translated into 512 byte LBAs regardless.

The sector address does have to be translated to 512-byte LBAs.  That
has nothing to do with the *size* of each write.  So *NO*, it is *not*
the same.

"dd" is a terrible tool, except when it is perfect.  As a general rule,
if you aren't specifying 'bs=' every time you use it, you've messed up.
 And if you specify 'direct', remember that each block sized read or
write issued by dd will have to *complete* through the whole driver
stack before dd will issue the next one.

> If it were a 4096 byte logical sector drive I'd agree.

You do know that drives are physically incapable of writing partial
sectors?  It has to be emulated, either in drive firmware or OS driver
stack.  What you've written suggests you've missed that basic reality.
The rest is operator error.  Roman and Wolfgang were too polite when
pointing out the need for bs=4096 -- it isn't 'should', it is 'must'.

As for the secure erase, I too am surprised that it didn't take care of
pending errors.  But I am *not* surprised that that new errors were
discovered shortly after, as pending errors are only ever discovered
when *reading*.

HTH,

Phil
