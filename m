From: Andrew Dunn <andrew.g.dunn@gmail.com>
Subject: Re: RAID 6 Failure follow up
Date: Mon, 09 Nov 2009 05:08:23 -0500
Message-ID: <4AF7EA17.1030504@gmail.com>
References: <4AF6D0A9.6000901@gmail.com> <4AF6D461.3050109@gmail.com> <4AF6D5FD.2010602@gmail.com> <4AF70791.9080007@sauce.co.nz> <4AF741A9.80701@gmail.com> <4AF74D39.3000304@sauce.co.nz> <7d86ddb90911081845j675818a2vec1a5bd26d542024@mail.gmail.com> <20091109080910.GE18545@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091109080910.GE18545@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: Ryan Wagoner <rswagoner@gmail.com>, Richard Scobie <richard@sauce.co.nz>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

does it momentarily offline the disks? like they re-appear in /dev
within moments? That would be similar behavior to what I am
experiencing, the disks drop from the array, but they are in /dev by the
time I get a chance to see them.

I am however not running smard to my knowledge, smartmontools is
installed and I access it through the webmin module, but checking the
drives with that and the array failures have not happened at the same time.

Gabor Gombas wrote:
> On Sun, Nov 08, 2009 at 09:45:40PM -0500, Ryan Wagoner wrote:
>
>   
>> This is interesting to hear as I have been using smartmontools on my
>> Supermicro LSI 1068E controller with the target firmware for 2 years
>> now on CentOS 5. I have 3 RAID 1 arrays across 2 drives, a RAID 5
>> drive across 3 drives, and a RAID 0 across 2 drives.
>>     
>
> [...]
>
>   
>> uname -r
>> 2.6.18-128.4.1.el5
>>     
>
> Kernel version matters. With 2.6.22 we only got occassional complaints
> that the drives are not capable of SMART checks that were not true but
> were otherwise harmless. With 2.6.26 and 2.6.30, the controller offlines
> the disks.
>
> Gabor
>
>   

-- 
Andrew Dunn
http://agdunn.net

