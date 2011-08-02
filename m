From: Alex <mysqlstudent@gmail.com>
Subject: Re: Assembling array with missing members
Date: Tue, 2 Aug 2011 00:26:05 -0400
Message-ID: <CAB1R3sjkQmObHVJ+EReL6kPH=3yLoNp3O0t3KK7YURZknoVEKQ@mail.gmail.com>
References: <CAB1R3siG=FOXXq5kRx5N8O7ExCiM=0ic0xakYpfKZH1FOROXoQ@mail.gmail.com>
	<CAB1R3sjuUEVAPLgGNdnwnyHVir3bEGOT9iOSdYBz+QSs+2fhaA@mail.gmail.com>
	<4E3673C2.7070607@anonymous.org.uk>
	<CAB1R3siEvHsK9nYUpbe7_Z8B08cvXVX=xd-w0BVybsrO6NojBQ@mail.gmail.com>
	<alpine.DEB.2.00.1108011316040.4709@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1108011316040.4709@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

>> I've tried this, but it complains about the system not being shut down
>> cleanly. Should I just force it?
>
> Check so that the event count is fairly ok on all components (doesn't differ
> too much), and then --force it. It's not that you have much choice
> currently, but that's a good sanity check.

Thanks so much for your help. I've managed to add the new disk and
make the whole array active. Took about 6hrs at 35MB/s to sync. I'm
now copying all 1.5TB to a remote server and will rebuild it from
scratch.

Thanks again,
Alex
