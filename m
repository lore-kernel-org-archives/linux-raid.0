From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 09/13] iop-adma: P+Q self test
Date: Thu, 19 Mar 2009 17:19:27 -0700
Message-ID: <e9c3a7c20903191719y501925f2w65c6959e964a9470@mail.gmail.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
	 <20090318192102.20375.36540.stgit@dwillia2-linux.ch.intel.com>
	 <18882.57341.196519.507194@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18882.57341.196519.507194@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

On Thu, Mar 19, 2009 at 5:14 PM, Neil Brown <neilb@suse.de> wrote:
>> +#include <linux/raid/raid6.h>
>
> ???
> =A0<linux/raid/pq.h> =A0Maybe?
>

Yes, neglected the cross compile before pushing this out, will fix.

Thanks,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
