From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: performance of raid5 on fast devices
Date: Tue, 17 Jan 2017 22:04:30 +0100
Message-ID: <27fb7a94-27d0-b319-30b8-daf4dab97415@redhat.com>
References: <CA+Dh761_kVPEcRdFEAo72Wif_t-G7RpgyoKGetEFveyMpaYD1w@mail.gmail.com>
 <20170117101043.78e80bdc@natsu>
 <CA+Dh763Ttvnt9CSEUZ0QwPOLCaZq6VVXmj4OoheR7WTO6o4Pbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+Dh763Ttvnt9CSEUZ0QwPOLCaZq6VVXmj4OoheR7WTO6o4Pbw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jake Yao <jgyao1@gmail.com>, Roman Mamedov <rm@romanrm.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jake et al,

I took the oportunity to measure raid5 on a 4x NVME here with
variations of group_thread_cnt={0..10} minimal
stripe_cache_size={256,512,1024,2048,4096,8192,16384,32768}

This is on an X-99 with Intel E5-2640 and kernel 4.9.3-200.fc25.x86_64.

Highest active stripe count logged < 17K.


fio job/sections used:
----------------------------
[r-md0]
ioengine=libaio
iodepth=40
rw=read
bs=4096K
direct=1
size=4G
numjobs=8
filename=/dev/md0

[w-md0]
ioengine=libaio
iodepth=40
rw=write
bs=4096K
direct=1
size=4G
numjobs=8
filename=/dev/md0


Baseline performance seen with raid0:
---------------------------------------------------
md0 : active raid0 dm-350[3] dm-349[2] dm-348[1] dm-347[0]
       33521664 blocks super 1.2 32k chunks

READ: io=32768MB, aggrb=8202.3MB/s, minb=1025.3MB/s, maxb=1217.7MB/s, 
mint=3364msec, maxt=3995msec
WRITE: io=32768MB, aggrb=5746.8MB/s, minb=735584KB/s, maxb=836685KB/s, 
mint=5013msec, maxt=5702msec


Performance with raid5:
--------------------------------
md0 : active raid5 dm-350[3] dm-349[2] dm-348[1] dm-347[0]
       25141248 blocks super 1.2 level 5, 32k chunk, algorithm 2 [4/4] 
[UUUU]


READ: io=32768MB, aggrb=7375.3MB/s, minb=944025KB/s, maxb=1001.1MB/s, 
mint=4088msec, maxt=4443msec


Write results for group_thread_cnt/stripe_cache_size variations:
------------------------------------------------------------------------------------
0/256  -> WRITE: io=32768MB, aggrb=1296.4MB/s, minb=165927KB/s, 
maxb=167644KB/s, mint=25019msec, maxt=25278msec
1/256  -> WRITE: io=32768MB, aggrb=2152.6MB/s, minb=275524KB/s, 
maxb=278654KB/s, mint=15052msec, maxt=15223msec
2/256  -> WRITE: io=32768MB, aggrb=3177.4MB/s, minb=406700KB/s, 
maxb=415854KB/s, mint=10086msec, maxt=10313msec
3/256  -> WRITE: io=32768MB, aggrb=4026.6MB/s, minb=515397KB/s, 
maxb=524222KB/s, mint=8001msec, maxt=8138msec
4/256  -> WRITE: io=32768MB, aggrb=4172.2MB/s, minb=534034KB/s, 
maxb=552609KB/s, mint=7590msec, maxt=7854msec  *
5/256  -> WRITE: io=32768MB, aggrb=4166.9MB/s, minb=533355KB/s, 
maxb=547845KB/s, mint=7656msec, maxt=7864msec
6/256  -> WRITE: io=32768MB, aggrb=4189.3MB/s, minb=536218KB/s, 
maxb=556126KB/s, mint=7542msec, maxt=7822msec
7/256  -> WRITE: io=32768MB, aggrb=4192.5MB/s, minb=536630KB/s, 
maxb=560810KB/s, mint=7479msec, maxt=7816msec
8/256  -> WRITE: io=32768MB, aggrb=4185.2MB/s, minb=535807KB/s, 
maxb=562389KB/s, mint=7458msec, maxt=7828msec
9/256  -> WRITE: io=32768MB, aggrb=4192.1MB/s, minb=536699KB/s, 
maxb=577966KB/s, mint=7257msec, maxt=7815msec
10/256 -> WRITE: io=32768MB, aggrb=4182.3MB/s, minb=535329KB/s, 
maxb=568256KB/s, mint=7381msec, maxt=7835msec

