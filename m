From: tomas.hodek@volny.cz
Subject: =?iso-8859-2?Q?Re:_raid1_read_balance_with_write_mostly?=
Date: Sun, 03 Feb 2013 10:02:12 +0100 (CET)
Message-ID: <7564da610e67d6a62ffef3498273f4b4@mail1.volny.cz>
References: <36edd03089332985af9a97eeaf719cd3@mail1.volny.cz> <510D8A8C.5090505@hardwarefreak.com> <20130203040758.5e2e7f3c@natsu> <1359843383.430.18.camel@workstation-home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1359843383.430.18.camel@workstation-home>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yes, main question is what means write mostly. From 

http://marc.info/?l=linux-raid&m=112374499705545&w=4 

means : "Read requests will only be sent if there is no other option."

Maybe we want to change this behavior but direct selection is wrong way. It does not matter if other drives have little bit or heavy workload but only idle. 

If we want a uneven distribution of load some adjustable advantage/disadvantage is better solution then direct selection.

Yes my situation ssd+hdd is the extreme case, but my experience with old scsi 15k hdd is like. In sequential read/write is slow compare to modern green hdd, but if it have random workload all invert. Direct selection slowest drive may stun system for some time while fastest hdd is idle. 

Hodek


