From: Mitchell Laks <mlaks@verizon.net>
Subject: hard drives with "variable"  device names - mdadm raid assembly
 options setup
Date: Fri, 30 Dec 2005 09:08:18 -0500
Message-ID: <200512300908.19390.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I notice on my system that the hard drives "device names" can change.
Ie . 

The hard drives  are connected to the motherboard  SATA connectors or to PCI 
SATA cards. They get different "names" /dev/sda or /dev/sdc depending how 
many of the cards are "active". 

For instance the hard drives on the motherboard itself are called /dev/sde 
and /dev/sdf if there are hard drives on the 2 PCI cards and are 
called /dev/sda and /dev/sdb if there are none.

This is disconcerting, as I am setting up a remote site that I want to be able 
to visit rarely. I want to leave the "extra" hard drives on the PCI cards 
"off" for a few months, and am worried of FUD (fear uncertainty and doubt)
when I zoom in - to adjust the system - in a few months time when I come to 
connect the additional drives.

(Note: I am completely confused by udev which makes my raid life difficult - 
and I completely removed it so I am working with a static /dev/ 
directory :) )

I notice that there is a -u option based on the fixed uuid
mdadm -A /dev/md0 -u ?????

now I read in the man page:

If precisely one device is listed, but --scan is not given, then  mdadm
       acts  as  though --scan was given and identify information is extracted
       from the configuration file.

       The identity can be given with the --uuid  option,  with  the  --super-
       minor  option,  can be found  in the config file, or will be taken from
       the super block on the first component-device  listed  on  the  command
       line.

Now I am confused:  unfortunately this does not seem to help me: 
if it relys on the configuration file /etc/mdadm/mdadm.conf 
this config file - i create with the aid of mdadm --detail --scan 
seems to still have the (problematic) "variable" device names in it. 
I want only to use the uuid and not the "device name" which may change.
How can I deal effectively with my problem?  

I want to  set up my assemble line in my startup script so that all I need to 
do is 
1) connect the additional hard drives and 
2) uncomment a line in a startup script that will refer to the new hard drives 
only by their uuid so that I can be assured that the new device /dev/md1 will 
be the new drives and not a switcheroo? 

Thanks!

Mitchell
