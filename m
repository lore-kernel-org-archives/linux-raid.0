From: "Vicky Gonzalez" <vgonzalez@stoneflynetworks.com>
Subject: RE: Ways to query RAID status - notification questions
Date: Wed, 30 Apr 2003 18:27:30 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <05331901808F5A4CAEEAD68170C528282DF2FA@molokai.stoneflynetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Sean Kormilo <skormilo@nortelnetworks.com>, Linux-RAID mailinglist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks again for all of your help Sean!

I thought I'd ask the rest of the folks here if there was a way for the MD driver to notify my process that something bad occurred or of a status change? So instead of me polling for status from the driver directly(using ioctls) or the mdadm(using ioctls & mdstat), can I register with the driver or and OS interrupt to catch something when changes occur?

Thanks!
~Vicky

-----Original Message-----
From: Sean Kormilo [mailto:skormilo@nortelnetworks.com]
Sent: Monday, April 14, 2003 11:31 AM
To: Vicky Gonzalez
Cc: Linux-RAID mailinglist
Subject: Re: Ways to query RAID status


Vicky,

It depends upon what you are trying to monitor, and how you are trying
to monitor it.

You have the following basic options:
1) /proc/mdstat
2) mdadm (from Neil Brown - should be many references to it on the
mailing list archives)
3) ioctl (if you want to query from a C program)

The ioctl interface is missing the ability to query raid rebuild status.
If that is something  which interests you, let me know as I created a
small patch to add a new ioctl to query raid rebuild information.

Sean. 


> 
> Are the other ways to query the status of the RAID other than from querying the /proc/mdstat file? If I should ask a different list or need to look through the archives first , could someone please point me in the right direction.
> 
> Many Thanks!
> ~Vicky 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 

Sean C. Kormilo, STORM Software Architect, Nortel Networks
              email: skormilo@nortelnetworks.com
  

