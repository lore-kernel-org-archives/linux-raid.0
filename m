From: Curtis J Blank <curt@curtronics.com>
Subject: Best way (only?) to setup SSD's for using TRIM
Date: Sun, 28 Oct 2012 13:59:22 -0500
Message-ID: <508D808A.7040100@curtronics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've got two new SSD's that I want to set up as RAID1 and use strictly 
for the OS and MySQL DB's partitioned accordingly.

I'll be using the 3.4.6 kernel for now in openSuSE 12.2 with ext4. So 
after a lot of Google'n and reading it is my understanding that discard 
is not sent to the devices via the raid drivers. I am aware of Shaohua 
Li's patches to make it work but am not inclined to use them due to 
openSuSE's Online Update replacing the kernel. I'm not against patching 
and gen'ing a kernel, that used to be SOP, but just don't want deal with 
that overhead. Of course unless I really need to.

So I've read, and if I understand things correctly, I can use LVM and 
RAID1 and the the discard commands will be sent to the devices. Is that 
correct and currently the only way or is/are there other ways?

I've also read that a lot of people are saying TRIM isn't needed because 
the SSD's garbage collection is so good now TRIM isn't needed. But I 
don't see how that could work because the SSD's don't have access to the 
file system so they don't know which pages in the blocks are marked 
unused to do any consolidation and erasing. And using TRIM is suggested 
in a OCZ document I read and who's drives these are. Unless, the SDD 
when it has to change a page moves the whole block then erases the old 
block? But without TRIM in could be moving invalid data too because it 
doesn't know that and that to me sure doesn't sound efficient and this 
operation would be a perfect time to get rid of the invalid data if it 
did know.

And due to PEC I'm wondering if this is even a good idea? Granted the OS 
files can be considered somewhat static, with the exception of /var/log 
so maybe that shouldn't go on the SSD, and maybe MySQL shouldn't either 
because for things like ZoneMinder it's DB is pretty dynamic. But with 
all the logging going on, and there is a lot, and the dynamic nature of 
the MySQL data is the exact reason I want it put it on SSD's, for the 
speed. See my quandary?

This is my best understanding of things right now so I came here to and 
am asking the experts for help in clarifying and  understanding this and 
pick the best direction to go. Have the SSD's for a couple of weeks now 
but holding off using them until the I can determine the best way to use 
them. Oh and the SSD's are OCZ Vertex 4 VTX4-25SAT3-256G.

Thanks.
