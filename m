From: Pol Hallen <raid2@fuckaround.org>
Subject: ata4.00: exception Emask 0x0 SAct 0x1b7ffff SErr 0x0 action 0x6 frozen
Date: Mon, 15 Nov 2010 15:33:17 +0100
Message-ID: <201011151533.17638.raid2@fuckaround.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

howdy :-)

in dmesg:

[ 5485.000040] ata4.00: exception Emask 0x0 SAct 0x1b7ffff SErr 0x0 action 0x6 
frozen
[ 5485.000103] ata4.00: failed command: READ FPDMA QUEUED
[ 5485.000140] ata4.00: cmd 60/08:00:9f:00:00/00:00:7c:00:00/40 tag 0 ncq 4096 
in
[ 5485.000141]          res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask 0x4 
(timeout)
[ 5485.000265] ata4.00: status: { DRDY }
[ 5485.000293] ata4.00: failed command: READ FPDMA QUEUED
[ 5485.000325] ata4.00: cmd 60/60:08:c7:3e:84/00:00:56:00:00/40 tag 1 ncq 
49152 in
[ 5485.000326]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[...]

how check which disk should be broke broken? or is it a controller problem?
thanks!

Pol
