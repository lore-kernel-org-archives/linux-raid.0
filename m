From: "Vicky Gonzalez" <vgonzalez@stoneflynetworks.com>
Subject: RE: Ways to query RAID status
Date: Mon, 14 Apr 2003 11:41:33 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <05331901808F5A4CAEEAD68170C528282DF2D0@molokai.stoneflynetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Sean Kormilo <skormilo@nortelnetworks.com>
Cc: Linux-RAID mailinglist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Sean,

you wrote:
>>It depends upon what you are trying to monitor, and how you are trying
to monitor it.>>

>>You have the following basic options:>>
>>1) /proc/mdstat>>
>>2) mdadm (from Neil Brown - should be many references to it on the
mailing list archives)>>
>>3) ioctl (if you want to query from a C program)>>

>>The ioctl interface is missing the ability to query raid rebuild status.
If that is something  which interests you, let me know as I created a
small patch to add a new ioctl to query raid rebuild information.>>

I am currently monitoring the /proc/mdstat file for the current status, i.e. if there was a Failure detected, if it is currently in the rebuild stage and if there is only one disk currently active, as well as if it is in a good state. This is being done from a perl daemon that is a System V startup process, but it can easily be moved to a C program. 

What some initial testing has found is that during the query of the mdstat file, it was preventing some of our other processes from running. The initial theory is that the opening/closing of the mdstat file to read it is the culprit. So I am looking into moving it to C and monitoring it via an ioctl call with the hopes of streamlining the status checking process. 

Where would I find the appropriate ioctl calls to make in my program? 

Thanks again Sean for the quick response.
~Vicky

