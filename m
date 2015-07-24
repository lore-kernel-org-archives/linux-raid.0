From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: [PATCH] raid0: data corruption when using trim
Date: Fri, 24 Jul 2015 16:42:19 +0200
Message-ID: <55B24ECB.3080705@assyoma.it>
References: <013e01d0c1d2$f3af4fb0$db0def10$@samsung.com> <yq1y4ibknz4.fsf@sermon.lab.mkp.net> <005601d0c36c$59d28ec0$0d77ac40$@samsung.com> <yq1wpxu154v.fsf@sermon.lab.mkp.net> <005601d0c470$951ea860$bf5bf920$@samsung.com> <55B1DF90.7090904@assyoma.it> <023401d0c60a$fff39330$ffdab990$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <023401d0c60a$fff39330$ffdab990$@samsung.com>
Sender: linux-raid-owner@vger.kernel.org
To: Seunguk Shin <seunguk.shin@samsung.com>
Cc: linux-raid@vger.kernel.org, g.danti@assyoma.it
List-Id: linux-raid.ids

Hi Seunguk,
thank you for your further explanation.

Does it means that only driver with Queued TRIM are affected, or it 
affect all TRIM-capable driver?

What I wounder is that, if it is only a timing-triggered problem, why it 
is only apparent on specific SSDs? I would expect it to manifest on 
other devices also, albeit with different frequency.

Sorry if some questions sound dumb, I'm only trying to understand.
Thanks.


On 24/07/15 14:19, Seunguk Shin wrote:
> Gionatan,
>
> Because it is related with timing.
>
> 1st trim is issued and before complete it, 2nd trim is started
> (allocates memory but is not issued to device)
> Then, when 1st trim is completed, it frees 2nd trim's memory,
> because they share the pointer due to bug.
> If 3rd trim is started before 2nd trim is issued to device,
> 3rd trim can allocate the same memory with 2nd trim,
> because it is freed when 1st trim is completed.
> Only this case makes the corruption.
>
> Thank you,
> Seunguk Shin
>
>>
>> Hi, any idea on why the bug affects/manifests only on specific SATA SSDs?
>> It is timing related, or it depends on how the controller manage TRIM
>> requests?
>>
>> Thanks.
>>
>> --
>> Danti Gionatan
>> Supporto Tecnico
>> Assyoma S.r.l. - www.assyoma.it
>> email: g.danti@assyoma.it - info@assyoma.it GPG public key ID: FF5F32A8
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
>

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
