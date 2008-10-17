From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID 0, disks swapped ?
Date: Fri, 17 Oct 2008 09:18:12 -0400
Message-ID: <48F89094.2080504@tmr.com>
References: <200810171318.12654.c.baegert-listes@lixium.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200810171318.12654.c.baegert-listes@lixium.fr>
Sender: linux-raid-owner@vger.kernel.org
To: c.baegert-listes@lixium.fr
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

c.baegert-listes@lixium.fr wrote:
> Hi,
>
> I had a RAID 10, crashed since a few days, made with a soft RAID 0 (/dev/md5) 
> of 2 soft RAID 1 (/dev/md3 and /dev/md4). I'm using default kernel on Debian 
> Etch.
>   

Just for educational purposes (won't help fix your problem), you had 
RAID 1+0 rather than RAID-10. See the mdadm docs for the difference. And 
reading old discussions here on the performance of RAID-10 with two far 
copies would be useful as well.

Sorry for your loss.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


