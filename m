From: Matthias Eble
	<matthias.eble@mailing.kaufland-informationssysteme.com>
Subject: accessing mirrired lvm on shared storage
Date: Thu, 06 Apr 2006 20:19:53 +0200
Message-ID: <44355BC9.4020608@mailing.kaufland-informationssysteme.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


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
