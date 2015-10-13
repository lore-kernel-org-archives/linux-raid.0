From: Marek <mlf.conv@gmail.com>
Subject: Re: First 12Mb of data missing after accidental deletion of first
 drive (4 2TB raid5)
Date: Tue, 13 Oct 2015 17:04:40 +0200
Message-ID: <CA+sqOsZ2E-VyPikjX8mNFjgE3UkuHQ_84y58myHj4JN9UvQo-g@mail.gmail.com>
References: <CA+sqOsZSmYUDvwWu2MY-EpQyePGmT6wBjCCR5kKPEygKByD=Xw@mail.gmail.com>
	<CAETWcfvePZiUBiCY-cWMktQ=F7rckKt-7YDGa6PsiNt6j1ONGg@mail.gmail.com>
	<CA+sqOsaBm4jXrEpNyRMBoSMjE7f8MdAnq9Na3WcrLvVdAB7vSw@mail.gmail.com>
	<CAFE24U28NQBoKaTwNfXb5-3jK8PDggfZMUnc7KJLUGbrCFS-Xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFE24U28NQBoKaTwNfXb5-3jK8PDggfZMUnc7KJLUGbrCFS-Xw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Weedy <weedy2887@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Alexander Afonyashin <a.afonyashin@madnet-team.ru>
List-Id: linux-raid.ids

Could it be that the raid wasnt synced at the time i overwrote
/dev/sda ? i have run the command you suggested and will report after
its done. would it still be possible to recover the raid?

On Tue, Oct 13, 2015 at 4:36 PM, Weedy <weedy2887@gmail.com> wrote:
>
> On 13 Oct 2015 10:06 am, "Marek" <mlf.conv@gmail.com> wrote:
>>
>> no, i had a working raid consisting of 4 2TB drives (raid5)
>> sda,sdb,sdc,sdb ( no partitions were created on drives) - then i
>> accidentally deleted /dev/sda by installing ubuntu. when inspecting
>> dev/md127 with a hex editor i discovered first 12mb are missing.
>
> Wait, if it's a raid5 can't you just resync it?
>
> Also I believe 1.2 metadata is at the end of a partition. If your saying the
> raids hasn't noticed you can run a check and it should fix itself.
>
> echo check > /sys/block/mdX/md/sync_action
