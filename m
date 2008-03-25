From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: raid10 vs raid5 - strange performance
Date: Wed, 26 Mar 2008 00:36:49 +0100
Message-ID: <20080325233649.GA632@rap.rap.dk>
References: <bb145bd20803251433q1018703cva56ea20e9bedf3c6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bb145bd20803251433q1018703cva56ea20e9bedf3c6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Mar 25, 2008 at 10:33:06PM +0100, Christian Pernegger wrote:
> I did a few tests of raid10 on an old 3ware 7506-8 today (using 6
> drives), both with the built-in raid 10 and md's n2 and chunk sizes
> from 64KB to 1024KB.
> - caches dropped before each test
> - averages of three runs
> - arrays in synced state
> - dd tests: 6GB (3MB bs)

What are the specifics for the raid10? Which layout? How many copies?

Best regards
keld
