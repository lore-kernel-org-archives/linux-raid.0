From: Matthew Ingersoll <matth@digitalwest.net>
Subject: active/active raid0
Date: Fri, 16 Oct 2009 09:21:33 -0700
Message-ID: <213B643B-ECBF-45E7-BC74-299766082AF8@digitalwest.net>
References: <1255588866-4133-1-git-send-email-Vishnu@freescale.com> <e9c3a7c20910151825o67cd2712id91aead70f84987c@mail.gmail.com> <20091016153334.GA27401@ovro.caltech.edu>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091016153334.GA27401@ovro.caltech.edu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm testing an active/active setup that uses md for raid0 and was  
hoping for some feedback.
The basic design has a storage device that runs vladed (aoe-storage)  
and an aoe initiator (controller) that creates a raid0 using mdadm  
from the aoe devices.  From there, lvm (clustered/clvm) slices out  
storage for sharing block devices.  I don't want to concentrate on the  
layers above that (clustered file systems, etc) but mainly the active/ 
active portion of this interacting with raid0 (via md not lvm) and aoe.

Some diagrams that may help in understanding...
-----
"Physical" diagram:

(export network block devices [ iscsi, aoe, etc] )
                -----------
                /        \
       active  /          \  active
   +-------------+      +-------------+
   | controller1 |      | controller2 |
   +-------------+      +-------------+
              \           /
               +---------+
                    |
             +-------------+                    +-------------+
             | aoe-storage | --- drbd raid1 --- |  secondary  |
             +-------------+                    +-------------+

-----
Layer diagram:
+-----------------+
| (net block dev) | controller1/2
+-----------------+
| lvm2 clustered  | controller1/2
+-----------------+
| md: linux-raid0 | controller1/2
+-----------------+
|  aoe initiator  | controller1/2
+-----------------+
|   aoe target    | aoe-storage
+-----------------+


My main concern is interaction with buffer cache and the consistencies  
of the md devices between the controllers (probably not page cache  
since these are block devices?).  Will direct/O_DIRECT bypass this  
keeping the state of the data purely on the aoe-storage device?  I  
have a test setup of this running with no issues so far connecting to  
the controllers that run iscsi-target (iet) in blockio mode, thus  
bypaassing buffer/page cache.

Any feedback is appreciated.

--
Matth

