From: Larkin Lowrey <llowrey@gmail.com>
Subject: Re: [PATCH 2/2] mdadm: remove journal with "remove-journal"
Date: Mon, 20 Nov 2017 11:04:37 -0500
Message-ID: <d0302f12-88bb-2997-9991-b05d59952aa8@gmail.com>
References: <63717f4b-5b81-7290-5265-087713f0bd45@nuclearwinter.com>
 <20170831175101.2965834-1-songliubraving@fb.com>
 <24a446c5-18bd-bcfe-02a4-ec569dc572a5@gmail.com>
 <DF9BC546-4C44-4468-8780-8782223043D2@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <DF9BC546-4C44-4468-8780-8782223043D2@fb.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "shli@kernel.org" <shli@kernel.org>, "jes.sorensen@gmail.com" <jes.sorensen@gmail.com>
List-Id: linux-raid.ids

On 11/16/2017 12:55 PM, Song Liu wrote:
>> On Nov 16, 2017, at 9:35 AM, Larkin Lowrey <llowrey@gmail.com> wrote:
>>
>> # mdadm /dev/md124 --fail /dev/md127p4
>> mdadm: set /dev/md127p4 faulty in /dev/md124
>>
>> # mdadm /dev/md124 --remove /dev/md127p4
>> mdadm: hot removed /dev/md127p4 from /dev/md124
>>
>> # cat /sys/block/md124/md/consistency_policy
>> journal
>>
>> # echo resync > /sys/block/md124/md/consistency_policy
>>
>> # cat /sys/block/md124/md/consistency_policy
>> resync
> Could you please try the following command here:
>
> echo active > /sys/block/md124/md/array_state
>
>
>> # mdadm --stop /dev/md124
>> mdadm: stopped /dev/md124
>>
>> # mdadm --assemble /dev/md124 /dev/md12[23] /dev/sd[goqpjfl]1
>> mdadm: Not safe to assemble with missing or stale journal device, consider --force.

This worked, thanks!

--Larkin
