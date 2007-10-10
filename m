From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: How do i limit the bandwidth-usage while resyncing on RAID 1?
Date: Wed, 10 Oct 2007 17:15:36 +0200
Message-ID: <470CEC98.3050209@wpkg.org>
References: <735D322AED9CD711BE53000476917CD002972B92@NT-SERVER-5>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <735D322AED9CD711BE53000476917CD002972B92@NT-SERVER-5>
Sender: linux-raid-owner@vger.kernel.org
To: "Rustedt, Florian" <florian.rustedt@smartnet.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Rustedt, Florian schrieb:
> Hello List,
> 
> while resyncing, the process takes the whole bandwidth from disk to disk.
> 
> This leads in a VERY unhappy situation, because the system on this raid is
> unpractical slow now, because it has to wait for disk-io.
> 
> How can i tune this? I want somthing like "nice -n 19 dm-mirror" ;)

Look into sync_speed_min and sync_speed_max in /sys/block/mdX/md.


-- 
Tomasz Chmielewski
http://blog.wpkg.org
