From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Linux 5.5 Breaks Raid1 on Device instead of Partition, Unusable
 I/O
Date: Mon, 2 Mar 2020 13:32:42 +0000
Message-ID: <5E5D0AFA.1030701@youngman.org.uk>
References: <e46b2ae7-3b88-05f2-58d7-94ee3df449e4@suddenlinkmail.com>
 <20200302102542.309e2d19@natsu>
 <920df583-1d9e-6037-1d61-cbd5e1133d4d@suddenlinkmail.com>
 <20200302115141.1e796b7c@natsu>
 <c5d8e6d2-a572-5602-6562-795ea52168ac@suddenlinkmail.com>
 <CAJCQCtTOJrvm7BnyqSSuCUa82ehZbtHgSGaQo1bzcepgdtazSw@mail.gmail.com>
 <9e31d56a-a35d-2413-b6c7-4a97445d487d@suddenlinkmail.com>
 <9b1ceff4-1299-8e8a-cbc9-da717c72bba3@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9b1ceff4-1299-8e8a-cbc9-da717c72bba3@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, "David C. Rankin" <drankinatty@suddenlinkmail.com>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/03/20 11:44, Phil Turmel wrote:
> Hi David,
> 
> On 3/2/20 4:27 AM, David C. Rankin wrote:
>> On 03/02/2020 01:08 AM, Chris Murphy wrote:
>>> smart also reports for /de/sdc
>>>
>>>    40 53 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455
>>>
>>>
>>> So I'm suspicious of timeout mismatch as well.
>>> https://raid.wiki.kernel.org/index.php/Timeout_Mismatch
>>>
>>>
>>> Chris Murphy
>>>
>>
>> The strace between the virtualbox host and guess show and number of
>> I/O waits
>> that would seem to fit some timeout issue like that. But according to the
>> page, both drives in this array provide:
>>
>> SCT capabilities:              (0x1085) SCT Status supported.
> 
> SCT Status itself isn't sufficient.  You must have ERC "Error Recovery
> Control", an optional part of SCT.
> 
> smartctl -a doesn't expose that.  Use smartctl -x in general, or
> smartctl -l scterc to specifically check the needed setting.
> 
It's a Seagate Barracuda ... nuff said

(For David, Barracudas don't support SCT/ERC - they are not recommended
for raid. Okay for 1 but definitely not anything else. Get an Ironwolf
to replace it.)

Cheers,
Wol
