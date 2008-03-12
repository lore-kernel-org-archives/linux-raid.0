From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik-X3B1VOXEql0@public.gmane.org>
Subject: Re: Re: md-raid5, dm-crypt, alignment and readahead
Date: Wed, 12 Mar 2008 13:55:20 +0200
Message-ID: <20080312115520.GT21162@edu.joroinen.fi>
References: <bb145bd20803100910l6cfe250bs631184b493a23e04@mail.gmail.com> <bb145bd20803111647h13685bd8w4088138316667524@mail.gmail.com>
Reply-To: dm-crypt-4q3lyFh4P1g@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-crypt-return-2653-glkdd-dm-crypt=m.gmane.org-4q3lyFh4P1g@public.gmane.org>
List-Post: <mailto:dm-crypt-4q3lyFh4P1g@public.gmane.org>
List-Help: <mailto:dm-crypt-help-4q3lyFh4P1g@public.gmane.org>
List-Unsubscribe: <mailto:dm-crypt-unsubscribe-4q3lyFh4P1g@public.gmane.org>
List-Subscribe: <mailto:dm-crypt-subscribe-4q3lyFh4P1g@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <bb145bd20803111647h13685bd8w4088138316667524-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
To: dm-crypt-4q3lyFh4P1g@public.gmane.org
Cc: linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

On Wed, Mar 12, 2008 at 12:47:02AM +0100, Christian Pernegger wrote:
> >  Is there a difference between running blockdev --setra and echo-int to
> >  /sys/block/.../read_ahead_kb for devices that have the entry in /sys?
> 
> To answer myself, blockdev --setra seems to change
> /sys/block/.../read_ahead_kb, so I'll just always use that.
> 
> >  How is readahead handled when "stacked" virtual block devices are
> >  involved?
> 
> Ran quite a few tests and readahead at any layer but the top layer did
> not have any effect. This means that read ahead blocks will always be
> decrypted. Oh well ...
>

Just to make it clear.. with "top layer" you mean you set read ahead only for
the dm-crypt device and NOT for the md-raid and/or physical sdX devices? 
 
-- Pasi
