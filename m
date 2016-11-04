From: Phil Turmel <philip@turmel.org>
Subject: Re: clearing blocks wrongfully marked as bad if --update=no-bbl can't
 be used?
Date: Fri, 4 Nov 2016 14:22:48 -0400
Message-ID: <90cf5c8f-fcd3-d510-7f6e-6be6ade3969f@turmel.org>
References: <20161030161929.GA5582@metamorpher.de>
 <20161030164342.GC28648@merlins.org> <20161030170242.GA5724@metamorpher.de>
 <20161030021614.asws67j34ji64qle@merlins.org>
 <20161030093337.GA3627@metamorpher.de> <20161030153857.GB28648@merlins.org>
 <20161030161929.GA5582@metamorpher.de>
 <f6b83548-cb8b-be21-ee4f-cae9f7fa2950@turmel.org>
 <20161030171234.GD28648@merlins.org> <20161030171654.GE28648@merlins.org>
 <20161104181808.lplrtmafwlub3ck4@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161104181808.lplrtmafwlub3ck4@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>, Neil Brown <neilb@suse.de>, Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/04/2016 02:18 PM, Marc MERLIN wrote:

> Right, so I thought I was home free, but not even close. My array is
> back up, the badblock feature is disabled, array reports clean, but I
> cannot access data past 8.8TB, it just fails.
> 
> myth:~# dd if=/dev/md5 of=/dev/null bs=1GB skip=8797
> dd: reading `/dev/md5': Invalid argument
> 0+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 0.000403171 s, 0.0 kB/s
> myth:~# dd if=/dev/md5 of=/dev/null bs=1GB skip=8796
> dd: reading `/dev/md5': Invalid argument
> 1+0 records in
> 1+0 records out
> 1000000000 bytes (1.0 GB) copied, 10.5817 s, 94.5 MB/s

That has nothing to do with MD.  You are using a power of ten suffix in
your block size, so you are running into non-aligned sector locations.

