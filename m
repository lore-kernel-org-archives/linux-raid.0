From: "Norman Elton" <normelton@gmail.com>
Subject: Re: Raid over 48 disks ... for real now
Date: Thu, 17 Jan 2008 11:32:21 -0500
Message-ID: <6b3a7f010801170832y15237aa4n83c4817c1ee2acad@mail.gmail.com>
References: <6b3a7f010801170819o59533c39qf4dada60a6f8701@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6b3a7f010801170819o59533c39qf4dada60a6f8701@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> Hi, sounds like a monster server. I am interested in how you will make
>> the space useful to remote machines- iscsi? this is what I am
>> researching currently.

Yes, it's a honker of a box. It will be collecting data from various
"collector" servers. The plan right now is to collect the file to
binary files using a daemon (already running on a smaller box), then
make the last 30/60/90/?? days available in a database that is
populated from these files. If we need to gather older data, then the
individual files must be consulted locally.

So, in production, I would probably setup the database partition on
it's own set of 6 disks, then dedicate the rest to handling/archiving
the raw binary files. These files are small (a few MB each), as they
get rotated every five minutes.

Hope this makes sense, and provides a little background info on what
we're trying to do.

Norman
