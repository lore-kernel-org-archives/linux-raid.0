From: "Michael" <michael@insulin-pumpers.org>
Subject: force spare to sync
Date: Thu, 13 Nov 2003 09:39:27 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200311131739.hADHdS226410@bzs.org>
Reply-To: michael@insulin-pumpers.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been messing with a new raid 1 system with hot swap bays and it 
occurred to me that in a raid/boot situation, the spare drive is not 
sync'd and has no boot track. Is there a way to force the spare drive 
to sync to the "master" set so that lilo can be run on that drive to 
place a boot track with the appropriate information... or is there a 
way to hold the spare in sync. This need not be done for the entire 
disk, only the raid 1 boot partition. I can't see an easy way to do 
this with the current tools, it might be a nice option to add to 
future I'mplimentations.

Michael
Michael@Insulin-Pumpers.org
