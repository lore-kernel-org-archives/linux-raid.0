From: "Sean Kormilo" <skormilo@nortelnetworks.com>
Subject: Re: Ways to query RAID status
Date: 14 Apr 2003 14:31:17 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1050345076.13718.51.camel@pcary03q.ca.nortel.com>
References: <05331901808F5A4CAEEAD68170C528282DF2CF@molokai.stoneflynetworks.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <05331901808F5A4CAEEAD68170C528282DF2CF@molokai.stoneflynetworks.com>
To: Vicky Gonzalez <vgonzalez@stoneflynetworks.com>
Cc: Linux-RAID mailinglist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

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
  

