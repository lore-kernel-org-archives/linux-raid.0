From: Joe Landman <landman@scalableinformatics.com>
Subject: Re: Any hope for a 27 disk RAID6+1HS array with four disks reporting
 "No md superblock detected"?
Date: Wed, 04 Feb 2009 15:50:03 -0500
Message-ID: <4989FF7B.6030503@scalableinformatics.com>
References: <1233775657.10151.5.camel@localhost.localdomain>
Reply-To: landman@scalableinformatics.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1233775657.10151.5.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: tjb@unh.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thomas J. Baker wrote:
> Any help greately appreciated. Here are the details:
> 
> [root@node002 ~]# ./examineRAIDDisks 
> mdadm -E /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1 /dev/sdm1 /dev/sdn1 /dev/sdo1 /dev/sdp1 /dev/sdq1 /dev/sdr1 /dev/sds1 /dev/sdt1 /dev/sdu1 /dev/sdv1 /dev/sdw1 /dev/sdx1 /dev/sdy1 /dev/sdz1 /dev/sdaa1 /dev/sdab1 /dev/sdac1
> /dev/sdb1:
>           Magic : a92b4efc
>         Version : 00.90.00

Hi Thomas:

   Don't you need 1.0 or higher superblocks to make this work?

Joe



-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics LLC,
email: landman@scalableinformatics.com
web  : http://www.scalableinformatics.com
        http://jackrabbit.scalableinformatics.com
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
