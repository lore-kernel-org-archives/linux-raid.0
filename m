From: "Mikael Chambon" <raid-ml@cronos.org>
Subject: RAID SYNC
Date: Thu, 10 Jul 2003 20:54:04 -1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <017101c34779$37d581a0$c9e903ca@magnus>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Again,

My second question is about RAID sync.

Just for my curiosity, I am testing RAID1 on two empty 110 gig partitions, 
the system takes about 3h30 to resync, why is it taking so long ?

Here is my idea: As the RAID layer has nothing to do with the FS layer,
the raid driver (I use md) does not and can't see the difference between 
a used block of data and an unused block of data. That's why it has to 
resync everything. Am I right ?
 
Thanks guys,
--
Mikael Chambon


