From: Gordon Henderson <gordon@drogon.net>
Subject: Re: RAID1 VS RAID5
Date: Mon, 27 Oct 2003 09:19:49 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0310270916270.5277@unicorn.drogon.net>
References: <1067179519.1222.107.camel@cala> <200310270933.37564.dusty@strike.wu-wien.ac.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200310270933.37564.dusty@strike.wu-wien.ac.at>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 27 Oct 2003, Hermann Himmelbauer wrote:

> My experience is that software RAID5 is quite slow.

My experiences are the opposite to yours I'm afraid - I've not found it
any slower than a single drive and in some cases a lot faster!

A lot depends on exactly what you are doing with it though, but I'm
willing to sacrifice some speed for data integrity.

Most of my systems are network servers with 100Mb Network cards fitted -
as long as my disk systems are faster than 12.5MB/sec I'm happy. In
practice I can stream 50MB/sec+ out of some simple RAID5 IDE systems I
have.

Gordon
