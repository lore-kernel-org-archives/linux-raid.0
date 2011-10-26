From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] GCC compile fix: remove calculation of unused variable
 'reservation'
Date: Wed, 26 Oct 2011 14:51:36 +0200
Message-ID: <4EA80258.70302@redhat.com>
References: <1317912231-26625-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1317912231-26625-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/06/11 16:43, Jes.Sorensen@redhat.com wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> gcc 4.6.1 doesn't like calculating a variable that then isn't
> used. Remove it.
> 
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  super-intel.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)

Neil,

Any chance you could reply this one? It still seems to be an issue with
the latest git tree.

Thanks,
Jes
