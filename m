From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: auto-assembling arrays without a configuration file
Date: Sat, 8 Mar 2008 01:40:09 +0100
Message-ID: <20080308004009.GA32251@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I want to assemble the root partition automatically, without having 
a configuration file. Is that possible? 

mdadm -A --scan 

does seem to require a configuration file.

On the other hand, I think all info needed is available in the super
blocks, and a traversal of the partitions present on the system (ala
fdisk -l) could give consistent naming - there seems to be no /dev/md
association available in the superblock.

best regrds
keld
