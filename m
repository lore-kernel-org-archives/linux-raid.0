From: Wakko Warner <wakko@animx.eu.org>
Subject: How does one assemble a DDF or IMSM array?
Date: Thu, 2 Aug 2012 21:05:32 -0400
Message-ID: <20120803010532.GA1285@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've not used DDF or IMSM arrays much.

I understand that the devices (ie /dev/sda and /dev/sdb) are the containers.

I know that one can use mdadm -I on the devices and it will create mdXXX
(last I tried it was 127) and then will create mdXXX for each virtual disk
in the container and they will just work.

If I do mdadm -A /dev/mdXXX, how would one get the volumes inside started?
I tried mdadm -I /dev/mdXXX after mdadm -A.  It created mdXXX where XXX is
-2 from the first one (it 127 being the container and 125 being there but
not in a state that works)

Does DDF/IMSM require mdadm.conf to work when using -A?

I'm not sure if I'm making myself very clear here or not.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
