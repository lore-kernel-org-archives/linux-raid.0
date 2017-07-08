From: Veljko <veljko3@gmail.com>
Subject: Re: Linear device of two arrays
Date: Sat, 8 Jul 2017 12:26:23 +0200
Message-ID: <CALee7haowPD0DKPtEQUN8M8LDCNOq62SDrk5VNMO5C+5iUqtrQ@mail.gmail.com>
References: <CALee7hZYgLNO2siDJNtFge_BoocTXX-9BSgRHmMJH8MaH6V3LA@mail.gmail.com>
 <20170705214250.0ea99538@natsu> <595D2ADA.8010907@youngman.org.uk>
 <CALee7hZqmLK19tSEEFBgSWMKm9TRoUqLBCxUmbNJpwmM45BjTQ@mail.gmail.com> <df053262-9334-1070-c24a-5d2f91402716@hardwarefreak.org>
Reply-To: veljko3@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <df053262-9334-1070-c24a-5d2f91402716@hardwarefreak.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jul 8, 2017 at 12:52 AM, Stan Hoeppner <stan@hardwarefreak.org> wrote:
> On 07/07/2017 03:26 PM, Veljko wrote:
>>
>> I just noticed that I replied to Wol insted to list.
>>
>> On Wed, Jul 5, 2017 at 8:07 PM, Wols Lists <antlists@youngman.org.uk>
>> wrote:
>>>
>>> On 05/07/17 17:42, Roman Mamedov wrote:
>>>>
>>>> On Wed, 5 Jul 2017 17:34:09 +0200
>>>> Veljko <veljko3@gmail.com> wrote:
>>>>
>>>>> Hello,
>>>>>
>>>>> I have a RAID10 device which I have formated using the mkfs.xfs
>>>>> defaults (Stan helped me with this few years back). I reached 88%
>>>>> capacity and it is time to expand it. I bought 4 more drives to create
>>>>> another RIAD10 array. I would like to create linear device out of
>>>>> those two and grow XFS across the 2nd device. How can this be done
>>>>> without loosing the existing device's data? I would also like to add a
>>>>> spare HDD. Do I have to have a separate spare HDD for each array or
>>>>> one can be used by both of them?
>>>>
>>>> Why make another RAID10? With modern versions of mdadm and kernel you
>>>> should
>>>> be able to simply reshape the current RAID10 to increase the number of
>>>> devices used from 4 to 8.
>>>>
>>>>
>>> I was thinking of replying, but isn't that not possible for some
>>> versions of RAID-10?
>>>
>>> My feeling was, if you can't just add drives to the existing raid 10,
>>> create a new one which you can expand, migrate the fs across (btrfs
>>> would let you do that live, I believe, so xfs probably can too), then
>>> you can scrap the old raid-10 and add the drives into the new one.
>>>
>>> Cheers,
>>> Wol
>>
>>
>> Thanks for your input, Roman and Wol.
>>
>> Expanding existing RAID is one of the options, but I was advised by
>> Stan Hoeppner to do it this way and I tend to believe him on this
>> subject. With my metadata heavy backup workload, this will provide
>> better performance.
>>
>> So my question is still, how can an existing array be added to linear
>> device, and it's file system expanded over the second array.
>
> For this to work the existing RAID10 array must already be a member of a
> linear device with one component device.  If this linear array already
> exists then you could add another RAID10 array to the linear device.  If you
> currently have an XFS filesystem sitting atop a 'bare' RAID10 then I don't
> believe the linear option will work for you.  Thus I'd tend to agree with
> others that reshaping your current RAID10 is the best option.
>
> My apologies if I wasn't clear in my previous advice.
>
> Stan

Here is your previous advice:
"Do not use LVM.  Directly format the RAID10 device using the mkfs.xfs
defaults.  mkfs.xfs will read the md configuration and automatically
align the filesystem to the stripe width.

When the filesystem reaches 85% capacity, add 4 more drives and create
another RAID10 array.  At that point we'll teach you how to create a
linear device of the two arrays and grow XFS across the 2nd array."

From this I concluded that it is possible to create linear device
using existing array, but since it is not the case, I'll just have to
create new array, move data to it, than add first array to a new
linear device (1 member), copy my data to it, and than join second
device to it. I wanted to avoid all this copying but will have to do
it. Than I will add one drive to spare-group both arrays will be a
members of, as advised by Andreas. Does this sound OK?

Regards,
Veljko
