From: "TheGerwazy ." <gerardlesiuk@gmail.com>
Subject: Re: Mdadm with data offsets
Date: Mon, 14 Dec 2015 13:03:00 +0100
Message-ID: <CAH_hVdo43dSuaeJT-QGN14LhiRnR1zYVFwqvueV6vxthHYYU9g@mail.gmail.com>
References: <CAH_hVdp4mGE-AZ1ww81u9vS0xri4xR+LrpaRSbaUb6VRohZ_Rg@mail.gmail.com>
	<566E0440.70801@turmel.org>
	<566E05B2.20803@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <566E05B2.20803@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2015-12-14 0:56 GMT+01:00 Phil Turmel <philip@turmel.org>:
> On 12/13/2015 06:50 PM, Phil Turmel wrote:
>> On 12/13/2015 01:18 AM, TheGerwazy . wrote:
>>> Hello
>>> I have to recreate mdadm raid 6 made with different data offsets. Some
>>> drives have 2048 and others 262144.
>>> I am looking for mdadm version with data offsets option for each drive.
>>> Could somebody help me. Please ?
>>
>> version 3.3 and above, I believe.  If in doubt, just compile the latest
>> version yourself -- no root privileges are required to compile it.  Then
>> run it from the current directory.
>>
>> git clone git://neil.brown.name/mdadm
>>
>> make
>> [sudo] ./mdadm ......
>
> I should add that using --create to reconstruct an array is incredibly
> dangerous (to your data) and should only be used as a last resort and
> when you are 100% confident you know how to do it.  Your question
> suggests that might not be true....  in which case sharing your problem
> here might be wise.
>
> Phil

Hi  Phil
Thanks for the message .... but,
In the last version of mdadm I get:

./mdadm --create --raid-devices=8 --level=6 --assume-clean /dev/md7
/dev/mapper/ovsdb1:1024 /dev/mapper/ovsdc1:4096
/dev/mapper/ovsdd1:1024 /dev/mapper/ovsde1:1024
/dev/mapper/ovsdf1:1024 /dev/mapper/ovsdg1:1024
/dev/mapper/ovsdh1:1024 /dev/mapper/ovsdi1:4096
mdadm: cannot open /dev/mapper/ovsdb1:1024: No such file or directory

but, There is branch data_offset of mdadm 3.2.5:

sudo ./mdadm --create --raid-devices=8 --level=6 --assume-clean
/dev/md7 /dev/mapper/ovsdb1 /dev/mapper/ovsdc1:4096
/dev/mapper/ovsdd1:1024 /dev/mapper/ovsde1:1024
/dev/mapper/ovsdf1:1024 /dev/mapper/ovsdg1:1024
/dev/mapper/ovsdh1:1024 /dev/mapper/ovsdi1:4096

dadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md7 started.

so it is exactly what I need :)

BTW is it possible to find right data offset without superblock on drive ?

Regards, Gerard
