From: Franc Carter <franc@tech.sirca.org.au>
Subject: multipath superblock problem
Date: Fri, 4 Mar 2005 12:54:50 +1100
Message-ID: <200503041254.50113.franc@tech.sirca.org.au>
Reply-To: Franc Carter <franc@tech.sirca.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have several multipath md arrays made from the two LUNs presented by a
Hitachi SAN. I created, mounted etc these while the system was running and all
seemed to be fine at that point.

However on a reboot several of the arrays have failed to come up. It looks
like a combination of problems have resulted in the superblocks being
incorrect. An example output of mdadm -E is below

      [root@fs1 src]# mdadm -E /dev/scsi/sdh1-0c0i3l12
      /dev/scsi/sdh1-0c0i3l12:
                Magic : a92b4efc
              Version : 00.90.00
                 UUID : c1c48438:2e955af4:caac8720:d04d6d22
        Creation Time : Thu Feb 10 16:32:28 2005
           Raid Level : multipath
         Raid Devices : 1
        Total Devices : 2
      Preferred Minor : 16

          Update Time : Thu Feb 10 16:32:28 2005
                State : active
       Active Devices : 1
      Working Devices : 2
       Failed Devices : 0
        Spare Devices : 1
             Checksum : f8951a65 - correct
               Events : 0.1


            Number   Major   Minor   RaidDevice State
      this     1      65      240        1      
spare   /dev/scsi/sdh1-0c0i1l15

         0     0      65      224        0      active 
sync   /dev/scsi/sdh1-0c0i1l14
         1     1      65      240        1      
spare   /dev/scsi/sdh1-0c0i1l15


The devices that are listed as being components of the array do not include
the device that was queried.

I've resolved the device node issue and am considering rewiring the
superblocks by re-creating the raid devices - my understanding is that this
shouldn't damage the data as only the superblocks get changed when creating a
multipath device ??

Can anyone see any hidden risks in this - or a better way of fixing the
problem ?

thanks

-- 
Franc Carter     Ph:61-2-9236-9127      Fax: 61-2-9321-5988
Systems Manager, SIRCA Ltd              http://www.sirca.org.au/

DISCLAIMER: The contents of this email, inclusive of attachments, may
be legally privileged and confidential. Any unauthorised use of the
contents is expressly prohibited. If you have received this message in
error or are not the intended recipient, you should destroy the email
message along with any attachment(s).  Unintended recipients of this
email are prohibited from retaining, disclosing, distributing or using
any information contained herein.  This email is also subject to
copyright. No part of it should be reproduced, adapted or transmitted
without the written consent of the copyright owner.
