From: Neil Brown <neilb@suse.de>
Subject: Re: [patch] install a static build
Date: Mon, 29 May 2006 12:24:47 +1000
Message-ID: <17530.23407.766753.5581@cse.unsw.edu.au>
References: <5d0f60990605270308j71f3f2aem18219202d0fa957f@mail.gmail.com>
	<20060527134825.GJ8203@percy.comedia.it>
	<5d0f60990605271519t6e06fd9bw1e0a5f4f372bb31a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dirk Jagdmann on Sunday May 28
Sender: linux-raid-owner@vger.kernel.org
To: Dirk Jagdmann <jagdmann@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday May 28, jagdmann@gmail.com wrote:
> Hello Luca,
> 
> > maybe you better add an install-static target.
> 
> you're right, that would be a cleaner approach. I've don so, and while
> doing so added install-tcc, install-ulibc, install-klibc too.
> 
> And while I'm busy in the Makefile anyway I've made a third patch
> which adds the uninstall: target too.
> 
> -- 
> ---> Dirk Jagdmann
> ----> http://cubic.org/~doj
> -----> http://llg.cubic.org

thanks for these.  
They are now in my git tree:
  http://neil.brown.name/cgi-bin/gitweb.cgi?p=mdadm
  git://neil.brown.name/mdadm
  
They claim me as their author I'm afraid.. I'll have to fix my scripts
to get it right next time :-(

NeilBrown
