From: "Martin Bene" <martin.bene@icomedias.com>
Subject: AW: other RAID features
Date: Mon, 27 May 2002 09:05:00 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A1A5A3BBFEB3D24E8D84F91AFC8452E3015484@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: 3tcdgwg3 <3tcdgwg3@prodigy.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, 

> Please,  any body know if there is a plan to support
> more RAID features under Linux?  If yes, when.
> I am interested in two of them (can either online or offline, 
> but online will be really good):
> 1. Expend capacity.
> 2. RAID level migration.

Check out the raidreconf tool at http://unthought.net/raidreconf/index.shtml, I've sucessfully used it to add a new disk to a raid5 array (4 Disk ==> 5 Disk), thus extending the capacity without data loss. 

Bye, Martin
 
