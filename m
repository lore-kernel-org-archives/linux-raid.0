From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Linux and SSD and how to decrease io delay : question, please
Date: Tue, 04 Mar 2008 11:56:04 -0500
Message-ID: <47CD7F24.7090601@tmr.com>
References: <303475.18445.qm@web35709.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <303475.18445.qm@web35709.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mariella Petrini <mariellapetrini@yahoo.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


 > DanielMariella Petrini wrote:
> Hi,
>
> I have run a benchmark using the latest Linux kernel
> and having
> still the elevator set to noop (for each hard drive)
> and vm.dirty_expire_centisecs = 6000
>
> The system has 24GB of RAM, 2 SSD Mtron drives on a
> RAID controller.
> The databases are spread across two ext3 filesystems
> mounted on the SSD drives (one filesystem maps to one
> SSD drive and the other one to the other SSD drive.
> Each drive is seen as a single volume).
> The system has 2 cpus with 2 cores each.
>
>   
Have you mounted those filesystem with the "noatime" option? If you 
don't do that you risk causing a *lot* of unwanted seek and write 
activity to the journal.
> Before starting each benchmark the system has
> approximately 16GB of RAM already cached (so that most
> of the file reads are reduced)
>   

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


