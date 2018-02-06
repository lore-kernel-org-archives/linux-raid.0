From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: force remapping a pending sector in sw raid5 array
Date: Tue, 6 Feb 2018 16:31:58 -0600
Message-ID: <CAAMCDeeFVY_NVnzdZYumyxJ_aUTy9_gybhFDqfazSMOqPOeU2A@mail.gmail.com>
References: <20180206181416.amo6geclrvc6ylrf@merlins.org> <d764a824-fe3e-583a-10ef-040bc32dc78e@websitemanagers.com.au>
 <20180206220225.GE9565@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180206220225.GE9565@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

What kind of drive is it?   I have had good luck getting seagates to
remap, on my 3tb WD Red drive with bad sectors the drive does not seem
to remap them as easily.

So far I have a lot of repeat bad sectors, but only 1 has remapped,
even thought I am given the drive a lot of chances to remap the
sectors.

On Tue, Feb 6, 2018 at 4:02 PM, Marc MERLIN <marc@merlins.org> wrote:
> On Wed, Feb 07, 2018 at 08:51:15AM +1100, Adam Goryachev wrote:
>> I think instead of reading the sector from the drive and relying on the
>> drive to determine the correct data (it's already telling you it can't).
>
> Just on that point, it's not that simple. A drive will only try to read the
> data a few times before giving up and marking the sector as pending a
> re-write with new data (so that it can be re-mapped).
> You can however re-read it in different ways and sometimes get the data
> back, which _should_ then cause an immediate re-writing of the data on a new
> block and turn the pending into a reallocated block
> However, this does not seem to have happened on my drive, either because the
> bad data didn't really get read by hdparm --read-sector, or because the
> firmware isn't doing its remapping job, or something else I don't understand
>
>> What you need to do is find out where on md7 drive x sector y maps to
>> and read that sector from md7, which will get md to (possibly) notice
>> the read error, and then read the data from the other drives, and then
>> re-write the faulty sector with correct calculated data (or do the
>> resync on that area of md7 only).
>
> Yeah, I got that part.
>
>> So try setting something like 1287000000 * 4 as the start of the resync
>> up to 1288000000 * 4 and see if that finds and fixes it for you.
>>
>> If nothing else, it should finish fairly quickly. You might need to
>> start earlier, but you could just keep reducing the "window" until you
>> find the right spot. Or, someone who knows a lot more about this mapping
>> might jump in and answer the question, though they might need to see the
>> raid details to see the actual physical layout/order of drives/etc.
>
> I did however (indeed) miss that I can narrow the check range, so I'll try
> playing with that until I can narrow it down to the right bit.
>
> I'm still curious as to why the hdparm bit didn't work, but oh well at this
> point.
>
> Thanks,
> Marc
> --
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
