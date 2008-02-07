From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: raid5: two writing algorithms
Date: Thu, 7 Feb 2008 17:13:38 +0100
Message-ID: <20080207161337.GA6044@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

As I understand it, there are 2 valid algoritms for writing in raid5.

1. calculate the parity data by XOR'ing all data of the relevant data
chunks.

2. calculate the parity data by kind of XOR-subtracting the old data to
be changed, and then XOR-adding the new data. (XOR-subtract and XOR-add
is actually the same).

There are situations where method 1 is the fastest, and situations where
method 2 is the fastest.

My idea is then that the raid5 code in the kernel can calculate which
method is the faster. 

method 1 is faster, if all data is already available. I understand that
this method is employed in the current kernel. This would eg be the case
with sequential writes.

Method 2 is faster, if no data is available in core. It would require
2 reads and two writes, which always will be faster than n reads and 1
write, possibly except for n=2. method 2 is thus faster normally for
random writes.

I think that method 2 is not used in the kernel today. Mayby I am wrong,
but I did have a look in the kernel code.

So I hereby give the idea for inspiration to kernel hackers.

Yoyr kernel hacker wannabe
keld
