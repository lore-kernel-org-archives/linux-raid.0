From: MRK <mrk@shiftmail.org>
Subject: Re: stuck tasks
Date: Mon, 12 Apr 2010 13:06:06 +0200
Message-ID: <4BC2FE9E.9040802@shiftmail.org>
References: <hputbs$qq2$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <hputbs$qq2$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeremy Sanders <jeremy@jeremysanders.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/12/2010 12:40 PM, Jeremy Sanders wrote:
> Hi - I'm not getting any joy with Fedora's bugzilla. Has anyone seen
> problems like this with Fedora 12? Our systems have recently been getting
> stuck while rsyncing data onto an MD device:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=578549
>
>    

You need to lower the sync speed by catting a value into 
/sys/block/md{n}/md/sync_speed_max
the value should be about 1/3 lower than the max speed you see (cat 
/proc/mdstat) now that it's not yet limited.
Set up a script to set it at boot.

If it was not happening for you on older kernels might be a good sign: 
it might mean that the resync is faster now...

What is the sync speed you see (cat /proc/mdstat)? How many drives do 
you have and what type of raid is that?


