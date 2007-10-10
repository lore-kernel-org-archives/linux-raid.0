From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: How do i limit the bandwidth-usage while resyncing on RAID 1?
Date: Thu, 11 Oct 2007 08:45:51 +1300
Message-ID: <470D2BEF.3040305@sauce.co.nz>
References: <735D322AED9CD711BE53000476917CD002972B92@NT-SERVER-5>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <735D322AED9CD711BE53000476917CD002972B92@NT-SERVER-5>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Rustedt, Florian wrote:

> How can i tune this? I want somthing like "nice -n 19 dm-mirror" ;)

Have a look at man rsync - the --bwlimit=KBPS option.

Regards,

Richard

