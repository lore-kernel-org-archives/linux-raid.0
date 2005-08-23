From: John McMonagle <johnm@advocap.org>
Subject: Re: RAID10 vs. LVM on RAID1
Date: Tue, 23 Aug 2005 10:47:02 -0500
Message-ID: <430B44F6.4000300@advocap.org>
References: <20050822213100.GA6165@anthropohedron.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050822213100.GA6165@anthropohedron.net>
Sender: linux-raid-owner@vger.kernel.org
To: gsslist+linuxraid@anthropohedron.net
Cc: Linux RAID list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I did lvm over 2 raid 1 arrays recently.

Running dd on the lv gives about 3 times  the  drive speed.
Should be 4 times .
I hate to give up performance but I'm willing to live with it as lvm 
makes disk management so much easier.

John
 




Gregory Seidman wrote:

>Is there any advantage to RAID10 over creating an LVM volume group across
>the same number of RAID1 pairs? LVM does striping, after all. Am I
>overlooking something?
>
>--Greg
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  
>

