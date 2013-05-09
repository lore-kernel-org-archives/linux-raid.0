From: Marek Becka <marek.becka@superhosting.cz>
Subject: Re: mdadm fails to assemble arrays with quotes in name
Date: Thu, 09 May 2013 17:47:25 +0200
Message-ID: <518BC50D.1000605@superhosting.cz>
References: <5187E9AB.4040904@superhosting.cz> <20130509151423.7c0e2256@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130509151423.7c0e2256@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/09/2013 07:14 AM, NeilBrown wrote:
> Try:
>     ..... name="'newname':-"
>
> That should work.  Quotes are special.
Yes, this works fine.

> I should probably update the mdadm.conf manpage to mention that.
>
> NeilBrown
I think, that an output from `mdadm  --detail --scan` and `mkconf` 
should also be updated to generate correct name parameters for this case.
