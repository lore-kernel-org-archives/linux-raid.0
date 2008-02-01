From: aristizb@ualberta.ca
Subject: Linux md and iscsi problems
Date: Fri, 01 Feb 2008 11:59:19 -0700
Message-ID: <20080201115919.5qx4ih3zeogswc4w@webmail.ualberta.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello.

Currently I am working on a RAID-1 created using mdadm (version 2.6.2)  
with a local disc and a remote disc connected via iSCSI (open iscsi  
for the initiator and iscsi enterprise target).

I am testing the performance of the RAID writing data to the array  
disc having my target disc on a simulated link of 1 Mbps, I also  
defined my slow device as write-mostly and I am using the write-behind  
option so I can write with a decent speed without having to receive  
the ACK from the slow device.

My test constantly writes a file on the raid for around 20 minutes,  
but then the slow device is marked as faulty; I can recover the raid  
removing the device and adding it again, but the resynchronization  
process takes a long time (obviously because of the slow device).

Here is the message from the kernel when the slow disc fails:
sd 6:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT,SUGGEST_OK


Summarizing, I have two questions about the behavior of Linux md with  
slow devices:

1. Is it possible to modify some kind of time-out parameter on the  
mdadm tool so the slow device wouldn't be marked as faulty because of  
its slow performance.

2. Is it possible to control the "buffer" size of the RAID?, in other  
words, can I control the amount of data I can write to the local disc  
before I receive an acknowledgment from the slow device when I am  
using the write-behind option.


Any help is highly appreciated.

Thanks.


Juan Aristizabal.
