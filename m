From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Spares and partitioning huge disks
Date: Sun, 09 Jan 2005 20:59:51 +0300
Message-ID: <41E17117.2090500@tls.msk.ru>
References: <200501091623.j09GNG917488@www.watkins-home.com> <41E15D73.9020203@tls.msk.ru> <qj78b2-jqk.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <qj78b2-jqk.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer wrote:
> Michael Tokarev <mjt@tls.msk.ru> wrote:
> 
>>I think all modern drives support bad block remapping on both read and write.
>>But think about it: if there's a read error, it means the drive CAN NOT read
>>the "right" data for some reason (for some definition of "right" anyway) --
>>ie, the drive "knows" there's some problem with the data and it can't
> 
> I really don't want RAID to fault the disk offline in this case.  I want
> RAID to read from the other disk(s) instead, and rewrite the data on the
> disk that gave the fail notice on that sector, and if that gives no error,
> then just carry on and be happy ...

There where some patches posted to this list some time ago that tries to
do just that (or a discussion.. i don't remember).  Yes, md code currently
doesn't do such things, and fails a drive after the first error -- it's
the simplest way to go ;)

/mjt
