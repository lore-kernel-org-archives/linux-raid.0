From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] imsm: remove redundant characters from some error messages
Date: Fri, 16 Sep 2016 09:51:07 -0400
Message-ID: <wrfjlgysosvo.fsf@redhat.com>
References: <20160916132514.29226-1-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160916132514.29226-1-artur.paszkiewicz@intel.com> (Artur
        Paszkiewicz's message of "Fri, 16 Sep 2016 15:25:14 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Artur Paszkiewicz <artur.paszkiewicz@intel.com> writes:
> Fix the cases that produced messages like "mdadm: : The message".
>
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  super-intel.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)

Applied!

Thanks,
Jes
