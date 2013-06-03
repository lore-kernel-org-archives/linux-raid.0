From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: RAID-10 keeps aborting
Date: Sun, 2 Jun 2013 23:14:45 -0700
Message-ID: <CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com>
References: <51AC1440.7020505@zytor.com>
	<CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com>
	<51AC3283.4000403@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51AC3283.4000403@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Jun 2, 2013 at 11:06 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/02/2013 10:47 PM, Dan Williams wrote:
>>
>> One hack to prove this may be to explicitly disable write_same before
>> the array is assembled:
>>
>> for i in /sys/class/scsi_disk/*/max_write_same_blocks; do echo 0 > $i; done
>>
>> If this works then maybe md needs to be tolerant of write_same
>> failures since the block layer will simply retry with zeroes.
>>
>
> Trying that (array is already assembled but is currently functional.)
> Let's hope it works.
>

If I'm reading things correctly that may still result in failure since
md will still pass the REQ_WRITE_SAME bios down to the the devices and
will receive BLK_PREP_KILL for its trouble.  md only notices that
write same is disabled on underlying devices at assembly time.
