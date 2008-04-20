From: devzero@web.de
Subject: managing raid on linux
Date: Sun, 20 Apr 2008 23:51:41 +0200
Message-ID: <247041911@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello !

since we use lots of servers with raid where i work, for every system i need to go trough that hassle to find out, how to monitor the state of the raid array.

if you you have more than one brand of raid controller, you really need a large amount of time to find the proper tool for this, if you think you found it, then you have a broken link or the wrong version, the tool is outdated, doesn`t work with recent controller versions, is tricky to setup or difficult to use.

this takes a lot of time and is a major annoyance.

isn`t there a linux project which is adressing this?
some site for the sysadmin to consult?
i have raid controller xyz, what do i need to monitor the arrays state....?

i would expect, that the linux kernel would provide sort of a standardized way to check the health state of a raid array - i.e. this should be completely done in kernel space, as some raid drivers do.

instead i need to use a dozen different tools, which are often closed source, too.

anybody suffer from that headaches, too ?

regards
roland

_____________________________________________________________________
Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
http://smartsurfer.web.de/?mc=100071&distributionid=000000000066

