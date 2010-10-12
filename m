From: Tim Small <tim@seoss.co.uk>
Subject: Re: can mdadm use /dev/sgX as devices?
Date: Tue, 12 Oct 2010 14:50:54 +0100
Message-ID: <4CB467BE.3050003@seoss.co.uk>
References: <201010091822.33148.harry.mangalam@uci.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201010091822.33148.harry.mangalam@uci.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Harry Mangalam <harry.mangalam@uci.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/10/10 02:22, Harry Mangalam wrote:
> the short version:
>    Can mdadm use /dev/sgX as devices?
>    (and if so, how?)
>
> the longer version is:
>
> I inherited a 6-bay IBM x3655  with a ServeRAID-8k RAID controller
> (from docs, it seems to be an 8-port Adaptec 9580W SAS/SATA
> controller). I'd like to run Ubuntu 10.04.
>
> I can use the controller BIOS on boot to config and set up a RAID5
> (which presents to the OS as '/dev/sda' - the 'very large device'.
>    


You could try:

. Looking for someone who's made a script or utility to check the array 
status of the controller (I know there were opensource tools for earlier 
adaptec controllers, so this might not be too difficult).
. Configuring  each individual device as a JBOD (single device RAID0 
etc.), and running md on top of that.

Although I'm guessing it'd probably be possible to get the sd driver to 
attach to he drives some way, you'd probably end up with the controller 
BIOS, or the RAID controller driver fighting with md over the device 
metadata.

If you wipe the adaptec metadata from the drives, do you just end up 
with 5 individual disks in Linux?

Tim.

-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

