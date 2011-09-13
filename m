From: Andriano <chief000@gmail.com>
Subject: Re: RAID6 issues
Date: Tue, 13 Sep 2011 18:57:14 +1000
Message-ID: <CAGZH0-eAynK17a-B=x-pKHXpN8K+tDNb7cOYqa3M1ThhyvB=4g@mail.gmail.com>
References: <CAGZH0-dz9y5=vH7PQr8VRy15i1WsuAxKjPPpmx8-1UqCaJnRxg@mail.gmail.com>
	<20110913082511.3c34dec9@notabene.brown>
	<CAGZH0-fEU+NTdAF1AWcU6SnyBPYgd51zjizaiZT_toV=k4EDFg@mail.gmail.com>
	<20110913084419.380babcc@notabene.brown>
	<CAGZH0-fRTkKOL8ofLbChmNH3fuiYwHkC0LAv1-VVyb22O7UnwA@mail.gmail.com>
	<20110913093850.606efa70@notabene.brown>
	<CAGZH0-f+e80W36VMZMHrTakTxUHO2nppO9xHSTmHh6QV_Mo2Fg@mail.gmail.com>
	<20110913144424.64348c41@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110913144424.64348c41@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Sep 13, 2011 at 6:44 PM, Roman Mamedov <rm@romanrm.ru> wrote:
> On Tue, 13 Sep 2011 17:51:56 +1000
> Andriano <chief000@gmail.com> wrote:
>
>> Apparently you're right
>> blockdev --getsz /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg
>> /dev/sdh /dev/sdi /dev/sdj /dev/sdk
>> 3907027055
>> 3907027055
>> 3907029168
>> 3907029168
>> 3907029168
>> 3907029168
>> 3907027055
>> 3907029168
>> 3907029168
>> 3907029168
>>
>> sdb, sdc and sdh - are smaller and they are problem disks
>>
>> So what would be a solution to fix this issue?
>
> You mentioned you use Gigabyte EP35C-DS3 motherboard. Gigabyte BIOSes are known to cut off about 1 MByte or so from the end of HDDs (on the onboard controller, and maybe just the one on Port 0), setting an HPA area and storing a copy of the BIOS there. That's known as "(Virtual) Dual/Triple/Quad BIOS". Google for "gigabyte bios hpa" and you'll find a lot of reports about this problem. You can check if you can disable that "feature" in BIOS setup, but older boards did not have such option.
>
> To restore the native capacity of the drives you can use "hdparm -N" (see its man page), while disks are on the non-onboard controller.
>
> In the future, create your RAID from partitions, and leave 8-10 MB of space in the end of each disk for cases like these.
>
> --
> With respect,
> Roman
>

Roman,

Looks like you have pointed to the source of the problem. The option
to backup BIOS has been enabled.
Is "hdparm -N" going to affect superblock or data integrity of these
disks? Or has that backup already done the damage?

thanks

Andrew
