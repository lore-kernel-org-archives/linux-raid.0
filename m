From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: I/O Blocking
Date: Thu, 22 Jul 2004 14:02:49 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407221802.i6MI2n328114@watkins-home.com>
References: <40FFEB55.2000905@ocis.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40FFEB55.2000905@ocis.net>
To: "'Jason C. Leach'" <jleach@ocis.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

What is the CPU load like?  Are you at 100%?  If so a second CPU may help.
If you are blocked on i/o it should not use much CPU, so my guess is your
CPU load is very low, and a second CPU won't do much.  How much RAM do you
have?  Are you swapping?

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Jason C. Leach
Sent: Thursday, July 22, 2004 12:29 PM
To: linux-raid@vger.kernel.org
Subject: I/O Blocking

Hi,

Both the RAID (Promise SuperTrak 6000) or the USB subsystems really 
drive the system load up. I'm using a AMD 3200+ system that is only a 
few months old with the 2.4.25 kernel.  When the I/O systems are 
blocking the system is very unresponsive. Some times samba will timeout, 
or I'll wait several seconds for commands like df, top, w and so on.

I am wondering if I were to use a dual CPU system, would this solve my 
I/O blocking problem?  Would one CPU tend to the I/O subsystem and the 
second would deal with other system requests I (samba, DB, LDAP, ...)?
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

