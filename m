From: "Omri Schwarz" <ocschwar@MIT.EDU>
Subject: Using the md driver to look at a bad hardware RAID.
Date: Tue, 01 Mar 2005 18:08:50 -0500
Message-ID: <200503012308.j21N8oSh029058@mint-square.mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, everyone.

I have a 7 drive dpt_i2o RAID 5 with which a drive going bad coincided with 
the card going bad. The card (Adaptec mumblefrotz) is going elsewhere,
while the drives are now on an aic7xxx SCSI chain set as JBOD. 

If it were possible to configure an md device to have the same 
arrangement as the hardware, so I could mount this degraded RAID
as read only and rescue some data, it would make me a very happy man. 

I would just like to make absolutely sure that just loading the
drives into an mdadm incantation won't cause any write operations to 
happen. Is there a way to tell the driver precisely which drive to 
treat as bad, and not to engage in any write operations what-so-ever ?

I'd be most gratefull for any help you might care to give.

--Omri Schwarz

