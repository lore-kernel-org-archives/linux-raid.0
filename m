From: Rich <rich@pcfusion.co.uk>
Subject: LINEAR RAID, little help
Date: Sat, 07 Apr 2007 12:17:44 +0100
Message-ID: <46177DD8.9080707@pcfusion.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I currently have a linear RAID setup via mdadm with is made up of 3 
drives. I just have a few questions that I can't seem to find searching 
around on Google, etc.

First question, what happens if one drive fails (I know I will loose the 
data on that drive) but how, if at all can I recover the data on the 
other drives can I plug them in (on their own) as though they were in 
fact an individual drives? Do I need to execute a rebuild command in 
mdadm at all to rebuild the array?

Second question, how can I go about adding a drive to my linear RAID, I 
wish to add two new 500GB drives but I'm unsure how. I have found 
howto's for RAID 5 but I just wanted to check it was a similar process 
for Linear? Also this won't effect any data currently on the drive will it?


Thanks,

Richard

