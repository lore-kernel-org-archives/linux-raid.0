From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID1 degraded
Date: Tue, 04 Aug 2015 09:48:35 +1000
Message-ID: <55BFFDD3.5000005@websitemanagers.com.au>
References: <AA2DC53A-A663-45CE-A8FE-DF6C8C285F37@me.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AA2DC53A-A663-45CE-A8FE-DF6C8C285F37@me.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hans Malissa <hmalissa@me.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/08/15 08:18, Hans Malissa wrote:
> Hi everybody,
>
> It looks like one of my disks in my RAID1 just failed:
>
> [SNIP]
>
> Are there any other tests I could run in order to figure out what=92s=
 going on? It looks like I will have to replace /dev/sdc1 with a new ha=
rd drive. What is the correct procedure to do so without loosing my dat=
a?
>
Have a look at dmesg or your system kernel logs for details.
Also, use smartctl to examine what the drive itself thinks.
Also, try to use dd to read/write the drive.

One common scenario is that you haven't configured the timing for the=20
drive correctly, and the drive is working perfectly, but didn't respond=
=20
to the kernel quickly enough. Research SCT/ERC on this list

Regards,
Adam
--=20
Adam Goryachev Website Managers www.websitemanagers.com.au
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
