From: Luca Berra <bluca@comedia.it>
Subject: Re: [PATCH] (Re: Questions regarding startup of imsm container)
Date: Wed, 24 Mar 2010 07:12:11 +0100
Message-ID: <20100324061211.GA18699@maude.comedia.it>
References: <7db987b31003222056i46c42112s541ba949821a6759@mail.gmail.com> <20100323080419.GA9374@maude.comedia.it> <20100324115749.1ac9d6f8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100324115749.1ac9d6f8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 24, 2010 at 11:57:49AM +1100, Neil Brown wrote:
>On Tue, 23 Mar 2010 09:04:19 +0100
>Thanks for the patch.  However I would prefer to disable bitmap support for
>those metadata formats which report that they don't support it.
>Thus the following patch.
It is more reasonable, as Dan confirmed external bitmaps should work,
which i was unsure at the beginning.

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
