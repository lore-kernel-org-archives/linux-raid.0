From: Andrew Morton <akpm@osdl.org>
Subject: Re: SW RAID5 + high memory support freezes 2.6.3 kernel
Date: Sun, 22 Feb 2004 21:30:11 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040222213011.7e1b8bbf.akpm@osdl.org>
References: <20040223024124.GA1590@psilocybus>
	<16441.33071.218049.163976@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16441.33071.218049.163976@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: P.Luptak@sh.cvut.cz, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@cse.unsw.edu.au> wrote:
>
> > Hello,
>  > issue http://www.spinics.net/lists/lvm/msg10322.html could be still present
>  > in the current 2.6.3 kernel. I am able to repeat the conditions to halt the 
>  > 2.6.3 kernel (using mkfs.ext3 on RAID device):
> 
>  To be fair, your subject should say that 
>     SW RAID5 + high memory + loop device freezes 2.6.3 kernel
>                            ^^^^^^^^^^^^^^

hm, yes.  And the loop code which was involved here was removed from the
kernel last week, so it's a bit academic.

Retest on current 2.6.3-bk or 2.6.3-mm3 please.
