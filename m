From: Marek <mlf.conv@gmail.com>
Subject: Re: First 12Mb of data missing after accidental deletion of first
 drive (4 2TB raid5)
Date: Tue, 13 Oct 2015 16:50:00 +0200
Message-ID: <CA+sqOsYgZOPOdsJWaF_64wd4Z2u4td6CUj4XxLjr1NijFcoF-g@mail.gmail.com>
References: <CA+sqOsZSmYUDvwWu2MY-EpQyePGmT6wBjCCR5kKPEygKByD=Xw@mail.gmail.com>
	<CAETWcfvePZiUBiCY-cWMktQ=F7rckKt-7YDGa6PsiNt6j1ONGg@mail.gmail.com>
	<CA+sqOsaBm4jXrEpNyRMBoSMjE7f8MdAnq9Na3WcrLvVdAB7vSw@mail.gmail.com>
	<CAETWcfuS+ygi-FrFnCUdkwKyDY6zKwY8z4S9hRf0MwHFqwoJGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAETWcfuS+ygi-FrFnCUdkwKyDY6zKwY8z4S9hRf0MwHFqwoJGw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Afonyashin <a.afonyashin@madnet-team.ru>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

yes first 12Mb seem to be zeroed

On Tue, Oct 13, 2015 at 4:40 PM, Alexander Afonyashin
<a.afonyashin@madnet-team.ru> wrote:
> Hi,
>
> Does /proc/mdstat show that raid is ok? If so, why did you make an
> assumption that data of first 12MB are gone? Zeroed? Missed files on
> filesystem?
>
> Regards,
> Alexander
>
> On Tue, Oct 13, 2015 at 5:04 PM, Marek <mlf.conv@gmail.com> wrote:
>> no, i had a working raid consisting of 4 2TB drives (raid5)
>> sda,sdb,sdc,sdb ( no partitions were created on drives) - then i
>> accidentally deleted /dev/sda by installing ubuntu. when inspecting
>> dev/md127 with a hex editor i discovered first 12mb are missing.
>>
>> On Tue, Oct 13, 2015 at 3:53 PM, Alexander Afonyashin
>> <a.afonyashin@madnet-team.ru> wrote:
>>> Hi Marek,
>>>
>>> Do you mean you have files (on raid) that were used as loop devices?
>>>
>>> Regards,
>>> Alexander
>>>
>>> On Tue, Oct 13, 2015 at 4:44 PM, Marek <mlf.conv@gmail.com> wrote:
>>>> Hi,
>>>>
>>>> I'd like to ask about recovering partitions saved as images on eg a raid.
>>>> How do I recover such image - I tried to run test disk and it found
>>>> lots of images which I wasn't able to view via P (NFTS) and ext3
>>>> partitions but I'd like to save them to another harddrive, I tried
>>>> photo tree with only ext3 superblock and image file enabled but it
>>>> wouldn't find the partition in was looki for and found via testdisk.
>>>> What would you recommend me to do?
>>>>
>>>> Marek
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
