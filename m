From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] Check for multipath module before running multipath tests
Date: Mon, 14 May 2012 22:16:05 +0200
Message-ID: <4FB16805.7020105@redhat.com>
References: <1337015001-14516-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1337015001-14516-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: dledford@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/14/12 19:03, Jes.Sorensen@redhat.com wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> Some systems do not ship the md multipath module. If not available
> simply skip any multipath tests.
> 
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Please ignore this one - something ate my brain today and damaged my
bash-fu. I'll post a working version shortly.

Sorry for the noise.

Jes
