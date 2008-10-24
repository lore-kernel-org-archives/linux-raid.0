From: Luca Berra <bluca@comedia.it>
Subject: Re: Proactive Drive Replacement
Date: Fri, 24 Oct 2008 07:57:26 +0200
Message-ID: <20081024055726.GA16857@maude.comedia.it>
References: <cccedfc60810201035m53873320tb069f333b707191b@mail.gmail.com> <gdj1c4$8nf$1@ger.gmane.org> <48FD94F9.3060400@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <48FD94F9.3060400@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 21, 2008 at 09:38:17AM +0100, David Greaves wrote:
>The main issue is that the drive being replaced almost certainly has a bad
>block. This block could be recovered from the raid5 set but won't be.
>Worse, the mirror operation may just fail to mirror that block - leaving it
>'random' and thus corrupt the set when replaced.
False,
if SMART reports the drive is failing, it just means the number of
_correctable_ errors got too high, remember that hard drives (*) do use
ECC and autonomously remap bad blocks.
You replace a drive based on smart to prevent it developing bad blocks.

Ignoring the above, your scenario is still impossible, if you tried to
mirror a source drive with a bad block, md will notice and fail the
mirroring process. You will never end up with one drive with a bad block
and the other with uninitialized data.

If what you are really worried about is not bad block, but silent
corruption, you should run a check (see sync_action in
/usr/src/linux/Documentation/md.txt)

L.
(*) note that i don't write 'modern hard drives'.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
