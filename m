From: David Brown <david.brown@hesbynett.no>
Subject: Re: single cpu thread performance limit?
Date: Fri, 12 Aug 2011 11:04:31 +0200
Message-ID: <j22qav$bmf$1@dough.gmane.org>
References: <CAACGR8sSieD1MLCEnY0Wv24pHd9xpcJ=mhduwGMCqo5A5ttZpw@mail.gmail.com>	<4E44265D.3050809@hardwarefreak.com> <CAACGR8to9iybX+fJ_CGYBFgR6XtgPoqCt8kFA4mpqo4d1jEMqw@mail.gmail.com> <4E44340D.7060402@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E44340D.7060402@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/08/11 21:57, Joe Landman wrote:
> On 08/11/2011 03:37 PM, mark delfman wrote:
>
>
>> Whilst a R0 on top of the R1/10's does offer some increase in
>> performance, linear does not :(
>
> Linear makes no sense for distributing IO's among many devices. Linear
> is a concatenation.
>

If the real-world application involves parallel access to lots of 
different files, then XFS on a linear concatenation /will/ make sense, 
if your allocation groups match your concatenated devices.  It won't 
give you faster access to any of the files, but it will let you have 
fast access to several files at the same time.  Of course, YMMV 
according to the setup and application.

