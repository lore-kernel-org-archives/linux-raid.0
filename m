From: Neil Brown <neilb@suse.de>
Subject: Re: understanding RAID1 conf printout in syslog
Date: Mon, 29 Nov 2010 12:19:15 +1100
Message-ID: <20101129121915.1402155b@notabene.brown>
References: <4CF2DB8A.5000908@revamp-it.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CF2DB8A.5000908@revamp-it.ch>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Rudin <linuxraid@revamp-it.ch>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 28 Nov 2010 23:45:30 +0100 Andreas Rudin <linuxraid@revamp-it.ch>
wrote:

> Hello
> 
> I don't find a documentation of the following syslog lines:
> 
> RAID1 conf printout:
>  --- wd:1 rd:2
>  disk 0, wo:1, o:1, dev:sda1
>  disk 1, wo:0, o:1, dev:sdb1
> 
> What is the meaning of wd, rd, wo and o ?
> 
> Thanks for your help
> 
> Andreas

The only documentation is the source code.

wd == working disks
rd == raid disks
wo == write-only
o  == online

NeilBrown
