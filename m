From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/1] Work around architectures having statfs.f_type defined as long
Date: Wed, 19 Mar 2014 21:43:37 +0100
Message-ID: <201403192143.37675.arnd@arndb.de>
References: <1395235562-24672-1-git-send-email-Jes.Sorensen@redhat.com> <1395235562-24672-2-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1395235562-24672-2-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: neilb@suse.de, linux-raid@vger.kernel.org, ralf@linux-mips.org
List-Id: linux-raid.ids

On Wednesday 19 March 2014, Jes.Sorensen@redhat.com wrote:
> @@ -1946,9 +1946,13 @@ int in_initrd(void)
>  {
>         /* This is based on similar function in systemd. */
>         struct statfs s;
> +       /* statfs.f_type is signed long on s390x and MIPS, causing all
> +          sorts of sign extension problems with RAMFS_MAGIC being
> +          defined as 0x858458f6 */
>         return  statfs("/", &s) >= 0 &&
>                 ((unsigned long)s.f_type == TMPFS_MAGIC ||
> -                (unsigned long)s.f_type == RAMFS_MAGIC);
> +                ((unsigned long)s.f_type & 0xFFFFFFFFUL) ==
> +                ((unsigned long)RAMFS_MAGIC & 0xFFFFFFFFUL));

The comment is wrong: on s390x the type is actually 'unsigned int'.
The fix however works on all variants as far as I can tell.

Thinking about it a bit more, I guess we can also cast both
sides to 'unsigned int' for the same effect and get rid of
the mask.

	Arnd
