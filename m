From: Linux Raid Study <linuxraid.study@gmail.com>
Subject: Re: Raid5 Read Perf drop in 2.6.27
Date: Wed, 9 Sep 2009 18:45:31 -0700
Message-ID: <f5d1f90a0909091845t744ce5cerdf00fd656ff21c09@mail.gmail.com>
References: <f5d1f90a0909091554u6d40b402ga7e9f58cabf21b57@mail.gmail.com>
	 <70ed7c3e0909091652m60b0ea9cp7000db919a639c35@mail.gmail.com>
	 <f5d1f90a0909091817g667d211djcf767714740102d@mail.gmail.com>
	 <70ed7c3e0909091827i745e2e38u6f8e246a0c9a49f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909091827i745e2e38u6f8e246a0c9a49f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I build/compile my own kernel..

Have you done any benchmarks for Read RAID5 perf?

Thanks!

On 9/9/09, Majed B. <majedb@gmail.com> wrote:
> Well, that's my point. To make sure that your kernels are identical in
>  options, compare the .config files found in /usr/src/linux-<version>
>
>  You may find changes and differences in areas like bluetooth,
>  wireless, ...etc. These don't matter.
>
>  Did you compile your own kernel, or are you using one compiled for a
>  specific distro?
>
>  On Thu, Sep 10, 2009 at 4:17 AM, Linux Raid
>
> Study<linuxraid.study@gmail.com> wrote:
>  > Yes - the setup is the same. The only thing that changes is the kernel.
>  >
>  > I have 4 HDDs (2 from WD VelociRaptor 150GB/10k RPM and 2 from Seagate
>  > 320GB/7.2k RPM).  The HDDs are connected using two Silicon Image SATA
>  > controllers (Sil3132) connected to my host using PCIe.
>  >
>  > I use the default kernel scheduling scheme.
>  >
>  > Thanks!
>  >
>  > On 9/9/09, Majed B. <majedb@gmail.com> wrote:
>  >> Are you sure you're using the same Kernel Scheduler on both kernels?
>  >>
>  >>  Have you checked and verified that the same drivers are being loaded?
>  >>  (IDE vs. AHCI -- proprietary drivers vs. open source)
>  >>
>  >>  This is interesting!
>  >>
>  >>
>  >>  On Thu, Sep 10, 2009 at 1:54 AM, Linux Raid
>  >>  Study<linuxraid.study@gmail.com> wrote:
>  >>  > Hello:
>  >>  >
>  >>  > I'm benchmarking RAID5 Read performance with 4 disks and notice perf
>  >>  > drop when using kernel 2.6.27.
>  >>  > The perf with 2.6.27 is 150MB/s whereas with kernel 2.6.21 (and same
>  >>  > setup), the perf is 180MB/s/
>  >>  >
>  >>  >
>  >>  >
>  >>  > Some of the tests I have done:
>  >>  > 1. I ran  experiments using iozone also but notice that READ perf with
>  >>  > RAID5 in 2.6.27 is ~30% less as compared to 2.6.21.
>  >>  > Write perf is similar but Read is an issue.
>  >>  >
>  >>  > 2. On 2.6.27, I played around with chunk size and blocksize parameters
>  >>  > and got ~5% improvement but not much. I used following cmds:
>  >>  >
>  >>  > #mdadm --create /dev/md0 --level=5 --assume-clean --raid-devices=4
>  >>  > /dev/sda /dev/sdb /dev/sdc /dev/sdd --chunk=32
>  >>  > #mke2fs -b 4096 -E stride=8 /dev/md0
>  >>  >
>  >>  > #time dd if=/dev/md0 of=/dev/null bs=94208 count=1024
>  >>  >
>  >>  >
>  >>  > Is this perf drop a known issue? Can someone please recommend some
>  >>  > performance tuning tips?
>  >>  >
>  >>  > Thanks a lot for your time and help!
>  >>
>  >> > --
>  >>  > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>  >>  > the body of a message to majordomo@vger.kernel.org
>  >>  > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  >>  >
>  >>
>  >>
>  >>
>  >>  --
>  >>
>  >>        Majed B.
>  >>
>  >
>
>
>
>
> --
>
>        Majed B.
>
