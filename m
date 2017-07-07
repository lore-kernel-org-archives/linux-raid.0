From: Stan Hoeppner <stan@hardwarefreak.org>
Subject: Re: Linear device of two arrays
Date: Fri, 7 Jul 2017 17:52:41 -0500
Message-ID: <df053262-9334-1070-c24a-5d2f91402716@hardwarefreak.org>
References: <CALee7hZYgLNO2siDJNtFge_BoocTXX-9BSgRHmMJH8MaH6V3LA@mail.gmail.com>
 <20170705214250.0ea99538@natsu> <595D2ADA.8010907@youngman.org.uk>
 <CALee7hZqmLK19tSEEFBgSWMKm9TRoUqLBCxUmbNJpwmM45BjTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALee7hZqmLK19tSEEFBgSWMKm9TRoUqLBCxUmbNJpwmM45BjTQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: veljko3@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/07/2017 03:26 PM, Veljko wrote:
> I just noticed that I replied to Wol insted to list.
>
> On Wed, Jul 5, 2017 at 8:07 PM, Wols Lists <antlists@youngman.org.uk> wrote:
>> On 05/07/17 17:42, Roman Mamedov wrote:
>>> On Wed, 5 Jul 2017 17:34:09 +0200
>>> Veljko <veljko3@gmail.com> wrote:
>>>
>>>> Hello,
>>>>
>>>> I have a RAID10 device which I have formated using the mkfs.xfs
>>>> defaults (Stan helped me with this few years back). I reached 88%
>>>> capacity and it is time to expand it. I bought 4 more drives to create
>>>> another RIAD10 array. I would like to create linear device out of
>>>> those two and grow XFS across the 2nd device. How can this be done
>>>> without loosing the existing device's data? I would also like to add a
>>>> spare HDD. Do I have to have a separate spare HDD for each array or
>>>> one can be used by both of them?
>>> Why make another RAID10? With modern versions of mdadm and kernel you should
>>> be able to simply reshape the current RAID10 to increase the number of
>>> devices used from 4 to 8.
>>>
>>>
>> I was thinking of replying, but isn't that not possible for some
>> versions of RAID-10?
>>
>> My feeling was, if you can't just add drives to the existing raid 10,
>> create a new one which you can expand, migrate the fs across (btrfs
>> would let you do that live, I believe, so xfs probably can too), then
>> you can scrap the old raid-10 and add the drives into the new one.
>>
>> Cheers,
>> Wol
>
> Thanks for your input, Roman and Wol.
>
> Expanding existing RAID is one of the options, but I was advised by
> Stan Hoeppner to do it this way and I tend to believe him on this
> subject. With my metadata heavy backup workload, this will provide
> better performance.
>
> So my question is still, how can an existing array be added to linear
> device, and it's file system expanded over the second array.
For this to work the existing RAID10 array must already be a member of a 
linear device with one component device.  If this linear array already 
exists then you could add another RAID10 array to the linear device.  If 
you currently have an XFS filesystem sitting atop a 'bare' RAID10 then I 
don't believe the linear option will work for you.  Thus I'd tend to 
agree with others that reshaping your current RAID10 is the best option.

My apologies if I wasn't clear in my previous advice.

Stan


> And there is also question of spare drive.
>
> Regards,
> Veljko
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

