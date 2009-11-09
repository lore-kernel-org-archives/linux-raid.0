From: Andrew Dunn <andrew.g.dunn@gmail.com>
Subject: Re: RAID down, dont know why!
Date: Mon, 09 Nov 2009 17:03:37 -0500
Message-ID: <4AF891B9.708@gmail.com>
References: <4AF6CEFD.60309@gmail.com> <4AF6D099.5040407@scalableinformatics.com> <4AF6D0F8.80704@gmail.com> <4AF82DAC.4020307@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF82DAC.4020307@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: landman@scalableinformatics.com, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

/dev/sdm did not drop out, and it is on the same cable as sd[kl]

Maurice Hilarius wrote:
> Andrew Dunn wrote:
>> storrgie@ALEXANDRIA:~$ lsscsi  | grep sd[ijkl]
>> [11:0:0:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdi
>> [11:0:1:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdj
>> [11:0:2:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdk
>> [11:0:3:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdl
>>   
> Looks like cable got "jostled" and the 4 drives "dropped out" of the
> RAID,
> then it re-connected and now they show up as devs again.
>
>
>
> -- 
> With our best regards,
>
> /Maurice W. Hilarius         Telephone: 01-780-456-9771
> Hard Data Ltd.                FAX:          01-780-456-9772
> 11060 - 166 Avenue         email:maurice@harddata.com
> <mailto:email:maurice@harddata.com>
> Edmonton, AB, Canada      T5X 1Y3/
>

-- 
Andrew Dunn
http://agdunn.net

