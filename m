From: Drew <drew.kay@gmail.com>
Subject: Re: RAID halting
Date: Sun, 5 Apr 2009 07:05:57 -0700
Message-ID: <c268e4660904050705v73f1aa0eud93357f1e369110c@mail.gmail.com>
References: <49D85AE8.7090701@sauce.co.nz>
	 <20090405082217.VGMW1944.cdptpa-omta02.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090405082217.VGMW1944.cdptpa-omta02.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> The problem started immediately the last time I
> rebuilt the array and formatted it as Reiserfs, after moving the drives out
> of the old RAID chassis.

What file system were you using before ReiserFS?

I'm no expert but it seems, based on what you said about the raid
resyncing just fine while a filesystem call blocked, you may want to
look at the filesystem you're using. RAID provides a block level
interface to the FS and if the block level interface is working and
not reporting errors from lower levels, your culprit is higher up the
chain, ie the FS.

It's perhaps a matter of personal preference but I try to avoid
Reiser. It's not that it's a bad FS or anything but I've never had it
work quite right for me. Plus, based on my read of how it works, it
requires more processing on file creation due to the various
optimization algorithms it uses.


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
