From: Tommy Apel <tommyapeldk@gmail.com>
Subject: Re: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840 PRO
Date: Sun, 21 Apr 2013 21:56:43 +0200
Message-ID: <CAGA4a+Fsrum9vrtWbeKP4jWfT3JAAMK4Ci1HU6A2cMez1mwttw@mail.gmail.com>
References: <5171CBF9.9020701@redhost.ro>
	<CAH3kUhEaZGON=fAyVMZOz5fH_DcfKv=hCa96UCeK4pN7k81c_Q@mail.gmail.com>
	<51725458.7020109@redhost.ro>
	<CAH3kUhHxBiqugFQm=PPJNNe9jOdKy0etUjQNsoDz_LJNUCLCCQ@mail.gmail.com>
	<51732422.1050109@redhost.ro>
	<5173536C.2040108@hardwarefreak.com>
	<CAGA4a+EMvLJMqufWjfmze9FZ_sDRBE0SCbOe0UYXRNOLU=DUTw@mail.gmail.com>
	<51743F14.7020404@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51743F14.7020404@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Andrei Banu <andrei.banu@redhost.ro>, linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Calm the f. down, I was just handing over some information, sorry your
day was ruined mr. high and mighty, use the info for whatever you want
to but flaming me is't going to help anyone.

2013/4/21 Stan Hoeppner <stan@hardwarefreak.com>:
> On 4/21/2013 7:23 AM, Tommy Apel wrote:
>> Hello, FYI I'm getting ~68MB/s on two intel330 in RAID1 aswell on
>> vanilla 3.8.8 and 3.9.0-rc3 when writing random data and ~236MB/s
>> writing from /dev/zero
>>
>> mdadm -C /dev/md0 -l 1 -n 2 --assume-clean --force --run /dev/sdb /dev/sdc
>
>
>> openssl enc -aes-128-ctr -pass pass:"$(dd if=/dev/urandom bs=128
>> count=1 2>/dev/null | base64)" -nosalt < /dev/zero | pv -pterb >
>> /run/fill ~1.06GB/s
>
> What's the purpose of all of this?  Surely not simply to create random
> data, which is accomplished much more easily.  Are you sand bagging us
> here with a known bug, or simply trying to show off your mad skillz?
> Either way this is entirely unnecessary for troubleshooting an IO
> performance issue.  dd doesn't (shouldn't) care if the bits are random
> or not, though the Intel SSD controller might, as well as other layers
> you may have in your IO stack.  Keep it simple so we can isolate one
> layer at a time.
>
>> dd if=/run/fill of=/dev/null bs=1M count=1024 iflag=fullblock ~5.7GB/s
>> dd if=/run/fill of=/dev/md0 bs=1M count=1024 oflag=direct ~68MB/s
>> dd if=/dev/zero of=/dev/md0 bs=1M count=1024 oflag=direct ~236MB/s
>
> Noting the above, it's interesting that you omitted this test
>
>   dd if=/run/fill of=/dev/sdb bs=1M count=1024 oflag=direct
>
> preventing an apples to apples comparison between raw SSD device and
> md/RAID1 performance with your uber random file as input.
>
> --
> Stan
>
