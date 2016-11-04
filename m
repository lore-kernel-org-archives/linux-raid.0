From: Roman Mamedov <rm@romanrm.net>
Subject: Re: clearing blocks wrongfully marked as bad if --update=no-bbl
 can't be used?
Date: Sat, 5 Nov 2016 00:31:09 +0500
Message-ID: <20161105003109.25964c52@natsu>
References: <20161030170242.GA5724@metamorpher.de>
        <20161030021614.asws67j34ji64qle@merlins.org>
        <20161030093337.GA3627@metamorpher.de>
        <20161030153857.GB28648@merlins.org>
        <20161030161929.GA5582@metamorpher.de>
        <f6b83548-cb8b-be21-ee4f-cae9f7fa2950@turmel.org>
        <20161030171234.GD28648@merlins.org>
        <20161030171654.GE28648@merlins.org>
        <20161104181808.lplrtmafwlub3ck4@merlins.org>
        <90cf5c8f-fcd3-d510-7f6e-6be6ade3969f@turmel.org>
        <20161104185040.yrznk3j4rvtwsxbk@merlins.org>
        <20161104235917.2d6d0fcc@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161104235917.2d6d0fcc@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: Phil Turmel <philip@turmel.org>, Neil Brown <neilb@suse.de>, Andreas Klauer <Andreas.Klauer@metamorpher.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 4 Nov 2016 23:59:17 +0500
Roman Mamedov <rm@romanrm.net> wrote:

> On Fri, 4 Nov 2016 11:50:40 -0700
> Marc MERLIN <marc@merlins.org> wrote:
> 
> > I can switch to GiB if you'd like, same thing:
> > myth:/dev# dd if=/dev/md5 of=/dev/null bs=1GiB skip=8190
> > dd: reading `/dev/md5': Invalid argument
> > 2+0 records in
> > 2+0 records out
> > 2147483648 bytes (2.1 GB) copied, 21.9751 s, 97.7 MB/s
> 
> But now you cansee the cutoff point is exactly at 8192 -- a strangely familiar
> number, much more so than "8.8 TB", right? :D
> 
> Could you recheck (and post) your mdadm --detail /dev/md5, if the whole array
> didn't get cut to a half of its size in "Array Size".

Also check that member devices of /dev/md5 (/dev/sd*1 partitions) are still
larger than 2TB, and are still readable past 2TB.

-- 
With respect,
Roman
