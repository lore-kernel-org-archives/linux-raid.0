From: Can Sar <csar@stanford.edu>
Subject: Recovery after Partial Writes
Date: Wed, 9 Mar 2005 03:06:19 -0800
Message-ID: <c161b9c916fd3b77f6dcee76f3ecf875@stanford.edu>
Mime-Version: 1.0 (Apple Message framework v619.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have another question regarding how softraid handles simple system 
crashes (no disk crash) for Raid Level 4-6.
Let's say that in a system with 5 disks we write one block, and the 
writes for disks 1-3 go through but those for disks 4-5 do not. When 
the computer restarts and the softraid device is remounted, is there 
some kind of recovery done at the raid level because the checksum for 
that block will now be off? Or is this simply left to the FS to deal 
with?

Thank you very much for your help,
Can Sar

