From: "Bene Martin" <martin.bene@icomedias.com>
Subject: AW: Spares and partitioning huge disks
Date: Mon, 10 Jan 2005 20:27:26 +0100
Message-ID: <FA095C015271B64E99B197937712FD024BCF7F@freedom.grz.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: maarten <maarten@ultratux.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Maarten,
> this constant switching by itself.  Now my FS is XFS, maybe 
> that filesystem has this behaviour?  
> Anyone having a raid-5 with XFS on top can confirm 
> this ?  

I can definitely confirm this. XFS does not use constant request sizes
for accessing the block device. That's why it used to be impossible to
combine XFS and drbd  - drbd couldn't cope with the constantly changing
block sizes.

Bye, Martin
