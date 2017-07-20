From: Veljko <veljko3@gmail.com>
Subject: Re: Linear device of two arrays
Date: Thu, 20 Jul 2017 23:40:30 +0200
Message-ID: <CALee7hY=dhvyEVz2yT+6jzk5u=o2X2SooSQYgLZobeqAUTKung@mail.gmail.com>
References: <CALee7hZYgLNO2siDJNtFge_BoocTXX-9BSgRHmMJH8MaH6V3LA@mail.gmail.com>
 <20170705214250.0ea99538@natsu> <595D2ADA.8010907@youngman.org.uk>
 <CALee7hZqmLK19tSEEFBgSWMKm9TRoUqLBCxUmbNJpwmM45BjTQ@mail.gmail.com>
 <df053262-9334-1070-c24a-5d2f91402716@hardwarefreak.org> <CALee7haowPD0DKPtEQUN8M8LDCNOq62SDrk5VNMO5C+5iUqtrQ@mail.gmail.com>
 <5afd5cea-06b8-8524-e4f5-8534f23bd714@hardwarefreak.org> <87van15j9b.fsf@notabene.neil.brown.name>
 <e394625b-18d7-d141-3957-3c16c9bc6e44@gmail.com> <87o9sn232n.fsf@notabene.neil.brown.name>
 <1eefd627-1aba-a795-05f0-d2106d3a62a3@gmail.com> <87shhyzhg5.fsf@notabene.neil.brown.name>
 <38e015fa-a07c-8f1a-3a04-384d973966be@gmail.com> <c4938980-5cbf-d080-3a87-af07d5414437@gmail.com>
Reply-To: veljko3@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c4938980-5cbf-d080-3a87-af07d5414437@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids

On Tue, Jul 18, 2017 at 10:58 AM, Veljko <veljko3@gmail.com> wrote:
> On 07/17/2017 12:16 PM, Veljko wrote:
>>
>> On 07/15/2017 02:12 AM, NeilBrown wrote:
>>
>>> So command should be
>>>
>>>>>   dd if=/dev/md2 of=SOMEWHERE/SAFE bs=1M skip=5626590
>>>
>>>
>>> and expect it to create a 3M file.
>>>
>>> Use this 'skip' number of the 'seek' number later.
>>>
>>> NeilBrown
>>
>>
>> Thanks, Neil, now it makes more sense.
>>
>> I tried to create new linear device, but mdadm is complaining about
>> data-offset:
>>
>> # mdadm -C /dev/md4 -l linear -n 2 --rounding=1M -e 1.0 --data-offset=0
>> /dev/md2 /dev/md3
>>  mdadm: invalid data-offset: 0
>>
>> I'm using Debian 8.8 if it makes any difference.
>>
>> # mdadm -V
>>  mdadm - v3.3.2 - 21st August 2014
>>
>> What could be the problem?
>
>
> I noticed that md2 and md3 use 1.2 metadata. Can that be the issue? Trying
> to create 1.0 metadata for md4?

Any advice on this?
