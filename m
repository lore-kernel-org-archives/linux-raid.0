From: Tim Small <tim@buttersideup.com>
Subject: Re: read errors with md RAID5 array
Date: Tue, 16 Aug 2016 13:22:02 +0100
Message-ID: <8411601e-8e21-cbb3-a716-d2d409656b8e@buttersideup.com>
References: <78aab29c-9b7b-ff8b-f9c7-fab286f16243@buttersideup.com>
 <CAJCQCtSggAsQMSH9Ufa=Vjmu13cBm58+Q-RBZ4WRXm9UF=Yd+Q@mail.gmail.com>
 <b353161b-255e-e359-e3f4-800eac848847@buttersideup.com>
 <CAJCQCtSDEWr6Tp0Hd+Jifw4h_aoM6Tqroav_vLmfwfqjoEe8Rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtSDEWr6Tp0Hd+Jifw4h_aoM6Tqroav_vLmfwfqjoEe8Rg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 15/08/16 17:23, Chris Murphy wrote:
>> > These were all reporting:
>> >
>> > SCT Error Recovery Control:
>> >            Read: Disabled
>> >           Write: Disabled
> 
> You failed to provide the value for the 2nd command. Is it something
> other than 30 for each device?

Sorry about that - it's 30 seconds for all array members.

# for i in a c d ; do cat /sys/block/sd${i}/device/timeout ; done
30
30
30

Thanks,

Tim.
