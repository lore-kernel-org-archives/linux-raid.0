From: Luca Berra <bluca@comedia.it>
Subject: Re: Failed Hard Disk... help!
Date: Sat, 10 Jun 2006 07:42:29 +0200
Message-ID: <20060610054229.GC11250@percy.comedia.it>
References: <002801c68c1d$905a6020$7e0c10ac@enterprise.local> <448A07D6.70103@ucolick.org> <003701c68c1e$ad23f440$7e0c10ac@enterprise.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <003701c68c1e$ad23f440$7e0c10ac@enterprise.local>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jun 09, 2006 at 07:44:40PM -0400, David M. Strang wrote:
>/Patrick wrote:
>>pretty sure "smartctl -d ata -a /dev/sdwhatever" will tell you the
>>serial number. (Hopefully the kernel is new enough that it supports
>>SATA/smart, otherwise you need a kernel patch which won't be any 
>>better...)
>
>Yep... 2.6.15 or better... I need the magical patch =\.
>
>Any other options?
>
scsi_id from udev, if you are lucky enough

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
