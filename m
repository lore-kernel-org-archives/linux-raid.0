From: "drenning, bruce" <bdrenni@catholicrelief.org>
Subject: 3ware raid 10 rebuild fails
Date: Mon, 15 Jul 2002 09:04:42 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <F748CB1980A1D111A00300A0C99DBBF0090F6DA6@mail1>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've got a 3ware 6410 with 4 drives in a RAID 10 config. 1 of the drives
failed. I installed a new drive (same model) and it sees it OK but wheh I
initiate rebuild it fails every time after a few 15 sec. 

Jul 14 08:24:43 files3 kernel: 3w-xxxx: Received AEN 0xb
Jul 14 08:24:48 files3 3w-xxxx[583]: Rebuild started on unit 0 on controller
ID:0. (0xb)
Jul 14 08:25:02 files3 kernel: 3w-xxxx: Received AEN 0x4
Jul 14 08:25:04 files3 3w-xxxx[583]: Rebuild/Initialization failed on unit 0
on controller ID:0. Check drives for media errors. (0x4)

I tried swapping out the controller w/ another from a spare/test server,
same result. Running 2.4.9-31 Red Hat kernel under 7.1. Anyone have a
suggestion as to how to get this array rebuilt? thanks.

