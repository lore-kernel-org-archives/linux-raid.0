From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Spares and partitioning huge disks
Date: Sun, 9 Jan 2005 18:52:26 +0100
Message-ID: <qj78b2-jqk.ln1@news.it.uc3m.es>
References: <200501091623.j09GNG917488@www.watkins-home.com> <41E15D73.9020203@tls.msk.ru>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev <mjt@tls.msk.ru> wrote:
> I think all modern drives support bad block remapping on both read and write.
> But think about it: if there's a read error, it means the drive CAN NOT read
> the "right" data for some reason (for some definition of "right" anyway) --
> ie, the drive "knows" there's some problem with the data and it can't

I really don't want RAID to fault the disk offline in this case.  I want
RAID to read from the other disk(s) instead, and rewrite the data on the
disk that gave the fail notice on that sector, and if that gives no error,
then just carry on and be happy ...

Peter

