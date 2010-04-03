From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Linux Raid performance
Date: Fri, 2 Apr 2010 17:39:45 -0700
Message-ID: <l2j5bdc1c8b1004021739z969b99v6011fcc6fddd470a@mail.gmail.com>
References: <r2v7efa8a7d1003311242vfa92024ar93ad2123a7b49806@mail.gmail.com>
	 <20100331201539.GA19395@rap.rap.dk>
	 <g2s7efa8a7d1004012007ibe8b42b6k28a6d2a531fb6103@mail.gmail.com>
	 <20100402110506.GA16294@rap.rap.dk>
	 <x2q7efa8a7d1004021055oe2e832ccl8877e9171b8f3442@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <x2q7efa8a7d1004021055oe2e832ccl8877e9171b8f3442@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Learner Study <learner.study@gmail.com>
Cc: linux-raid@vger.kernel.org, keld@dkuug.dk
List-Id: linux-raid.ids

On Fri, Apr 2, 2010 at 10:55 AM, Learner Study <learner.study@gmail.com> wrote:
<SNIP>
>
> 2. Secondly, I would like to understand how raid stack (md driver)
> scales as we add more cores...if single core gives ~500MB/s, can two
> core give ~1000MB/s? can four cores give ~2000MB/s? etc....
<SNIP>

More cores by themselves certainly won't do it for you.

1) More disks in parallel. (striped data)

2) More ports to attach those drives.

3) More bandwidth on those ports. SATA3 is better than SATA2 is better
than SATA is better than PATA, etc. (Obviously disks must match ports,
right? SATA1 disks on SATA3 ports isn't the right thing...)

4) More bus bandwidth getting to those ports. PCI-Express16 is better
than PCI-Express1 is better than PCI, etc.

5) Faster RAID architectures for the number of disks chosen.

Once all of that is in place then possibly more cores will help, but I
suspect even then it probably hard to use 4 billion CPU cycles/second
doing nothing but disk I/O. SATA controllers are all doing DMA so CPU
overhead is relatively *very* low.

HTH,
Mark
