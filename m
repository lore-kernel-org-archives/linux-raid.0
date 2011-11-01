From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 1/3] conf_match(): Remove dead code
Date: Tue, 01 Nov 2011 07:22:45 +0100
Message-ID: <4EAF9035.30407@redhat.com>
References: <1320069234-13112-1-git-send-email-Jes.Sorensen@redhat.com>	<1320069234-13112-2-git-send-email-Jes.Sorensen@redhat.com> <20111101133331.21d4ebae@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111101133331.21d4ebae@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

On 11/01/11 03:33, NeilBrown wrote:
> Hi Jes,
>  thanks for these 3 patches.
>  In each case I chose to remove different code :-)
> 
>  In this case search_mdstat was nearly identical to conf_match, but uses the
>  bits you removed.  So I unified the two.
> 
>  For the 'Kill' fix, I removed a different test on 'force' so that the printf
>  that you removed could not actually be reached.

That is great! There are times where I am not quite sure what the
original intention of the code was, so I am just glad the patches is
proving to be of use :)

Cheers,
Jes
