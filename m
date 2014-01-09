From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: RAID 10 far and offset on-disk layouts
Date: Thu, 09 Jan 2014 09:03:37 +0100
Message-ID: <52CE57D9.1030501@assyoma.it>
References: <52BD8EDD.10809@assyoma.it> <20131227151927.GA4003@www5.open-std.org> <52BD9B4F.3000509@assyoma.it> <20131227154952.GA6539@www5.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131227154952.GA6539@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: keld@keldix.com, neilb@suse.de
List-Id: linux-raid.ids

>>
>> Interesting. Two question:
>> 1) from which kernel the layout is the one depicted by Wikipedia?
>> 2) it is possible, using mdadm, check what "far" layout is in use?
>
> I cannot answer that. Neil Brown should know.
>
> Best regards
> Keld
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hi all,
anyone with an update on these two questions?

I was thinking to use the kernel block trace facility to track disk 
access and infer the on-disk data structure, but I haven't tried for now.

On the other hand, I carefully looked at mdadm output, without finding 
anything related to physical block placing.

Any new advices on that regard?
Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
