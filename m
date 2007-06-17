From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: limits on raid
Date: Sun, 17 Jun 2007 15:30:25 -0400
Message-ID: <20070617193025.GA8770@animx.eu.org>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm> <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown> <20070616020320.GB2002@animx.eu.org> <18035.23867.576212.859440@notabene.brown> <20070616140857.GA4206@animx.eu.org> <Pine.LNX.4.64.0706161845180.24938@twinlark.arctic.org> <20070617132809.GB7806@animx.eu.org> <Pine.LNX.4.64.0706171019490.24938@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706171019490.24938@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: Neil Brown <neilb@suse.de>, david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

dean gaudet wrote:
> On Sun, 17 Jun 2007, Wakko Warner wrote:
> 
> > > i use an external write-intent bitmap on a raid1 to avoid this... you 
> > > could use internal bitmap but that slows down i/o too much for my tastes.  
> > > i also use an external xfs journal for the same reason.  2 disk raid1 for 
> > > root/journal/bitmap, N disk raid5 for bulk storage.  no spindles in 
> > > common.
> > 
> > I must remember this if I have to rebuild the array.  Although I'm
> > considering moving to a hardware raid solution when I upgrade my storage.
> 
> you can do it without a rebuild -- that's in fact how i did it the first 
> time.
> 
> to add an external bitmap:
> 
> mdadm --grow --bitmap /bitmapfile /dev/mdX
> 
> plus add "bitmap=/bitmapfile" to mdadm.conf... as in:
> 
> ARRAY /dev/md4 bitmap=/bitmap.md4 UUID=dbc3be0b:b5853930:a02e038c:13ba8cdc

I used evms to setup mine.  I have used mdadm in the past.  I use lvm ontop
of it which evms makes it a little easier to maintain.  I have 3 arrays
total (only the raid5 was configured by evms, the other 2 raid1s were done
by hand)

> you can also easily move an ext3 journal to an external journal with 
> tune2fs (see man page).

I only have 2 ext3 file systems (One of which is mounted R/O since it's
full), all my others are reiserfs (v3).

What benefit would I gain by using an external journel and how big would it
need to be?

> if you use XFS it's a bit more of a challenge to convert from internal to 
> external, but see this thread:

I specifically didn't use XFS (or JFS) since neither one at the time could
be shrinked.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
