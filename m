From: Brinley Craig <brinley.craig@godfreyhirst.com>
Subject: Kernel Problem
Date: Mon, 20 May 2002 16:04:33 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <EED7EA5584A4D311AB4100E029444A3601761633@syspcb>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

i have a kernel panic on my Sun E450,
Runs RH 6.2 sparc64 2.2.19-6.2.16smp
(with s/w raid 1 & 5)
its under very little load, and has had a uptime of about 3 months.

Its been running well untill the following error appear on the console.
any idea's what caused it? i havent reset it yet if there is any other info
from the panic needed, or any other box info, let me know.
Thanks
Brin


data_access_exception: Shit SFSR[0000000000801009] SFAR[fffff80000000030],
going.
(pic of face goes here)
swapper(0): Dax

CPU[1]: (irq counts)
TSTATE: (stuff here)
(cpu registers here)
Instruction DUMP: (stuff here)
Aiee, killing interupt handler
CPU[3]: (irq counts)
TSTATE: (stuff here)
kernel panic: attempted to kill the idle task!
In swapper task - not syncing
(cpu register stuff)




---------------------------------------------------
Brinley Craig
Network Administrator
Godfrey Hirst Australia Pty. Ltd.
Ph: 03 5225-0139 Fx: 03 5222-3885
brinley.craig@godfreyhirst.com
---------------------------------------------------



PLEASE NOTE:
Whilst we use software to detect viruses we exclude all liability
for the presence of any virus or alike in any attachments.

