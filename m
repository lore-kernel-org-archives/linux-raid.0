From: Stan Hoeppner <stan@hardwarefreak.org>
Subject: Re: performance collapse: 9 mio IOPS to 1.5 mio with MD RAID0
Date: Wed, 25 Jan 2017 17:01:34 -0600
Message-ID: <1d766141-465b-34f2-dbd6-b7f71ecc344c@hardwarefreak.org>
References: <ebf6cf62-b877-251f-5704-c5c6238a4b91@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ebf6cf62-b877-251f-5704-c5c6238a4b91@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tobias Oberstein <tobias.oberstein@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/25/2017 05:45 AM, Tobias Oberstein wrote:
> Hi,
>
> I have a storage consisting of 8 NVMe drives (16 logical drives) that 
> I verified (FIO) is able to do >9 million 4kB random read IOPS if I 
> run FIO on the set of individual NVMes.
>
> However, when I create a MD (RAID-0) over the 16 NVMes and run the 
> same tests, performance collapses:
>
> ioengine=sync, invidual NVMes: IOPS=9191k
> ioengine=sync, MD (RAID-0) over NVMes: IOPS=1562k
>
> Using ioengine=psync, the performance collapse isn't as dramatic, but 
> still very signifcant:
>
> ioengine=sync, invidual NVMes: IOPS=9395k
> ioengine=sync, MD (RAID-0) over NVMes: IOPS=4117k
>
> -- 
>
> All detail results (including runs under Linux perf) and FIO control 
> files are here
>
> https://github.com/oberstet/scratchbox/tree/master/cruncher/sync-engines-perf 
>
>

You don't need 1024 jobs to fill the request queues.  Just out of 
curiosity, what are the fio results when using fewer jobs and a greater 
queue depth, say one job per core, 88 total, with a queue depth of 32?

osq_lock appears to be a per cpu opportunistic spinlock.  Might be of 
benefit to try even fewer jobs for fewer active cores.

> -- 
>
> With sync/MD, top in perf is
>
>   82.77%  fio      [kernel.kallsyms]   [k] osq_lock
>    3.12%  fio      [kernel.kallsyms]   [k] nohz_balance_exit_idle
>    1.40%  fio      [kernel.kallsyms]   [k] trigger_load_balance
>    1.01%  fio      [kernel.kallsyms]   [k] 
> native_queued_spin_lock_slowpath
>
>
> With psync/MD, top in perf is
>
>   45.56%  fio      [kernel.kallsyms]   [k] md_make_request
>    4.33%  fio      [kernel.kallsyms]   [k] osq_lock
>    3.40%  fio      [kernel.kallsyms]   [k] 
> native_queued_spin_lock_slowpath
>    3.23%  fio      [kernel.kallsyms]   [k] _raw_spin_lock
>    2.21%  fio      [kernel.kallsyms]   [k] raid0_make_request
>
> -- 
>
> Of course there isn't a free lunch, but a performance collapse in this 
> order for a RAID-0, that is pure striping, seems excessive.
>
> What's going on?
>
> Cheers,
> /Tobias
>
>
> MD device was created like this:
>
> sudo mdadm --create /dev/md1 \
>   --chunk=8 \
>   --level=0 \
>   --raid-devices=16 \
>   /dev/nvme0n1 \
>   /dev/nvme1n1 \
>   /dev/nvme2n1 \
>   /dev/nvme3n1 \
>   /dev/nvme4n1 \
>   /dev/nvme5n1 \
>   /dev/nvme6n1 \
>   /dev/nvme7n1 \
>   /dev/nvme8n1 \
>   /dev/nvme9n1 \
>   /dev/nvme10n1 \
>   /dev/nvme11n1 \
>   /dev/nvme12n1 \
>   /dev/nvme13n1 \
>   /dev/nvme14n1 \
>   /dev/nvme15n1
>
> The NVMes are low-level formatted with 4k sectors. Before, I had 512 
> bytes (default), and the perf. collapse was even more dramatic.
>
> The chunk size of 8k is used because this is supposed to carry 
> database workloads later.
>
> My target workload is PostgreSQL which is 100% 8k and lseek/read/write 
> (not using pread/pwrite or pvread/pvwrite etc).
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

