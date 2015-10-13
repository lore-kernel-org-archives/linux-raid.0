From: Marek <mlf.conv@gmail.com>
Subject: Re: First 12Mb of data missing after accidental deletion of first
 drive (4 2TB raid5)
Date: Tue, 13 Oct 2015 16:04:10 +0200
Message-ID: <CA+sqOsaBm4jXrEpNyRMBoSMjE7f8MdAnq9Na3WcrLvVdAB7vSw@mail.gmail.com>
References: <CA+sqOsZSmYUDvwWu2MY-EpQyePGmT6wBjCCR5kKPEygKByD=Xw@mail.gmail.com>
	<CAETWcfvePZiUBiCY-cWMktQ=F7rckKt-7YDGa6PsiNt6j1ONGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAETWcfvePZiUBiCY-cWMktQ=F7rckKt-7YDGa6PsiNt6j1ONGg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Afonyashin <a.afonyashin@madnet-team.ru>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

no, i had a working raid consisting of 4 2TB drives (raid5)
sda,sdb,sdc,sdb ( no partitions were created on drives) - then i
accidentally deleted /dev/sda by installing ubuntu. when inspecting
dev/md127 with a hex editor i discovered first 12mb are missing.

On Tue, Oct 13, 2015 at 3:53 PM, Alexander Afonyashin
<a.afonyashin@madnet-team.ru> wrote:
> Hi Marek,
>
> Do you mean you have files (on raid) that were used as loop devices?
>
> Regards,
> Alexander
>
> On Tue, Oct 13, 2015 at 4:44 PM, Marek <mlf.conv@gmail.com> wrote:
>> Hi,
>>
>> I'd like to ask about recovering partitions saved as images on eg a raid.
>> How do I recover such image - I tried to run test disk and it found
>> lots of images which I wasn't able to view via P (NFTS) and ext3
>> partitions but I'd like to save them to another harddrive, I tried
>> photo tree with only ext3 superblock and image file enabled but it
>> wouldn't find the partition in was looki for and found via testdisk.
>> What would you recommend me to do?
>>
>> Marek
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
