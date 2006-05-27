From: Luca Berra <bluca@comedia.it>
Subject: Re: [patch] install a static build
Date: Sat, 27 May 2006 15:48:26 +0200
Message-ID: <20060527134825.GJ8203@percy.comedia.it>
References: <5d0f60990605270308j71f3f2aem18219202d0fa957f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5d0f60990605270308j71f3f2aem18219202d0fa957f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, May 27, 2006 at 12:08:19PM +0200, Dirk Jagdmann wrote:
>Hello developers,
>
>after building my static mdadm I wanted to install it via "make
>install", but had to tweak the Makefile a little. However my approach
>is not the best, since I had to remove the "rmconf" target for the
>static build, issue a "cp" of the mdadm.static binary and my patch
>might interfere with the "everything" target :-(
>
maybe you better add an install-static target.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
