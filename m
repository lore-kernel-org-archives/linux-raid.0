From: Ric Wheeler <ric@emc.com>
Subject: Re: Failed Hard Disk... help!
Date: Sat, 10 Jun 2006 08:37:23 -0400
Message-ID: <448ABD03.1020008@emc.com>
References: <002801c68c1d$905a6020$7e0c10ac@enterprise.local> <448A07D6.70103@ucolick.org> <003701c68c1e$ad23f440$7e0c10ac@enterprise.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <003701c68c1e$ad23f440$7e0c10ac@enterprise.local>
Sender: linux-raid-owner@vger.kernel.org
To: "David M. Strang" <dstrang@shellpower.net>
Cc: Patrik Jonsson <patrik@ucolick.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



David M. Strang wrote:

> /Patrick wrote:
>
>> pretty sure "smartctl -d ata -a /dev/sdwhatever" will tell you the
>> serial number. (Hopefully the kernel is new enough that it supports
>> SATA/smart, otherwise you need a kernel patch which won't be any 
>> better...)
>
>
> Yep... 2.6.15 or better... I need the magical patch =\.
>
> Any other options?
>
>
If you have an up dated copy of hdparm, you can use it against libata 
"SCSI" drives to get the serial number:

    # hdparm -V
    hdparm v5.7

    # hdparm -I /dev/sda


    /dev/sda:

    ATA device, with non-removable media
            Model Number:       Maxtor 7L320S0
            Serial Number:      L616D6YH
            Firmware Revision:  BACE1G70
    (and so on....)




