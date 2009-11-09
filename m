From: Andrew Dunn <andrew.g.dunn@gmail.com>
Subject: Re: RAID 6 Failure follow up
Date: Mon, 09 Nov 2009 17:04:25 -0500
Message-ID: <4AF891E9.3030901@gmail.com>
References: <4AF6D0A9.6000901@gmail.com> <4AF6D461.3050109@gmail.com> <4AF6D5FD.2010602@gmail.com> <4AF70791.9080007@sauce.co.nz> <4AF741A9.80701@gmail.com> <4AF74D39.3000304@sauce.co.nz> <7d86ddb90911081845j675818a2vec1a5bd26d542024@mail.gmail.com> <20091109080910.GE18545@boogie.lpds.sztaki.hu> <4AF7EA17.1030504@gmail.com> <20091109113454.GB4492@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091109113454.GB4492@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: Ryan Wagoner <rswagoner@gmail.com>, Richard Scobie <richard@sauce.co.nz>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I am not experiencing this issue then. My devices are in /dev after the
raid drop out. I can use smart scanning on them without issue also.

Gabor Gombas wrote:
> On Mon, Nov 09, 2009 at 05:08:23AM -0500, Andrew Dunn wrote:
>
>   
>> does it momentarily offline the disks? like they re-appear in /dev
>> within moments? That would be similar behavior to what I am
>> experiencing, the disks drop from the array, but they are in /dev by the
>> time I get a chance to see them.
>>     
>
> No, either the disks need to be physically removed and re-inserted, or
> the machine needs to be rebooted.
>
> Gabor
>
>   

-- 
Andrew Dunn
http://agdunn.net

