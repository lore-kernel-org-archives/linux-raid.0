From: Luca Berra <bluca@comedia.it>
Subject: Re: raid0/jbod/lvm, sorta?
Date: Wed, 30 Dec 2009 08:29:15 +0100
Message-ID: <20091230072915.GB17485@maude.comedia.it>
References: <20091230000357.GA23485@septictank.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091230000357.GA23485@septictank.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Dec 29, 2009 at 06:03:57PM -0600, Matt Garman wrote:
>I know I could do this manually with symlinks.  E.g., have a
>directory like /bigstore that contains symlinks into /mnt/drive1,
>/mnt/drive2, /mnt/drive3, etc.  And then if one drive dies, the
>whole store isn't trashed.  This seems fairly simple, so I wonder if
>there's not some automatic way to do it.  Hence, this email.  :)
>
http://www.filesystems.org/project-unionfs.html
maybe your distribution includes it already.

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
