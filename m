From: Andrian Jardan <ajardan@tacitknowledge.com>
Subject: Software Raid and mismatch_cnt
Date: Thu, 12 Nov 2009 12:23:46 +0200
Message-ID: <4AFBE232.9090606@tacitknowledge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After the upgrade to CentOS 5.4, messages about mismatch_cnt != 0 
started to annoy us every week.

Hours of reading, and performing some simple test didn't get us to the 
answer we need.

Does this mean that our files may be corrupted by these mismatches ?

Looks like this is true, for raid1 arrays.

Can you please confirm, or better disagree, if it's the case.

Thank you in advance for your attention, and time.
