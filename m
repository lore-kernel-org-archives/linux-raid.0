From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: [PATCH 2/6] Makefile: Allow the user to pass EXTRA_CFLAGS
Date: Wed, 19 Jun 2013 11:48:47 +0200
Message-ID: <51C17E7F.3050504@itwm.fraunhofer.de>
References: <20130618090910.1161109.69430.stgit@fsdevel7.hpc.devnet.itwm.fhg.de> <20130618090921.1161109.54531.stgit@fsdevel7.hpc.devnet.itwm.fhg.de> <20130619100730.0a0e5240@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130619100730.0a0e5240@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: piergiorgio.sartor@nexgo.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,

On 06/19/2013 02:07 AM, NeilBrown wrote:
> On Tue, 18 Jun 2013 11:09:21 +0200 Bernd Schubert
> <bernd.schubert@itwm.fraunhofer.de> wrote:
>
>> Users might want to compile with optimization levels and
>> CXFLAGS as suggested in the Makefile comment does not work.
>
> Doesn't it?  It works for me.
>
>     make CXFLAGS=-O3
>
> compiled with "-O3".
>
>
> I haven't applied this patch (feel free to try to be more convincing) but has
> applied all the others (after removing a little bit of trailing white space).
>


I'm sorry for the extra work with the white space. Next time I'm first 
going to run linux/scripts/checkpatch.pl

Hmm, indeed

make CXFLAGS=-O3

works, but the other way around it does not:

CXFLAGS=-O3 make

I still wonder how it works, as Makefile sets "CXFLAGS = -ggdb".
Anyway, whichever exception 'make' has for that, can we change it to

-CXFLAGS = -ggdb
+CXFLAGS ?= -ggdb

which would make it work with either way CXFLAGS is specified.


Thanks,
Bernd

