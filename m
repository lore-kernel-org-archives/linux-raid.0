From: Guntsche Michael <mike@it-loops.com>
Subject: Re: 2.6.25.x: Wrong CPU frequency (cpufreq table) with p4-clockmod
Date: Fri, 30 May 2008 19:21:14 +0200
Message-ID: <22164834-E7AA-4161-916C-F3D95E3BEA10@it-loops.com>
Mime-Version: 1.0 (Apple Message framework v924)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok,

I enabled debugging and here is the output of the boot-up

cpufreq-core: trying to register driver p4-clockmod
cpufreq-core: adding CPU 0
p4-clockmod: has errata -- disabling low frequencies
speedstep-lib: x86: f, model: 1
speedstep-lib: P4 - MSR_EBC_FREQUENCY_ID: 0x8a01fe00 0x0
speedstep-lib: P4 - FSB 100000 kHz; Multiplier 138; Speed 13800000 kHz
freq-table: setting show_table for cpu 0 to e2950d60
freq-table: table entry 0 is invalid, skipping
freq-table: table entry 1 is invalid, skipping
freq-table: table entry 2: 3450000 kHz, 2 index
freq-table: table entry 3: 5175000 kHz, 3 index
freq-table: table entry 4: 6900000 kHz, 4 index
freq-table: table entry 5: 8625000 kHz, 5 index
freq-table: table entry 6: 10350000 kHz, 6 index
freq-table: table entry 7: 12075000 kHz, 7 index
freq-table: table entry 8: 13800000 kHz, 8 index
cpufreq-core: setting new policy for CPU 0: 3450000 - 13800000 kHz
freq-table: request for verification of policy (3450000 - 13800000  
kHz) for cpu 0
freq-table: verification lead to (3450000 - 13800000 kHz) for cpu 0
freq-table: request for verification of policy (3450000 - 13800000  
kHz) for cpu 0
freq-table: verification lead to (3450000 - 13800000 kHz) for cpu 0
cpufreq-core: new min and max freqs are 3450000 - 13800000 kHz
cpufreq-core: governor switch
cpufreq-core: __cpufreq_governor for CPU 0, event 1
cpufreq-core: governor: change or update limits
cpufreq-core: __cpufreq_governor for CPU 0, event 3
cpufreq-core: initialization complete
cpufreq-core: driver p4-clockmod up and running
p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available

FSB and the multiplier look a litte bit off to me.

/Michael

