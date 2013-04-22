From: Andrei Banu <andrei.banu@redhost.ro>
Subject: Re: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840
 PRO
Date: Mon, 22 Apr 2013 13:26:23 +0300
Message-ID: <21ba656fc34d77a018772f603ba5b75f@redhost.ro>
References: <5171CBF9.9020701@redhost.ro>
 <CAH3kUhEaZGON=fAyVMZOz5fH_DcfKv=hCa96UCeK4pN7k81c_Q@mail.gmail.com>
 <51725458.7020109@redhost.ro>
 <CAH3kUhHxBiqugFQm=PPJNNe9jOdKy0etUjQNsoDz_LJNUCLCCQ@mail.gmail.com>
 <51732422.1050109@redhost.ro> <5173536C.2040108@hardwarefreak.com>
 <CAGA4a+EMvLJMqufWjfmze9FZ_sDRBE0SCbOe0UYXRNOLU=DUTw@mail.gmail.com>
 <51743F14.7020404@hardwarefreak.com>
 <CAGA4a+Fsrum9vrtWbeKP4jWfT3JAAMK4Ci1HU6A2cMez1mwttw@mail.gmail.com>
 <517488B7.9030505@hardwarefreak.com>
 <CAGA4a+HS1EkQ0N1J0He25sWYeL6dhACO=zkVB6jSevZUUuOFBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGA4a+HS1EkQ0N1J0He25sWYeL6dhACO=zkVB6jSevZUUuOFBQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

No worries about the typo. I ran iostat -x -m 2 for a few minutes and I 
get:

- 0-500KB/s 70% of the time
- 1-2MB/s 20% of the time
- 3-4MB/s 10% of the time.

It never went beyond 4MB/s write speed. But I guess none of this 
qualifies as a heavy write. Right?

The fio test can be carried out safely on an active production server 
just as you gave it?

Thanks!
Andrei

On 2013-04-22 10:51, Tommy Apel wrote:
> Stan>
> That was exactly what I was trying to show, that you result may vary
> depending on data and backing device, as far as the raid1 goes it
> doesn't care much for the data beeing passed through it.
> 
> Ben>
> could you try to run iostat -x 2 for a few minuts just to make sure
> there is no other I/O going on the device before running your tests,
> and then run the tests with fio instead of dd ?
> 
> fio write test > fio --rw=write --filename=testfile --bs=1048576
> --size=4294967296 --ioengine=psync --end_fsync=1 --invalidate=1
> --direct=1 --name=writeperftest
> 
> /Tommy
> 
> 2013/4/22 Stan Hoeppner <stan@hardwarefreak.com>:
>> On 4/21/2013 2:56 PM, Tommy Apel wrote:
>>> Calm the f. down, I was just handing over some information, sorry 
>>> your
>>> day was ruined mr. high and mighty, use the info for whatever you 
>>> want
>>> to but flaming me is't going to help anyone.
>> 
>> Your tantrum aside, the Intel 330, as well as all current Intel SSDs,
>> uses the SandForce 2281 controller.  The SF2xxx series' write
>> performance is limited by the compressibility of the data.  What 
>> you're
>> doing below is simply showcasing the write bandwidth limitation of 
>> the
>> SF2xxx controllers with incompressible data.
>> 
>> This is not relevant to md.  And it's not relevant to Andrei.  It 
>> turns
>> out that the Samsung 840 SSDs have consistent throughput because they
>> don't rely on compression.
>> 
>> --
>> Stan
>> 
>> 
>>> 2013/4/21 Stan Hoeppner <stan@hardwarefreak.com>:
>>>> On 4/21/2013 7:23 AM, Tommy Apel wrote:
>>>>> Hello, FYI I'm getting ~68MB/s on two intel330 in RAID1 aswell on
>>>>> vanilla 3.8.8 and 3.9.0-rc3 when writing random data and ~236MB/s
>>>>> writing from /dev/zero
>>>>> 
>>>>> mdadm -C /dev/md0 -l 1 -n 2 --assume-clean --force --run /dev/sdb 
>>>>> /dev/sdc
>>>> 
>>>> 
>>>>> openssl enc -aes-128-ctr -pass pass:"$(dd if=/dev/urandom bs=128
>>>>> count=1 2>/dev/null | base64)" -nosalt < /dev/zero | pv -pterb >
>>>>> /run/fill ~1.06GB/s
>>>> 
>>>> What's the purpose of all of this?  Surely not simply to create 
>>>> random
>>>> data, which is accomplished much more easily.  Are you sand bagging 
>>>> us
>>>> here with a known bug, or simply trying to show off your mad 
>>>> skillz?
>>>> Either way this is entirely unnecessary for troubleshooting an IO
>>>> performance issue.  dd doesn't (shouldn't) care if the bits are 
>>>> random
>>>> or not, though the Intel SSD controller might, as well as other 
>>>> layers
>>>> you may have in your IO stack.  Keep it simple so we can isolate 
>>>> one
>>>> layer at a time.
>>>> 
>>>>> dd if=/run/fill of=/dev/null bs=1M count=1024 iflag=fullblock 
>>>>> ~5.7GB/s
>>>>> dd if=/run/fill of=/dev/md0 bs=1M count=1024 oflag=direct ~68MB/s
>>>>> dd if=/dev/zero of=/dev/md0 bs=1M count=1024 oflag=direct ~236MB/s
>>>> 
>>>> Noting the above, it's interesting that you omitted this test
>>>> 
>>>>   dd if=/run/fill of=/dev/sdb bs=1M count=1024 oflag=direct
>>>> 
>>>> preventing an apples to apples comparison between raw SSD device 
>>>> and
>>>> md/RAID1 performance with your uber random file as input.
>>>> 
>>>> --
>>>> Stan
>>>> 
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe 
>>> linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> 
>> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
