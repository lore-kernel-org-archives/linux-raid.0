From: "berk walker" <berk@panix.com>
Subject: Re: Migrating from SINGLE DISK to RAID1
Date: Tue, 01 Feb 2005 17:57:32 -0500
Message-ID: <opsljjd6o7v40d6c@berk.site>
References: <41FFD1F8.3010101@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <41FFD1F8.3010101@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Heinzmann <Robert.Heinzmann@gmx.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I seem to remember that one can create a degraded array.  Then copy over,  
and shoot the old disk and add it to the aray.
b-

On Tue, 01 Feb 2005 20:01:12 +0100, Robert Heinzmann  
<Robert.Heinzmann@gmx.net> wrote:

> Hello,
>
> can someone verify if the following statements are true ?
>
> - It's not possible to simply  convert a existing partition with a  
> filesystem on it to a raid1 mirror set.
>
> This may seem succesfull (filesystem can be mounted and must not be  
> checked), but it will cause data integrity problems. One of the last  
> Blocks of the device formaly used for file data will be used for the  
> raid superblock and so all data on this block will be not accessible  
> anymore.
>
> - Using a former disk of a raid1 array as a usual disk (not mounted as  
> degrated /dev/mdX, but instead mounted as /dev/sdX or /dev/hdX) is  
> successfull.
>
> This is because the MD device layer reports the device size as size of  
> disk - superblock offset during the creation of a filesystem on the MD  
> device. Thus the used size of the disk, when mounting it as /dev/sdX  
> /dev/hdX, is some KB smaller than it could be, but no data is lost.
>
> - Its always possible to use raid1 disks as regular disks (not taking  
> the md autodiscovery into concern). Using regular disks as raid disks  
> always requires data migration (new filesystem and copy).
>
> Thank you very much. I would really appreshiate some somments on this  
> one.
>
> Robert Heinzmann
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Using Opera's revolutionary e-mail client: http://www.opera.com/m2/
