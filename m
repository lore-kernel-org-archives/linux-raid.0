From: =?ISO-8859-1?Q?Ask_Bj=F8rn_Hansen?= <ask@develooper.com>
Subject: 3ware and dmraid - duplicate serial numbers (!)
Date: Fri, 18 Jan 2008 03:17:56 -0800
Message-ID: <A2C96114-A87C-493B-A94D-4DCC80A17F95@develooper.com>
Mime-Version: 1.0 (Apple Message framework v915)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi everyone,

One of my boxes crashed (with a hardware error, I think - CPU and  
motherboard replacements are on their way).  I booted it up on a  
rescue disk (Fedora 8) to let the software raid sync up.

When it was running I noticed that one of the disks were listed as  
"dm-5" and ... uh-oh ... there was a disk missing.   I figured out  
that the multipath stuff for some reason had setup two of the disks  
as /dev/mapper/mpath0 and now md was syncing to this device.

Much later I figured out that "dmraid -b" reported two of the disks as  
being the same:

/dev/sda:    976541696 total, "W553841781E0A2001842"
/dev/sdb:    976773168 total, "V600VXZG000000000000"
/dev/sdc:    586114704 total, "U1757241000000000000"
/dev/sdd:    976773168 total, "U1907712000000000000"
/dev/sde:    976773168 total, "U2133609000000000000"
/dev/sdf:    976773168 total, "D2994402000000000000"
/dev/sdg:    625140335 total, "U2130349000000000000"
/dev/sdh:    976773168 total, "U1541228000000000000"
/dev/sdi:    976771055 total, "W5267124000000000000"
/dev/sdj:    976773168 total, "U1409513000000000000"
/dev/sdk:    976773168 total, "U1409513000000000000"

Any idea how this could happen?   All 11 disks are on a 3ware 9650  
controller (the first one is a "single" 3ware device, the rest are  
JBOD).  I tried rebooting and booting on a Fedora 7 DVD with the same  
result.

[ all this of course seems to have messed up my raid10 badly -- more  
on that tomorrow ]


  - ask

-- 
http://develooper.com/ - http://askask.com/


