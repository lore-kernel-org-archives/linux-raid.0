From: Danilo Godec <danilo.godec@agenda.si>
Subject: Special drives for Linux Raid?
Date: Mon, 07 Nov 2011 14:29:07 +0100
Message-ID: <4EB7DD23.9090907@agenda.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Some manufacturers make 'special' versions of drives for RAID (WD RE4, 
Seagate SE, ...). Apparently the main difference is in error handling, 
where normal 'desktop' drives try hard to recover an error (up to 
several minutes) while RAID drives give up quickly (few seconds) so that 
the RAID controller can take over.

Are there any other known and significant differences?

Is usage of these special drives recommended with Linux md?


  Thanks, Danilo

