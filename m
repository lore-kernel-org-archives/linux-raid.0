From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Using the md driver to look at a bad hardware RAID.
Date: Tue, 1 Mar 2005 18:27:02 -0500
Message-ID: <200503012327.j21NR7512050@www.watkins-home.com>
References: <200503012308.j21N8oSh029058@mint-square.mit.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <200503012308.j21N8oSh029058@mint-square.mit.edu>
Sender: linux-raid-owner@vger.kernel.org
To: 'Omri Schwarz' <ocschwar@MIT.EDU>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It is a 7 drive array.  If you use 6 of 7 drives, md will not try to
re-sync.  But I have no idea if how to re-use the previous RAID data.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Omri Schwarz
Sent: Tuesday, March 01, 2005 6:09 PM
To: linux-raid@vger.kernel.org
Subject: Using the md driver to look at a bad hardware RAID. 

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

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

