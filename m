From: Robert Heinzmann <Robert.Heinzmann@gmx.net>
Subject: mdadm 2.2 new option
Date: Thu, 15 Dec 2005 23:14:02 +0100
Message-ID: <43A1EAAA.6090802@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

i just downloaded the mdadm 2.2 version. It seems that there are some 
new options which are not explained in details. of special interest are 
2 options.

-GROW
The new grow mode is very very helpfull for us. It would allow us to do 
resize operations with md devices at last - without the need for LVM.
The manpage states that the GROW mode requires kernel support to work. 
There is no note that states, which kernel supports the options. Also 
with various distributions with patched kernels its not possible to say 
version X.Y.Z. of the kernel contains the required patches.

Is there a way to find out via mdadm, if the current kernel supports the 
GROW mode, prior to performing the GROW ?

-bitmap

As far as I understand this bitmap options, in incorperates write intend 
logging.
Is this based on paper by James Bottomley ? Also is there a way to find 
out via mdadm if the running kernel supports intend logging via mdadm ?

-There is also an option --write-mostly since 2.0.

I guess this especially usefull for MD devices with large storage arrays 
as backend. They have clever caches and read ahead paramaters, that can 
be non-effective if we change the disk for each read. Does this option 
require a kernel modification too ?

One last question. Besindes the source code and manpage is there oterh 
documentation available on how the md works internally ? (update of 
superblock, handling of device renaming inside the superblock etc.)

Thanks,
Robert Heinzmann
