From: Christopher Smith <csmith@nighthawkrad.net>
Subject: Problems with software RAID + iSCSI or GNBD
Date: Mon, 27 Jun 2005 12:42:42 +1000
Message-ID: <42BF67A2.6040601@nighthawkrad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm not sure if this is the correct list to be posting this to, but it 
is software RAID related, so if nothing else hopefully someone here can 
point me in the right direction.

I'm trying to roll my own SAN, but I've had mixed results thus far.  In 
my basic, initial setup I've created a configuration with two "disk 
nodes" and a single "concentrator node".  My objective is to have the 
"concentrator" take the physical disk exported from the "disk nodes" and 
  stitch it together into a RAID1.  So, it looks like this:

              "Concentrator"
                 /dev/md0
                  /     \
              GigE       GigE
                /         \
     "Disk node 1"       "Disk node 2"

So far I've tried using iSCSI and GNBD as the "back end" to make the 
disk space in the nodes visible to the concentrator.  I've had two 
problems, one unique to using iSCSI and the other common to both.


Problem 1: (Re)Sync performance is atrocious with iSCSI

If I use iSCSI as the back end, the RAID only builds at about 6 - 
7M/sec.  Once that is complete, however, performance is much better - 
reads around 100M/sec and writes around 50M/sec.  It's only during the 
sync the performance is awful.  It's not related to 
/proc/sys/dev/raid/speed_limit_max either, which I have set to 50M/sec. 
  Nor is it related to the sheer volume of traffic flying around, as if 
I use disktest to simultaneously read and write to both disk nodes, 
performance on all benchmarks only drops down to about 40 - 50M/sec.

If I switch the back end to GNBD, the resync speed is around 40 - 50M/sec.


Problem 2: The system doesn't deal with failure very well.

Once I got the RAID1 up and running, I tried to simulate a node failure 
by pulling the network cable from the node while disk activity was 
taking place.  I was hoping the concentrator would detect the "disk" had 
failed and simply drop it from the array (so it could later be simply 
re-added).  Unfortunately that doesn't appear to happen.  What does 
happen is that all IO to the md device "hangs" (eg: disktest throughput 
drops to 0M/sec), I am unable to either 'cat /prod/mdstat' to see the md 
device's status or use mdadm to manually fail the device - both simply 
result in the command "hanging".


Does anyone have any insight as to what might be causing these problems ?

Cheers,
CS