0/512 -> WRITE: io=32768MB, aggrb=1297.8MB/s, minb=166025KB/s, 
maxb=167664KB/s, mint=25016msec, maxt=25263msec
1/512 -> WRITE: io=32768MB, aggrb=2148.5MB/s, minb=275000KB/s, 
maxb=278044KB/s, mint=15085msec, maxt=15252msec
2/512 -> WRITE: io=32768MB, aggrb=3158.4MB/s, minb=404270KB/s, 
maxb=411407KB/s, mint=10195msec, maxt=10375msec
3/512 -> WRITE: io=32768MB, aggrb=4102.7MB/s, minb=525141KB/s, 
maxb=539738KB/s, mint=7771msec, maxt=7987msec
4/512 -> WRITE: io=32768MB, aggrb=4162.8MB/s, minb=532745KB/s, 
maxb=541759KB/s, mint=7742msec, maxt=7873msec     *
5/512 -> WRITE: io=32768MB, aggrb=4178.6MB/s, minb=534851KB/s, 
maxb=549856KB/s, mint=7628msec, maxt=7842msec
6/512 -> WRITE: io=32768MB, aggrb=4167.4MB/s, minb=533422KB/s, 
maxb=562314KB/s, mint=7459msec, maxt=7863msec
7/512 -> WRITE: io=32768MB, aggrb=4192.1MB/s, minb=536699KB/s, 
maxb=566338KB/s, mint=7406msec, maxt=7815msec
8/512 -> WRITE: io=32768MB, aggrb=4189.8MB/s, minb=536287KB/s, 
maxb=558644KB/s, mint=7508msec, maxt=7821msec
9/512 -> WRITE: io=32768MB, aggrb=4165.8MB/s, minb=533219KB/s, 
maxb=559837KB/s, mint=7492msec, maxt=7866msec
10/512 -> WRITE: io=32768MB, aggrb=4177.2MB/s, minb=534783KB/s, 
maxb=570188KB/s, mint=7356msec, maxt=7843msec

0/1024 -> WRITE: io=32768MB, aggrb=1288.6MB/s, minb=164935KB/s, 
maxb=166877KB/s, mint=25134msec, maxt=25430msec
1/1024 -> WRITE: io=32768MB, aggrb=2218.5MB/s, minb=283955KB/s, 
maxb=289842KB/s, mint=14471msec, maxt=14771msec
2/1024 -> WRITE: io=32768MB, aggrb=3186.1MB/s, minb=407926KB/s, 
maxb=420903KB/s, mint=9965msec, maxt=10282msec
3/1024 -> WRITE: io=32768MB, aggrb=4107.4MB/s, minb=525733KB/s, 
maxb=538836KB/s, mint=7784msec, maxt=7978msec
4/1024 -> WRITE: io=32768MB, aggrb=4146.9MB/s, minb=530790KB/s, 
maxb=550505KB/s, mint=7619msec, maxt=7902msec
5/1024 -> WRITE: io=32768MB, aggrb=4160.5MB/s, minb=532542KB/s, 
maxb=550795KB/s, mint=7615msec, maxt=7876msec  *
6/1024 -> WRITE: io=32768MB, aggrb=4174.3MB/s, minb=534306KB/s, 
maxb=558942KB/s, mint=7504msec, maxt=7850msec
7/1024 -> WRITE: io=32768MB, aggrb=4189.8MB/s, minb=536287KB/s, 
maxb=556864KB/s, mint=7532msec, maxt=7821msec
8/1024 -> WRITE: io=32768MB, aggrb=4188.2MB/s, minb=536081KB/s, 
maxb=561035KB/s, mint=7476msec, maxt=7824msec
9/1024 -> WRITE: io=32768MB, aggrb=4167.4MB/s, minb=533422KB/s, 
maxb=567872KB/s, mint=7386msec, maxt=7863msec
10/1024 -> WRITE: io=32768MB, aggrb=4188.2MB/s, minb=536081KB/s, 
maxb=569878KB/s, mint=7360msec, maxt=7824msec

