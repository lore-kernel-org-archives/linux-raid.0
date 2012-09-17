From: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
Subject: What parameters to mdadm, to re-create md device with payload starting
 at 0x22000 position on backing storage?
Date: Mon, 17 Sep 2012 09:00:14 +0200
Message-ID: <5056CA7E.5040303@statystyka.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I try to recover from mdadm raid disaster, which happened when moving 
from ubuntu server 10.04 to 12.04. I know the correct order of devices 
from dmesg log, but given this information, I still cannot access the data.

The superblocks look messy; the mdadm --examine for each disk is on 
http://askubuntu.com/questions/186666/mdadm-fails-after-10-04-12-04-upgrade

By inspecting the raw contents of backing storage, I found the beginning 
of my data (the LUKS container in my case) starts at position 0x22000 
relative to the beginning of the first partition in the raid, .i.e. 
/dev/sdb6.

Question: What is the combination of options issued to "mdadm --create" 
to re-create mdadm that starts with the given offset? Bitmap size?

The relevant information from syslog when the system was healthy are 
pasted here: http://pastebin.com/9KKaXXiU

P.S. This question, like the previous one, is a copy from my question on 
Serverfault.com: 
http://serverfault.com/questions/427683/what-parameters-to-mdadm-to-re-create-md-device-with-payload-starting-at-0x2200

Yours,

Adam Ryczkowski
Skype:sisteczko
