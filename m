From: "Jason C. Leach" <jleach@ocis.net>
Subject: I/O Blocking
Date: Thu, 22 Jul 2004 09:29:09 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40FFEB55.2000905@ocis.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Both the RAID (Promise SuperTrak 6000) or the USB subsystems really 
drive the system load up. I'm using a AMD 3200+ system that is only a 
few months old with the 2.4.25 kernel.  When the I/O systems are 
blocking the system is very unresponsive. Some times samba will timeout, 
or I'll wait several seconds for commands like df, top, w and so on.

I am wondering if I were to use a dual CPU system, would this solve my 
I/O blocking problem?  Would one CPU tend to the I/O subsystem and the 
second would deal with other system requests I (samba, DB, LDAP, ...)?
