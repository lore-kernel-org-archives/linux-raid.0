From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: trying to "brute-force" my RAID 5...
Date: Tue, 18 Jul 2006 16:04:35 +0200
Message-ID: <62b0912f0607180704k6b2c8679w2ac70371a346afec@mail.gmail.com>
References: <44BAB76D.9070809@start.no>
	 <62b0912f0607170413x465b363eh92c811da67cc363@mail.gmail.com>
	 <44BBFF5A.7010702@start.no> <44BBFFCA.5030309@online.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44BBFFCA.5030309@online.no>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Sevrin Robstad <quack@online.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sevrin Robstad wrote:
> I created the RAID when I installed Fedora Core 3 some time ago,
> didn't do anything special so the chunks should be 64kbyte and
> parity should be left-symmetric ?

I have no idea what's default on FC3, sorry.

> Any Idea ?

I missed that you were trying to fdisk -l /dev/md0..
As others have suggested, search for filesystems using fsck, or mount,
or what not ;-).
