From: AndrewL733 <AndrewL733@aol.com>
Subject: Assemble Same RAID0 More than Once?
Date: Sat, 02 Feb 2008 18:23:48 -0500
Message-ID: <47A4FB84.4070901@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is it possible to assemble the same Linux Software RAID0 array two or 
more times simultaneously? The idea would be to let one machine assemble 
the block devices with Read/Write Access and to let additional machines 
assemble the block devices with Read Only Access.

You might think this is a ridiculous question but I have discovered the 
following. If I:

    -- take a Server with two sets of 12 drives, each set connected to a
    Hardware RAID controller and configured as a RAID-5 Array
    -- export each 12-drive array as an individual iSCSI Target with IET
    or SCST
    -- connect the Targets to a Client machine and stripe them together
    as a Software RAID0 ON THE CLIENT MACHINE


I can get about 700 MB/sec writing to the Server and over 600 MB/sec 
reading -- with blockdev and other settings optimized. I'm talking about 
writing one stream of data and reading one stream back.

On the other hand, if I stripe the two Hardware RAID devices together ON 
THE SERVER and export them as a single Target, I only get about half the 
read and write performance on the Client.

Ideally, I would like to get to "Two Target Performance" with just "One 
Target" and I'm attacking this problem at the level of the iSCSI Target 
and Initiator software, as well as at the Network level. BUT if I can't 
solve it in any of these places, I'm wondering if there might be a way 
to Assemble the same Software RAID two or more times simultaneously.

Currently with the iSCSI Enterprise Target (and a couple of other Linux 
Targets), it is possible to allow one Client to connect to a target with 
Read/Write access and to give all other Clients Read Only Access. SO, if 
I create a Software RAID on the Server and export that as a Single 
Target, it is possible to give multiple users simultaneous access to the 
Target. However, as I said above, the performance is not optimal. '
'
If I create a Software RAID on the Client out of TWO targets, the 
performance is great. But now it seems much more complicated for two or 
more clients to access the data, because each client has to Assemble the 
Software RAID out of the same two Targets. And only one can have Write 
Access.

My question is, is it possible to Assemble a RAID if you can't write 
anything to the block device or touch its metadata (i.e., to mark that 
it is clean or dirty whatever gets written when the RAID is Assembled). 
In my first attempt to test this I tried making the Targets RO, but 
mdadm gave me a segmentation fault when I tried to Assemble the RAID0. 
And then when I made the Targets R/W again, one of them was missing its 
raid superblock and mdadm couldn't assemble it.

Alternately, is there a safe way to Assemble the same RAID 0 two or more 
times but only mount it R/W ONCE, and in all other instances mount it 
RO. What happens to the RAID metadata if you do that?


Andrew

-- 

EditShare -- The Smart Way to Edit Together
119 Braintree Street
Suite 402
Boston, MA 02134 
Tel:  +1 617.782.0479
Fax:  +1 617.782.1071

