From: "Jim Buttafuoco" <jim@contactbda.com>
Subject: Re: failed raid 5 array
Date: Fri, 10 Sep 2004 09:03:58 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040910130306.M40329@contactbda.com>
References: <20040910122914.M88134@contactbda.com>
Reply-To: jim@contactbda.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040910122914.M88134@contactbda.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I fixed this by following the instructions in the Software Raid Howto.  

Sorry for the panic.
Jim



---------- Original Message -----------
From: "Jim Buttafuoco" <jim@contactbda.com>
To: linux-raid@vger.kernel.org
Sent: Fri, 10 Sep 2004 08:31:55 -0400
Subject: failed raid 5 array

> HELP.
> 
> I have a failed raid 5 array.  What happend is hde failed yesterday (system hung). This morning it was 
> replaced.  After about 10 minutes of the rebuild, hdg failed and the system hung.
> 
> Is there any way to recover my array?
> 
> Thanks
> Jim
> 
> Here is my /etc/raidtab file
> 
>      raiddev /dev/md0
>            raid-level              5
>            nr-raid-disks           4
>            nr-spare-disks          0
>            persistent-superblock   1
>            parity-algorithm        left-symmetric
>           chunk-size               128k
>            device                  /dev/hde1
>            raid-disk               0
>            device                  /dev/hdg1
>            raid-disk               1
>            device                  /dev/hdi1
>            raid-disk               2
>            device                  /dev/hdk1
>            raid-disk               3
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
------- End of Original Message -------

