From: Vincent Schut <schut@sarvision.nl>
Subject: Re: looking for advice on raid drives upgrade
Date: Thu, 31 Mar 2011 10:50:55 +0200
Message-ID: <in1f9f$47c$1@dough.gmane.org>
References: <imuu5b$gaf$1@dough.gmane.org> <imvadk$q8j$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <imvadk$q8j$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/30/2011 03:14 PM, David Brown wrote:
> On 30/03/2011 11:46, Vincent Schut wrote:
>> Hi all,
>>
>> one of my raid's is currently a raid5 with 4 1TB drives, which I'm going
>> to upgrade by replacing all drives with 2TB drives.
>> Main question: what is recommended:
>>
>> - offline the raid, dd(rescue) each 1TB drive onto a new 2TB one,
>> replace drives, put raid online again
>>
>> or:
>> - manually replace one drive at a time, and let the raid recover and
>> thus write the data onto the new drive?
>>
>> As far as I know all current drives are healthy; regularly SMART
>> monitoring and raid checks have not ringed any bells sofar.
>>
>> I guess offlining and dd-ing would be more secure, but I might miss
>> something and would like to hear other considerations from people more
>> experienced in this area.
>>
>> Regards,
>> Vincent Schut.
>>
>
>
> If you've got a spare drive slot, and plenty of time, there is another
> option that lets you keep online and redundant during the process.
> Re-shape the array to raid 6, while adding one of the new drives. Then
> you can replace each drive, one at a time, letting the raid recover in
> between. For the last drive, you just have to remove it then reshape
> back to raid 5 (although ideally you could buy an extra drive and keep
> the raid 6 layout - it's worth the cost, assuming you have the drive slot).
>
> Once everything is swapped over, you grow the array to fit the new disks.

Good thinking. I've asked for budget for one other drive and think I'll 
go the raid6 way.

Thanks for all the advice, everyone.

Vincent.

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>

