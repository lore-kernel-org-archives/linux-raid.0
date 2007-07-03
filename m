From: Michael Frotscher <infomails@tronserver.dyndns.org>
Subject: Re: RAID5 not being reassembled correctly after device swap
Date: Tue, 3 Jul 2007 21:20:25 +0200
Message-ID: <200707032120.25080.infomails@tronserver.dyndns.org>
References: <200707012321.48346.infomails@tronserver.dyndns.org> <200707031916.50502.infomails@tronserver.dyndns.org> <468A98D5.9090206@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <468A98D5.9090206@dgreaves.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi David,

> Do you have a mdman.conf file that specifies/limits partitions to search?

Just the usual "DEVICE partitons" followed by the ARRAY-lines. However, I 
don't think it's the mdadm.conf, rather the superblocks. Right now my main 
worry is my array which holds the root filesystem. The others I was able to 
resurrect (disks at their original ide ports) using the --update-option when 
assembling. As I cannot do that with the root array (didn't work when I 
booted off a CD), I'm a bit stuck.

When the system starts, it does not even bother to look for a third array 
component but starts the array degraded. I can then "mdadm -a" the third disk 
back into the array, it synchronizes and everything looks good. The same 
thing at the next boot.

Isn't there an option which updates all superblocks on an assembled array 
saying: you partitions are an array and stay an array until your superblock 
is erased or hell freezes over, whichever happens first. Amen.
-- 
YT,
Michael