0/2048 -> WRITE: io=32768MB, aggrb=1265.7MB/s, minb=162004KB/s, 
maxb=166111KB/s, mint=25250msec, maxt=25890msec
1/2048 -> WRITE: io=32768MB, aggrb=2239.5MB/s, minb=286652KB/s, 
maxb=290846KB/s, mint=14421msec, maxt=14632msec
2/2048 -> WRITE: io=32768MB, aggrb=3184.5MB/s, minb=407609KB/s, 
maxb=413150KB/s, mint=10152msec, maxt=10290msec
3/2048 -> WRITE: io=32768MB, aggrb=4213.5MB/s, minb=539321KB/s, 
maxb=557901KB/s, mint=7518msec, maxt=7777msec     *
4/2048 -> WRITE: io=32768MB, aggrb=4168.5MB/s, minb=533558KB/s, 
maxb=543162KB/s, mint=7722msec, maxt=7861msec
5/2048 -> WRITE: io=32768MB, aggrb=4185.5MB/s, minb=535739KB/s, 
maxb=549352KB/s, mint=7635msec, maxt=7829msec
6/2048 -> WRITE: io=32768MB, aggrb=4181.8MB/s, minb=535260KB/s, 
maxb=553338KB/s, mint=7580msec, maxt=7836msec
7/2048 -> WRITE: io=32768MB, aggrb=4215.7MB/s, minb=539599KB/s, 
maxb=566109KB/s, mint=7409msec, maxt=7773msec
8/2048 -> WRITE: io=32768MB, aggrb=4200.5MB/s, minb=537662KB/s, 
maxb=568102KB/s, mint=7383msec, maxt=7801msec
9/2048 -> WRITE: io=32768MB, aggrb=4184.1MB/s, minb=535671KB/s, 
maxb=574483KB/s, mint=7301msec, maxt=7830msec
10/2048 -> WRITE: io=32768MB, aggrb=4172.7MB/s, minb=534102KB/s, 
maxb=567641KB/s, mint=7389msec, maxt=7853msec

0/4096 -> WRITE: io=32768MB, aggrb=1264.8MB/s, minb=161879KB/s, 
maxb=168588KB/s, mint=24879msec, maxt=25910msec
1/4096 -> WRITE: io=32768MB, aggrb=2349.4MB/s, minb=300710KB/s, 
maxb=312541KB/s, mint=13420msec, maxt=13948msec
2/4096 -> WRITE: io=32768MB, aggrb=3387.6MB/s, minb=433609KB/s, 
maxb=441877KB/s, mint=9492msec, maxt=9673msec
3/4096 -> WRITE: io=32768MB, aggrb=4182.3MB/s, minb=535329KB/s, 
maxb=552390KB/s, mint=7593msec, maxt=7835msec    *
4/4096 -> WRITE: io=32768MB, aggrb=4170.2MB/s, minb=533762KB/s, 
maxb=560061KB/s, mint=7489msec, maxt=7858msec
5/4096 -> WRITE: io=32768MB, aggrb=4179.6MB/s, minb=534919KB/s, 
maxb=548490KB/s, mint=7647msec, maxt=7841msec
6/4096 -> WRITE: io=32768MB, aggrb=4183.4MB/s, minb=535465KB/s, 
maxb=549208KB/s, mint=7637msec, maxt=7833msec
7/4096 -> WRITE: io=32768MB, aggrb=4174.9MB/s, minb=534374KB/s, 
maxb=557530KB/s, mint=7523msec, maxt=7849msec
8/4096 -> WRITE: io=32768MB, aggrb=4178.6MB/s, minb=534851KB/s, 
maxb=570188KB/s, mint=7356msec, maxt=7842msec
9/4096 -> WRITE: io=32768MB, aggrb=4180.2MB/s, minb=535056KB/s, 
maxb=570110KB/s, mint=7357msec, maxt=7839msec
10/4096 -> WRITE: io=32768MB, aggrb=4183.9MB/s, minb=535534KB/s, 
maxb=574640KB/s, mint=7299msec, maxt=7832msec

