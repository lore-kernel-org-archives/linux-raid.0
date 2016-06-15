From: "John Stoffel" <john@stoffel.org>
Subject: Re: Failure propagation of concatenated raids ?
Date: Tue, 14 Jun 2016 21:37:42 -0400
Message-ID: <22368.45414.256389.605050@quad.stoffel.home>
References: <CAAkR8+s1=P5+4w0JBLs71DFtqQiD+x4mssjvL4utmb0HGOfLEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAkR8+s1=P5+4w0JBLs71DFtqQiD+x4mssjvL4utmb0HGOfLEg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nicolas Noble <nicolas@nobis-crew.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Nicolas>   I have a somewhat convoluted question, which may take me
Nicolas> some lines to explain, but the TL;DR version of it is
Nicolas> somewhat along the lines of "How can I safely concatenate two
Nicolas> raids into a single filesystem, and avoid drastic corruption
Nicolas> when one of the two underlying raids fails and goes read only
Nicolas> ?" I have done extensive research about that, but I haven't
Nicolas> been able to get any answer to it.

You can't basically.  When half your filesystem goes away, or
randomlly readonly, you're screwed.  

If you're trying to take smaller chunks and make it so that data can
span and balance across them without your having to do it, then it
*might* make sense to look at ceph or some other distributed
filesystem.  Having the data spread across multiple backends, with
redundancy, is possible, but once too much of the underlying device(s)
goes away, no filesystem I know handles that without either going
readonly, or totally locking up.

