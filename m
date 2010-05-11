From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Broken RAID1 boot arrays
Date: Tue, 11 May 2010 12:25:26 -0400
Message-ID: <4BE984F6.1000603@tmr.com>
References: <BE.8D.20763.249C8EB4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BE.8D.20763.249C8EB4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Leslie Rhorer wrote:
> 	On a related note, does anyone know of a good Linux Live CD which
> enables both network operations (especially telnetd and ftpd) along with
> mdadm?  I have a couple of Live CDs on hand, but they don't support mdadm or
> remote access.  This is a headless system, and I really can't effectively
> work with a local console, plus I need to mount the /boot array in order to
> properly edit the initrd.  I suppose I could mount the drive as a non-array
> and then force a sync to the second drive, but I'd rather not. 
>
>   
Fedora disks can be booted in rescue mode.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

