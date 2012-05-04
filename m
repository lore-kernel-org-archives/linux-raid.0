From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/2] super-intel.c: Don't try to close negative fd
Date: Fri, 4 May 2012 11:00:15 -0700
Message-ID: <CAA9_cmcnWHeu-x9L5os9gZzmhtMxvAWVnLf3uSfey+aVktaKoA@mail.gmail.com>
References: <1336138882-31869-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1336138882-31869-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 4, 2012 at 6:41 AM,  <Jes.Sorensen@redhat.com> wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> This should be harmless, but lets be consistent and not try to close a
> negative file descripter.
>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---

Patch 1 and 2, Acked-by: Dan Williams <dan.j.williams@intel.com>
