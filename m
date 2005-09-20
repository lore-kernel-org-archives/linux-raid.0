From: "George N. White III" <aa056@chebucto.ns.ca>
Subject: Re: Good, recent FS comparison?
Date: Tue, 20 Sep 2005 18:00:37 -0300 (ADT)
Message-ID: <Pine.LNX.4.63.0509201747360.12990@cerberus.cwmannwn.nowhere>
References: <432D3024.3080302@dtbb.net> <Pine.GSO.4.44L.0509181124430.23379-100000@unix2.cc.ksu.edu>
Reply-To: "George N. White III" <aa056@chebucto.ns.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.44L.0509181124430.23379-100000@unix2.cc.ksu.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Stegman <matts@ksu.edu>
Cc: Al Boldi <a1426z@gawab.com>, linux-fsdevel@vger.kernel.org, Linux RAID Mailing List <linux-raid@vger.kernel.org>, linux-xfs@oss.sgi.com
List-Id: linux-raid.ids

On Sun, 18 Sep 2005, Matt Stegman wrote:

> This has been discussed on the mailing list before.  Quick rundown:
>
> "Ordered mode" means that a file's metadata isn't written until after the
> file's data.  On XFS, which doesn't use ordered mode, under certain
> circumstances you may see files which are the correct size, with correct
> times, etc, but with only null bytes for the data.

Another way to look at this: in some case, e.g., transaction processing,
the priority is to make sure no data are lost.  The opposite situation is
where you have large volumes of data coming in, e.g., remote sensing,
rendering farms, big numerical simulations.  If something breaks you are
losing data until the system is back.  With XFS you have a consistent 
filesystem immediately, but you may want to look carefully at the files
being written when the problem occurred.

> In my experience it's not that big a deal; I can almost always easily
> recreate data which could be lost by being written out just before a crash
> or power loss.  I put important systems on an UPS and use stable kernels,
> and I've never personally seen the null data problem.

Clients and other data sources like satellite dishes often break at
inconvenient times.

Write a large structured file like hdf from an NFS client and pull the
network plug or turn off the client when the client job finishes but 
before the data has all been written.  You should endup with a consistent
filesystem but a sparse file.

> Currently, I believe only ext3 and reiserfs support ordered mode.  I'm not
> sure if reiser4's journaling is ordered or not.

I don't thnk you can make a blanket statement -- different horses for 
different courses.

-- 
George N. White III  <aa056@chebucto.ns.ca>

