From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: blog entry on RAID limitation
Date: Sat, 21 Jan 2006 18:50:29 -0200
Message-ID: <17362.40597.2229.222073@fisica.ufpr.br>
References: <8E5ACAE05E6B9E44A2903C693A5D4E8A097F6C86@hqemmail02.nvidia.com>
	<1137487538.309F9186@bd12.dngr.org>
	<17356.51593.481883.173707@cse.unsw.edu.au>
	<43CD1E5A.3050802@mungo.dk>
	<17357.29686.842091.898632@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17357.29686.842091.898632@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown (neilb@suse.de) wrote on 18 January 2006 09:47:
 >On Tuesday January 17, jacob@mungo.dk wrote:
 >> Neil Brown wrote:
 >> > In general, I think increasing the connection between the filesystem
 >> > and the volume manager/virtual storage is a good idea.

Well, I agree in principle however the increase in complexity is
likely to make the whole thing even harder to be as reliable as one
needs... Just consider the complication of xfs or reiser4...

 >I have had a project underway for some time (about half a day a week
 >at the moment) to create a file system which is raid-friendly.  When
 >configured on a raid5, it will always write a full stripe at a time,
 >and never over-write live data.  This means that there is no need to
 >pre-read parity or data, and it completely removes the "write hole".

This seems interesting not so much because of the write-hole but
because of the possible increase in speed. I'm not going to ask about
the filesystem features because I think you already said in the list
that you want to play with it yourself :-)
