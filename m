From: Luca Berra <bluca@comedia.it>
Subject: Re: Can uuid of raid array be changed?
Date: Mon, 18 Apr 2005 09:13:51 +0200
Message-ID: <20050418071351.GB30849@percy.comedia.it>
References: <4262DD5D.40805@advocap.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4262DD5D.40805@advocap.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Apr 17, 2005 at 05:04:13PM -0500, John McMonagle wrote:
>Need to duplicate some computers that are using raid 1.
>
>I was thinking of just adding adding an extra drive and then moving it 
>to the new system. The only problem is the clones will all have the same 
>uuids.  If at some later date the drives got mixed up I could see a 
>possibilities for disaster.  Not exactly likely as the computers will be 
>in different cities.
>
>Is there a way to change the uuid if a raid array?
>Is it really worth worrying about?
>
you can recreate the array, this will not damage existing data.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
