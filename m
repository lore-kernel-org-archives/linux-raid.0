From: Maarten van den Berg <maarten@ultratux.net>
Subject: Re: Raid5 Construction Question
Date: Thu, 19 Aug 2004 22:30:24 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408192230.24825.maarten@ultratux.net>
References: <4124E24E.7070802@psc.edu> <4124F240.20606@nsr500.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4124F240.20606@nsr500.net>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday 19 August 2004 20:32, Tim Moore wrote:
> My raid tab has 'chunk-size 64' and I get 64k chunks.  Does 'chunk-size
> 64k' mean 64M chunks?
>
> Did you set stride correctly when running mke2fs (based on
> chunk_size/fs_block_size)?

I've often wondered about this stride setting when NOT using ext2 (ext3)...
How do you specify it for other filesystems ?  And when you cannot, how does 
it affect the performance of the FS ?  Take for example reiserfs, which does 
not mention stride in its entire manpage.  What then ?

Maarten

