From: Dominic Raferd <dominic@timedicer.co.uk>
Subject: Re: SSD + Rust as raid1
Date: Fri, 31 May 2013 08:47:00 +0100
Message-ID: <51A85574.8080709@timedicer.co.uk>
References: <51A7C36F.4030605@timedicer.co.uk> <20130531133018.77cd9285@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130531133018.77cd9285@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 31/05/2013 08:30, Roman Mamedov wrote:
> On Thu, 30 May 2013 22:23:59 +0100
> Dominic Raferd <dominic@timedicer.co.uk> wrote:
>
>> I am wanting to (re)set up my raid1 array with 1 SSD partition
>> (/dev/sda2) and 1 'rust' drive partition (/dev/sdb1) , both 240GB. SSD
> Sorry but what is "Rust drive partition"? At first I thought it's some
> software layer like 'bcache' or some other non-regular block device. Then I
> think I got it, but can you please leave at home your own petty cutesy
> terminology when asking a serious question on a serious mailing list?

Sorry no offence intended! I just mean a conventional spinning platter 
hard disk drive.

> And yes I use a HDD+SSD RAID1 for a very long time, to get some improvement
> (though debatable how much) you can also mark the HDD as "write-mostly"
> (see man md).

This is my idea too (see my OP), but I am concerned about optimisation 
(--write-behind, --bitmap and --bitmap-chunk settings) especially for 
writes.