0/8192 -> WRITE: io=32768MB, aggrb=1260.9MB/s, minb=161381KB/s, 
maxb=171511KB/s, mint=24455msec, maxt=25990msec
1/8192 -> WRITE: io=32768MB, aggrb=2368.5MB/s, minb=303166KB/s, 
maxb=320444KB/s, mint=13089msec, maxt=13835msec
2/8192 -> WRITE: io=32768MB, aggrb=3408.8MB/s, minb=436225KB/s, 
maxb=458544KB/s, mint=9147msec, maxt=9615msec
3/8192 -> WRITE: io=32768MB, aggrb=4219.5MB/s, minb=540085KB/s, 
maxb=564585KB/s, mint=7429msec, maxt=7766msec     *
4/8192 -> WRITE: io=32768MB, aggrb=4208.6MB/s, minb=538698KB/s, 
maxb=570653KB/s, mint=7350msec, maxt=7786msec
5/8192 -> WRITE: io=32768MB, aggrb=4200.5MB/s, minb=537662KB/s, 
maxb=562013KB/s, mint=7463msec, maxt=7801msec
6/8192 -> WRITE: io=32768MB, aggrb=4189.3MB/s, minb=536218KB/s, 
maxb=585387KB/s, mint=7165msec, maxt=7822msec
7/8192 -> WRITE: io=32768MB, aggrb=4184.5MB/s, minb=535602KB/s, 
maxb=579323KB/s, mint=7240msec, maxt=7831msec
8/8192 -> WRITE: io=32768MB, aggrb=4186.6MB/s, minb=535876KB/s, 
maxb=572132KB/s, mint=7331msec, maxt=7827msec
9/8192 -> WRITE: io=32768MB, aggrb=4176.5MB/s, minb=534578KB/s, 
maxb=598246KB/s, mint=7011msec, maxt=7846msec
10/8192 -> WRITE: io=32768MB, aggrb=4184.1MB/s, minb=535671KB/s, 
maxb=580285KB/s, mint=7228msec, maxt=7830msec

0/16384 -> WRITE: io=32768MB, aggrb=1281.0MB/s, minb=163968KB/s, 
maxb=183542KB/s, mint=22852msec, maxt=25580msec
1/16384 -> WRITE: io=32768MB, aggrb=2451.8MB/s, minb=313827KB/s, 
maxb=337787KB/s, mint=12417msec, maxt=13365msec
2/16384 -> WRITE: io=32768MB, aggrb=3409.5MB/s, minb=436406KB/s, 
maxb=468532KB/s, mint=8952msec, maxt=9611msec
3/16384 -> WRITE: io=32768MB, aggrb=4192.5MB/s, minb=536630KB/s, 
maxb=566721KB/s, mint=7401msec, maxt=7816msec   *
4/16384 -> WRITE: io=32768MB, aggrb=4172.2MB/s, minb=534034KB/s, 
maxb=581089KB/s, mint=7218msec, maxt=7854msec
5/16384 -> WRITE: io=32768MB, aggrb=4175.4MB/s, minb=534442KB/s, 
maxb=587108KB/s, mint=7144msec, maxt=7848msec
6/16384 -> WRITE: io=32768MB, aggrb=4188.2MB/s, minb=536081KB/s, 
maxb=585224KB/s, mint=7167msec, maxt=7824msec
7/16384 -> WRITE: io=32768MB, aggrb=4173.8MB/s, minb=534238KB/s, 
maxb=591330KB/s, mint=7093msec, maxt=7851msec
8/16384 -> WRITE: io=32768MB, aggrb=4163.2MB/s, minb=532880KB/s, 
maxb=590165KB/s, mint=7107msec, maxt=7871msec
9/16384 -> WRITE: io=32768MB, aggrb=4166.9MB/s, minb=533355KB/s, 
maxb=608664KB/s, mint=6891msec, maxt=7864msec
10/16384 -> WRITE: io=32768MB, aggrb=4157.9MB/s, minb=532204KB/s, 
maxb=594768KB/s, mint=7052msec, maxt=7881msec

