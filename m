From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: I/O Blocking
Date: Thu, 22 Jul 2004 14:37:30 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407221837.i6MIbU328251@watkins-home.com>
References: <410002F1.3050703@ocis.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <410002F1.3050703@ocis.net>
To: "'Jason C. Leach'" <jleach@ocis.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If your 1 CPU is 95% idle, it can do other "user requests".  But not if the
other "user requests" require disk I/O, they will also block regardless of
which CPU they are using.  I think there is a performance problem with your
disks.  But just a guess.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Jason C. Leach
Sent: Thursday, July 22, 2004 2:10 PM
To: Guy
Cc: linux-raid@vger.kernel.org
Subject: Re: I/O Blocking

Guy:

CPU load is very low (95-96% idle), load avg is 2. The system has 512MB 
RAM, some free and only a few megs swapped out.  If I was really working 
the RAID card I would get load avgs more like 2.5-3.  Right now just 
light USB and system usage and I am at 2.

I though if one CPU was tied up with the process that is blocking (using 
the RAID card), then the second would be free to deal with user 
requests. Or am I misunderstanding SMP and blocking I/O?

J.

Guy wrote:

>What is the CPU load like?  Are you at 100%?  If so a second CPU may help.
>If you are blocked on i/o it should not use much CPU, so my guess is your
>CPU load is very low, and a second CPU won't do much.  How much RAM do you
>have?  Are you swapping?
>
>Guy
>
>-----Original Message-----
>From: linux-raid-owner@vger.kernel.org
>[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Jason C. Leach
>Sent: Thursday, July 22, 2004 12:29 PM
>To: linux-raid@vger.kernel.org
>Subject: I/O Blocking
>
>Hi,
>
>Both the RAID (Promise SuperTrak 6000) or the USB subsystems really 
>drive the system load up. I'm using a AMD 3200+ system that is only a 
>few months old with the 2.4.25 kernel.  When the I/O systems are 
>blocking the system is very unresponsive. Some times samba will timeout, 
>or I'll wait several seconds for commands like df, top, w and so on.
>
>I am wondering if I were to use a dual CPU system, would this solve my 
>I/O blocking problem?  Would one CPU tend to the I/O subsystem and the 
>second would deal with other system requests I (samba, DB, LDAP, ...)?
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

