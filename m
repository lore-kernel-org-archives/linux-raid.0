From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: md road-map: 2011
Date: Fri, 18 Feb 2011 20:18:20 +0100
Message-ID: <20110218191820.GA2517@www2.open-std.org>
References: <20110217010455.GA16324@www2.open-std.org> <ijiu99$ill$1@dough.gmane.org> <20110217105815.GA24580@www2.open-std.org> <4D5D0A66.80608@texsoft.it> <20110217154440.GA24982@www2.open-std.org> <4D5DB9AC.10106@texsoft.it> <20110218025623.GA26387@www2.open-std.org> <4D5E4030.8020805@texsoft.it> <20110218184329.GA2297@www2.open-std.org> <AANLkTinYkEsaWinaz4LaOBpT36+fpizCSFO=AfH7sWEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTinYkEsaWinaz4LaOBpT36+fpizCSFO=AfH7sWEA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>, Giovanni Tessore <giotex@texsoft.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 18, 2011 at 05:00:27PM -0200, Roberto Spadim wrote:
> again... for realloc we need TRIM command or reserved sectors just for
> bad block realloc, TRIM command tell MD what sector isn?t in use, at
> WRITE command MD set the sector as inuse, at array creation md set
> sector as inuse too. this will only work with ext4 and swap, others
> filesystem don?t have TRIM. the solution of others filesystem are
> based on not used block, but it?s a internal logic of each filesystem.
> i don?t know what is best, TRIM command is nice (we can send TRIM to
> disks, this help to make their life bigger) a bad block is a disk
> getting smaller and smaller, the disk can realloc badblock. if it
> cant, filesystem should realloc it (it have more information about
> logic device, it shouldn?t, TRIM command is the information that disk
> should have to discart blocks, not a filesystem logic, but... it?s a
> option, filesystem can realloc)

I think I prefer a realloc area in the raid metadata area. And the
metadata area could be contaning a not-too-small realloc area, with an
option of enlarging the realloc area at a later time. This could be done
by shrinking the related file system, and then adding the freed space to
the realloc area in the raid metadata. 

Some MBs set aside for this would not be noticeable in todays TB disks
regime. I think current disk hardware allows relocation of under 1000
blocks a 512 byte = under 512 kB. So no problem sizewise.
Performance may be a bigger problem.  Maybe some binary searcheable list
built at MD RAID assembly time.

best regards
keld
