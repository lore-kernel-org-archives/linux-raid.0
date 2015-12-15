From: "TheGerwazy ." <gerardlesiuk@gmail.com>
Subject: Re: Mdadm with data offsets
Date: Tue, 15 Dec 2015 12:30:03 +0100
Message-ID: <CAH_hVdqMdrPTAz1LcDzZNDMdGKFOpwo32mh0E+mFZtcCBEBqJg@mail.gmail.com>
References: <CAH_hVdp4mGE-AZ1ww81u9vS0xri4xR+LrpaRSbaUb6VRohZ_Rg@mail.gmail.com>
	<566E0440.70801@turmel.org>
	<566E05B2.20803@turmel.org>
	<CAH_hVdo43dSuaeJT-QGN14LhiRnR1zYVFwqvueV6vxthHYYU9g@mail.gmail.com>
	<566EBC38.7060205@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <566EBC38.7060205@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2015-12-14 13:55 GMT+01:00 Phil Turmel <philip@turmel.org>:
> On 12/14/2015 07:03 AM, TheGerwazy . wrote:
>
>> Hi  Phil
>> Thanks for the message .... but,
>> In the last version of mdadm I get:
>>
>> ./mdadm --create --raid-devices=8 --level=6 --assume-clean /dev/md7
>> /dev/mapper/ovsdb1:1024 /dev/mapper/ovsdc1:4096
>> /dev/mapper/ovsdd1:1024 /dev/mapper/ovsde1:1024
>> /dev/mapper/ovsdf1:1024 /dev/mapper/ovsdg1:1024
>> /dev/mapper/ovsdh1:1024 /dev/mapper/ovsdi1:4096
>> mdadm: cannot open /dev/mapper/ovsdb1:1024: No such file or directory
>
> The final version of that feature requires --data-offset=variable before
> the :offset syntax is recognized on the devices.
>
>> sudo ./mdadm --create --raid-devices=8 --level=6 --assume-clean
>
>> mdadm: array /dev/md7 started.
>
> You're committed now.  I hope it works out for you.
>
>> BTW is it possible to find right data offset without superblock on drive ?
>
> Only if the content of that member device has searchable content in a
> predictable location.  In practice that means finding the offset of the
> first member by locating filesystem magic, or otherwise locating the
> transition from all zeros to randomish data.
>
> Good luck.
>
> Phil
>

"Good Luck" seems to be working ... ;)

I finally recovered files with magic cmd:

sudo ./mdadm --create --raid-device=8 --level=6 --assume-clean
--size=974508544 /dev/md7 /dev/mapper/ovsde2:1024
/dev/mapper/ovsdh1:100352 /dev/mapper/ovsdg1:100352
/dev/mapper/ovsdc1:131072 /dev/mapper/ovsda1:1024
/dev/mapper/ovsdb1:1024 /dev/mapper/ovsdf1:131072
/dev/mapper/ovsdd1:100352


The main problem is the data offsets are not stored elsewhere than in
superblock. I have some drives from debian 6.0.5 and some were changed
in debian 7.5. In 6.0.5 default data offset was at 2048 sector while
int 7.5 it is 262144.

But - when add new drive to existing array and partition (or drive) is
smaller than 262144 plus array data (array device size) when mdadm
calculates something between 2048 and 262144. -> so as above magic
cmd's in my case it was 200704 sector.

I recovered it by doing all steps regarding mdadm in virtual
enviroment and I am surprised by the non standard data offsets.

Thanks for Phil

regards
Gerard
