From: dean gaudet <dean@arctic.org>
Subject: Re: [PATCH] mdadm 2.5 (Was: ANNOUNCE: mdadm 2.5 - A tool for managing
 Soft RAID under Linux)
Date: Sun, 28 May 2006 14:42:51 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0605281441590.30134@twinlark.arctic.org>
References: <17526.41252.855793.479011@cse.unsw.edu.au>
 <20060528133203.GC8203@percy.comedia.it> <Pine.LNX.4.64.0605281004010.30550@twinlark.arctic.org>
 <20060528174826.GK8203@percy.comedia.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060528174826.GK8203@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 28 May 2006, Luca Berra wrote:

> dietlibc rand() and random() are the same function.
> but random will throw a warning saying it is deprecated.

that's terribly obnoxious... it's never going to be deprecated, there are 
only approximately a bazillion programs using random().

-dean
