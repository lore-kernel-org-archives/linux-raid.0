From: Steven Dake <sdake@mvista.com>
Subject: Re: Raid autodetection
Date: Tue, 03 Dec 2002 12:22:14 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3DED0466.2020707@mvista.com>
References: <Pine.LNX.4.44.0212031137001.20853-100000@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: danci@agenda.si
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Danci,

You can set a RAID to autostart by setting its partition id to 0xfd 
(RAID autostart) with the fdisk utility.  You could also use an initrd 
to scan the configuration file and start the RAID arrays.

The second is what most distributions do such as RedHat.

Thanks
-steve

danci@agenda.si wrote:

>Hi!
>
>Is there a tool to force the kernel to try auto-detecting RAID? I think I
>saw that SuSE has something like that implemented, so they can use it in
>initrd...
>
>Thanks, D.
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
>  
>

