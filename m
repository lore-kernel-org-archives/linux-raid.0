From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Thu, 10 Dec 2015 14:09:54 -0600
Message-ID: <CAE9DZUSNkLxaKH8MtggW+5_uo38CHRTcscvh7Kk-VTb_zWPQ4g@mail.gmail.com>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
	<5669DB3B.30101@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5669DB3B.30101@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Dec 10, 2015 at 2:06 PM, Phil Turmel <philip@turmel.org> wrote:
> On 12/09/2015 08:34 PM, Dallas Clement wrote:
>> Hi all.  I'm trying to determine best and worst case expected
>> sequential write speeds for Linux software RAID with spinning disks.
>>
>> I have been assuming on the following:
>>
>> Best case RAID 6 sequential write speed is (N-2) * X, where is is
>> number of drives and X is write speed of a single drive.
>>
>> Worst case RAID 6 sequential write speed is (N-2) * X / 2.
>>
>> Best case RAID 5 sequential write speed is (N-1) * X.
>>
>> Worst case RAID 5 sequential write speed is (N-1) * X / 2.
>>
>> Could someone please confirm whether these formulas are accurate or not?
>
> Confirm these?  No.  In fact, I see no theoretical basis for stating a
> worst case speed as half the best case speed.  Or any other fraction.
> It's dependent on numerous variables -- block size, processor load, I/O
> bandwidth at various choke points (Northbridge, southbridge, PCI/PCIe,
> SATA/SAS channels, port mux...), I/O latency vs. queue depth vs. drive
> buffers, sector positioning at block boundaries, drive firmware
> housekeeping, etc.
>
> Where'd you get the worst case formulas?
>

> Where'd you get the worst case formulas?

Google search I'm afraid.  I think the assumption for RAID 5,6 worst
case is having to read and write the parity + data every cycle.
