From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Assembling array with missing members
Date: Mon, 1 Aug 2011 13:17:10 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1108011316040.4709@uplift.swm.pp.se>
References: <CAB1R3siG=FOXXq5kRx5N8O7ExCiM=0ic0xakYpfKZH1FOROXoQ@mail.gmail.com> <CAB1R3sjuUEVAPLgGNdnwnyHVir3bEGOT9iOSdYBz+QSs+2fhaA@mail.gmail.com> <4E3673C2.7070607@anonymous.org.uk> <CAB1R3siEvHsK9nYUpbe7_Z8B08cvXVX=xd-w0BVybsrO6NojBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB1R3siEvHsK9nYUpbe7_Z8B08cvXVX=xd-w0BVybsrO6NojBQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex <mysqlstudent@gmail.com>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 1 Aug 2011, Alex wrote:

> I've tried this, but it complains about the system not being shut down
> cleanly. Should I just force it?

Check so that the event count is fairly ok on all components (doesn't 
differ too much), and then --force it. It's not that you have much choice 
currently, but that's a good sanity check.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
