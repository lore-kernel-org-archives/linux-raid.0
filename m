From: Thomas Garner <tlg1466@neo.tamu.edu>
Subject: Fibre Channel Shared Raid 5
Date: Sat, 27 Aug 2005 23:37:20 -0400
Message-ID: <43113170.9030509@neo.tamu.edu>
Reply-To: tlg1466@neo.tamu.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is it possible to take a group of fibre channel drives on a fc-al loop, 
run raid 5 on top of them, run lvm on top of that, then gfs on top of 
that, and have the entire thing readable/writable by multiple machines 
at the same time?  I have searched amongst lvm, clvm, evms, nbd, enbd, 
linux software raid, etc. but to no avail.  I assume that both clvm or 
evms would suit me to make the drives available to multiple machine 
concurrently, but not allow redundancy.  Hopefully I am wrong and this 
is in fact possible.

Thanks!
Thomas
