From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-10 keeps aborting
Date: Sun, 02 Jun 2013 23:06:59 -0700
Message-ID: <51AC3283.4000403@zytor.com>
References: <51AC1440.7020505@zytor.com> <CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/02/2013 10:47 PM, Dan Williams wrote:
> 
> One hack to prove this may be to explicitly disable write_same before
> the array is assembled:
> 
> for i in /sys/class/scsi_disk/*/max_write_same_blocks; do echo 0 > $i; done
> 
> If this works then maybe md needs to be tolerant of write_same
> failures since the block layer will simply retry with zeroes.
> 

Trying that (array is already assembled but is currently functional.)
Let's hope it works.

	-hpa


