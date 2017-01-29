From: jes.sorensen@gmail.com
Subject: Re: [PATCH] Fix oddity where mdadm did not recognise a relative path
Date: Sun, 29 Jan 2017 12:48:17 -0500
Message-ID: <wrfjzii9iwpq.fsf@gmail.com>
References: <587E6B56.8090704@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <587E6B56.8090704@youngman.org.uk> (Wols Lists's message of "Tue,
        17 Jan 2017 19:07:02 +0000")
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Wols Lists <antlists@youngman.org.uk> writes:
> From 4ce784307a9004124392ce48432960d7ca94d0bf Mon Sep 17 00:00:00 2001
> From: Wol <anthony@youngman.org.uk>
> Date: Tue, 17 Jan 2017 17:47:05 +0000
> Subject: [PATCH] Fix oddity where mdadm did not recognise a relative path
>
> mdadm assumed that a pathname started with a "/", while an array
> name didn't. This alters the logic so that if the first character
> is not a "/" it tries to open an array, and if that fails it drops
> through to the pathname code rather than terminating immediately
> with an error.
>
> Signed-off-by: Wol <anthony@youngman.org.uk>
> ---
>  mdadm.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Applied, thanks!

Sorry I have been swamped the last couple of weeks finishing up my old
job and starting the new one. Will be bogged down a lot the next couple
of weeks, so please be patient.

Cheers,
Jes