0/32768 -> WRITE: io=32768MB, aggrb=1288.1MB/s, minb=164980KB/s, 
maxb=189026KB/s, mint=22189msec, maxt=25423msec
1/32768 -> WRITE: io=32768MB, aggrb=2443.6MB/s, minb=312774KB/s, 
maxb=348624KB/s, mint=12031msec, maxt=13410msec
2/32768 -> WRITE: io=32768MB, aggrb=3467.1MB/s, minb=443888KB/s, 
maxb=484722KB/s, mint=8653msec, maxt=9449msec
3/32768 -> WRITE: io=32768MB, aggrb=4131.2MB/s, minb=528782KB/s, 
maxb=572444KB/s, mint=7327msec, maxt=7932msec    *
4/32768 -> WRITE: io=32768MB, aggrb=4082.8MB/s, minb=522589KB/s, 
maxb=606990KB/s, mint=6910msec, maxt=8026msec
5/32768 -> WRITE: io=32768MB, aggrb=3985.5MB/s, minb=510131KB/s, 
maxb=578046KB/s, mint=7256msec, maxt=8222msec
6/32768 -> WRITE: io=32768MB, aggrb=3937.2MB/s, minb=504062KB/s, 
maxb=591914KB/s, mint=7086msec, maxt=8321msec
7/32768 -> WRITE: io=32768MB, aggrb=4012.3MB/s, minb=513567KB/s, 
maxb=583028KB/s, mint=7194msec, maxt=8167msec
8/32768 -> WRITE: io=32768MB, aggrb=3944.2MB/s, minb=504851KB/s, 
maxb=567257KB/s, mint=7394msec, maxt=8308msec
9/32768 -> WRITE: io=32768MB, aggrb=3930.1MB/s, minb=503155KB/s, 
maxb=580687KB/s, mint=7223msec, maxt=8336msec
10/32768 -> WRITE: io=32768MB, aggrb=3965.2MB/s, minb=507539KB/s, 
maxb=599443KB/s, mint=6997msec, maxt=8264msec


Analysis:
-----------
- the amount of minimum stripe cache entries doesn't cause much 
variation as expected
- writing threads cause significant performance enhancement
- seen best results with 3 or 4 writing threads which correlates well to 
the # of stripes


Did you provide your fio job(s) for comparision yet?

Regards,
Heinz

P.S.: write performance tested with the following script:

#!/bin/sh

MD=md0

for s in 256 512 1024 2048 4096 8192 16384 32768
do
         echo $s > /sys/block/$MD/md/stripe_cache_size

         for t in {0..10}
         do
                 echo $t > /sys/block/$MD/md/group_thread_cnt
                 echo -n "$t/$s -> "
                 fio  --section=w-md0 fio_md0.job 2>&1|grep "aggrb="|sed 
's/^ *//'
         done
done



On 01/17/2017 04:28 PM, Jake Yao wrote:
> Thanks for the response.
>
> I am using fio for performance measurement.
>
> The chunk size of raid5 array is 32K, and the block size in fio is set
> to 96K(3x chunk size) which is also the optimal_io_size, ioengine is
> set to libaio with direct IO.
>
> Increasing stripe_cache_size does not help much, and it looks like the
> write is limited by the single kernel thread as mentioned earlier.
>
>
> On Tue, Jan 17, 2017 at 12:10 AM, Roman Mamedov <rm@romanrm.net> wrote:
>> On Mon, 16 Jan 2017 21:35:21 -0500
>> Jake Yao <jgyao1@gmail.com> wrote:
>>
>>> I have a raid5 array on 4 NVMe drives, and the performance on the
>>> array is only marginally better than a single drive. Unlike a similar
>>> raid5 array on 4 SAS SSD or HDD,  the performance on array is 3x
>>> better than a single drive, which is expected.
>>>
>>> It looks like when the single kernel thread associated with the raid
>>> device running at 100%, the array performance hit its peak. This can
>>> happen easily for fast devices like NVMe.
>>>
>>> This can reproduced by creating a raid5 with 4 ramdisks as well, and
>>> comparing performance on the array and one ramdisk. Sometimes the
>>> performance on the array is worse than a single ramdisk.
>>>
>>> The kernel version is 4.9.0-rc3 and mdadm is release 3.4, no write
>>> journal is configured.
>>>
>>> Is this a known issue?
>> How do you measure the performance?
>>
>> Sure it may be CPU-bound in the end, but also why not try the usual
>> optimization tricks, such as:
>>
>>    * increase your stripe_cache_size, it's not uncommon that this can speed up
>>      linear writes by as much as several times;
>>
>>    * if you meant reads, you could look into read-ahead settings for the array;
>>
>>    * and in both cases, try experimenting with different stripe sizes (if you
>>      were using 512K, try with 64K stripes).
>>
>> --
>> With respect,
>> Roman
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

