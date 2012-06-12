From: Asdo <asdo@shiftmail.org>
Subject: On mdadm 3.2 and bad-block-log
Date: Tue, 12 Jun 2012 18:51:25 +0200
Message-ID: <4FD7738D.3040403@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello
is it possible to keep mdadm 3.2 installed in the system (e.g. 3.2 as 
the monitoring daemon) and have an array with bad-block functionality 
(created with 3.3) running, or this will do a mess?

Bad-block functionality is in mdadm-3.3 but this has not been released 
yet. I was thinking about using it only once to create the array.

However I am still missing the manual for mdadm-3.3, where is that? 
without that I don't know how I should launch it to create an array with 
bad blocks.

Another question: are older kernels such as 3.0 capable to run an array 
created with bad-block-log, obviously without using the bad-block-log 
functionality? oh but that could be dangerous, couldn't it...

Thank you
A.
