From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: SSD & mechanical disc in RAID 1
Date: Sat, 9 Jan 2010 21:23:26 +0200
Message-ID: <20100109192326.GB16383@rap.rap.dk>
References: <7a329d911001090953j17829cd9qca0888fbcd7b4805@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7a329d911001090953j17829cd9qca0888fbcd7b4805@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Wil Reichert <wil.reichert@gmail.com>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Jan 09, 2010 at 09:53:11AM -0800, Wil Reichert wrote:
> Has anyone ever tried putting an SSD and a mechanical disc in RAID 1
> using write-mostly?  The goal would be to extol the speed & latency
> virtues of an SSD while retaining the integrity of the traditional
> storage.  Would this setup even work as I expect it to?


I think you are better served by trying out RAID10 in the far or offset
layouts. RAID1 would per se not gain from the low latency times of 
SSD. RAID1 should function the same with hard disk as with SSD, 
and with hard disk it would not make sense to multiplex reading
of a file, as skipping and reading a block essentially takes the same
time.

Best regards
Keld
