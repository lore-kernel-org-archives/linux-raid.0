From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: RAID 10 far and offset on-disk layouts
Date: Fri, 27 Dec 2013 16:22:55 +0100
Message-ID: <52BD9B4F.3000509@assyoma.it>
References: <52BD8EDD.10809@assyoma.it> <20131227151927.GA4003@www5.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131227151927.GA4003@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: keld@keldix.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> On Fri, Dec 27, 2013 at 03:29:49PM +0100, Gionatan Danti wrote:
> The wikipedia description is what you get for new arrays with newer
> kernels, while the suse documentation is what you will get with older kernels.
> The wikipedia layout was made because there are better chances of recovery,
> Chances went from 1/3 to 2/3 with eg 4 drives, when 2 drives were failing.
>
> I would say that the Suse description is just not updated.
>
> Best regards
> Keld
>

Interesting. Two question:
1) from which kernel the layout is the one depicted by Wikipedia?
2) it is possible, using mdadm, check what "far" layout is in use?

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
