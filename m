From: Jim Rees <rees-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Subject: Re: [PATCH] pnfs: Automatically select blocks & objects layouts
Date: Thu, 11 Aug 2011 18:13:05 -0400
Message-ID: <20110811221305.GA8608@merit.edu>
References: <CA+55aFwkJdyEpyNY64aAQ5ChrPZ8Kvx9iRUwy1J6_SRaxoN=zA@mail.gmail.com>
 <20110810122304.96b8be67.rdunlap@xenotime.net>
 <CA+a=Yy5izxiyvW5eYiWuute9E1vXwNTj4frdzNeEwsLDrszesg@mail.gmail.com>
 <20110810175829.a834d80f.rdunlap@xenotime.net>
 <CA+55aFzcSLrhkexEn=J7BN8F3P3Vy+EAjwgGwMQPdeoYoQG+Bw@mail.gmail.com>
 <F19688880B763E40B28B2B462677FBF805BF0EAC8A@MX09A.corp.emc.com>
 <4E43AAD1.7090806@tonian.com>
 <4E4422FD.3060706@panasas.com>
 <4E444552.9030105@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4E444552.9030105-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: Benny Halevy <bhalevy-4/WYdZTkCtzQT0dZR+AlfA@public.gmane.org>, Sorin Faibish <sfaibish-mb1K0bWo544@public.gmane.org>, peter honeyman <honey-vtMw8L3fJ9vSiEDVxGk4TQ@public.gmane.org>, tao.peng-mb1K0bWo544@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org, bergwolf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Welch, Brent" <welch-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-raid.ids

Boaz Harrosh wrote:

  What about the below? based on v3.1-rc1
  
  ----
  From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
  Subject: [PATCH] pnfs: Automatically select blocks & objects layouts
  
  Just like files-layout, blocks & objects layouts are part of the
  NFS 4.1 protocol and should be automatically selected if NFS_4_1
  is selected. The small problem is that these depend on other
  Kernel support being present, while files only depends on NFS
  itself.
  
  This patch removes from the user choice the presence of objects
  and blocks layout. But makes sure these are selected only if
  the depended subsystems are present in the Kernel.
  
  Signed-off-by: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>

Acked-by: Jim Rees <rees-63aXycvo3TyHXe+LvDLADg@public.gmane.org>

I think this is what we want.  There is no point allowing the user to pick
and choose various layout drivers.  If they have selected nfs4.1 they should
get all the layout drivers their kernel will support, based on the
dependencies.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
