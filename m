From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Nvidia Raid5 Failure
Date: Mon, 14 Apr 2014 01:14:05 -0500
Message-ID: <534B7CAD.3080908@hardwarefreak.com>
References: <DUB122-W521994A2683B8CBD327D3DA3550@phx.gbl> <CAK_KU4ZHZik=_=2=fMPW1c_y-xc0DW_9=ucsYQXU2e=eSOtYQg@mail.gmail.com> <CACJz6QtoddN1nOcfzeJeV-09j+t9fhT=E2a17Ppxq4gXpZDcVA@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACJz6QtoddN1nOcfzeJeV-09j+t9fhT=E2a17Ppxq4gXpZDcVA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/13/2014 11:42 AM, Drew wrote:
> On Thu, Apr 10, 2014 at 7:36 AM, Scott D'Vileskis <sdvileskis@gmail.com> wrote:
>> <snip>  I
>> would also advise against what is known as 'fake raid' controllers
>> like your NVIDIA hardware likely is, (or Promise, highpoint, Intel,
>> etc)  because it can be difficult to recover data if you have a
>> controller/mobo failure without exact hardware.
> 
> Agree on the staying away from fake-RAID. One thing I will point out
> for reference tho, is that not *all* Intel RAID is fakeraid. The
> onboard RAID built into Intel's ICH family certainly is. However Intel
> does make a line of RAID controller daughter cards which are rebadged
> LSI RAID controllers and are in fact true H/W RAID. Easiest way to
> know is to see if the card supports SAS. If it does, chances are it's
> a H/W RAID card.

The term "hardware RAID" is no longer appropriate as a means of
classifying or describing the capability or performance of an HBA, and
ceased to be quite a few years ago.

All of the Intel mezzanine cards and PCIe HBAs use LSI SAS ASICs and LSI
RAID firmware. In that sense they are "hardware RAID" controllers as the
RAID software executes on the ASIC, not the host.  However more than
half of them lack DRAM.  Those without DRAM do not and cannot support
[F|B|]BWC.  Without BBWC you lose two features that are really the
defining characteristics of what we used to call a "hardware RAID"
controller.

1.  Early ACK.  Without BBWC the ASIC firmware cannot buffer small
random IOs and it cannot ACK command completion for sync, fsync,
O_DIRECT, etc writes.  Additionally one cannot disable barriers in
filesystems.  BBWC enhances the performance of such workloads
dramatically by reducing latency.

2.  Writeback.  Some of Intel's DRAM-less RAID solutions, just like
their LSI counterparts, support RAID5.  Without on board DRAM these
controllers cannot perform efficient writeback of RMW operations because
there is no read cache.  This would be roughly equivalent to hacking
md/RAID5 to use a stripe_cache_size of 0.  Using RAID5 with one of these
controllers most often yields lower IOPS/throughput than a single disk.

Better classification for the current era:

1.  RAID controller - ASIC firmware, BBWC
2.  HBA w/RAID      - ASIC firmware, cache less
3.  Fake-RAID       - host software


Cheers,

Stan
