From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Issue with growing RAID10
Date: Wed, 2 Nov 2016 18:09:24 +0000
Message-ID: <581A2BD4.3070109@youngman.org.uk>
References: <CAANLjFrK25fUjMpif6m7y3PZ0phNa_zVLFWUVs2Yj1PtbkA_Qg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAANLjFrK25fUjMpif6m7y3PZ0phNa_zVLFWUVs2Yj1PtbkA_Qg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert LeBlanc <robert@leblancnet.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/11/16 17:59, Robert LeBlanc wrote:
> We would like to add read performance to our RAID10 volume by adding
> another drive (we don't care about space), so I did the following test
> with poor results.

Quicky reply ...

I don't think you can change the number of raid-devices on a raid10. Are
you trying to replace a slow drive with a faster one? You can probably
use the --replace option.

If not that, what do you want to achieve?

Cheers,
Wol

