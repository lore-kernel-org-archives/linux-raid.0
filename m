From: Radovan Makovsky <radovan.makovsky@gmail.com>
Subject: It is possible to recover data after incorrect assemble of the RAID5?
Date: Thu, 10 Dec 2009 11:29:31 +0100
Message-ID: <4B20CD8B.1040809@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I did a silly mistake when i tried to assemble array back to the raid5 
with 3 drives in total.

What i did:

-I found some errors in smart. So i removed first disk from raid:

mdadm --fail /dev/md0 /dev/sda7
mdadm --remove /dev/md0 /dev/sda7

-Than i run badblocks with these parameters:

badblocks -svw /dev/sda                           

-Output of the command i never saw, but it should look like this:
     
Checking for bad blocks in read-write 
mode                                   
 From block 0 to 
65535                                                        
Testing with pattern 0xaa: 
done                                              
Reading and comparing: 0 0.00% done, 0:00 
elapsed                            
1                                                                             

2                  
.
.
65535
done
Testing with pattern 0x55: done
Reading and comparing: done
Testing with pattern 0xff: done
Reading and comparing: done
Testing with pattern 0x00: done
Reading and comparing: done
Pass completed, 65536 bad blocks found.

-During the test something happened and server crashed. I boot live cd 
for recovery.

-First i copied partition table from second disk to first disk.

-I tested following commands on test data and for mine shame they were 
successful on test data but not on live data:

|mdadm -Cv /dev/md0 -lraid5 -n3 /dev/sd[abc]7|

I do not understand how i could overlook assemble in documentation.

Question is. It is possible if i exactly know what was on the first disk 
in time of creation of array recover the data. If yes it is possible in 
human life? What tools can be used for this?

BR

Radovan
