From: Can Sar <csar@stanford.edu>
Subject: Write Order Restrictions
Date: Tue, 8 Mar 2005 00:59:11 -0800
Message-ID: <67694f3ccfa401a4523d7b2ed7a18e38@stanford.edu>
Mime-Version: 1.0 (Apple Message framework v619.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I work with a research teams that automatically checks file systems and 
block devices for bugs, and I have a question regarding the possible 
write orderings for Linux soft raid devices. From the code it seems 
that sync forces the block devices that make up a raid device to be 
synced one after the other.
However, for general writes, any type of ordering is possible, because 
the driver just cycles through all devices that make up a soft raid 
device and just calls generic_make_request on them. Is this correct, or 
does some other function involved in the write process (starting from 
the soft raid level down) actually wait on buffers to enforce 
restrictions that e.g. cause blocks for one disk to be written before 
those of another?

Thank you very much for any help and clarifications,
Can Sar

