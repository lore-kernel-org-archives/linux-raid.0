From: Frank van Maarseveen <frankvm@xs4all.nl>
Subject: Re: mdadm - comments on command layout
Date: Sat, 14 Aug 2004 11:56:44 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040814095644.GA25051@janus>
References: <16669.9163.392465.637229@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16669.9163.392465.637229@gargle.gargle.HOWL>
To: John Stoffel <stoffel@lucent.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Aug 13, 2004 at 04:25:47PM -0400, John Stoffel wrote:
> ideally I could do either:
> 
>   > mdadm assemble md0 /dev/hda1 /dev/hda2 ...
> 
> or
> 
>   > mdadm
>   madam> assemble md0 /dev/hda1 /dev/hda2 ...
> 

Both should have an identical command/argument syntax. The "shell"
mode would allow for context sensitive argument completion and help (can
mostly be done in bash as well but that's a bit clumsy).
This might be useful for tools which aren't used on daily basis.

On the other hand you have to figure it out anyway and better prepare
the cookbooks/scripts to handle drive failure in advance.

-- 
Frank
