From: Joachim Achtzehnter <joachima@netacquire.com>
Subject: Reasons why mdmon is not starting?
Date: Fri, 09 Dec 2011 12:05:48 -0800
Message-ID: <4EE26A1C.3040109@netacquire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

When trying to understand why an existing Intel RAID1 volume always ends 
up in read-only state during a Debian installation attempt I saw from 
various posts on mailing lists that this is likely because mdmon isn't 
running. What possible reasons cause mdmon to exit?

I've tried several installation images and some have old versions of 
mdadm, which explains the problem for those cases, but I've also tried a 
recent live CD with the latest version (3.2.2), and I've tried starting 
the array manually, also with the latest version of mdadm/mdmon 
installed in /sbin. Somehow, mdmon either doesn't get started by mdadm 
or it exits prematurely without any indication of reasons in syslog.

When I try to start mdmon in a console it immediately exits without any 
message. What might be causing this? Any suggestions what to try?

Thanks,

Joachim


-- 
work:	joachima@netacquire.com		http://www.netacquire.com
home:	joachim@kraut.ca		http://www.kraut.ca
