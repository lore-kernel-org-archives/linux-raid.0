From: Tommy Apel <tommyapeldk@gmail.com>
Subject: Re: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840 PRO
Date: Sun, 21 Apr 2013 14:23:48 +0200
Message-ID: <CAGA4a+EMvLJMqufWjfmze9FZ_sDRBE0SCbOe0UYXRNOLU=DUTw@mail.gmail.com>
References: <5171CBF9.9020701@redhost.ro>
	<CAH3kUhEaZGON=fAyVMZOz5fH_DcfKv=hCa96UCeK4pN7k81c_Q@mail.gmail.com>
	<51725458.7020109@redhost.ro>
	<CAH3kUhHxBiqugFQm=PPJNNe9jOdKy0etUjQNsoDz_LJNUCLCCQ@mail.gmail.com>
	<51732422.1050109@redhost.ro>
	<5173536C.2040108@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5173536C.2040108@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Andrei Banu <andrei.banu@redhost.ro>, linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello, FYI I'm getting ~68MB/s on two intel330 in RAID1 aswell on
vanilla 3.8.8 and 3.9.0-rc3 when writing random data and ~236MB/s
writing from /dev/zero

mdadm -C /dev/md0 -l 1 -n 2 --assume-clean --force --run /dev/sdb /dev/sdc
openssl enc -aes-128-ctr -pass pass:"$(dd if=/dev/urandom bs=128
count=1 2>/dev/null | base64)" -nosalt < /dev/zero | pv -pterb >
/run/fill ~1.06GB/s
dd if=/run/fill of=/dev/null bs=1M count=1024 iflag=fullblock ~5.7GB/s
dd if=/run/fill of=/dev/md0 bs=1M count=1024 oflag=direct ~68MB/s
dd if=/dev/zero of=/dev/md0 bs=1M count=1024 oflag=direct ~236MB/s

iostat claiming 100% util on both drives when doing so, running both
deadline and noop scheduler,
doing the same with 4 threads and offset by 1.1GB on the disk and
taske set to 4 cores makes no difference, still ~68MB/s with random
data
# for x in `seq 0 4`; do taskset -c $x dd if=/run/fill of=/dev/md0
bs=1M count=1024 seek=$(($x * 1024)) oflag=direct & done

/Tommy

2013/4/21 Stan Hoeppner <stan@hardwarefreak.com>:
> On 4/20/2013 6:26 PM, Andrei Banu wrote:
>
>> They are connected through SATA2 ports (this does explain the read speed
>> but not the pitiful write one) in AHCI.
>
> These SSDs are capable of 500MB/s, and cost ~$1000 USD.  Spend ~$200 USD
> on a decent HBA.  The 6G SAS/SATA LSI 9211-4i seems perfectly suited to
> your RAID1 SSD application.  It is a 4 port enterprise JBOD HBA that
> also supports ASIC level RAID 1, 1E, 10.
>
> Also, the difference in throughput your show between RAID maintenance,
> direct device access, and filesystem access suggests you have something
> running between the block and filesystem layers, for instance LUKS.
> Though LUKS alone shouldn't hammer your CPU and IO throughput so
> dramatically.  However, if the SSDs do compression or encryption
> automatically, and I believe the 840s do, the LUKS encrypted blocks may
> cause the SSD firmware to take considerably more time to process the blocks.
>
> --
> Stan
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
