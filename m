From: Steve Hill <steve@navaho.co.uk>
Subject: Raid 1 without a persistent superblock
Date: Tue, 6 Jan 2004 13:00:04 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0401061257440.27264@sorbus2.navaho>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I can't seem to find any information on how to start a raid array which 
doesn't have a persistent superblock - from what I can tell, raidstart 
only works with devices with a persistent superblock, so how do I start a 
raid array based entirely on the information in /etc/raidtab?

- Steve Hill
Senior Software Developer                        Email: steve@navaho.co.uk
Navaho Technologies Ltd.                           Tel: +44-870-7034015

        ... Alcohol and calculus don't mix - Don't drink and derive! ...


