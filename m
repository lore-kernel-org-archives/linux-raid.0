From: Peng Tao <bergwolf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] pnfs: Automatically select blocks & objects layouts
Date: Fri, 12 Aug 2011 07:47:20 +0800
Message-ID: <CA+a=Yy5dgW99H8pTokUZDTJaS_uDS_vKfUeR+i8QNcCwtdFCAQ@mail.gmail.com>
References: <CA+55aFwkJdyEpyNY64aAQ5ChrPZ8Kvx9iRUwy1J6_SRaxoN=zA@mail.gmail.com>
 <20110810122304.96b8be67.rdunlap@xenotime.net> <CA+a=Yy5izxiyvW5eYiWuute9E1vXwNTj4frdzNeEwsLDrszesg@mail.gmail.com>
 <20110810175829.a834d80f.rdunlap@xenotime.net> <CA+55aFzcSLrhkexEn=J7BN8F3P3Vy+EAjwgGwMQPdeoYoQG+Bw@mail.gmail.com>
 <F19688880B763E40B28B2B462677FBF805BF0EAC8A@MX09A.corp.emc.com>
 <4E43AAD1.7090806@tonian.com> <4E4422FD.3060706@panasas.com>
 <4E444552.9030105@panasas.com> <20110811221305.GA8608@merit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110811221305.GA8608-8f4Pc2RrbJmHXe+LvDLADg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Rees <rees-63aXycvo3TyHXe+LvDLADg@public.gmane.org>, Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: Benny Halevy <bhalevy-4/WYdZTkCtzQT0dZR+AlfA@public.gmane.org>, Sorin Faibish <sfaibish-mb1K0bWo544@public.gmane.org>, peter honeyman <honey-vtMw8L3fJ9vSiEDVxGk4TQ@public.gmane.org>, tao.peng-mb1K0bWo544@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org, Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Welch, Brent" <welch-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-raid.ids

On Fri, Aug 12, 2011 at 6:13 AM, Jim Rees <rees-63aXycvo3TyHXe+LvDLADg@public.gmane.org> wrote:
> Boaz Harrosh wrote:
>
> =C2=A0What about the below? based on v3.1-rc1
>
> =C2=A0----
> =C2=A0From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
> =C2=A0Subject: [PATCH] pnfs: Automatically select blocks & objects la=
youts
>
> =C2=A0Just like files-layout, blocks & objects layouts are part of th=
e
> =C2=A0NFS 4.1 protocol and should be automatically selected if NFS_4_=
1
> =C2=A0is selected. The small problem is that these depend on other
> =C2=A0Kernel support being present, while files only depends on NFS
> =C2=A0itself.
>
> =C2=A0This patch removes from the user choice the presence of objects
> =C2=A0and blocks layout. But makes sure these are selected only if
> =C2=A0the depended subsystems are present in the Kernel.
>
> =C2=A0Signed-off-by: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
>
> Acked-by: Jim Rees <rees-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
>
> I think this is what we want. =C2=A0There is no point allowing the us=
er to pick
> and choose various layout drivers. =C2=A0If they have selected nfs4.1=
 they should
> get all the layout drivers their kernel will support, based on the
> dependencies.
>
I agree automatically selecting is more reasonable.
Acked-by: Peng Tao <peng_tao-mb1K0bWo544@public.gmane.org>


--=20
Thanks,
-Bergwolf
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
