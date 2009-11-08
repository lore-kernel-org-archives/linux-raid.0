From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: RAID 6 Failure follow up
Date: Sun, 08 Nov 2009 08:56:34 -0600
Message-ID: <4AF6DC22.7010909@gmail.com>
References: <4AF6D0A9.6000901@gmail.com> <4AF6D461.3050109@gmail.com> <4AF6D786.6070505@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF6D786.6070505@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Dunn <andrew.g.dunn@gmail.com>
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Andrew Dunn wrote:
> [10:0:0:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sde
> [10:0:1:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdf
> [10:0:2:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdg
> [10:0:3:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdh
> [11:0:0:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdi
> [11:0:1:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdj
> [11:0:2:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdk
> [11:0:3:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdl
> [11:0:4:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdm
> 
> So 4 drives dropped out on the second controller. But why didnt sdm go
> with them?
> 
>

It is possible that by the time it got to checking the last drive that 
the errors had cleared up, so sdm was ok with it checked.


Is this on a port multiplier?


