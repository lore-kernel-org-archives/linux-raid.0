From: Roel Adriaans <roel@weetniksbeters.nl>
Subject: Disklayout Raid10
Date: Sun, 26 Feb 2006 10:29:41 +0100
Message-ID: <44017505.9050002@weetniksbeters.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I'm in the process of converting my raid-5 file server to an raid-10 
file server after some major
raid-5 problems..

Should I use the RAID-10 driver, or is it better to make separate raid-1 
arrays
and combine them into a raid-0 array?

My biggest concern is that I want to know where my data is. Is it 
possible with the
raid10 driver to show witch disk has what data? (It doesn't seem 
possible with mdadm?)


Roel Adriaans.
