From: Mircea Ciocan <mirceac@interplus.ro>
Subject: Re: Please help with a special RAID 1 setup
Date: Wed, 07 Jan 2004 15:23:30 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FFC0852.8060407@interplus.ro>
References: <3FFBDC7A.8020702@interplus.ro> <Pine.LNX.4.58.0401071413590.16314@hosting.rdsbv.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0401071413590.16314@hosting.rdsbv.ro>
To: Catalin BOIE <util@deuroconsult.ro>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Catalin BOIE wrote:

>>    Here are some relevant data of the test setup that may be usefull:
>>[root@test]# cat /etc/raidtab
>>raiddev /dev/md0
>>raid-level      1
>>nr-raid-disks   2
>>nr-spare-disks  0
>>chunk-size     4
>>persistent-superblock 1
>>device          /dev/sda2
>>raid-disk       0
>>device          /dev/sdb2
>>raid-disk       1
>>    
>>
>
>I think that you must replace:
>	nr-raid-disks   2
>with
>	nr-raid-disks   3
>Plus, the correspinding entry:
>	device          /dev/sdb3
>	raid-disk       2
>
>Else, the third drive isn't recognized as part of the md array.
>Probably, you must restart the array (only first time).
>You may want to use mdadm instead of raidtools.
>
>  
>

    Modified config file, umounted and stoped raid, restarted raid, 
hotadded the disk, still the same results :(.
Any other ideeas ??

    Mircea


