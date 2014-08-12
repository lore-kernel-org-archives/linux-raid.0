From: Xiao Ni <xni@redhat.com>
Subject: Re: Clone failed
Date: Tue, 12 Aug 2014 00:57:33 -0400 (EDT)
Message-ID: <186578391.21147864.1407819453181.JavaMail.zimbra@redhat.com>
References: <192555642.20505182.1407722576334.JavaMail.zimbra@redhat.com> <270921245.20505628.1407722766562.JavaMail.zimbra@redhat.com> <20140811125909.3e936159@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140811125909.3e936159@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



----- Original Message -----
> From: "NeilBrown" <neilb@suse.de>
> To: "Xiao Ni" <xni@redhat.com>
> Cc: linux-raid@vger.kernel.org
> Sent: Monday, August 11, 2014 10:59:09 AM
> Subject: Re: Clone failed
> 
> On Sun, 10 Aug 2014 22:06:06 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:
> 
> > Hi all
> > 
> >    Could you help me about this? I tried to git clone
> >    git://git.neil.brown.name/md.git.
> > But it always failed. I tried to search the way to resolve this, but I
> > don't find the
> > right method.
> > 
> > [root@dhcp-12-129 aprilava]# git clone git://neil.brown.name/md
> > Initialized empty Git repository in /home/neil/md/.git/
> > remote: fatal: Out of memory, realloc failed
> > remote: aborting due to possible repository corruption on the remote side.
> > fatal: early EOF
> > fatal: index-pack failed
> > 
> >    What should I do? Could you help me?
> > 
> 
> You would probably be more successful if you cloned linux from some local git
> tree and then just 'fetch'ed or 'pull'ed from my tree.
> 
> It seems that fetching the full tree now requires over a gigabyte of memory
> on the server, and my VM only had that much.
> I've added some swap so it should cope now if you really want to clone
> entirely from my tree.
> 
> NeilBrown
> 

Hi Neil

   Thanks very much. I have cloned it successfully. 


Best Regards
Xiao
