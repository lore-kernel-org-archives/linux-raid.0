From: Alireza Haghdoost <alireza@cs.umn.edu>
Subject: Re: clustered MD - beyond RAID1
Date: Mon, 21 Dec 2015 20:29:56 -0600
Message-ID: <CAB-428=ekQPx_ia1Xtx-hDTX8squ2W9ZN5YrVgf=4nbW2erMhQ@mail.gmail.com>
References: <56742652.5040304@nasa.gov> <87si2w66tm.fsf@notabene.neil.brown.name>
 <567850C4.30108@bnl.gov> <87bn9j4jhr.fsf@notabene.neil.brown.name>
 <56786EA4.2020209@bnl.gov> <8737uv4fz6.fsf@notabene.neil.brown.name> <5678A908.6070401@bnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5678A908.6070401@bnl.gov>
Sender: linux-raid-owner@vger.kernel.org
To: Tejas Rao <raot@bnl.gov>
Cc: NeilBrown <neilb@suse.de>, Scott Sinno <scott.sinno@nasa.gov>, Linux RAID <linux-raid@vger.kernel.org>, "Knister, Aaron S. (GSFC-606.2)[COMPUTER SCIENCE CORP]" <aaron.s.knister@nasa.gov>
List-Id: linux-raid.ids

On Mon, Dec 21, 2015 at 7:36 PM, Tejas Rao <raot@bnl.gov> wrote:
>
> We currently have 10's of petabytes in production using linux md raid. We
> are currently not sharing md devices, only hardware raid block devices are
> shared. In our experience hardware raid controllers are expensive. Linux
> raid has worked well over the years and performance is very good as GPFS
> coalesces I/O in large filesystem blocksize blocks (8MB) and if aligned
> properly eliminate RMW (doing full stripe writes) and the need for NVRAM
> (unless someone is doing POSIX fsync).
>

Full Stripe Write does not eliminate the need for NVRAM. Stored data
under MD RAID-6 is vulnerable to write-hole data corruption issue.
Yes, hardware RAID controllers are expensive because they would
provide more data reliability and high-availibiltiy that might not be
useful for this use case.

--Alireza
