From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 1/1] md: drivers/md/unroll.pl replaced with awk analog
Date: Mon, 5 Oct 2009 16:30:50 -0500
Message-ID: <200910051630.51039.rob@landley.net>
References: <4aca1863.0a1ad00a.33bf.1017@mx.google.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754954AbZJEVbb@vger.kernel.org>
In-Reply-To: <4aca1863.0a1ad00a.33bf.1017@mx.google.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Vladimir Dronnikov <dronnikov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Monday 05 October 2009 11:01:39 Vladimir Dronnikov wrote:
> From: Vladimir Dronnikov <dronnikov@gmail.com>
>
> drivers/md/unroll.pl replaced by awk script to drop build-time dependency
> on perl
>
> Signed-off-by: Vladimir Dronnikov <dronnikov@gmail.com>

Acked-by: Rob Landley <rob@landley.net>

We already discussed this on another mailing list, thread starts at:

http://lists.impactlinux.com/pipermail/firmware-impactlinux.com/2009-October/000328.html

I've added this as patch #4 in the perl removal series I've submitted
during the last few merge windows.

Thanks,

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
