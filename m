From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Postgres on RAID5
Date: Wed, 16 Mar 2005 19:55:49 +0300
Message-ID: <42386515.1070103@tls.msk.ru>
References: <4231F5F2.6000509@m-cam.com> <Pine.LNX.4.58.0503160947080.11922@lewis.et.byu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <Pine.LNX.4.58.0503160947080.11922@lewis.et.byu.edu>
Sender: linux-raid-owner@vger.kernel.org
To: David Dougall <davidd@et.byu.edu>
Cc: Arshavir Grigorian <ag@m-cam.com>, linux-raid@vger.kernel.org, pgsql-performance@postgresql.org
List-Id: linux-raid.ids

David Dougall wrote:
> In my experience, if you are concerned about filesystem performance, don't
> use ext3.  It is one of the slowest filesystems I have ever used
> especially for writes.  I would suggest either reiserfs or xfs.

I'm a bit afraid to start yet another filesystem flamewar, but.
Please don't make such a claims without providing actual numbers
and config details.  Pretty please.

ext3 performs well for databases, there's no reason for it to be
slow.  Ok, enable data=journal and use it with eg Oracle - you will
see it is slow.  But in that case it isn't the filesystem to blame,
it's operator error, simple as that.

And especially reiserfs, with its tail packing enabled by default,
is NOT suitable for databases...

/mjt
