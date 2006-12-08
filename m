From: Jacob Schmidt Madsen <jacob@mungo.dk>
Subject: mdadm assemble question
Date: Fri, 8 Dec 2006 14:27:21 +0100
Message-ID: <200612081427.22117.jacob@mungo.dk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey,

I've added 2 new disks to an existing raid5 array and started the grow 
process.

The grow process was unsuccessfull because it stalled at 98.1% and the system 
log show a long list of "compute_blocknr: map not correct".

I'm not able to mount the array or stop it at all. The 'mount' command 
and 'mdadm' just stall in middle of their execution.

So now I want to recover as much data as possible, but its not possible since 
I cant read from the filesystem on the array, because 'mount' stall.

Now I want to assemble the array without starting the reshape process after 
rebooting, but I cant find this option in the manual of mdadm.
I'm suspecting the reshape process is the problem and thats why I dont want it 
to start.
I'm hoping it will be possible to use the array and read from it, if the 
reshape process it not started.

Am I just blind or is it not possible to start an array without starting the 
reshape process?

Thanks!
