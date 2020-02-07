From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: Is it possible to break one full RAID-1 to two degraded RAID-1?
Date: Fri, 7 Feb 2020 08:49:17 -0600
Message-ID: <42332f03-4c16-5f8f-0e9e-a21ddedd4f5b@gmail.com>
References: <1120831b-13e6-6a5d-8908-ee6a312e7302@gmail.com>
 <aa41492c-1ad7-070f-9bc6-646977364758@thelounge.net>
 <2c4fedff-a1c9-6ca3-5385-72b542a4a0b4@gmail.com>
 <551449ed-49f9-e567-09d3-981f4cf9eea9@thelounge.net>
 <5E32855D.3020906@youngman.org.uk>
 <0c70c04f-d8d0-0c44-e603-46c101b21cc1@gmail.com>
 <5E3D2D9C.8020908@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5E3D2D9C.8020908@youngman.org.uk>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Reindl Harald <h.reindl@thelounge.net>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2/7/20 3:27 AM, Wols Lists wrote:
> On 07/02/20 07:02, Ram Ramesh wrote:
>> I got no response on this and want to take a shot before going the
>> backup way.
>>
>> Assuming (hda1 and hdb1 in raid1 md0) Will the following work?
>>
>> 1. Fail and remove hdb1
>> 2. Create new RAID1 md1 with hdb1 and missing
>> 3. dd md0 onto md1
> I wouldn't bother with any of the above. Just shut down and physically
> remove a LIVE disk. That now is your backup.
>
> In fact, this might be a good excuse to get a 3rd disk and either go
> raid 5 or use it for backups.

Wol, you forgot the history in this thread. I already said removing disk 
is no-no due to the way it is installed nvme with manual install of 
heatsync etc.

Also, I do not understand RAID5 statement. Not seem to be relevant to 
original idea. Also, I only have two nvme slots and no PCIE x4 left. May 
be you have some point that I am not understanding. Please elaborate, if 
you can.
>
>> 4. Make both bootable. (I suppose I need to change UUID of md1
>>     partitions. I suppose that is easy)
> Yes it's easy. Yes it should have been done a LOOONG time ago.
Not if you break md0 into degraded md0 and md1. grub.cfg need to be 
updated after that fact and UUID update is only doable after breakup. 
Again not sure if I am missing something important implied by LOONG in 
your answer.
>
>> 5. Boot both and double check
> They'll be degraded, so you might have to do a forced assembly to make
> them run ...
I converted from from single to raid1. So this process is already 
tested, but yes your point is well taken.
>> 6. Now upgrade md0 without fear.
>> 7. Boot and test the new system for a couple of days to make sure
>>     everything is fine.
>> 8. If that fails, delete md0, and add hda1 to md1. If not delete md1
>>     and add hdb1 to md0
> Yup.
>> Regards
>> Ramesh
>>
> Cheers,
> Wol
>
Thanks for taking the time. I just want to pass it by to make sure that 
I do not assume something and go to point of no return.

Regards
Ramesh
