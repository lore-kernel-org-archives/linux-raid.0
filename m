From: Steven Dake <sdake@mvista.com>
Subject: Re: raid0 to raid1
Date: Thu, 04 Sep 2003 13:45:04 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1062708304.25969.93.camel@persist.az.mvista.com>
References: <005f01c371dd$12f0fc00$2101a8c0@newhonest.com>
Reply-To: sdake@mvista.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <005f01c371dd$12f0fc00$2101a8c0@newhonest.com>
To: pg <pg@newhonest.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

reload the server
or backup and restore after changing disk layout
there is no online way to fix this problem
thanks
-steve
On Tue, 2003-09-02 at 22:34, pg wrote:
> Excuse me for asking the question again, because my last question has not
> been answered.
> 
> I have two scsi hd of same geometry : 36G
> I want to have
> sda1 sdb1 map to /boot by raid1
> sda2 sdb2 map to /     by raid1
> 
> Unfortunately, I wrongly formated sda2+sdb2 to raid0, and the error was
> discovered a few weeks after the server has been put into production.
> 
> So my problem is how can I use minimum time to convert the raid0 back to
> radi1 safely?
> 
> 
> 
> -Jason
> 
> ps The usage of sda2+sdb2 is less than 10G at the present moment
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

