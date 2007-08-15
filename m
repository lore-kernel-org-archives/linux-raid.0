From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: SWAP file on a RAID-10 array possible?
Date: Thu, 16 Aug 2007 01:42:26 +0400
Message-ID: <46C37342.9080509@msgid.tls.msk.ru>
References: <c70ff3ad0708070116k20605787pf897f9eccc93cd65@mail.gmail.com><5b170a7d0708070126t52cb4be5x4549b22bac643450@mail.gmail.com><c70ff3ad0708070302g1d23f4c8qd53c230d4118fd51@mail.gmail.com><18104.18410.623573.929770@notabene.brown><c70ff3ad0708070332n33296a9cp719a6e1b8860ec4b@mail.gmail.com><c70ff3ad0708070346u4b538be9j6d1b5cf83f535de6@mail.gmail.com><18104.21737.341407.654022@notabene.brown><c70ff3ad0708070431v3ba47ab0j533197d92aea884c@mail.gmail.com> <18104.23111.369229.891505@notabene.brown> <02a201c7df1b$07dec720$332317ac@Cortex> <46C2D101.8050205@dgreaves.com> <02db01c7df27$04321c60$332317ac@Cortex>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <02db01c7df27$04321c60$332317ac@Cortex>
Sender: linux-raid-owner@vger.kernel.org
To: Tomas France <tomfra@centrum.cz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tomas France wrote:
> Thanks for the answer, David!
> 
> I kind of think RAID-10 is a very good choice for a swap file. For now I
> will need to setup the swap file on a simple RAID-1 array anyway, I just
> need to be prepared when it's time to add more disks and transform the
> whole thing into RAID-10... which will be big fun anyway, for sure ;)

By the way, you don't really need raid10 for swap.  Built-in linux
swap code can utilize multiple swap areas just fine - mkswap + swapon
on multiple devices/files.  This is essentially a raid0.  For raid10,
one thing needed is the mirroring, with is provided by raid1.  So
when you've two drives, use single partition on both to form a raid1
array for swap space.  If you've 4 drives, create 2 raid1 arrays and
specify them both as swap space, giving them appropriate priority
(prio=xxx in swap line in fstab).  With 6 drives, have 3 raid1 arrays
and so on...  This way, the whole thing is much simpler and more
manageable.

/mjt
