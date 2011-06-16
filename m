From: Mike Power <mpower@dodtsair.com>
Subject: mdadm and disk failures
Date: Wed, 15 Jun 2011 20:37:31 -0700
Message-ID: <4DF97A7B.1070901@dodtsair.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was looking around the wiki and I could not find the answer.

I wanted to know if the raid system will recover bad blocks lost on the 
one device when the copies of those blocks are available on another.  
 From what I understand when a hard drive loses a block it replaces it 
with another block but it can not recover the data.  At this point I do 
not know what the raid system does.  At one point in the past my 
understanding is, the raid system did nothing.  If it read from the disk 
that had the block it gets garbage for data.  Conceptually the raid 
system could read the data from one disk and write it to the copy on the 
other and restore the data.

Is the raid system capable of recovering and restoring bad blocks?

Mike Power
