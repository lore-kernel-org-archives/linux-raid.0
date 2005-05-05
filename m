From: Robey Holderith <robey@flaminglunchbox.net>
Subject: success repairing raid5 with 2 dead drives
Date: Thu, 05 May 2005 16:07:53 -0400
Message-ID: <427A7D19.1030805@flaminglunchbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Awhile ago I had a power failure on a raid 5 array.  Two drives were 
reported out of sync and the array made me force it back together.  So I 
just did:

mdadm --assemble --force /dev/md0 /dev/sd[a-f]2

After processing for awhile two of the six drives were marked as failed 
and were dropped out of the array.  Using badblocks revealed that both 
drives had failed sectors in the same areas. ... Ugh!  Have I lost all 
information?  It seemed kindof silly that all information would be lost 
when it was very specific sectors that were dead.  Here are the steps I 
took to save 99.9% of the information on the array.  I am not claiming 
that anyone else will have success using these methods and am not 
responsible for anyone's mistakes but my own.

1.  Back up whatever you can.  Using mdadm --assemble --force gave me 
about 2 hours before the drives were dropped from the array.  Doing this 
a couple of times allowed me to get the latest versions of important files.

2.  Get some new drives (but don't get rid of the old data).

3.  dd_rescue data.  Use dd_rescue to copy over whatever data is still 
good from the bad drives.  In my case I took out two of the good drives 
from the array and replaced them with the new drives.  I then did:

dd_rescue /dev/sdd /dev/sdc

and

dd_rescue /dev/sdf /dev/sde

as sdd and sdf were the drives that were going and sdc and sde were the 
locations of the new drives.  Once the data is copied replace the bad 
drives with the two that were removed.

4.  Re-assemble array.  With the new drives in place use 'mdadm 
--assemble --force' to reconstruct the array.  If all goes well you 
should be done.

Anyway... this is just to let people know that it is possible to save 
data from dead arrays.  Just make sure you plan your steps carefully and 
think throught the consequences of all of your actions.

Also... thanks to everyone who helped me figure out what steps to take.

-Robey Holderith
