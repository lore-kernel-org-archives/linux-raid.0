From: Ric Wheeler <ric@emc.com>
Subject: Re: [PATCH 003 of 5] md: Change ENOTSUPP to EOPNOTSUPP
Date: Fri, 28 Apr 2006 12:48:37 -0400
Message-ID: <44524765.6070703@emc.com>
References: <20060428124313.29510.patches@notabene>	 <1060428025144.30770@suse.de> <62b0912f0604280634x7df2a8a5m9022826876446cb6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0604280634x7df2a8a5m9022826876446cb6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Molle Bestefich wrote:

> NeilBrown wrote:
>
>> Change ENOTSUPP to EOPNOTSUPP
>> Because that is what you get if a BIO_RW_BARRIER isn't supported !
>
>
> Dumb question, hope someone can answer it :).
>
> Does this mean that any version of MD up till now won't know that SATA
> disks does not support barriers, and therefore won't flush SATA disks
> and therefore I need to disable the disks's write cache if I want to
> be 100% sure that raid arrays are not corrupted?
>
> Or am I way off :-).
>
You are absolutely right - if you do not have a validated, working 
barrier for your low level devices (or a high end, battery backed array 
or JBOD), you should disable the write cache on your RAIDed partitions 
and on your normal file systems ;-)

There is working support for SCSI (or libata S-ATA) barrier operations 
in mainline, but they conflict with queue enable targets which ends up 
leaving queuing on and disabling the barriers.

ric

