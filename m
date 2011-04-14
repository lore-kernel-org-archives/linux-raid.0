From: David Brown <david@westcontrol.com>
Subject: Re: Resync intermittently writes to spare drives, waking them up
Date: Thu, 14 Apr 2011 10:32:53 +0200
Message-ID: <io6bc0$6ol$1@dough.gmane.org>
References: <BANLkTikqAaS91n06Xw7SwWcMKik_8E0iHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTikqAaS91n06Xw7SwWcMKik_8E0iHA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13/04/2011 23:10, Rory Jaffe wrote:
> I have a RAID5 array with 4 active devices and two spares. The spares
> are normally in sleep mode. I ran a resync with:
>
> echo repair>  /sys/devices/virtual/block/md0/md/sync_action
>
> About 20 times (evenly spaced apart) during the resync, the spares
> were written to, waking them up. Is that behavior desired? It seems to
> me that it's a waste--I don't know why the resync would bother with
> the spares.
>

This isn't an answer to your question, but I would recommend changing to 
a raid 6 with 5 devices and one spare.  Raid 6 gives you /much/ better 
reliability - you can thing of it as Raid 5 + hot spare with the hot 
spare already synchronised.


