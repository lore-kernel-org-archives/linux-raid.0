From: "Armin Mohring" <arminmohring@surfeu.de>
Subject: Raidsetup
Date: Thu, 8 May 2003 09:04:16 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <FEEPICBHELONLMDKJLPOOEEJCBAA.arminmohring@surfeu.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

1. Setup
actual setup:
hda win xp
hdb linux raid 0
hdc linux raid 0
hdd swap disk for win and linux

Is it better to setup as follows?
hda liunx raid 0
hdb win xp
hdc linux raid 0
hdd swap disk for win xp and linux

2. The disks for linux have a read-performance of ~28MB/s.
   I only measure 40 MB/s read-performance for the raid.

TIA 

Armin Mohring 

