From: Laurent CARON <lcaron@apartia.fr>
Subject: Re: Setting up a RAID 10 under RedHat 9
Date: Fri, 13 Aug 2004 16:07:24 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <411CCB1C.6090808@apartia.fr>
References: <000201c47ffb$9cd59b60$cd03a8c0@archnet2.atgsd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000201c47ffb$9cd59b60$cd03a8c0@archnet2.atgsd.com>
To: aboster <aboster@at-sd.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

aboster wrote:

>I have a functional RAID 10 on a Red Hat 9 server.  It's very basic:
>(A with RAID 1 mirror A') concatenated in RAID 0 with (B with RAID 1 mirror
>B'))
>
>During boot, the system finds the RAID1 mirrors but not the RAID0 concat of
>them.
>I can have the system start the RAID 0 with a line in the rc.local script
>easily enough, but it seems to me that there should be a more graceful way
>of doing this.  What am I missing?  In the conf files, I have the RAID1
>mirrors listed first already - that alone doesn't do it.  It's as if there
>really needs to be a second auto-discovery pass.
>
>Alex
>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  
>
what is the type of your partitions?
fd?
