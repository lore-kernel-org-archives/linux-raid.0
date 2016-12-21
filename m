From: Robert LeBlanc <robert@leblancnet.us>
Subject: Re: RAID without dev size prevents adding a new member
Date: Wed, 21 Dec 2016 16:58:16 -0700
Message-ID: <CAANLjFqbui=+DXCOT2PsPPiYsR=vvWpe1FPXTKrrO8+pojyvqA@mail.gmail.com>
References: <CAANLjFo09x0VMj2KbPZzWwpgXebS0d1ZGNTwDqi7fiVsKvFJ+g@mail.gmail.com>
 <8760mdswsn.fsf@notabene.neil.brown.name> <CAANLjFpYKFNG8mmBfVmXuOGwcs5BvMwiqjsy9nLw3LpkhGtLyg@mail.gmail.com>
 <87h95wrhh6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87h95wrhh6.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Dec 21, 2016 at 4:27 PM, NeilBrown <neilb@suse.com> wrote:
> snprintf(fname, MAX_SYSFS_PATH_LEN,


Bingo! The size is now reported and I could add the drive. Hopefully
this can get added to Red Hat... Thanks for the fix.

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
