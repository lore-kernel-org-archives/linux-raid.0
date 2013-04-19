From: linux.news@bucksch.org
Subject: Re: md RAID5: Disk wrongly marked "spare", need to force re-add it
Date: Sat, 20 Apr 2013 00:56:17 +0200
Message-ID: <5171CB91.1040708@bucksch.org>
References: <516869D2.9030506@bucksch.org> <516B3077.9020507@schinagl.nl> <516B590C.5060807@bucksch.org> <516AE7A0.4070504@schinagl.nl> <516BD5E0.4040007@bucksch.org> <516FF25B.4000907@bucksch.org> <516FFC13.2030803@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <516FFC13.2030803@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Maarten <maarten@ultratux.net>
List-Id: linux-raid.ids

Maarten wrote, On 18.04.2013 15:58:
> On 18/04/13 15:17, Ben Bucksch wrote:
>> To re-summarize (for full info, see first post of thread):
>> * There are 2 RAID5 arrays in the machine, each have 8 disks.
>> * I upgraded Ubuntu 10.04 to 12.04.
>> * After reboot, both arrays had each ejected one disk.
>>    The ejected disks are working fine (at least now).
>> * During the resync mandated by above ejection,
>>     one other drive failed, this one fatally with a real hardware failure.
>> * The second array resynced fine, further proving that the
>>     disks ejected during upgrade were working.
>> * Now I am left with: originally 8-disk RAID5, 6 disks are healthy,
>>    1 disk with hardware failure, and 1 disk that was ejected, but is
>> working.
>> * The latter is currently marked "spare" by md and has an event count
>>    (only) 2 events lower than the other 6 disks.
>> * My task is to get the latter disk back online *with* its data, without
>> resync.
>>
>> I desperately need help, please.
>>
>> Based on suggestions here by Oliver and on forums, I did (and the result
>> is):
>>
>>> # mdadm --stop /dev/md0
>>> mdadm: stopped /dev/md0
>>> # mdadm --assemble --run --force /dev/md0 /dev/sd[jlmnopq]
>>> mdadm: failed to RUN_ARRAY /dev/md0:
>>> mdadm: Not enough devices to start the array.
> At this point, does dmesg show anything pointing to that input/output
> error ? The procedure is correct

[630786.513314] md: md0 stopped.
[630786.513341] md: unbind<sdl>
[630786.590662] md: export_rdev(sdl)
[630786.590744] md: unbind<sdj>
[630786.670652] md: export_rdev(sdj)
[630786.670887] md: unbind<sdq>
[630786.750650] md: export_rdev(sdq)
[630786.750707] md: unbind<sdn>
[630786.830649] md: export_rdev(sdn)
[630786.830712] md: unbind<sdp>
[630786.910651] md: export_rdev(sdp)
[630786.910710] md: unbind<sdo>
[630786.990649] md: export_rdev(sdo)
[630786.990700] md: unbind<sdm>
[630787.070649] md: export_rdev(sdm)
[630793.315121] md: md0 stopped.
[630794.785328] md: bind<sdm>
[630794.785512] md: bind<sdo>
[630794.785695] md: bind<sdp>
[630794.785891] md: bind<sdn>
[630794.786643] md: bind<sdq>
[630794.787009] md: bind<sdl>
[630794.788164] md: bind<sdj>
[630794.788236] md: kicking non-fresh sdl from array!
[630794.788250] md: unbind<sdl>
[630794.810082] md: export_rdev(sdl)
[630794.812725] raid5: device sdj operational as raid disk 0
[630794.812734] raid5: device sdq operational as raid disk 7
[630794.812740] raid5: device sdn operational as raid disk 6
[630794.812745] raid5: device sdp operational as raid disk 5
[630794.812750] raid5: device sdo operational as raid disk 4
[630794.812755] raid5: device sdm operational as raid disk 3
[630794.813895] raid5: allocated 8490kB for md0
[630794.813966] 0: w=1 pa=0 pr=8 m=1 a=2 r=8 op1=0 op2=0
[630794.813974] 7: w=2 pa=0 pr=8 m=1 a=2 r=8 op1=0 op2=0
[630794.813980] 6: w=3 pa=0 pr=8 m=1 a=2 r=8 op1=0 op2=0
[630794.813986] 5: w=4 pa=0 pr=8 m=1 a=2 r=8 op1=0 op2=0
[630794.813993] 4: w=5 pa=0 pr=8 m=1 a=2 r=8 op1=0 op2=0
[630794.813999] 3: w=6 pa=0 pr=8 m=1 a=2 r=8 op1=0 op2=0
[630794.814005] raid5: not enough operational devices for md0 (2/8 failed)
[630794.820671] RAID5 conf printout:
[630794.820675]  --- rd:8 wd:6
[630794.820680]  disk 0, o:1, dev:sdj
[630794.820685]  disk 3, o:1, dev:sdm
[630794.820689]  disk 4, o:1, dev:sdo
[630794.820693]  disk 5, o:1, dev:sdp
[630794.820697]  disk 6, o:1, dev:sdn
[630794.820701]  disk 7, o:1, dev:sdq
[630794.820945] raid5: failed to run raid set md0
[630794.826530] md: pers->run() failed ...
[630794.834455] md: export_rdev(sdl)
[630794.834463] md: export_rdev(sdl)

The problem is:
md: kicking non-fresh sdl from array!
thus:
raid5: not enough operational devices for md0 (2/8 failed)

# mdadm -E /dev/sdl
   Checksum : ca6e81a9 - correct      Events : 13274863
# mdadm -E /dev/sdn
   Checksum : c9a41046 - correct      Events : 13274865

So, the question is: How do I convince md not to be so anal retentive 
and prevent me from accessing any of my data? The drive ***is fine***, 
has practically all the data (I don't care about these 2 events), just 
use it already. Nobody seems to know the magic shell commands to do that.

The lack of a proper shell command for that effectively constitutes a 
dataloss bug. I've been patient, but I'm getting more and more upset at md.
Thanks, Maarten, for your help. I hope 1) you or anybody else can help 
me, and I hope 2) these kinds of problems will be fixed once and for 
good by the devs.

> Good luck!

Thanks.

Ben
