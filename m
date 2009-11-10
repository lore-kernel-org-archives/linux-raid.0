From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Re: RAID 6 Failure follow up
Date: Tue, 10 Nov 2009 07:45:50 -0500
Message-ID: <7d86ddb90911100445y16cc04d9m296ad532395daf44@mail.gmail.com>
References: <4AF6D0A9.6000901@gmail.com> <4AF6D5FD.2010602@gmail.com>
	 <4AF70791.9080007@sauce.co.nz> <4AF741A9.80701@gmail.com>
	 <4AF74D39.3000304@sauce.co.nz>
	 <7d86ddb90911081845j675818a2vec1a5bd26d542024@mail.gmail.com>
	 <20091109080910.GE18545@boogie.lpds.sztaki.hu>
	 <4AF7EA17.1030504@gmail.com>
	 <20091109113454.GB4492@boogie.lpds.sztaki.hu>
	 <4AF946B9.8040809@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF946B9.8040809@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Dunn <andrew.g.dunn@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Boot up a CentOS 5 LiveCD. It should detect your arrays and try
running smartctl. From my experience with different distros I have
found that Red Hat spends a good amount of time making sure enterprise
hardware is stable on their system. Ubuntu seems to focus more on
desktops.

Ryan

On Tue, Nov 10, 2009 at 5:55 AM, Andrew Dunn <andrew.g.dunn@gmail.com> wrote:
> I am able to reproduce this smart error now. I have done it twice, so
> maybe other things are causing this also.
>
> When I scanned the devices this morning with smartctl via webmin I lost
> 8 of the 9 drives. They are howerver still in my /dev folder.
>
> Now I sent out my logs from the first failure last night, smartctl was
> on the system... I dont know if ubuntu server's default smartd
> configuration makes it do periodic scans because I didnt change anything.
>
> I would hate to move back to 9.10 and see this problem again.
>
> Should I just not install smartmontools? This seems like a bad solution
> because now I wont be able to check the drives in advance for failures.
>
> Have you installed LSI's linux drivers? Some people say this solves
> their issue.
>
> From the logs sent out last night do you think it could be something else?
>
> Thanks a ton,
>
> Gabor Gombas wrote:
>> On Mon, Nov 09, 2009 at 05:08:23AM -0500, Andrew Dunn wrote:
>>
>>
>>> does it momentarily offline the disks? like they re-appear in /dev
>>> within moments? That would be similar behavior to what I am
>>> experiencing, the disks drop from the array, but they are in /dev by the
>>> time I get a chance to see them.
>>>
>>
>> No, either the disks need to be physically removed and re-inserted, or
>> the machine needs to be rebooted.
>>
>> Gabor
>>
>>
>
> --
> Andrew Dunn
> http://agdunn.net
>
>
