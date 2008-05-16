From: Maurice Hilarius <maurice@harddata.com>
Subject: mdadm 2.6.5 compile issue
Date: Fri, 16 May 2008 15:56:23 -0600
Message-ID: <482E0307.9020302@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Having grabbed sources for mdadm 2.6.5, we tried 'mdassemble.static'
This does not really compile "as is" so it made for some head scratching moments.

If I use MDASSEMBLE_AUTO=1 with make, then mdassemble,  
or mdassemble.static - which is now the same thing,
does not link because sysfs.c is not on the list of mdassemble sources.

It apparently needs to be.  

This was not the case in the past.


-- 
Regards, Maurice

