From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: AW: How do i limit the bandwidth-usage while resyncing on RAID  1?
Date: Fri, 12 Oct 2007 07:48:43 +1300
Message-ID: <470E700B.1060609@sauce.co.nz>
References: <735D322AED9CD711BE53000476917CD002972BB6@NT-SERVER-5>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <735D322AED9CD711BE53000476917CD002972BB6@NT-SERVER-5>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Rustedt, Florian wrote:
>  Hi Richard,
> 
> Seems to me, that you mussunderstood? There's no rsync in RAID afaik?
> This is an internal driver...?
> 

Hi Florian,

My mistake - I read "rsync" in the Subject of your mail instead of "resync".

Try "echo XXXXX > /sys/block/mdY/md/sync_speed_max"

where XXXXX is the speed you require in kB/s and Y is your md device.

Regards,

Richard
