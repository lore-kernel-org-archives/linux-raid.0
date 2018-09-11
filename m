From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: linux-next: Tree for Sep 11 (drivers/md/dm-thin-metadata.o:)
Date: Tue, 11 Sep 2018 08:25:31 -0700
Message-ID: <e5fa94e1-76b1-b703-94fe-dd0493f7b9fd@infradead.org>
References: <20180911145852.116222ab@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180911145852.116222ab@canb.auug.org.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, Linux-Next Mailing List <linux-next@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/10/18 9:58 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20180910:
> 

on i386:

drivers/md/dm-thin-metadata.o: In function `__set_metadata_reserve':
dm-thin-metadata.c:(.text+0x555): undefined reference to `__udivdi3'



Reported-by: Randy Dunlap <rdunlap@infradead.org>

-- 
~Randy
