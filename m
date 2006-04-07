From: "Stern, Rick (Serviceguard Linux)" <rick.stern@hp.com>
Subject: RE: accessing mirrired lvm on shared storage
Date: Thu, 6 Apr 2006 17:54:15 -0700
Message-ID: <1C4766A743ADF74FAEDF2AAD0679BAA207CA6C29@cacexc03.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Eble <matthias.eble@mailing.kaufland-informationssysteme.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Matthias,

Your best bet is to not activate the md mirrors until you need to.
There is a theoretical case where one system (A) can be writing data
while the other (B) is doing a remirror.   B reads data in prep for a
write, A writes to that same block, then B writes the old data.  

LVM does not refuse to activate volume groups.  While there is a cluster
volume manager, it doesn't help in this case as it requires an interface
to the cluster sw.

Regards,
Rick

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Matthias Eble
Sent: Thursday, April 06, 2006 11:20 AM
To: linux-raid@vger.kernel.org
Subject: accessing mirrired lvm on shared storage


Hi all,

I've got an extended setup whith two Systems, each with two FC cards. 
Every card is connected to a seperate disk array (so one system accesses

two arrays). The other node has access to the same two arrays (standby).

The active server mirrors the data (4 LUNs) between the two arrays via 
md. On top is a LVM physical volume. The other system is meant to be 
booted but not acessing the VGs.

My question is, if it is possible to let both systems set up the md 
mirror without corrupting the data? Is there any data written even when 
the VGs are not taken active? I think I remember that LVM refuses to 
activate volumegroups which are active on another system, right?
This would save me from caring about IO fencing.

thanks for your help in advance..
matthias
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
