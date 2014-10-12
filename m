From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Is it safe to shutdown while mdadm --grow is in progress.
Date: Sun, 12 Oct 2014 00:46:14 -0500
Message-ID: <543A15A6.5010508@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I googled this topic and got differing answers. Some old ones report 
horror stories and others suggest rebuild continues after reboot 
normally. My array is rebuilding and it will take about 6 days to 
complete. I am expecting bad weather in a couple of days and would like 
to proactively shutdown the machine and reboot. Is this safe?

If the information is already available in a clear manner, please let me 
know.

uname: Linux xxx 3.13.0-37-generic #64-Ubuntu SMP Mon Sep 22 21:28:38 
UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
mdadm - v3.2.5 - 18th May 2012

Thanks for your help

Ramesh

