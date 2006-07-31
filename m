From: Jes Sorensen <jes@sgi.com>
Subject: Re: [PATCH 0/2] Fix RAID5 + IA64 compile
Date: Mon, 31 Jul 2006 15:13:55 +0200
Message-ID: <44CE0213.8030204@sgi.com>
References: <20060728140145.9149.43458.sendpatchset@prarit.boston.redhat.com> <yq01ws29li9.fsf@jaguar.mkp.net> <44CE01AB.8040205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ia64-owner@vger.kernel.org>
In-Reply-To: <44CE01AB.8040205@redhat.com>
Sender: linux-ia64-owner@vger.kernel.org
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-ia64@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Prarit Bhargava wrote:
> Resubmitting ... please note this patch is ia64 ONLY.

> ------------------------------------------------------------------------
> 
> CONFIG_MD_RAID5 became CONFIG_MD_RAID456 in drivers/md/Kconfig.  Make the same
> change in arch/ia64
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Signed-off-by: Aron Griffis <aron@hp.com>

Acked-by: Jes Sorensen <jes@sgi.com>

I like this one much better :-)

Jes
