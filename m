From: Phil Turmel <philip@turmel.org>
Subject: Re: Wiki-recovering failed raid, overlay problem
Date: Sun, 02 Jun 2013 00:25:30 -0400
Message-ID: <51AAC93A.40004@turmel.org>
References: <CAGXrYFTamGFyiOz34ZV+zaoXMA3D9z-eJjco3gApdK95QR9fPg@mail.gmail.com> <51AA83FD.8080500@turmel.org> <CAGXrYFSgoLpKO-UHd_tvOh3gs3Ub2qqOKA48kPEA1Pr=cnrUhA@mail.gmail.com> <51AAA0B9.3050908@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51AAA0B9.3050908@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Finley <debenbain@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Whoops, noticed that I dropped the list...  Convention on kernel.org is
reply-to-all, as non-subscribers are welcome.

On 06/01/2013 09:32 PM, Phil Turmel wrote:
> On 06/01/2013 08:40 PM, Chris Finley wrote:
>> On Sat, Jun 1, 2013 at 4:30 PM, Phil Turmel <philip@turmel.org> wrote:
>>> Hi Chris,
>>>
>>> On 06/01/2013 02:23 AM, Chris Finley wrote:
>>>> I am trying to recover a failed Raid 5 array by following the guide at
>>>> https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID
>>>
>>> Stop.  Report the *critical* details of your setup.  At least:
>>
>> Thank you for the reply.
>>
>> Oh, yes. I'm the guy from an earlier post:
>> http://marc.info/?l=linux-raid&m=136840333618808&w=2
> 
> I missed it--I must have been busy.
> 
>> Because each of the drives had some read errors, I thought it would be
>> safer to make the first attempt with overlays. There is always the
>> possibility of me entering command incorrectly too :)
> 
> As long as the original metadata is still present, mdadm is quite
> robust.  Overlays are useful when you don't know the original metadata
> properties and don't have enough spare drives.
> 
> The material provided is quite complete, but lacks a correlation between
> device names and drive serial numbers.  I'd like some more confidence there:
> 
> Please show the output of my 'lsdrv' script [1] as your system is now
> set up.
> 
> Your drive with S/N S2H7JD2B105688 seems to be the worst, with
> triple-digit pending sectors.  This suggests a mismatch between your
> drives' error correction time limits and the linux drivers' default
> timeout.  And a lack of regular scrubbing to clean up pending sectors.
> "smartctl -l scterc" for each drive would give useful information.
> Anyways, the drive may not be really failing--it has zero relocations.
> 
> If S2H7JD2B105688 was the old /dev/sdd, then it doesn't matter, but
> you've now lost the opportunity to correct those sectors.
> 
> Phil
> 
> [1] http://github.com/pturmel/lsdrv/
> 

