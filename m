From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Device utilization with RAID-1
Date: Sat, 20 Aug 2011 04:13:03 +0100
Message-ID: <4E4F263F.7080405@anonymous.org.uk>
References: <4E4C5C29.6040303@googlemail.com> <20110818114205.61aaa454@notabene.brown> <CAGqmV7oDQ-LJVi04ZXx6b_hEdjJ6MNJBfoU-zLN5ZLohjygkXA@mail.gmail.com> <20110819103135.5b6a3998@notabene.brown> <4E4EAC45.9040705@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E4EAC45.9040705@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: maurice <mhilarius@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19/08/2011 19:32, maurice wrote:
> On 8/18/2011 6:31 PM, NeilBrown wrote:
>> ..
>> In mdstat you have 'active' or 'inactive'. You cannot access an array
>> at all
>> until it is active. If you are assembling an array bit by bit with "mdadm
>> -I", it will be inactive until all the devices appear. Then it will be
>> active.
>>
>> In mdadm "State :" you have 'active' or 'clean'. as described above.
>> It used
>> to be 'dirty' or 'clean' but people were confused by having 'dirty'
>> arrays in
>> normal operation. So I changed it to 'active' and now it confuses a
>> different set of people. You just can't win can you :-)
>>
>> NeilBrown
>
> mdstat:
> "Enabled" or "Disabled" perhaps?
>
> That matches what most commercial hardware RAID interfaces use.

Does it? It sounds more like an administrative action than a current 
status. I would have thought "online" or "offline" - unless that means 
something else somewhere else.

And for mdadm state: how about "busy" and "idle"? Hmm maybe just "busy" 
instead of "active" or "dirty"; we don't want to start an array with 
--assume-idle...

Cheers,

John.

